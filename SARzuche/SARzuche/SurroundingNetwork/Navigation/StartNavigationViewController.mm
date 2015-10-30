//
//  StartNavigationViewController.m
//  SARzuche
//
//  Created by admin on 14-9-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "StartNavigationViewController.h"
#import "BusLineDetailViewController.h"
#import "NavigationView.h"
#import "BusLineCell.h"
#import "ConstDefine.h"
#import "User.h"

#define Tag_DrivingSetBtn_avoidTrafficJam   1001
#define Tag_DrivingSetBtn_minToll           1002
#define Tag_DrivingSetBtn_minTime           1003
#define Tag_DrivingSetBtn_recommend         1004

#define Width_BackToMyLocationView  96.0 / 2.0
#define Height_BackToMyLocationView 96.0 / 2.0

#define Width_BackToMyLocationBtn   38.0 / 2.0
#define Height_BackToMyLocationBtn  38.0 / 2.0
#define OriginX_BackToMyLocationBtn (Width_BackToMyLocationView - Width_BackToMyLocationBtn) / 2.0
#define OriginY_BackToMyLocationBtn (Height_BackToMyLocationView - Height_BackToMyLocationBtn) / 2.0

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end


@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
	CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end


@interface StartNavigationViewController ()

@end

@implementation StartNavigationViewController
{
    int navigationType;
    UITableView *pTableView;
    NSMutableArray *pDataSource;
    NSMutableArray *instructionArray;
    
    BMKMapView *_mapView;
    BMKLocationService* _locService;
    BMKRouteSearch* _routesearch;
    BNRoutePlanMode drivingSetting;
    
    CLLocationCoordinate2D newLocation;
    int mapViewZoomLevel;
}
@synthesize locationDic;

-(void)dealloc
{
    pTableView = nil;
    pDataSource = nil;
    instructionArray = nil;
    locationDic = nil;
    
    _mapView = nil;
    _routesearch = nil;
    _locService = nil;
}

- (id)init:(int)type;
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        navigationType = type;
        switch (navigationType)
        {
            case TAG_NavigationTypeBtn_bus:
                self.title = @"公交";
                break;
                
            case TAG_NavigationTypeBtn_driving:
                self.title = @"导航";
                break;
                
            case TAG_NavigationTypeBtn_walking:
                self.title = @"步行";
                break;
                
            default:
                break;
        }
        
        locationDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initBaiduMapManager];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    switch (navigationType)
    {
        case TAG_NavigationTypeBtn_bus:
        {
            pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY) style:UITableViewStylePlain];
            pTableView.delegate = self;
            pTableView.dataSource = self;
            [self.view addSubview:pTableView];
            
            // 去掉多余的行
            UIView *foot = [[UIView alloc] init];
            [pTableView setTableFooterView:foot];
            
            pDataSource = [[NSMutableArray alloc] init];
            instructionArray = [[NSMutableArray alloc] init];
            
            _routesearch = [[BMKRouteSearch alloc] init];
            [self startNavigation];
        }
            break;
            
        case TAG_NavigationTypeBtn_driving:
        {
            UILabel *drivingSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, originY, self.view.bounds.size.width - 10*2, 20)];
            drivingSettingLabel.text = @"偏好设置条件:";
            drivingSettingLabel.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:drivingSettingLabel];
            
