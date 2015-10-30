//
//  SBranchViewController.m
//  SARzuche
//
//  Created by admin on 14-9-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchesMapViewController.h"
#import "PublicFunction.h"
#import "BLNetworkManager.h"
#import "NavigationViewController.h"
#import "PersonalRentalViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "LoadingClass.h"
#import "ConstDefine.h"
#import "User.h"

#define Width_NavigationBtn     220.0 / 2.0
#define Height_NavigationBtn    72.0  / 2.0

#define Width_SearchBtn         34.0  / 2.0
#define Height_SearchBtn        34.0  / 2.0

#define Width_BackToMyLocationView  96.0 / 2.0
#define Height_BackToMyLocationView 96.0 / 2.0

#define Width_BackToMyLocationBtn   38.0 / 2.0
#define Height_BackToMyLocationBtn  38.0 / 2.0
#define OriginX_BackToMyLocationBtn (Width_BackToMyLocationView - Width_BackToMyLocationBtn) / 2.0
#define OriginY_BackToMyLocationBtn (Height_BackToMyLocationView - Height_BackToMyLocationBtn) / 2.0

#define Width_ImageView             30.0 / 2.0
#define Height_ImageView            30.0 / 2.0

#define MAP_LEVEL 14

@interface BranchesMapViewController ()

@end

@implementation BranchesMapViewController
{
    CLLocationManager *m_locationManager;
    
    BMKLocationService* m_locService;
    CLLocationCoordinate2D newLocation; // 记录位置
    
    UIView *branchDetailBackView;
    UILabel *branchTitleLabel;
    UILabel *branchAddressLabel;
    UITextField *searchTextField;
    
    UIView *backToMyLocationView;
    UIView *searchBackView;
      
    int selectBranchIndex;          // 记录选中网点在网点列表中的位置
    int mapViewZoomLevel;           // 记录地图比例尺级别
    
    BOOL systemLocationServiceOpened;
    BOOL baiduMapError;
    
    FMNetworkRequest *m_reqBranches;
}
@synthesize enterType, branchesArray;

- (void)dealloc
{
    NSLog(@"mapview dealloc()");
    m_locationManager.delegate = nil;
    m_locationManager = nil;
    
    [[User shareInstance].mapView removeFromSuperview];
    m_locService = nil;
    
    searchBackView = nil;
    searchTextField = nil;
    backToMyLocationView = nil;
    branchDetailBackView = nil;
    branchTitleLabel = nil;
    branchAddressLabel = nil;
    
    [branchesArray removeAllObjects];
    branchesArray = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:searchTextField];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"周边网点";
        branchesArray = [[NSMutableArray alloc] init];
        systemLocationServiceOpened = YES;
    }
    return self;
}

