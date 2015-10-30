//
//  MyCarViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyCarViewController.h"
#import "ConstString.h"
#import "ConfirmGivebackViewController.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "MyOrdersData.h"
#import "ConstDefine.h"
#import "OrderManager.h"
#import "BranchDataManager.h"
#import "CarDataManager.h"
#import "PublicFunction.h"
#import "LoadingClass.h"
#import "BranchesMapViewController.h"
#import "ConstImage.h"
#import "CustomAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "NSDataEx.h"


#define CAR_OP_GAP                  15
#define CAR_OP_BTN_W                (MainScreenWidth - CAR_OP_GAP * 3)/2
#define CAR_OP_BTN_H                90

#define HEIGHT_LABEL                40
#define HEIGHT_BTN_LABEL            30
#define LABEL_START_Y               (controllerViewStartY + CAR_OP_BTN_H * 2 + CAR_OP_GAP * 3)

#define FRAME_BTN_HONKING         CGRectMake(CAR_OP_GAP,  controllerViewStartY + CAR_OP_GAP, CAR_OP_BTN_W, CAR_OP_BTN_H)
#define FRAME_BTN_OPENDOOR        CGRectMake(CAR_OP_BTN_W + CAR_OP_GAP * 2, controllerViewStartY + CAR_OP_GAP, CAR_OP_BTN_W, CAR_OP_BTN_H)
#define FRAME_BTN_CLOSEDOOR       CGRectMake(CAR_OP_GAP,  controllerViewStartY + CAR_OP_BTN_H + CAR_OP_GAP * 2, CAR_OP_BTN_W, CAR_OP_BTN_H)
#define FRAME_BTN_GIVEBACK        CGRectMake(CAR_OP_BTN_W + CAR_OP_GAP * 2, controllerViewStartY + CAR_OP_BTN_H + CAR_OP_GAP * 2, CAR_OP_BTN_W, CAR_OP_BTN_H)

#define FRAME_INFO_LABEL_BG       CGRectMake(0, 0, MainScreenWidth, 55)
#define FRAME_INFO_LABEL          CGRectMake(10, 0, MainScreenWidth, HEIGHT_LABEL)
#define FRAME_CAR_INFO            CGRectMake(0, HEIGHT_LABEL, MainScreenWidth, 50)

//#define FRAME_SCROLL_VIEW         CGRectMake(0, LABEL_START_Y + 2, MainScreenWidth, MainScreenHeight - LABEL_START_Y-2 -kViewCaculateBarHeight)
#define FRAME_SCROLL_VIEW         CGRectMake(0, LABEL_START_Y + 2, MainScreenWidth, MainScreenHeight - LABEL_START_Y-2)

//#define FRAME_CAR_RENT_BTN              CGRectMake(0, MainScreenHeight - bottomButtonHeight -kViewCaculateBarHeight, MainScreenWidth, bottomButtonHeight)
#define FRAME_CAR_RENT_BTN              CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)
#if 0//SAR_TEST
#define MYCAR_TEST  1
#else
#define MYCAR_TEST  0
#endif


#define BAIDU_GPS   1


#define IMG_CLOSE_BG        @"icon_closedoor_background.png"
#define IMG_CLOSE           @"icon_closedoor.png"
#define IMG_GIVEBACK_BG     @"icon_giveback_background.png"
#define IMG_GIVEBACK        @"icon_giveback.png"
#define IMG_HONKING_BG      @"icon_honking_background.png"
#define IMG_HONKING         @"icon_honking.png"
#define IMG_OPENDOOR_BG     @"icon_opendoor_background.png"
#define IMG_OPENDOOR        @"icon_opendoor.png"

#define IMG_DISABLE_GB_BG   @"icon_disable_giveback_bk.png"
#define IMG_DISABLE_GB      @"icon_disable_giveback.png"

@interface MyCarViewController ()
{
    // 我的车辆操作按钮
    UIButton *m_honking;
    UIButton *m_openDoor;
    UIButton *m_closeDoor;
    UIButton *m_giveback;
    