//            BNRoutePlanMode_Recommend			= 0X00000001 ,	/**<  推荐 */
//            BNRoutePlanMode_MinTime 			= 0X00000002 ,	/**<  最短时间 */
//            BNRoutePlanMode_MinDist 			= 0X00000004 ,	/**<  最短距离 */
//            BNRoutePlanMode_MinToll 			= 0X00000008 ,	/**<  最少收费 */
//            BNRoutePlanMode_MaxRoadWidth		= 0X00000010 ,	/**<  最大道宽 */
//            BNRoutePlanMode_AvoidTrafficJam     = 0X00000020 	/**<  躲避拥堵 */
            
            UIButton *avoidTrafficJamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            avoidTrafficJamBtn.tag = Tag_DrivingSetBtn_avoidTrafficJam;
            avoidTrafficJamBtn.frame = CGRectMake(10, originY+25, 100, 30);
            [avoidTrafficJamBtn setTitle:@"避免拥堵" forState:UIControlStateNormal];
            [avoidTrafficJamBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [avoidTrafficJamBtn setBackgroundColor:[UIColor yellowColor]];
            [avoidTrafficJamBtn addTarget:self action:@selector(drivingSetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:avoidTrafficJamBtn];
            
            UIButton *minTollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            minTollBtn.tag = Tag_DrivingSetBtn_minToll;
            minTollBtn.frame = CGRectMake(10, originY+25+35, 100, 30);
            [minTollBtn setTitle:@"避免收费" forState:UIControlStateNormal];
            [minTollBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [minTollBtn setBackgroundColor:[UIColor yellowColor]];
            [minTollBtn addTarget:self action:@selector(drivingSetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:minTollBtn];
            
            UIButton *minTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            minTimeBtn.tag = Tag_DrivingSetBtn_minTime;
            minTimeBtn.frame = CGRectMake(10, originY+25+35*2, 100, 30);
            [minTimeBtn setTitle:@"最短时间" forState:UIControlStateNormal];
            [minTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [minTimeBtn setBackgroundColor:[UIColor yellowColor]];
            [minTimeBtn addTarget:self action:@selector(drivingSetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:minTimeBtn];
            
            UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            recommendBtn.tag = Tag_DrivingSetBtn_recommend;
            recommendBtn.frame = CGRectMake(10, originY+25+35*3, 100, 30);
            [recommendBtn setTitle:@"推荐路线" forState:UIControlStateNormal];
            [recommendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [recommendBtn setBackgroundColor:[UIColor yellowColor]];
            [recommendBtn addTarget:self action:@selector(drivingSetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:recommendBtn];
        }
            break;
            
        case TAG_NavigationTypeBtn_walking:
        {
            mapViewZoomLevel = 16;
            _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
            _mapView.mapType = BMKMapTypeStandard;
            _mapView.zoomLevel = mapViewZoomLevel;  // 地图比例尺级别
            _mapView.showMapScaleBar = YES;         // 显式比例尺
            [self.view addSubview:_mapView];
            _locService = [[BMKLocationService alloc] init];
            _routesearch = [[BMKRouteSearch alloc] init];
            
#if TARGET_IPHONE_SIMULATOR
            newLocation.latitude = 31.980802;
            newLocation.longitude = 118.763257;
            _mapView.centerCoordinate = newLocation;
#endif
            
            float originX = 15;
            float Width_zoomBackView = 96.0 / 2.0;
            float Height_zoomBackView = 185.0 / 2.0;
            // 地图缩小放大按钮的显示
            UIView *zoomBackView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - Width_zoomBackView - originX, originY+15, Width_zoomBackView, Height_zoomBackView)];
            [self.view addSubview:zoomBackView];
            
            UIImageView *zoomBackimg = [[UIImageView alloc] initWithFrame:zoomBackView.bounds];
            zoomBackimg.image = [UIImage imageNamed:@"放大缩小-背景.png"];
            [zoomBackView addSubview:zoomBackimg];
            
            float Height_enlargeBtn = 184.0 / 4;
            // 地图放大按钮
            UIImageView *enlargeImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 16, 16)];
            enlargeImg.image = [UIImage imageNamed:@"放大.png"];
            [zoomBackView addSubview:enlargeImg];
            
            UIButton *enlargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            enlargeBtn.frame = CGRectMake(0, 0, Width_zoomBackView, Height_enlargeBtn);
            [enlargeBtn setBackgroundColor:[UIColor clearColor]];
            [enlargeBtn addTarget:self action:@selector(enlargeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [zoomBackView addSubview:enlargeBtn];
            
            UIImageView *sepratorImg = [[UIImageView alloc] initWithFrame:CGRectMake(4, Height_enlargeBtn, 40, 0.5)];
            sepratorImg.image = [UIImage imageNamed:@"放大缩小-背景-分割线.png"];
            [zoomBackView addSubview:sepratorImg];
            
            // 地图缩小按钮
            UIImageView *lessenImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, Height_enlargeBtn+0.5+15, 16, 16)];
            lessenImg.image = [UIImage imageNamed:@"缩小.png"];
            [zoomBackView addSubview:lessenImg];
            
            UIButton *lessenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lessenBtn.frame = CGRectMake(0, Height_enlargeBtn+0.5, Width_zoomBackView, Height_enlargeBtn);
            [lessenBtn setBackgroundColor:[UIColor clearColor]];
            [lessenBtn addTarget:self action:@selector(lessenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [zoomBackView addSubview:lessenBtn];
            
            originX = 10;
            // 回到我的位置
            UIView *backToMyLocationView = [[UIView alloc] initWithFrame:CGRectMake(originX, self.view.bounds.size.height - 53, Width_BackToMyLocationView, Height_BackToMyLocationView)];
            [self.view addSubview:backToMyLocationView];
            
            UIImageView *backToMyLocationImg = [[UIImageView alloc] initWithFrame:backToMyLocationView.bounds];
            backToMyLocationImg.image = [UIImage imageNamed:@"全屏-背景.png"];
            [backToMyLocationView addSubview:backToMyLocationImg];
            
            UIButton *backToMyLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backToMyLocationBtn.frame = CGRectMake(OriginX_BackToMyLocationBtn, OriginY_BackToMyLocationBtn, Width_BackToMyLocationBtn, Height_BackToMyLocationBtn);
            [backToMyLocationBtn setBackgroundImage:[UIImage imageNamed:@"全屏.png"] forState:UIControlStateNormal];
            [backToMyLocationBtn addTarget:self action:@selector(backToMyLocationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [backToMyLocationView addSubview:backToMyLocationBtn];
            
            // 百度地图上比例尺的位置
            CGPoint point;
            point.x = originX + Width_BackToMyLocationView;
            point.y = self.view.bounds.size.height - 95;
            _mapView.mapScaleBarPosition = point;
            
            [self startNavigation];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    switch (navigationType)
    {
        case TAG_NavigationTypeBtn_bus:
        {
            _routesearch.delegate = self;   // BMKRouteSearchDelegate
        }
            break;
            
        case TAG_NavigationTypeBtn_driving:
            break;
            
        case TAG_NavigationTypeBtn_walking:
        {
            _routesearch.delegate = self;   // BMKRouteSearchDelegate
            
            [_mapView viewWillAppear];
            _mapView.delegate = self;       // BMKMapViewDelegate
            _locService.delegate = self;    // BMKLocationServiceDelegate
            
            [_locService startUserLocationService];
            _mapView.showsUserLocation = NO;//先关闭显示的定位图层
            _mapView.userTrackingMode = BMKUserTrackingModeFollow;  //设置定位的状态
            _mapView.showsUserLocation = YES;//显示定位图层
        }
            break;
            
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    switch (navigationType)
    {
        case TAG_NavigationTypeBtn_bus:
        {
            _routesearch.delegate = nil;
        }
            break;
            
        case TAG_NavigationTypeBtn_driving:
            break;
            
        case TAG_NavigationTypeBtn_walking:
        {
            _routesearch.delegate = nil;
            
            [_mapView viewWillDisappear];
            _mapView.delegate = nil;
            _locService.delegate = nil;
            
            [_locService stopUserLocationService];
            _mapView.showsUserLocation = NO;
        }
            break;
            
        default:
            break;
    }
}

// 初始化百度地图引擎
-(void)initBaiduMapManager
{
    if (![User shareInstance].mapManager)
    {
        //百度地图
        [User shareInstance].mapManager = [[BMKMapManager alloc] init];
        BOOL ret = [[User shareInstance].mapManager start:BAIDUMAPID generalDelegate:self]; // BMKGeneralDelegate
        if (!ret)
        {
            NSLog(@"baidu map manager start failed!");
        }
        
        // 初始化导航SDK引擎
        [BNCoreServices_Instance initServices:BAIDUMAPID];
        
        //开启引擎，传入默认的TTS类
        [BNCoreServices_Instance startServicesAsyn:nil fail:nil SoundService:[BNaviSoundManager getInstance]];
    }
}

-(void)startNavigation
{
    NSDictionary *startAddressDic = [locationDic objectForKey:KEY_LocationDic_startAddr];
    NSDictionary *endAddressDic = [locationDic objectForKey:kEY_LocationDic_endAddr];
    
    CLLocationCoordinate2D startLocation;
    startLocation.latitude = [[startAddressDic objectForKey:@"latitude"] floatValue];
    startLocation.longitude = [[startAddressDic objectForKey:@"longitude"] floatValue];
    
    CLLocationCoordinate2D endLocation;
    endLocation.latitude = [[endAddressDic objectForKey:@"latitude"] floatValue];
    endLocation.longitude = [[endAddressDic objectForKey:@"longitude"] floatValue];
    
    switch (navigationType)
    {
        case TAG_NavigationTypeBtn_bus:
        {
            BMKPlanNode* start = [[BMKPlanNode alloc] init] ;
            start.pt = startLocation;
            
            BMKPlanNode* end = [[BMKPlanNode alloc] init] ;
            end.pt = endLocation;
            
            BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
            transitRouteSearchOption.from = start;
            transitRouteSearchOption.to = end;
            transitRouteSearchOption.city = @"南京";
            BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
            if(flag)
            {
                NSLog(@"bus检索发送成功");
            }
            else
            {
                NSLog(@"bus检索发送失败");
            }
        }
            break;
            
        case TAG_NavigationTypeBtn_driving:
        {
            NSMutableArray *nodesArray = [[NSMutableArray alloc] init];
            
            // 起点
            BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
            startNode.pos = [[BNPosition alloc] init];
            startNode.pos.x = startLocation.longitude;
            startNode.pos.y = startLocation.latitude;
            startNode.pos.eType = BNCoordinate_BaiduMapSDK;
            [nodesArray addObject:startNode];
                        
            //终点
            BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
            endNode.pos = [[BNPosition alloc] init];
            endNode.pos.x = endLocation.longitude;
            endNode.pos.y = endLocation.latitude;
            endNode.pos.eType = BNCoordinate_BaiduMapSDK;
            [nodesArray addObject:endNode];
            
            [BNCoreServices_RoutePlan startNaviRoutePlan:drivingSetting naviNodes:nodesArray time:nil delegete:self userInfo:nil];
            
//            NSMutableArray *nodesArray = [[NSMutableArray alloc]initWithCapacity:2];
//            //起点 传入的是原始的经纬度坐标，若使用的是百度地图坐标，可以使用BNTools类进行坐标转化
//            BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//            startNode.pos = [[BNPosition alloc] init];
//            startNode.pos.x = 116.30142;
//            startNode.pos.y = 40.05087;
//            startNode.pos.eType = BNCoordinate_OriginalGPS;
//            [nodesArray addObject:startNode];
//            
//            //也可以在此加入1到3个的途经点
//            
//            BNRoutePlanNode *midNode = [[BNRoutePlanNode alloc] init];
//            midNode.pos = [[BNPosition alloc] init];
//            midNode.pos.x = 116.12;
//            midNode.pos.y = 39.05087;
//            midNode.pos.eType = BNCoordinate_OriginalGPS;
//            [nodesArray addObject:midNode];
//            
//            //终点
//            BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//            endNode.pos = [[BNPosition alloc] init];
//            endNode.pos.x = 116.39750;
//            endNode.pos.y = 39.90882;
//            endNode.pos.eType = BNCoordinate_OriginalGPS;
//            [nodesArray addObject:endNode];
//            
//            [BNCoreServices_RoutePlan startNaviRoutePlan:BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self userInfo:nil];
        }
            break;
            
        case TAG_NavigationTypeBtn_walking:
        {
#if TARGET_IPHONE_SIMULATOR
            _mapView.centerCoordinate = startLocation;
#endif
            
            BMKPlanNode* start = [[BMKPlanNode alloc]init];
            start.pt = startLocation;
            BMKPlanNode* end = [[BMKPlanNode alloc]init];
            end.pt = endLocation;
            
            BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
            walkingRouteSearchOption.from = start;
            walkingRouteSearchOption.to = end;
            BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
            if(flag)
            {
                NSLog(@"walk检索发送成功");
            }
            else
            {
                NSLog(@"walk检索发送失败");
            }
        }
            break;
            
        default:
            break;
    }
}

-(int)getWalkLongFromInstruction:(NSString *)srcString
{
    int walkLong;
    
    NSRange range1 = [srcString rangeOfString:@"步行"];
    
    int start = range1.location + range1.length;
    int length = [srcString rangeOfString:@"米"].location - start;
    if (length > srcString.length)
    {
        length = [srcString rangeOfString:@"公里"].location - start;
        walkLong = [[srcString substringWithRange:NSMakeRange(start, length)] floatValue] * 1000;
    }
    else
    {
        walkLong = [[srcString substringWithRange:NSMakeRange(start, length)] intValue];
    }
    
    return walkLong;
}

-(int)getStationNumFromInstruction:(NSString *)srcString
{
    NSRange range1 = [srcString rangeOfString:@"经过"];
    
    int start = range1.location + range1.length;
    int length = [srcString rangeOfString:@"站" options:NSBackwardsSearch].location - start;
    
    return [[srcString substringWithRange:NSMakeRange(start, length)] intValue];
}

-(NSString *)getBusNumFromInstruction:(NSString *)srcString
{
    NSRange range1 = [srcString rangeOfString:@"乘坐"];
    
    int start = range1.location + range1.length;
    int length = [srcString rangeOfString:@"经过" options:NSBackwardsSearch].location - start;
    
    return [srcString substringWithRange:NSMakeRange(start, length)];
}

#pragma mark - 按钮点击事件

-(void)backToMyLocationBtnClicked
{
    _mapView.centerCoordinate = newLocation;
}

-(void)enlargeBtnClicked
{
    mapViewZoomLevel = _mapView.zoomLevel;
    if (mapViewZoomLevel < 19)
        mapViewZoomLevel++;
    _mapView.zoomLevel = mapViewZoomLevel;
}

-(void)lessenBtnClicked
{
    mapViewZoomLevel = _mapView.zoomLevel;
    if (mapViewZoomLevel > 3)
        mapViewZoomLevel--;
    _mapView.zoomLevel = mapViewZoomLevel;
}

-(void)drivingSetBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case Tag_DrivingSetBtn_avoidTrafficJam:
            drivingSetting = BNRoutePlanMode_AvoidTrafficJam;
            break;
            
        case Tag_DrivingSetBtn_minToll:
            drivingSetting = BNRoutePlanMode_MinToll;
            break;
            
        case Tag_DrivingSetBtn_minTime:
            drivingSetting = BNRoutePlanMode_MinTime;
            break;
            
        case Tag_DrivingSetBtn_recommend:
            drivingSetting = BNRoutePlanMode_Recommend;
            break;
            
        default:
            break;
    }
    [self startNavigation];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BusLineDetailViewController *nextVC = [[BusLineDetailViewController alloc] init];
    nextVC.pDataSource = [instructionArray objectAtIndex:indexPath.row];
    nextVC.startLocation = [[locationDic objectForKey:KEY_LocationDic_startAddr] objectForKey:@"name"];
    nextVC.endLocation = [[locationDic objectForKey:kEY_LocationDic_endAddr] objectForKey:@"name"];
    nextVC.busLine = [[pDataSource objectAtIndex:indexPath.row] objectForKey:@"busLineTitle"];
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC = nil;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"StartNavigationViewCell";
    BusLineCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[BusLineCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *busLineDic = [pDataSource objectAtIndex:indexPath.row];
    cell.busNumLabel.text = [busLineDic objectForKey:@"busLineTitle"];

    float walkLong = [[busLineDic objectForKey:@"walkLong"] intValue];
    if (walkLong < 1000)
    {
        cell.detailLabel.text = [NSString stringWithFormat:@"约%@|%@站|%@公里|步行%@米", [busLineDic objectForKey:@"duration"], [busLineDic objectForKey:@"stationNum"], [busLineDic objectForKey:@"distance"], [busLineDic objectForKey:@"walkLong"]];
    }
    else
    {
        cell.detailLabel.text = [NSString stringWithFormat:@"约%@|%@站|%@公里|步行%.1f公里", [busLineDic objectForKey:@"duration"], [busLineDic objectForKey:@"stationNum"], [busLineDic objectForKey:@"distance"], walkLong/1000];
    }
    
    return cell;
}

#pragma mark - BNNaviRoutePlanDelegate
//算路成功回调
-(void)routePlanDidFinished:(NSDictionary *)userInfo
{
    NSLog(@"算路成功");
    
    //路径规划成功，开始导航
    [BNCoreServices_UI showNaviUI:BN_NaviTypeReal delegete:self isNeedLandscape:YES];
}

//算路失败回调
- (void)routePlanDidFailedWithError:(NSError *)error andUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"算路失败");
    if ([error code] == BNRoutePlanError_LocationFailed)
    {
        NSLog(@"获取地理位置失败");
    }
    else if ([error code] == BNRoutePlanError_LocationServiceClosed)
    {
        NSLog(@"定位服务未开启");
    }
}

//算路取消回调
-(void)routePlanDidUserCanceled:(NSDictionary*)userInfo
{
    NSLog(@"算路取消");
}

#pragma mark - BNNaviUIManagerDelegate

//退出导航回调
-(void)onExitNaviUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航");
    [self.navigationController popViewControllerAnimated:YES];
}

//退出导航声明页面回调
- (void)onExitexitDeclarationUI:(NSDictionary*)extraInfo
{
    NSLog(@"退出导航声明页面");
}

#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
#if !TARGET_IPHONE_SIMULATOR
    [_mapView updateLocationData:userLocation];
#endif
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
#if !TARGET_IPHONE_SIMULATOR
    [_mapView updateLocationData:userLocation];
    newLocation.longitude = userLocation.location.coordinate.longitude;
    newLocation.latitude = userLocation.location.coordinate.latitude;
#endif
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

#pragma mark - BMKRouteSearchDelegate
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
	return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type)
    {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"icon_nav_start.png"];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
            
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"icon_nav_end.png"];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
            
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"icon_nav_bus.png"];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
            
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"icon_nav_rail.png"];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
            
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc] initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			}
            else
            {
				[view setNeedsDisplay];
			}
			
            UIImage *image = [UIImage imageNamed:@"icon_direction.png"];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
            
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
			if (view == nil)
            {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
				view.canShowCallout = TRUE;
			}
            else
            {
				[view setNeedsDisplay];
			}
			
            UIImage *image = [UIImage imageNamed:@"icon_nav_waypoint.png"];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
        }
            break;
            
		default:
			break;
	}
	
	return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]])
    {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
	return nil;
}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (BMK_SEARCH_ST_EN_TOO_NEAR == error)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"终点离起点太近，建议步行" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.delegate = self;
        [alertView show];
    }
    else if (BMK_SEARCH_NO_ERROR == error)
    {
        [pDataSource removeAllObjects];
        for (BMKTransitRouteLine *transitLine in result.routes)
        {
            NSMutableString *busLineTitle = [NSMutableString stringWithString:@""];
            NSString *duration;
            int walkLong = 0;
            int stationNum = 0;
            
            if (0 == transitLine.duration.dates)
            {
                if (0 == transitLine.duration.hours)
                {
                    duration = [NSString stringWithFormat:@"%d分", transitLine.duration.minutes];
                }
                else
                {
                    duration = [NSString stringWithFormat:@"%d时%d分", transitLine.duration.hours, transitLine.duration.minutes];
                }
            }
            else
            {
                duration = [NSString stringWithFormat:@"%d天%d时%d分", transitLine.duration.dates, transitLine.duration.hours, transitLine.duration.minutes];
            }
            
            int stepsCount = [transitLine.steps count];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (int i = 0; i < stepsCount; i++)
            {
                BMKTransitStep* transitStep = [transitLine.steps objectAtIndex:i];
                if (BMK_WAKLING == transitStep.stepType)
                {
                    walkLong += [self getWalkLongFromInstruction:transitStep.instruction];
                }
                else
                {
                    stationNum += [self getStationNumFromInstruction:transitStep.instruction];
                    if ([busLineTitle isEqualToString:@""])
                    {
                        [busLineTitle appendString:[self getBusNumFromInstruction:transitStep.instruction]];
                    }
                    else
                    {
                        [busLineTitle appendFormat:@"->%@", [self getBusNumFromInstruction:transitStep.instruction]];
                    }
                }
                
                if (0 == i)
                {
                    [tempArray addObject:[NSString stringWithFormat:@"从%@出发,步行%d米", [[locationDic objectForKey:KEY_LocationDic_startAddr] objectForKey:@"name"], walkLong]];
                }
                else if (stepsCount - 1 == i)
                {
                    NSMutableString *tempStr = [NSMutableString stringWithString:transitStep.instruction];
                    NSRange range1 = [tempStr rangeOfString:@"到达"];
                    int start = range1.location + range1.length;
                    
                    [tempStr deleteCharactersInRange:NSMakeRange(start, tempStr.length - start)];
                    [tempStr appendString:[[locationDic objectForKey:kEY_LocationDic_endAddr] objectForKey:@"name"]];
                    
                    [tempArray addObject:tempStr];
                }
                else
                {
                    [tempArray addObject:transitStep.instruction];
                }
            }

            [instructionArray addObject:tempArray];
            
            float distance = transitLine.distance;
            distance = distance / 1000;
            
            NSMutableDictionary *busLineDic = [NSMutableDictionary dictionary];
            [busLineDic setObject:busLineTitle forKey:@"busLineTitle"];
            [busLineDic setObject:duration forKey:@"duration"];   // 时间
            [busLineDic setObject:[NSString stringWithFormat:@"%d", stationNum] forKey:@"stationNum"];
            [busLineDic setObject:[NSString stringWithFormat:@"%.1f", distance] forKey:@"distance"];
            [busLineDic setObject:[NSString stringWithFormat:@"%d", walkLong] forKey:@"walkLong"];
            [pDataSource addObject:busLineDic];
        }
        [pTableView reloadData];
    }
}

//- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
//{
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//	[_mapView removeAnnotations:array];
//	array = [NSArray arrayWithArray:_mapView.overlays];
//	[_mapView removeOverlays:array];
//    
//	if (error == BMK_SEARCH_NO_ERROR)
//    {
//        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
//        // 计算路线方案中的路段数目
//		int size = [plan.steps count];
//		int planPointCounts = 0;
//		for (int i = 0; i < size; i++)
//        {
//            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
//            if (i == 0)
//            {
//                RouteAnnotation* item = [[RouteAnnotation alloc] init];
//                item.coordinate = plan.starting.location;
//                item.title = @"起点";
//                item.type = 0;
//                [_mapView addAnnotation:item]; // 添加起点标注
//            }
//            else if(i == size - 1)
//            {
//                RouteAnnotation* item = [[RouteAnnotation alloc] init];
//                item.coordinate = plan.terminal.location;
//                item.title = @"终点";
//                item.type = 1;
//                [_mapView addAnnotation:item]; // 添加起点标注
//            }
//            
//            //添加annotation节点
//            RouteAnnotation* item = [[RouteAnnotation alloc]init];
//            item.coordinate = transitStep.entrace.location;
//            item.title = transitStep.entraceInstruction;
//            item.degree = transitStep.direction * 30;
//            item.type = 4;
//            [_mapView addAnnotation:item];
//
//            //轨迹点总数累计
//            planPointCounts += transitStep.pointsCount;
//        }
//        
//        // 添加途经点
//        if (plan.wayPoints)
//        {
//            for (BMKPlanNode* tempNode in plan.wayPoints)
//            {
//                RouteAnnotation* item = [[RouteAnnotation alloc] init];
//                item = [[RouteAnnotation alloc]init];
//                item.coordinate = tempNode.pt;
//                item.type = 5;
//                item.title = tempNode.name;
//                [_mapView addAnnotation:item];
//            }
//        }
//        
//        //轨迹点
//        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
//        int i = 0;
//        for (int j = 0; j < size; j++)
//        {
//            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
//            int k = 0;
//            for (k = 0; k < transitStep.pointsCount; k++)
//            {
//                temppoints[i].x = transitStep.points[k].x;
//                temppoints[i].y = transitStep.points[k].y;
//                i++;
//            }
//        }
//        
//        // 通过points构建BMKPolyline
//		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
//		[_mapView addOverlay:polyLine]; // 添加路线overlay
//	}
//}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
    
	if (error == BMK_SEARCH_NO_ERROR)
    {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
		int size = [plan.steps count];
		int planPointCounts = 0;
		for (int i = 0; i < size; i++)
        {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if (i == 0)
            {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            else if (i == size - 1)
            {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++)
        {
            BMKWalkingStep *transitStep = [plan.steps objectAtIndex:j];
            int k = 0;
            for(k = 0; k < transitStep.pointsCount; k++)
            {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
        }
        
        // 通过points构建BMKPolyline
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
		[_mapView addOverlay:polyLine]; // 添加路线overlay
	}
}

#pragma mark - BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 != iError)
        NSLog(@"onGetNetworkState %d",iError);
}

- (void)onGetPermissionState:(int)iError
{
    if (0 != iError)
        NSLog(@"onGetPermissionState %d",iError);
}

@end