- (id)initWithSeleBranch:(NSArray *)branchesArr
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        enterType = MapViewFromSelBranch;
        branchesArray = [[NSMutableArray alloc] initWithArray:branchesArr];
        if (branchesArray && [branchesArray count] > 0)
        {
            NSDictionary *branchDic = [branchesArray objectAtIndex:0];
            self.title =[branchDic objectForKey:@"name"]; // 要显示的标题
        }
        else
        {
            self.title = @"网点";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 导航栏按钮
    [customNavBarView setLeftButton:@"back.png" target:self leftBtnAction:@selector(backClk:)];
    [customNavBarView setRightButton:@"icon--menu.png" target:self rightBtnAction:@selector(listBtnCliked)];
    [customNavBarView setRightButtonFrame:CGRectMake(self.view.bounds.size.width - 20 - 10, 10, 25, 25)];
    
//    [self setUpForDismissKeyboard]; // 滑动地图的时候可以收起键盘
    [self initLocationManager];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    [self initBaiduMapManager];                     // 初始化百度地图引擎
    [self initBaiduMapAndLocationService:originY];  // 初始化百度地图和定位服务
    [self drawBranchDetailView];    // 网点详情的展示：包括网点名称、地址以及两个按
    
    originY += 10;
    [self drawSearchView:originY];  // 搜索框以及搜索按钮的显示
    [self drawZoomView];            // 地图放大缩小按钮
    [self drawMapScaleBarAndLocationBtn];   // 地图比例尺和定位按钮
    
//    newLocation.latitude = 32.064986;//32.064792;
//    newLocation.longitude = 118.802993;//118.802962;
    CLLocationCoordinate2D tmpLocation; // 记录位置
    tmpLocation.latitude = 32.064986;
    tmpLocation.longitude = 118.802993;
    [User shareInstance].mapView.centerCoordinate = tmpLocation;    // 地图的中心点为定位到的位置
#if TARGET_IPHONE_SIMULATOR
    newLocation.latitude = 31.980802;
    newLocation.longitude = 118.763257;
    
    if (enterType == MapViewFromHomeView)
    {
        [self sendRequestToGetBranches];    // 发送请求获取网点列表
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    baiduMapError = NO;
    
    [[User shareInstance].mapView viewWillAppear];
    [User shareInstance].mapView.delegate = self;   // 地图View的Delegate，不用的时候需要置nil，否则影响内存的释放
    m_locService.delegate = self;// 定位服务Delegate,调用startUserLocationService定位成功后，用此Delegate来获取定位数据
    
    [m_locService startUserLocationService];        // 打开定位服务
    [User shareInstance].mapView.showsUserLocation = NO;    // 先关闭显示的定位图层
    [User shareInstance].mapView.userTrackingMode = BMKUserTrackingModeNone;  // 设置定位的状态
    [User shareInstance].mapView.showsUserLocation = YES;   // 显示定位图层
    
    if ([branchesArray count] > 0)
    {
        [self reloadMapView];   // 刷新地图上标注的点
    }
    
    if (MapViewFromBranchesView == enterType) {
        if (customNavBarView) {
            [customNavBarView setTitle:STR_NETWORK];
        }
        [self accordingCityToGetBranches];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[User shareInstance].mapView viewWillDisappear];
    [User shareInstance].mapView.delegate = nil;
    m_locService.delegate = nil;
    
    [m_locService stopUserLocationService];  // 关闭定位服务
    [User shareInstance].mapView.showsUserLocation = NO;

    [self uninitLocationManager];
    
    CANCEL_REQUEST(m_reqBranches);
}

-(void)uninitLocationManager
{
    if (nil != m_locationManager)
    {
        [m_locationManager stopUpdatingLocation];
    }
}

#pragma mark - 一系列初始化
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
-(void)initBaiduMapAndLocationService:(float)originY
{
    if (![User shareInstance].mapView)
    {
        [User shareInstance].mapView = [[BMKMapView alloc] init];
    }
    mapViewZoomLevel = MAP_LEVEL;  // 地图比例尺级别, 在手机上当前可使用的级别为3-19级
    [User shareInstance].mapView.frame = CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY);
    [User shareInstance].mapView.mapType = BMKMapTypeStandard;
    [User shareInstance].mapView.zoomLevel = mapViewZoomLevel;  // 地图比例尺级别
    [User shareInstance].mapView.showMapScaleBar = YES;         // 显式比例尺
    [self.view addSubview:[User shareInstance].mapView];
    
    // 百度地图的定位服务
    m_locService = [[BMKLocationService alloc] init];
}