    //订单信息
    PersonalCarInfoView *m_carInfo;
    
    //订单数据
    srvOrderData *m_myOrderData;
    NSInteger m_branchCount;
    
    //无订单提示
    UIView *m_noOrderView;
    UILabel *m_noOrderLabel;
    UIButton *m_toRentCar;
    BOOL m_bHaveOrder;
    
    // car price
    NSMutableArray *m_workingDayArr;
    NSMutableArray *m_weekendArr;
    NSMutableArray *m_holidayArr;
    // SCROLLVIEW
    UIScrollView * m_scrollView;
    NSInteger m_scllHeight;
    
    NSTimer *m_Timer;
    
    CLLocationManager *m_locationManager;
    CLLocationCoordinate2D myLocation;  // 记录位置
    CLLocationCoordinate2D m_baiduLocation;
    
    BMKLocationService* m_locService;
    BOOL m_bGotGPS;
}
@end

@implementation MyCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _type = 0;//初始化
    [self getCurOrder];
    
    [self initMyCarView];
#if BAIDU_GPS
    m_bGotGPS = NO;
    [self initBaiduMapManager];
    [self initBaiduLocationService];
#else
    [self initLocationManager];
#endif
}

-(void)dealloc
{
    NSLog(@"navigationView dealloc()");
#if BAIDU_GPS
    m_locService = nil;
#else
    [self uninitLocationManager];
#endif
}

-(void)uninitLocationManager
{
    if (nil != m_locationManager)
    {
        [m_locationManager stopUpdatingLocation];
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
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)
    {
        NSLog(@"location denied");
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    myLocation.latitude = newLocation.coordinate.latitude;
    myLocation.longitude = newLocation.coordinate.longitude;
#if BAIDU_GPS
#else
    m_baiduLocation = [self convertLocationToBaidu:myLocation];
#endif
}


-(CLLocationCoordinate2D)convertLocationToBaidu:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D newLocation;
    
    NSDictionary *locationDic = BMKConvertBaiduCoorFrom(myLocation, BMK_COORDTYPE_COMMON);
    
    NSString *tmpLat = [locationDic objectForKey:@"y"];
    NSString *tmpLon = [locationDic objectForKey:@"x"];
    //    NSString *lat = [tmpLat dec]
    
    NSData * latEncode = [NSData dataWithBase64EncodedString:tmpLat];
    NSString *resultLat = [[NSString alloc]initWithData:latEncode encoding:NSUTF8StringEncoding ];
    NSString *bmkLat = [resultLat stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    newLocation.latitude = [bmkLat floatValue];
    
    NSData * lonEncode = [NSData dataWithBase64EncodedString:tmpLon];
    NSString *resultLon = [[NSString alloc]initWithData:lonEncode encoding:NSUTF8StringEncoding ];
    NSString *bmkLon = [resultLon stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    newLocation.longitude = [bmkLon floatValue];

    return newLocation;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setLeftButton:@"back.png" target:self leftBtnAction:@selector(backButtonPressed)];
        [customNavBarView setTitle:STR_MY_CAR];
    }
    
    [self timerStart];
#if BAIDU_GPS
    m_locService.delegate = self;// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
    [m_locService startUserLocationService];        // 打开定位服务
#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self timerStop];
#if BAIDU_GPS
    m_locService.delegate = nil;
    [m_locService stopUserLocationService];  // 关闭定位服务
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 定时器开
-(void)timerStart
{
//    needDisabelGiveback
    m_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkOrderTime) userInfo:nil repeats:YES];
}

// 定时检查订单
-(void)checkOrderTime
{
    if ([self needDisabelGiveback:m_myOrderData])
    {
        [m_giveback setEnabled:NO];
    }
    else
    {
        [m_giveback setEnabled:YES];
    }
}

// 停止定时器
-(void)timerStop
{
    [m_Timer invalidate];
    m_Timer = nil;
}

