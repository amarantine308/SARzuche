//
//  CarInfoViewController.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "EnterpriseInfoViewController.h"
#import "IntensionCarViewController.h"
#import "AreaCitySelectController.h"
#import "NextHelpViewController.h"
#import "CarInfoViewController.h"
#import "LoginViewController.h"
#import "PublicFunction.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "ConstImage.h"

#define NOTIFICATION_CAR_GETTYPE    @"NOTIFICATION_CAR_GETTYPE"
#define NOTIFICATION_AREA_CITY      @"NOTIFICATION_AREA_CITY"
#define RGB(r,g,b,al)               [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController
{
    CarInfoView *_carInfoView;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"企业租车";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    _carInfoView = [[CarInfoView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    _carInfoView.delegate = self;   // CarInfoViewDelegate
    [self.view addSubview:_carInfoView];
    
    //注册通知
    [self initNotify];
    
    if (customNavBarView) {
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        callBtn.backgroundColor = [UIColor clearColor];
        UIImage *callImg = [UIImage imageNamed:IMG_PHONE];
        [callBtn setImage:callImg forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:callBtn];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON2];
        UIImage *helpImg = [UIImage imageNamed:IMG_HELP];
        [helpBtn setImage:helpImg forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
    }
    
    self.view.backgroundColor = RGB(236, 234, 241, 1);
}

- (void)initNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotifyInCarInfo:)
                                                 name:NOTIFICATION_CAR_GETTYPE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotifyInArea:)
                                                 name:NOTIFICATION_AREA_CITY
                                               object:nil];
}

//通知方法，此处给意向车型赋值
- (void)getNotifyInCarInfo:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    NSString *seriesstr = [dic objectForKey:@"carseries"];
    NSString *brandstr = [dic objectForKey:@"brand"];
    _carInfoView.cartypeLabel.text = [NSString stringWithFormat:@"%@ %@", brandstr, seriesstr];
    _carInfoView.brand = brandstr;
    _carInfoView.carType = seriesstr;
}

- (void)getNotifyInArea:(NSNotification *)notification
{
    NSDictionary *dic = [notification object];
    NSString *str;
    if([dic objectForKey:@"city"]){
        str = GET([dic objectForKey:@"city"]);
    }else{
        str = GET([dic objectForKey:@"state"]);
    }
    _carInfoView.cityLabel.text = str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CarInfoViewDelegate
//下一步
-(void)enterEnterpriseInfoView:(NSMutableDictionary *)dic
{
    NSLog(@"next step");
    
    //if ([PublicFunction ShareInstance].m_bLogin == YES)
    {
        EnterpriseInfoViewController *nextVC = [[EnterpriseInfoViewController alloc] init];
        nextVC.dic_data = dic;
        nextVC.title = @"企业租车";
        [self.navigationController pushViewController:nextVC animated:YES];
        nextVC = nil;
    }
//    else
//    {
//        LoginViewController *nextVC = [[LoginViewController alloc] init];
//        nextVC.isFromUserCenter = NO;
//        
//        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:nextVC];
//        [self presentViewController:loginNav animated:YES completion:^{
//        }];
//    }
}

//意向车型
-(void)enterIntensionCarView
{
    IntensionCarViewController *nextVC = [[IntensionCarViewController alloc] init];
    nextVC.title = @"选择车型";
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC = nil;
}

//选择城市
-(void)enterAreaCityController
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    NSMutableArray *dic_list =[NSMutableArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in dic_list) {
        [list addObject:dic];
    }
    AreaCitySelectController *area = [[AreaCitySelectController alloc] init];
    area.areaCityType = Select_Area;
    area.area_list = list;
    area.title = @"选择城市";
    [self.navigationController pushViewController:area animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_carInfoView resignKeyBoard];
}

-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
}

-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    [next setTitle:STR_BISNESS_INTRODUCTION];
    NSString *type = [NSString stringWithFormat:@"help%d",2];
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}


@end