// 网点详情的展示：包括网点名称、地址以及两个按钮
-(void)drawBranchDetailView
{
    float branchDetailBackViewHeight = 100;
    float branchDetailBackViewOriginY = self.view.bounds.size.height - branchDetailBackViewHeight;
    if (enterType == MapViewFromHomeView)
    {
        branchDetailBackViewOriginY -= 48;
    }
    branchDetailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, branchDetailBackViewOriginY, self.view.bounds.size.width, branchDetailBackViewHeight)];
    branchDetailBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:branchDetailBackView];
    branchDetailBackView.hidden = YES;
    
    // 网点名称
    branchTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, branchDetailBackView.bounds.size.width - 10*2, 20)];
    branchTitleLabel.font = [UIFont systemFontOfSize:14];
    branchTitleLabel.textAlignment = NSTextAlignmentLeft;
    branchTitleLabel.backgroundColor = [UIColor clearColor];
    [branchDetailBackView addSubview:branchTitleLabel];
    
    // 网点地址
    branchAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+20, branchDetailBackView.bounds.size.width - 10*2, 20)];
    branchAddressLabel.font = [UIFont systemFontOfSize:12];
    branchAddressLabel.backgroundColor = [UIColor clearColor];
    branchAddressLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    [branchDetailBackView addSubview:branchAddressLabel];
    
    UIImageView *hideImg = [[UIImageView alloc] initWithFrame:CGRectMake(branchDetailBackView.bounds.size.width - 20 - Width_ImageView, 5, Width_ImageView, Height_ImageView)];
    hideImg.image = [UIImage imageNamed:@"请选择.png"];
    [branchDetailBackView addSubview:hideImg];
    
    // 隐藏网点详情按钮
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = CGRectMake(branchDetailBackView.bounds.size.width - 40 - 10, 0, 40, 40);
    [hideBtn setBackgroundColor:[UIColor clearColor]];
    [hideBtn addTarget:self action:@selector(hideBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [branchDetailBackView addSubview:hideBtn];
    
    // 预订车辆按钮
    UIButton *bookCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bookCarBtn.frame = CGRectMake(30, 10+20*2+5, Width_NavigationBtn, Height_NavigationBtn);
    [bookCarBtn setTitle:@"预订车辆" forState:UIControlStateNormal];
    [bookCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bookCarBtn setBackgroundImage:[UIImage imageNamed:@"预订车辆.png"] forState:UIControlStateNormal];
    [bookCarBtn addTarget:self action:@selector(bookCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [branchDetailBackView addSubview:bookCarBtn];
    
    // 导航按钮
    UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBtn.frame = CGRectMake(self.view.bounds.size.width - 30 - Width_NavigationBtn, 10+20*2+5, Width_NavigationBtn, Height_NavigationBtn);
    [navigationBtn setTitle:@"路线导航" forState:UIControlStateNormal];
    [navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBtn setBackgroundImage:[UIImage imageNamed:@"路线导航.png"] forState:UIControlStateNormal];
    [navigationBtn addTarget:self action:@selector(navigationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [branchDetailBackView addSubview:navigationBtn];
}

// 搜索框即搜索按钮的显示
-(void)drawSearchView:(float)originY
{
    float originX = 15;
    float width = self.view.bounds.size.width - originX * 2;
    float height = 44;
    searchBackView = [[UIView alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
    searchBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchBackView];
    
    UIImageView *searchBackImgView = [[UIImageView alloc] initWithFrame:searchBackView.bounds];
    searchBackImgView.image = [UIImage imageNamed:@"login输入框.png"];
    [searchBackView addSubview:searchBackImgView];
    
    // 搜索输入框
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, width - Width_SearchBtn - 10, height)];
    searchTextField.delegate = self;
    searchTextField.placeholder = @"输入搜索网点";
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchBackView addSubview: searchTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:searchTextField];
    
    // 搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(searchTextField.bounds.size.width + 5, (height - Height_SearchBtn) / 2.0, Width_SearchBtn, Height_SearchBtn);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [searchBackView addSubview:searchBtn];
}

// 地图缩小放大按钮的显示
-(void)drawZoomView
{
    float originX = 15;
    float Width_zoomBackView = 96.0 / 2.0;
    float Height_zoomBackView = 185.0 / 2.0;
    UIView *zoomBackView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 96.0 / 2.0 - originX, searchBackView.frame.origin.y + searchBackView.bounds.size.height + 20, Width_zoomBackView, Height_zoomBackView)];
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
}

// 地图上比例尺的位置和定位按钮
-(void)drawMapScaleBarAndLocationBtn
{
    float originX = 10;
    float backToMyLocationViewOriginY = self.view.bounds.size.height - 55;
    float mapScaleBarOriginY = self.view.bounds.size.height - 97;
    if (enterType == MapViewFromHomeView)
    {
        backToMyLocationViewOriginY -= 48;
        mapScaleBarOriginY -= 48;
    }

    backToMyLocationView = [[UIView alloc] initWithFrame:CGRectMake(originX, backToMyLocationViewOriginY, Width_BackToMyLocationView, Height_BackToMyLocationView)];
    [self.view addSubview:backToMyLocationView];
    UIImageView *backToMyLocationImg = [[UIImageView alloc] initWithFrame:backToMyLocationView.bounds];
    backToMyLocationImg.image = [UIImage imageNamed:@"全屏-背景.png"];
    [backToMyLocationView addSubview:backToMyLocationImg];
    
    UIButton *backToMyLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backToMyLocationBtn.frame = CGRectMake(OriginX_BackToMyLocationBtn, OriginY_BackToMyLocationBtn, Width_BackToMyLocationBtn, Height_BackToMyLocationBtn);
    [backToMyLocationBtn setBackgroundImage:[UIImage imageNamed:@"全屏.png"] forState:UIControlStateNormal];
    [backToMyLocationBtn addTarget:self action:@selector(backToMyLocationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backToMyLocationView addSubview:backToMyLocationBtn];  // 定位按钮
    
    CGPoint point;
    point.x = originX + Width_BackToMyLocationView;
    point.y = mapScaleBarOriginY;
    [User shareInstance].mapView.mapScaleBarPosition = point;   // 百度地图上比例尺的位置
}

#pragma mark - 导航栏按钮点击事件
// 导航栏返回按钮点击
-(void)backClk:(id)sender
{
    [[PublicFunction ShareInstance].rootNavigationConroller popViewControllerAnimated:YES];
}

// 网点列表按钮点击
-(void)listBtnCliked
{
    switch (enterType)
    {
        case MapViewFromHomeView:
        {
            selectBranchIndex = 0;
            // 网点列表界面
            BranchesViewController *nextVC = [[BranchesViewController alloc] initWithNibName:nil bundle:nil];
            nextVC.delegate = self;
            nextVC.enterType = BranchesViewFromBaiduMap;
            [[PublicFunction ShareInstance].rootNavigationConroller pushViewController:nextVC animated:YES];
            nextVC = nil;
        }
            break;
            
        case MapViewFromBranchesView:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }    
}

#pragma mark - 地图按钮点击事件：定位，地图放大、缩小、搜索
// 定位到我的位置
-(void)backToMyLocationBtnClicked
{
    if (FLOAT_IS_ZERO(newLocation.latitude)  || FLOAT_IS_ZERO(newLocation.longitude))
    {
        [[LoadingClass shared] showContent:@"无法定位当前位置" andCustomImage:nil];
    }
    else
    {
        [User shareInstance].mapView.centerCoordinate = newLocation;    // 地图的中心点为定位到的位置
    }
    NSLog(@"LON = %.6f, LAT =  %.6f", newLocation.longitude, newLocation.latitude);
}

// 地图放大按钮点击
-(void)enlargeBtnClicked
{
    mapViewZoomLevel = [User shareInstance].mapView.zoomLevel;
    if (mapViewZoomLevel < 19)
        mapViewZoomLevel++;
    [User shareInstance].mapView.zoomLevel = mapViewZoomLevel;
}

// 地图缩小按钮点击
-(void)lessenBtnClicked
{
    mapViewZoomLevel = [User shareInstance].mapView.zoomLevel;
    if (mapViewZoomLevel > 3)
        mapViewZoomLevel--;
    [User shareInstance].mapView.zoomLevel = mapViewZoomLevel;
}

// 搜索网点按钮点击
-(void)searchBtnClicked
{
    [searchTextField resignFirstResponder];
    
    if ([searchTextField.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"亲~您忘记输入搜索关键字了~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self hideBtnClicked];
    
    [self accordingKeywordToGetBranches];   // 通过关键字搜索网点
}

#pragma mark - 网点详情点击事件：隐藏网点详情、预订车辆、导航
// 隐藏网点详情展示
-(void)hideBtnClicked
{
    branchDetailBackView.hidden = YES;
    CGRect oldFrame = backToMyLocationView.frame;
    backToMyLocationView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 100, Width_BackToMyLocationView, Height_BackToMyLocationView);
    
    // 百度地图上比例尺的位置
    CGPoint oldPoint = [User shareInstance].mapView.mapScaleBarPosition;
    CGPoint newPoint;
    newPoint.x = oldPoint.x;
    newPoint.y = oldPoint.y + 100;
    [User shareInstance].mapView.mapScaleBarPosition = newPoint;
}

// 网点详情预订车辆按钮点击
-(void)bookCarBtnClicked
{
    NSDictionary *branchDic = [branchesArray objectAtIndex:selectBranchIndex];
    
    PersonalRentalViewController *nextVC = [[PersonalRentalViewController alloc] initWithNibName:nil bundle:nil];   // 进入分时租车页面
    [[PublicFunction ShareInstance].rootNavigationConroller pushViewController:nextVC animated:YES];
    [nextVC setSelBranche:branchDic];
    nextVC = nil;
}

// 网点详情路线导航按钮点击
-(void)navigationBtnClicked
{
    // 默认将网点地址作为终点地址进行导航，并将改地址保存到历史记录
    NSMutableDictionary *endLocationDic = [NSMutableDictionary dictionaryWithDictionary:[branchesArray objectAtIndex:selectBranchIndex]];
    [endLocationDic setObject:@"南京" forKey:@"city"];
    [endLocationDic setObject:@"0" forKey:@"type"];
    [self locationDicSaveToHistoryList:endLocationDic];
    
    NavigationViewController *nextVC = [[NavigationViewController alloc] init]; // 进入导航页面
    nextVC.enterType = NavigationViewFromMapView;
    [nextVC.locationsDic setObject:endLocationDic forKey:kEY_LocationDic_endAddr];
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC = nil;
}

// 网点地址保存到历史记录
-(void)locationDicSaveToHistoryList:(NSDictionary *)locationDic
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/baiduplist/%@", NSHomeDirectory(), @"locationHistory.plist"];
    NSMutableArray *historyArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (!historyArray)  // 如果网点列表不存在，新增网点列表，新增网点，保存在本地
    {
        historyArray = [[NSMutableArray alloc] init];
        [historyArray addObject:locationDic];
        [historyArray writeToFile:filePath atomically:YES];
    }
    else
    {
        if (0 == [historyArray count])  // 如果网点列表为空，新增网点，保存在本地
        {
            [historyArray addObject:locationDic];
            [historyArray writeToFile:filePath atomically:YES];
        }
        else
        {
            int i;  // 如果网点列表不为空，先查看网点地址是否已存在历史记录中
            for (i = 0; i < [historyArray count]; i++)
            {
                NSDictionary *historyDic = [historyArray objectAtIndex:i];
                if ([[locationDic objectForKey:@"name"] isEqualToString:[historyDic objectForKey:@"name"]])
                {
                    break;
                }
            }
            
            if (0 == i) // 网点地址在历史记录中为第一条
            {
                return;
            }
            else
            {
                if (i < [historyArray count])  // 网点在历史记录中，且不为第一条，将其调整为第一条
                {
                    [historyArray removeObjectAtIndex:i];
                }
                
                [historyArray insertObject:locationDic atIndex:0];
                [historyArray writeToFile:filePath atomically:YES];
            }
        }
    }
}

#pragma mark - 获取网点列表
// 获取不到经纬度时，获取南京所有网点，显示出来
-(void)accordingCityToGetBranches
{
    mapViewZoomLevel = MAP_LEVEL;
    [User shareInstance].mapView.zoomLevel = mapViewZoomLevel;
    
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    m_reqBranches = [[BLNetworkManager shareInstance]  selectBranchByCondition:nil city:@"南京" area:nil pageNumber:0 pageSize:0 delegate:self];
}

// 发送请求获取网点列表，根据经纬度
-(void)sendRequestToGetBranches
{
    mapViewZoomLevel = MAP_LEVEL;
    [User shareInstance].mapView.zoomLevel = mapViewZoomLevel;
    
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *reqBranches = [[BLNetworkManager shareInstance] getBranchListByPosition:[NSString stringWithFormat:@"%f", newLocation.longitude] latitude:[NSString stringWithFormat:@"%f", newLocation.latitude] pageNumber:@"1" pagesize:@"20" delegate:self];
    reqBranches = nil;
}

// 根据输入的搜索内容搜索网点
-(void)accordingKeywordToGetBranches
{
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] selectBranchByCondition:searchTextField.text city:@"南京" area:nil pageNumber:1 pageSize:20 delegate:self];
    req = nil;
}