// 返回
-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *方法描述：当前订单请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCurOrder
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    NSString *userId = [User shareInstance].id;
    FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance] getCurrentOrderInfo:userId delegate:self];
    
    tmpRequest = nil;
#if MYCAR_TEST
    [self getAuthentication];
#endif
}

/**
 *方法描述：初始化我的处理View
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initMyCarView
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    m_scrollView.backgroundColor = COLOR_BACKGROUND;
    m_scrollView.userInteractionEnabled = YES;
    [self.view addSubview:m_scrollView];
    
    CGRect rcTitle = CGRectMake(0, 3, CAR_OP_BTN_W, HEIGHT_BTN_LABEL);
    UILabel *tmpBtnLabel = [[UILabel alloc] initWithFrame:rcTitle];
    tmpBtnLabel.text = STR_HONKING;
    tmpBtnLabel.font = BOLD_FONT_LABEL_TITLE;
    tmpBtnLabel.textAlignment = NSTextAlignmentCenter;
    tmpBtnLabel.textColor = [UIColor whiteColor];
    tmpBtnLabel.backgroundColor = [UIColor clearColor];
    
     m_honking = [[UIButton alloc] initWithFrame:FRAME_BTN_HONKING];
    [m_honking setBackgroundImage:[UIImage imageNamed:IMG_HONKING_BG] forState:UIControlStateNormal];
    [m_honking setImage:[UIImage imageNamed:IMG_HONKING] forState:UIControlStateNormal];
    [m_honking addTarget:self action:@selector(honkingPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_honking addSubview:tmpBtnLabel];
    
    tmpBtnLabel = [[UILabel alloc] initWithFrame:rcTitle];
    tmpBtnLabel.text = STR_OPEN_DOOR;
    tmpBtnLabel.font = BOLD_FONT_LABEL_TITLE;
    tmpBtnLabel.textAlignment = NSTextAlignmentCenter;
    tmpBtnLabel.textColor = [UIColor whiteColor];
    tmpBtnLabel.backgroundColor = [UIColor clearColor];
    m_openDoor = [[UIButton alloc]initWithFrame:FRAME_BTN_OPENDOOR];
    [m_openDoor setImage:[UIImage imageNamed:IMG_OPENDOOR] forState:UIControlStateNormal];
    [m_openDoor setBackgroundImage:[UIImage imageNamed:IMG_OPENDOOR_BG] forState:UIControlStateNormal];
    [m_openDoor addTarget:self action:@selector(openDoorPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_openDoor addSubview:tmpBtnLabel];
    
    tmpBtnLabel = [[UILabel alloc] initWithFrame:rcTitle];
    tmpBtnLabel.text = STR_CLOSE_DOOR;
    tmpBtnLabel.font = BOLD_FONT_LABEL_TITLE;
    tmpBtnLabel.textAlignment = NSTextAlignmentCenter;
    tmpBtnLabel.textColor = [UIColor whiteColor];
    tmpBtnLabel.backgroundColor = [UIColor clearColor];
    m_closeDoor = [[UIButton alloc] initWithFrame:FRAME_BTN_CLOSEDOOR];
    [m_closeDoor setBackgroundImage:[UIImage imageNamed:IMG_CLOSE_BG] forState:UIControlStateNormal];
    [m_closeDoor setImage:[UIImage imageNamed:IMG_CLOSE] forState:UIControlStateNormal];
    [m_closeDoor addTarget:self action:@selector(closeDoorPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_closeDoor addSubview:tmpBtnLabel];
    
    tmpBtnLabel = [[UILabel alloc] initWithFrame:rcTitle];
    tmpBtnLabel.text = STR_GIVEBACK_CAR;
    tmpBtnLabel.font = BOLD_FONT_LABEL_TITLE;
    tmpBtnLabel.textAlignment = NSTextAlignmentCenter;
    tmpBtnLabel.textColor = [UIColor whiteColor];
    tmpBtnLabel.backgroundColor = [UIColor clearColor];
    m_giveback = [[UIButton alloc] initWithFrame:FRAME_BTN_GIVEBACK];
    [m_giveback setImage:[UIImage imageNamed:IMG_GIVEBACK] forState:UIControlStateNormal];
    [m_giveback setImage:[UIImage imageNamed:IMG_DISABLE_GB] forState:UIControlStateDisabled];
    [m_giveback setBackgroundImage:[UIImage imageNamed:IMG_DISABLE_GB_BG] forState:UIControlStateDisabled];
    [m_giveback setBackgroundImage:[UIImage imageNamed:IMG_GIVEBACK_BG] forState:UIControlStateNormal];
    [m_giveback addTarget:self action:@selector(givebackPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_giveback addSubview:tmpBtnLabel];
    
    
    [self.view addSubview:m_honking];
    [self.view addSubview:m_openDoor];
    [self.view addSubview:m_closeDoor];
    [self.view addSubview:m_giveback];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:FRAME_INFO_LABEL_BG];
    tmpView.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:tmpView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:FRAME_INFO_LABEL];
    infoLabel.text = STR_ORDER_INFO;
    infoLabel.font = FONT_LABEL_TITLE;
    infoLabel.textColor = COLOR_LABEL_GRAY;
    infoLabel.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:infoLabel];
    
    CGRect rect = CGRectMake(0, infoLabel.frame.origin.y + infoLabel.frame.size.height-1, MainScreenWidth, 2);
    tmpView = [[PublicFunction ShareInstance] getSeparatorView:rect];
    [m_scrollView addSubview:tmpView];
    
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CAR_INFO forUsed:forCurOrder];
    m_carInfo.delegate = self;
    [m_scrollView addSubview:m_carInfo];
    //隐藏我的车辆的跳转到地图的图标
    UIButton *takeOutcar = (UIButton *)[ m_carInfo viewWithTag:10000];
    takeOutcar.hidden =YES;
    UIButton *giveBackcar = (UIButton *)[ m_carInfo viewWithTag:10001];
    giveBackcar.hidden =YES;


    m_scrollView.contentSize = CGSizeMake(0, m_carInfo.frame.origin.y + m_carInfo.frame.size.height);
    
    m_noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)];
    m_noOrderView.backgroundColor = [UIColor whiteColor];
    m_noOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (MainScreenHeight- controllerViewStartY)/2, MainScreenWidth - 20, 40)];
    m_noOrderLabel.text = STR_NO_ORDER;
    m_noOrderLabel.textColor = [UIColor blackColor];
    m_noOrderLabel.textAlignment = NSTextAlignmentCenter;
    [m_noOrderView addSubview:m_noOrderLabel];
    
    CGRect tmpRect = CGRectMake(0, m_noOrderView.frame.size.height - bottomButtonHeight, m_noOrderView.frame.size.width, bottomButtonHeight);
    m_toRentCar = [[UIButton alloc] initWithFrame:tmpRect];
    [m_toRentCar setTitle:STR_TO_RENT forState:UIControlStateNormal];
    [m_toRentCar setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_toRentCar addTarget:self action:@selector(toRentCar) forControlEvents:UIControlEventTouchUpInside];
    [m_noOrderView addSubview:m_toRentCar];
}

// 跳转分时租车
-(void)toRentCar
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_personal];
}

/**
 *方法描述：显示无订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showNoOrderInfo:(BOOL)bShow
{
    if (bShow)
    {
        m_toRentCar.hidden = NO;
        if (m_bHaveOrder) {
            m_toRentCar.hidden = YES;
        }
        [self.view addSubview:m_noOrderView];
    }
    else
    {
        [m_noOrderView removeFromSuperview];
    }
}

-(void)networkError
{
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_NETWORK_ERROR delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    
    [tmpAlert show];
}

/**
 *方法描述：地图按钮代理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance
{
    NSLog(@"--- TO MAP ----");
    if (bTakeBrance) {
        
        BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:YES]];
        vc.enterType = MapViewFromSelBranch;
//        vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:NO]];
        vc.enterType = MapViewFromSelBranch;
//        vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**
 *方法描述：数据返回失败处理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initDataWithRequestFailed:(FMNetworkRequest *)fmRequest
{
    if (m_myOrderData) {
        m_myOrderData = nil;
    }
    if ([STR_NOT_GOT_ORDER isEqualToString:fmRequest.responseData]) {
        [self showNoOrderInfo:YES];
        return;
    }
    
    if ([REQUEST_NETWORK_ERROR isEqualToString:fmRequest.responseData]) {
        [self networkError];
        return;
    }

    if ([NO_ORDER_CURRENTLY isEqualToString:fmRequest.responseData])
    {
        [self showNoOrderInfo:YES];
    }
}


/**
 *方法描述：订单数据返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initMyOrderWithNetworkRequest:(FMNetworkRequest *)fmRequest
{
    if (m_myOrderData) {
        m_myOrderData = nil;
    }
    
    if ([STR_NOT_GOT_ORDER isEqualToString:fmRequest.responseData]) {
        [self showNoOrderInfo:YES];
        return;
    }
    
    if ([REQUEST_NETWORK_ERROR isEqualToString:fmRequest.responseData]) {
        [self networkError];
        return;
    }
    
    m_myOrderData = [[srvOrderData alloc] initWithOriginalData:fmRequest.responseData];
    
    if (nil == m_myOrderData)
    {
        m_bHaveOrder = NO;
        return;
    }
    m_bHaveOrder = YES;
    [self getBranchWithId:m_myOrderData.m_takeNet];
    [self getCarInfoWithId:m_myOrderData.m_carId];
    m_branchCount = 1;

    [[OrderManager ShareInstance] setCurrentOrderData:m_myOrderData];
    
    if ([self isTimeToTakeCar:m_myOrderData] || [SQL_ORDER_CANCEL isEqualToString:m_myOrderData.m_status]) {
        [self showNoOrderInfo:YES];
    }
    else
    {
        [self getAuthentication];
    }
}

// 根据订单判断是否到了取车时间
-(BOOL)isTimeToTakeCar:(srvOrderData *)orderData
{
    NSDate *date = [[PublicFunction ShareInstance] getDateFrom:orderData.m_effectTime];
    
    if ([[PublicFunction ShareInstance] inHalfAnHour:date])
    {
        return YES;
    }
    
    return NO;
}

// 判断还车状态
-(BOOL)needDisabelGiveback:(srvOrderData *)orderData
{
    NSString *strTime = [[PublicFunction ShareInstance] getYMDHMS:GET(orderData.m_effectTime)];
    NSDate *date = [[PublicFunction ShareInstance] getDateFrom:strTime];
    
    if ([[PublicFunction ShareInstance] IsTimeToTake:date])
    {
        return NO;
    }
    
    return YES;
}


/**
 *方法描述：网点数据返回更新
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initBranche:(FMNetworkRequest *)fmReques
{
    NSDictionary *dic = fmReques.responseData;
    NSArray *branchesArr = [dic objectForKey:@"branches"];
    
    if (0 == [branchesArr count]) {
        m_branchCount = 0;
        return;
    }
    
    if (1 == m_branchCount) {
        [[BranchDataManager shareInstance] setBranchData:[branchesArr objectAtIndex:0] withType:YES];
        [[BranchDataManager shareInstance] setSelBranchDic:[branchesArr objectAtIndex:0] isSelTake:YES];
        if ([m_myOrderData.m_takeNet isEqualToString:m_myOrderData.m_backNet])
        {
            [[BranchDataManager shareInstance] setBranchData:[branchesArr objectAtIndex: 0] withType:NO];
            [[BranchDataManager shareInstance] setSelBranchDic:[branchesArr objectAtIndex:0] isSelTake:NO];
            m_branchCount = 0;
            [self updateOrderData];
        }
        else
        {
            [self getBranchWithId:m_myOrderData.m_backNet];
            m_branchCount = 2;
            return;
        }
    }
    
    if (m_branchCount == 2)
    {
        [[BranchDataManager shareInstance] setBranchData:[branchesArr objectAtIndex: 0] withType:NO];
        [[BranchDataManager shareInstance] setSelBranchDic:[branchesArr objectAtIndex:0] isSelTake:NO];
        m_branchCount = 0;
        [self updateOrderData];
    }
}


/**
 *方法描述：解析初始化从服务器获取到的车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfo:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    [[CarDataManager shareInstance] setSelCar:[dic objectForKey:@"cars"]];
    [self updateCarInfo];
}


/**
 *方法描述：订单数据返回更新
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateOrderData
{
    BrancheData *tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:YES];
    NSString *takeBranch = [NSString stringWithFormat:@"%@",tmpData.m_name];
    tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:NO];
    NSString *givebackBranch = [NSString stringWithFormat:@"%@", tmpData.m_name];
    
    NSString *takeTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:m_myOrderData.m_effectTime]];
    
    NSString *backTime;
    //没有续订后返回的时间
    NSString *backTime1 = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:m_myOrderData.m_returnTime]];
    //续订后返回的时间
    NSString *newBackTime = [NSString stringWithFormat:@"%@",[[PublicFunction ShareInstance]  getYMDHMString:m_myOrderData.m_newReturnTime]];
    if (newBackTime.length!=0)
    {
        backTime=newBackTime;
    }
    else
    {
        backTime=backTime1;
    }
    [m_myOrderData setTakeBrancheName:takeBranch];
    [m_myOrderData setGivebackBrancheName:givebackBranch];
    [m_carInfo setSelectConditionWithBranche:takeBranch takeTime:takeTime backBranche:givebackBranch backTime:backTime];
}

/**
 *方法描述：车辆信息返回更新
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateCarInfo
{
    SelectedCar *carInfo = [[CarDataManager shareInstance] getSelCar];
    
    [m_carInfo setselectCarWithUnitPrice:carInfo.m_unitPrice dayPrice:carInfo.m_dayPrice carModel:carInfo.m_model carSerie:carInfo.m_carseries carPlate:carInfo.m_plateNum discount:carInfo.m_discount imageUrl:carInfo.m_carFile];
    [m_carInfo setNeedsDisplay];
}

/**
 *方法描述：请求车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarInfoWithId:(NSString *)carId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarInfo:carId delegate:self];
    req = nil;
}

/**
 *方法描述：请求网点信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getBranchWithId:(NSString*)brancheId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getBranchById:brancheId delegate:self];
    req = nil;
}

/**
 *方法描述：请求鉴权状态
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getAuthentication
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_orderNum)];
#if MYCAR_TEST
    NSString *carId = @"000001";
#else
    
    NSInteger nCarId = [GET(m_myOrderData.m_carId) integerValue];
    NSString *carId = [NSString stringWithFormat:@"%06d", nCarId];
    NSLog(@"carId = %@", carId);
//    NSString *carId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_carId)];
#endif

    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarAuthenticationWithCarId:carId orderId:orderId delegate:self];
    req = nil;
}

//鸣笛、开门、锁门前发送请求（经纬度),Code为100的时候进行相应的操作
- (void)sendMyLocation
{
#if MYCAR_TEST
    NSString *carId = @"000001";
#else
    NSInteger nCarId = [GET(m_myOrderData.m_carId) integerValue];
    NSString *carId = [NSString stringWithFormat:@"%06d", nCarId];
    NSLog(@"carId = %@", carId);
#endif

    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    NSString *latitude = [NSString stringWithFormat:@"%.6f",m_baiduLocation.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.6f",m_baiduLocation.longitude];
    //NSString *latitude = @"32.073346";
   // NSString *longitude = @"118.665285";
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] sendMyLocationWithLog:longitude
                                                                                lat:latitude
                                                                             cardId:carId
                                                                           delegate:self];
    req = nil;
    
}

/**
 *方法描述：鸣笛
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)honkingPressed
{
//    [self showWaiting];
    _type = 1;
    NSLog(@"honkingPressed");
    if ([self needDisabelGiveback:m_myOrderData])
    {
        [self showAlertView:STR_CANNOT_TAKECAR];
        return;
    }
    [self sendMyLocation];
 }
//发送鸣笛请求
-(void)sendHonkoingRequestWithOrderID:(NSString *)orderId withCardId:(NSString *)carId
{
     FMNetworkRequest *req = [[BLNetworkManager shareInstance] honkingWithCarId:carId orderId:orderId delegate:self];
     req = nil;
}

/**
 *方法描述：开门
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)openDoorPressed
{
    _type = 2;
//    [self showWaiting];
    NSLog(@"openDoorPressed");
    if ([self needDisabelGiveback:m_myOrderData])
    {
        [self showAlertView:STR_CANNOT_TAKECAR];
        return;
    }
    [self sendMyLocation];
  /*  NSString *orderId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_orderNum)];
#if MYCAR_TEST
    NSString *carId = @"000001";
#else
    
    NSInteger nCarId = [GET(m_myOrderData.m_carId) integerValue];
    NSString *carId = [NSString stringWithFormat:@"%06d", nCarId];
    NSLog(@"carId = %@", carId);
//    NSString *carId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_carId)];
#endif
   */
    
   
}
//发送开门请求
- (void)openDoorWithCarId:(NSString *)carId withOrderId:(NSString *)orderId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] openDoorWithCarId:carId orderId:orderId delegate:self];
    req = nil;
}
/**
 *方法描述：关门
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)closeDoorPressed
{
    _type = 3;
//    [self showWaiting];
    NSLog(@"closeDoorPressed");
    if ([self needDisabelGiveback:m_myOrderData])
    {
        [self showAlertView:STR_CANNOT_TAKECAR];
        return;
    }
    [self sendMyLocation];
/*
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_orderNum)];
#if MYCAR_TEST
    NSString *carId = @"000001";
#else
    NSInteger nCarId = [GET(m_myOrderData.m_carId) integerValue];
    NSString *carId = [NSString stringWithFormat:@"%06d", nCarId];
    NSLog(@"carId = %@", carId);
//    NSString *carId = [NSString stringWithFormat:@"%@", carId];
#endif
  */
}
//发送关门请求
- (void)closeDoorWithCarID:(NSString *)carId orderId:(NSString *)orderId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] closeDoorWithCarId:carId orderId:orderId delegate:self];
    req = nil;

}
// 还车
-(void)givebackPressed
{
    NSLog(@"giveBackPressed");
    ConfirmGivebackViewController *tmpCtrl = [[ConfirmGivebackViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

//鉴权失败
-(void)authenticationFailed
{
    [m_openDoor setEnabled:NO];
    [m_closeDoor setEnabled:NO];
    [m_honking setEnabled:NO];
    [m_giveback setEnabled:NO];
    
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:@"失败" delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    [tmpAlert show];
}

// 鸣笛失败
-(void)honkingFailed
{
//    [self getCarStatus];
}

//开门失败
-(void)openDoorFailed
{
//    [self getCarStatus];
}

//关门失败
-(void)closeDoorFailed
{
//    [self getCarStatus];
}

//请求车辆状态
-(void)getCarStatus
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *carId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_carId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarStatus:carId deleage:self];
    req = nil;
}

-(void)showAlertView:(NSString *)message
{
    CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    [tmpAlert needDismisShow];
}

/**
 *方法描述：鉴权成功
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)authenticationSuccess
{
    [m_openDoor setEnabled:YES];
    [m_closeDoor setEnabled:YES];
    [m_honking setEnabled:YES];
    [m_giveback setEnabled:YES];
}
//鸣笛成功
-(void)honkingSuccess
{
    NSLog(@"honkingSuccess");
}
// 开门成功
-(void)openDoorSuccess
{
    NSLog(@"openDoorSuccess");
}

// 关门成功
-(void)closeDoorSuccess
{
    NSLog(@"closeDoorSuccess");
}

// 车辆状态返回
-(void)carOpearation:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    NSString *status = [dic objectForKey:@"carStatus"];
    
    if (1 == [status integerValue]) {
        [self showAlertView:@"车辆行驶中。。。"];
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

// 初始化百度地图服务和定位服务
-(void)initBaiduLocationService
{
    // 百度地图的定位服务
    m_locService = [[BMKLocationService alloc] init];
}



-(void)updateLocation:(BMKUserLocation *)userLocation
{
    if (NO == FLOAT_IS_ZERO(userLocation.location.coordinate.latitude) &&
        NO == FLOAT_IS_ZERO(userLocation.location.coordinate.longitude))
    {
        m_bGotGPS = YES;
        m_baiduLocation.longitude = userLocation.location.coordinate.longitude;
        m_baiduLocation.latitude = userLocation.location.coordinate.latitude;
    }
    else
    {
        m_bGotGPS = NO;
    }
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
    [self updateLocation:userLocation];
#endif
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
#if !TARGET_IPHONE_SIMULATOR
    [self updateLocation:userLocation];
#endif
}


#pragma mark - http delegate
/**
 *方法描述：请求成功
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
//    [self hideWaiting];
    
    NSLog(@"--- SUCCESS ----");
    if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
    {
        [self initMyOrderWithNetworkRequest:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchById])
    {
        [self initBranche:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCarInfo])
    {
        [self initCarInfo:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carAuthentication])
    {
        [self authenticationSuccess];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carOpenDoor])
    {
        [self openDoorSuccess];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carCloseDoor])
    {
        [self closeDoorSuccess];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carHonking])
    {
        [self honkingSuccess];
    }
    else if([kRequest_getCarStatus isEqualToString:fmNetworkRequest.requestName])
    {
        [self carOpearation:fmNetworkRequest];
    }
    else if ([KRequest_sendMyLocation isEqualToString:fmNetworkRequest.requestName])
    {//code=100
        if ([fmNetworkRequest.responseData isEqualToString:@"100"])
        {
            //做鸣笛，开门，锁门相关操作
            NSString *orderId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_orderNum)];
           // NSString *carId = @"000001";
#if 0
            NSInteger nCarId = [GET(m_myOrderData.m_carId) integerValue];
            NSString *carId = [NSString stringWithFormat:@"%06d", nCarId];
#else
            NSString *carId = [NSString stringWithFormat:@"%@", GET(m_myOrderData.m_carId)];
#endif
            NSLog(@"carId = %@", carId);
            //1鸣笛2开门3锁
            if (1==_type)
            {
                [self sendHonkoingRequestWithOrderID:orderId withCardId:carId];
            }
            if (2==_type)
            {
                [self openDoorWithCarId:orderId withOrderId:carId ];
            }
            if (3==_type)
            {
                [self closeDoorWithCarID:orderId orderId:carId];
            }

        }
    
    }
    [[LoadingClass shared] hideLoadingForMoreRequest];
}

/**
 *方法描述：请求失败
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
//    [self hideWaiting];
    NSLog(@"--- FAILED ----");
    if ([[PublicFunction ShareInstance] checkResponseDataError:fmNetworkRequest.responseData]) {
        [[LoadingClass shared] hideLoadingForMoreRequest];
        return;
    }
    
    if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
    {
        [self initDataWithRequestFailed:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carAuthentication])
    {
//        [self authenticationFailed];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carOpenDoor])
    {
        [self openDoorFailed];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carCloseDoor])
    {
        [self closeDoorFailed];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kGet_carHonking])
    {
        [self honkingFailed];
    }
    else if([kRequest_getCarStatus isEqualToString:fmNetworkRequest.requestName])
    {
        [self carOpearation:fmNetworkRequest];
    }
    else if ([KRequest_sendMyLocation isEqualToString:fmNetworkRequest.requestName])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:fmNetworkRequest.responseData delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[LoadingClass shared] hideLoadingForMoreRequest];
}
@end
