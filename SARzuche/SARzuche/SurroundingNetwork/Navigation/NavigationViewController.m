
//
//  NavigationViewController.m
//  SARzuche
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavigationViewController.h"
#import "StartNavigationViewController.h"
#import "PublicFunction.h"
#import "ConstDefine.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController
{
    NavigationView *_navigationView;
    
    BOOL systemLocationServiceOpened;
    CLLocationManager *m_locationManager;
    CLLocationCoordinate2D myLocation;  // 记录位置
}
@synthesize locationsDic, enterType;

-(void)dealloc
{
    NSLog(@"navigationView dealloc()");
    
    _navigationView.delegate = nil;
    
    [self uninitLocationManager];
}

-(void)uninitLocationManager
{
    if (nil != m_locationManager)
    {
        [m_locationManager stopUpdatingLocation];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"导航";
        locationsDic = [[NSMutableDictionary alloc] init];  // 用来保存起点位置和终点位置
        systemLocationServiceOpened = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initLocationManager];
    
    // 导航栏左边按钮
    [customNavBarView setLeftButton:@"back.png" target:self leftBtnAction:@selector(backClk:)];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    _navigationView = [[NavigationView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    _navigationView.delegate = self;
    [self.view addSubview:_navigationView];
    
#if TARGET_IPHONE_SIMULATOR
    myLocation.latitude = 31.980802;
    myLocation.longitude = 118.763257;
#endif
    
    [locationsDic setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的位置", @"name", nil] forKey:KEY_LocationDic_startAddr];
    
    if ([locationsDic objectForKey:kEY_LocationDic_endAddr])
    {
        [_navigationView setEndAddress:[[locationsDic objectForKey:kEY_LocationDic_endAddr] objectForKey:@"name"]];
    }
}

-(void)initLocationManager
{
    if ([CLLocationManager locationServicesEnabled])
    {
        m_locationManager = [[CLLocationManager alloc] init];
        m_locationManager.delegate = self;  // CLLocationManagerDelegate
        [m_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [m_locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏按钮点击事件
-(void)backClk:(id)sender
{
    NSLog(@"NavigationViewController back click");
    
    switch (enterType)
    {
        case NavigationViewFromHomeView:
            [[PublicFunction ShareInstance].rootNavigationConroller popViewControllerAnimated:YES];
            break;
            
        case NavigationViewFromMapView:
        case NavigationViewFromGasStationView:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - NavigationViewDelegate
-(void)enterLocationView:(NSString *)title isMyLocation:(BOOL)location
{
    LocationViewController *nextVC = [[LocationViewController alloc] init];
    nextVC.title = title;
    nextVC.myLocation = location;
    nextVC.delegate = self;
    [[PublicFunction ShareInstance].rootNavigationConroller pushViewController:nextVC animated:YES];
}

-(void)enterStartNavigationView:(int)type
{
    if (!systemLocationServiceOpened)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请您前往设置-隐私-定位服务-享租车，打开定位服务，否则享租车无法为您提供地图相关服务哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSDictionary *startLocationDic = [locationsDic objectForKey:KEY_LocationDic_startAddr];
    NSDictionary *endLocationDic = [locationsDic objectForKey:kEY_LocationDic_endAddr];
    
    NSString *startAddress = [startLocationDic objectForKey:@"name"];
    NSString *endAddress = [endLocationDic objectForKey:@"name"];
    
    if (TAG_NavigationTypeBtn_driving == type)
    {
        if (![startAddress isEqualToString:@"我的位置"])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"起点不是当前位置，是否使用当前位置导航？" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", @"取消", nil];
            [alertView show];
            return;
        }
    }
    
    if ([startAddress isEqualToString:@"我的位置"])
    {
        NSMutableDictionary *myLocationDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的位置", @"name", [NSString stringWithFormat:@"%f", myLocation.latitude], @"latitude", [NSString stringWithFormat:@"%f", myLocation.longitude], @"longitude", nil];
        [locationsDic setObject:myLocationDic forKey:KEY_LocationDic_startAddr];
    }
    else if ([endAddress isEqualToString:@"我的位置"])
    {
        NSMutableDictionary *myLocationDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的位置", @"name", [NSString stringWithFormat:@"%f", myLocation.latitude], @"latitude", [NSString stringWithFormat:@"%f", myLocation.longitude], @"longitude", nil];
        [locationsDic setObject:myLocationDic forKey:kEY_LocationDic_endAddr];
    }
    
    if ([[startLocationDic objectForKey:@"latitude"] isEqualToString:
           [endLocationDic objectForKey:@"latitude"]] &&
        [[startLocationDic objectForKey:@"longitude"] isEqualToString:
           [endLocationDic objectForKey:@"longitude"]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起点位置与终点位置一样，请您重新选择！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    StartNavigationViewController *nextVC = [[StartNavigationViewController alloc] init:type];
    nextVC.locationDic = locationsDic;
    [[PublicFunction ShareInstance].rootNavigationConroller pushViewController:nextVC animated:YES];
}

-(void)startEndLocationChanged
{
    NSDictionary *startLocationDic = [locationsDic objectForKey:KEY_LocationDic_startAddr];
    NSDictionary *endLocationDic = [locationsDic objectForKey:kEY_LocationDic_endAddr];
    
    if (!startLocationDic)
    {
        [locationsDic removeObjectForKey:kEY_LocationDic_endAddr];
        [locationsDic setObject:endLocationDic forKey:KEY_LocationDic_startAddr];
    }
    else if (!endLocationDic)
    {
        [locationsDic setObject:startLocationDic forKey:kEY_LocationDic_endAddr];
        [locationsDic removeObjectForKey:KEY_LocationDic_startAddr];
    }
    else
    {
        [locationsDic setObject:startLocationDic forKey:kEY_LocationDic_endAddr];
        [locationsDic setObject:endLocationDic forKey:KEY_LocationDic_startAddr];
    }
}

#pragma mark - LocationViewControllerDelegate
-(void)getLocation:(NSDictionary *)tempDic startOrEnd:(NSString *)locationTitle
{
    if ([[tempDic objectForKey:@"name"] isEqualToString:@"我的位置"])
    {
        [_navigationView getTextFieldStr:@"我的位置"];
    }
    else
    {
        switch ([[tempDic objectForKey:@"type"] intValue])
        {
            case 1:
                [_navigationView getTextFieldStr:[NSString stringWithFormat:@"%@(公交站)", [tempDic objectForKey:@"name"]]];
                break;
                
            case 3:
                [_navigationView getTextFieldStr:[NSString stringWithFormat:@"%@(地铁站)", [tempDic objectForKey:@"name"]]];
                break;
                
            default:
                [_navigationView getTextFieldStr:[tempDic objectForKey:@"name"]];
                break;
        }
    }
    
    if ([locationTitle isEqualToString:@"起点"])
    {
        [locationsDic setObject:tempDic forKey:KEY_LocationDic_startAddr];
    }
    else
    {
        [locationsDic setObject:tempDic forKey:kEY_LocationDic_endAddr];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        NSLog(@"location denied");
        if (systemLocationServiceOpened)    // 如果定位服务未打开，提示用户去设置
        {
            systemLocationServiceOpened = NO;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    myLocation.latitude = newLocation.coordinate.latitude;
    myLocation.longitude = newLocation.coordinate.longitude;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0: // 确定
        {
            NSMutableDictionary *myLocationDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"我的位置", @"name",
                [NSString stringWithFormat:@"%f", myLocation.latitude], @"latitude",
                [NSString stringWithFormat:@"%f", myLocation.longitude], @"longitude", nil];
            [locationsDic setObject:myLocationDic forKey:KEY_LocationDic_startAddr];
            
            StartNavigationViewController *nextVC = [[StartNavigationViewController alloc] init:TAG_NavigationTypeBtn_driving];
            nextVC.locationDic = locationsDic;
            [[PublicFunction ShareInstance].rootNavigationConroller pushViewController:nextVC animated:YES];
        }
            break;
            
        case 1: // 取消
            break;
            
        default:
            break;
    }
}

@end