#pragma mark - 保存网点，刷新网点
// 保存服务器返回的网点列表数据，然后刷新地图
-(void)saveBranches:(NSDictionary *)responseDic
{
    NSArray *array = [responseDic objectForKey:@"branches"];
    if ([array count] > 0)
    {
        [branchesArray removeAllObjects];
        [branchesArray addObjectsFromArray:array];
        [self reloadMapView];   // 刷新地图
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"没有找到相关结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

// 刷新地图
-(void)reloadMapView
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:[User shareInstance].mapView.annotations];
    [[User shareInstance].mapView removeAnnotations:array];
    
    for (int i = 0; i < branchesArray.count; i++)
    {
        NSDictionary *branchDic = [branchesArray objectAtIndex:i];
        CLLocationCoordinate2D coor;
        coor.latitude = [[branchDic objectForKey:@"latitude"] floatValue];
        coor.longitude = [[branchDic objectForKey:@"longitude"] floatValue];
//        NSLog(@"--->coor.latitude = %f",coor.latitude);
//        NSLog(@"--->coor.longitude = %f",coor.longitude);
//        NSLog(@"--->%@",[branchDic objectForKey:@"address"]);
//        NSLog(@"--->%@",[branchDic objectForKey:@"name"]);


        
        BMKPointAnnotation *point = [[BMKPointAnnotation alloc] init];
        point.coordinate = coor;                        // 该点的坐标
        point.title = [branchDic objectForKey:@"name"]; // 要显示的标题
        [[User shareInstance].mapView addAnnotation:point];                 // 在地图上添加标注
        point = nil;
        
        if (0 == i)
            [User shareInstance].mapView.centerCoordinate = coor;   // 地图的中心点为第一个网点的位置
    }
    
    if (0 == [branchesArray count])
    {
        if (systemLocationServiceOpened)
            [User shareInstance].mapView.centerCoordinate = newLocation;// 如果没有网点显示，那么地图的中心点为定位到的位置
    }
    

}

#pragma mark - UITextFieldDelegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [searchTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClicked];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 30)
        return NO;
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    int maxLength = 30;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position)  // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        {
            if (toBeString.length > maxLength)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        }
        else    // 有高亮选择的字符串，则暂不对文字进行统计和限制
        {
        }
    }
    else    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    {
        if (toBeString.length > maxLength)
        {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}

#pragma mark - BranchesViewControllerDelegate
-(void)selBrancheFromController:(NSDictionary *)branchData
{
}

-(void)selBrancheForMapView:(NSDictionary *)brancheData
{
    [branchesArray removeAllObjects];
    [branchesArray addObject:brancheData];
    [self reloadbranchDetailBackView];
//    [self reloadMapView];   // 刷新地图
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

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)   // 如果定位服务未打开，提示用户去设置
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请您前往设置-隐私-定位服务-享租车，打开定位服务，否则享租车无法为您提供地图相关服务哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (systemLocationServiceOpened)
    {
        systemLocationServiceOpened = NO;
        if (enterType == MapViewFromHomeView)
            [self accordingCityToGetBranches];
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

-(void)updateLocation:(BMKUserLocation *)userLocation
{
    if (NO == FLOAT_IS_ZERO(userLocation.location.coordinate.latitude) &&
        NO == FLOAT_IS_ZERO(userLocation.location.coordinate.longitude))
    {
        // newLocation的经纬度为0，说明这是第一次获取到经纬度
        if (FLOAT_IS_ZERO(newLocation.latitude)  || FLOAT_IS_ZERO(newLocation.longitude))
        {
            systemLocationServiceOpened = NO;
            baiduMapError = NO;
            
            newLocation.longitude = userLocation.location.coordinate.longitude; // 更新位置信息
            newLocation.latitude = userLocation.location.coordinate.latitude;
            if (enterType == MapViewFromHomeView)
            {
                //[self sendRequestToGetBranches];    // 根据经纬度向服务器获取网点列表
                [self accordingCityToGetBranches];//获取周边全部网点

            }
        }
        
        newLocation.longitude = userLocation.location.coordinate.longitude;
        newLocation.latitude = userLocation.location.coordinate.latitude;
        [[User shareInstance].mapView updateLocationData:userLocation];
    }
    else
    {
        if (!baiduMapError)
        {
            baiduMapError = YES;
            if (systemLocationServiceOpened)
            {
                [[User shareInstance].mapView updateLocationData:userLocation];
                [self accordingCityToGetBranches];
            }
        }
    }
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [searchTextField resignFirstResponder];
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"branchMark";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;  // 设置重天上掉下的效果(annotation)
        annotationView.image = [UIImage imageNamed:@"icon-定位.png"];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 35)];
//        imageView.image = [UIImage imageNamed:@"定位.png"];
//        
//        UIView *testView = [[UIView alloc] initWithFrame:imageView.bounds];
//        testView.backgroundColor = [UIColor clearColor];
//        [testView addSubview:imageView];
//        
//        if (showNum)
//        {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//            label.text = [NSString stringWithFormat:@"%d", selectBranchIndex+1];
//            label.font = [UIFont systemFontOfSize:10];
//            label.textColor = [UIColor whiteColor];
//            label.backgroundColor = [UIColor clearColor];
//            label.textAlignment = NSTextAlignmentCenter;
//            [testView addSubview:label];
//        }
    }
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));// 设置位置
    annotationView.annotation = annotation;
	annotationView.canShowCallout = YES;    // 单击弹出泡泡，弹出泡泡前提:设置title
    annotationView.draggable = NO;          // 设置是否可以拖拽
    return annotationView;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    for (selectBranchIndex = 0; selectBranchIndex < [branchesArray count]; selectBranchIndex++)
    {
        NSDictionary *branchDic = [branchesArray objectAtIndex:selectBranchIndex];
        BMKPointAnnotation *point = (BMKPointAnnotation *)view.annotation;
        
        // 根据经纬度，从网点列表中找到选中的网点
        if ([[branchDic objectForKey:@"latitude"] floatValue] == point.coordinate.latitude &&
            [[branchDic objectForKey:@"longitude"] floatValue] == point.coordinate.longitude)
        {
            [User shareInstance].mapView.centerCoordinate = point.coordinate;   // 地图的中心点为选中的网点
            break;
        }
    }
    
    if (selectBranchIndex == [branchesArray count])
        return;
    NSDictionary *branchDic = [branchesArray objectAtIndex:selectBranchIndex];// 取出网点，展示网点相关信息
    // branchTitleLabel.text = [branchDic objectForKey:@"name"];
    branchTitleLabel.text = [NSString stringWithFormat:@"网点地址：%@",[branchDic objectForKey:@"name"]];
    branchAddressLabel.text = [NSString stringWithFormat:@"地址：%@", [branchDic objectForKey:@"address"]];
    
    if (branchDetailBackView.hidden)    // 网点详情展示出来以后需要调整定位按钮和比例尺的位置
    {
        branchDetailBackView.hidden = NO;
        
        CGRect oldFrame = backToMyLocationView.frame;
        backToMyLocationView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 100, Width_BackToMyLocationView, Height_BackToMyLocationView);   // 定位按钮
        
        CGPoint oldPoint = [User shareInstance].mapView.mapScaleBarPosition;
        CGPoint newPoint;
        newPoint.x = oldPoint.x;
        newPoint.y = oldPoint.y - 100;
        [User shareInstance].mapView.mapScaleBarPosition = newPoint;    // 百度地图上比例尺的位置
    }

   }
- (void)reloadbranchDetailBackView
{
    //branchDetailBackView.hidden=YES;
    NSDictionary *branchDic = [branchesArray objectAtIndex:selectBranchIndex];// 取出网点，展示网点相关信息
    // branchTitleLabel.text = [branchDic objectForKey:@"name"];
    branchTitleLabel.text = [NSString stringWithFormat:@"网点地址：%@",[branchDic objectForKey:@"name"]];
    branchAddressLabel.text = [NSString stringWithFormat:@"地址：%@", [branchDic objectForKey:@"address"]];
    
    if (branchDetailBackView.hidden)    // 网点详情展示出来以后需要调整定位按钮和比例尺的位置
    {
        branchDetailBackView.hidden = NO;
        
        CGRect oldFrame = backToMyLocationView.frame;
        backToMyLocationView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 100, Width_BackToMyLocationView, Height_BackToMyLocationView);   // 定位按钮
        
        CGPoint oldPoint = [User shareInstance].mapView.mapScaleBarPosition;
        CGPoint newPoint;
        newPoint.x = oldPoint.x;
        newPoint.y = oldPoint.y - 100;
        [User shareInstance].mapView.mapScaleBarPosition = newPoint;    // 百度地图上比例尺的位置
    }

}
/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark - FMNetworkDelegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchListByPosition] ||
        [fmNetworkRequest.requestName isEqualToString:kRequest_selectBranchByCondition])
    {
        // 保存服务器返回的网点列表数据，然后刷新地图
        [self saveBranches:fmNetworkRequest.responseData];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    NSLog(@" fm net work failed");
    
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchListByPosition])
    {
        [[LoadingClass shared] showContent:@"网络异常，请稍后重试" andCustomImage:nil];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_selectBranchByCondition])
    {
        [[LoadingClass shared] showContent:@"网络异常，请稍后重试" andCustomImage:nil];
    }
}

//
//- (UIImage *)makeImageWithView:(UIView *)view
//{
//    CGSize s = view.bounds.size;
//    
//    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
//    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}
//
@end
