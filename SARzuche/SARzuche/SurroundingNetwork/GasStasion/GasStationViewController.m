//
//  GasStationViewController.m
//  SARzuche
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "GasStationViewController.h"
#import "NavigationViewController.h"
#import "PublicFunction.h"
#import "LoadingClass.h"
#import "ConstDefine.h"

#define Width_SearchBtn             34.0  / 2.0
#define Height_SearchBtn            34.0  / 2.0

#define Width_BackToMyLocationView  96.0 / 2.0
#define Height_BackToMyLocationView 96.0 / 2.0

#define Width_BackToMyLocationBtn   38.0 / 2.0
#define Height_BackToMyLocationBtn  38.0 / 2.0
#define OriginX_BackToMyLocationBtn (Width_BackToMyLocationView - Width_BackToMyLocationBtn) / 2.0
#define OriginY_BackToMyLocationBtn (Height_BackToMyLocationView - Height_BackToMyLocationBtn) / 2.0

#define Width_NavigationBtn         580.0 / 2.0
#define Height_NavigationBtn        72.0  / 2.0

#define Width_ImageView             30.0 / 2.0
#define Height_ImageView            30.0 / 2.0

#define MAP_LEVEL 14

@interface GasStationViewController ()

@end

@implementation GasStationViewController
{
    CLLocationManager *m_locationManager;
    
    BMKMapView *m_mapView;
    BMKPoiSearch *m_poisearch;
    BMKLocationService* m_locService;
    CLLocationCoordinate2D newLocation;
    
    UIView *searchBackView;
    UIView *branchDetailBackView;
    UILabel *branchTitleLabel;
    UILabel *branchAddressLabel;
    
    UITextField *searchTextField;
    
    UIView *backToMyLocationView;
    
    NSMutableArray *branchesArray;
    int selectBranchIndex;
    int mapViewZoomLevel;
    int currentPage;
    
    NSString *searchKeyWord;
    
//    BOOL systemLocationServiceOpened;
    BOOL baiduMapError;
    
    id observer1;
    id observer2;
}

- (void)dealloc
{
    NSLog(@"gasStationView dealloc()");
    m_locationManager.delegate = nil;
    m_locationManager = nil;
    
    m_mapView = nil;
    m_poisearch = nil;
    m_locService = nil;
    
    searchKeyWord = nil;
    searchBackView = nil;
    searchTextField = nil;
    backToMyLocationView = nil;
    branchDetailBackView = nil;
    branchTitleLabel = nil;
    branchAddressLabel = nil;
    
    [branchesArray removeAllObjects];
    branchesArray = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:searchTextField];
//    [[NSNotificationCenter defaultCenter] removeObserver:observer1];
//    [[NSNotificationCenter defaultCenter] removeObserver:observer2];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"加油站";
        branchesArray = [[NSMutableArray alloc] init];
        searchKeyWord = [[NSString alloc] init];
        searchKeyWord = @"加油站";
//        systemLocationServiceOpened = YES;
    }
    return self;
}


-(void)hiddeRightBtn:(BOOL)bHidden
{
    for(UIButton *btn in [customNavBarView subviews])
    {
        if (101 == btn.tag)
        {
            btn.hidden = bHidden;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // 导航栏按钮
    [customNavBarView setLeftButton:@"back.png" target:self leftBtnAction:@selector(backBtnClicked)];
    [customNavBarView setRightButtonWithTitle:@"下一组" target:self rightBtnAction:@selector(nextBtnCliked)];
    
//    [self setUpForDismissKeyboard]; // 滑动地图的时候可以收起键盘
    [self initLocationManager];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    [self initBaiduMapAndLocationAndPOISearchService:originY];  // 初始化百度地图服务、定位服务和poi搜索服务
    [self drawBranchDetailView];    // 网店详情的展示：包括网点名称、地址以及两个按钮

    originY += 10;
    [self drawSearchView:originY];  // 搜索框即搜索按钮的显示
    [self drawZoomView];            // 地图缩小放大按钮的显示
    [self drawMapScaleBarAndLocationBtn];   // 地图上比例尺的位置和定位按钮
    
#if TARGET_IPHONE_SIMULATOR
    newLocation.latitude = 31.980802;
    newLocation.longitude = 118.763257;
    m_mapView.centerCoordinate = newLocation;    // 没有搜索结果则地图的中心点为定位到的位置
#endif
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    baiduMapError = NO;
    
    [m_mapView viewWillAppear];
    m_mapView.delegate = self;       // BMKMapViewDelegate
    m_poisearch.delegate = self;     // BMKPoiSearchDelegate
    
    m_locService.delegate = self;    // BMKLocationServiceDelegate
    [m_locService startUserLocationService];
    m_mapView.showsUserLocation = NO;//先关闭显示的定位图层
    m_mapView.userTrackingMode = BMKUserTrackingModeNone;  //设置定位的状态
    m_mapView.showsUserLocation = YES;//显示定位图层
    
#if TARGET_IPHONE_SIMULATOR
    currentPage = 0;
    [self sendMapSearch:searchKeyWord];
#endif
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_mapView viewWillDisappear];
    m_mapView.delegate = nil;
    m_poisearch.delegate = nil;
    
    m_locService.delegate = nil;
    [m_locService stopUserLocationService];
    m_mapView.showsUserLocation = NO;
    
    [self uninitLocationManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// 初始化百度地图服务、定位服务和poi搜索服务
-(void)initBaiduMapAndLocationAndPOISearchService:(float)originY
{
    CLLocationCoordinate2D tmpLocation;
    tmpLocation.latitude = 32.064986;
    tmpLocation.longitude = 118.802993;
    mapViewZoomLevel = MAP_LEVEL;
    m_mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    m_mapView.centerCoordinate = tmpLocation;
    m_mapView.mapType = BMKMapTypeStandard;
    m_mapView.zoomLevel = mapViewZoomLevel;  // 地图比例尺级别
    m_mapView.showMapScaleBar = YES;         // 显式比例尺
    [self.view addSubview:m_mapView];
    
    m_poisearch = [[BMKPoiSearch alloc]init];
    m_locService = [[BMKLocationService alloc] init];
}

// 网点详情的展示：包括网点名称、地址以及两个按钮
-(void)drawBranchDetailView
{
    float branchDetailBackViewHeight = 100;
    branchDetailBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - branchDetailBackViewHeight - 48, self.view.bounds.size.width, branchDetailBackViewHeight)];
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
    
    UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hideBtn.frame = CGRectMake(branchDetailBackView.bounds.size.width - 40 - 10, 0, 40, 40);
    [hideBtn setBackgroundColor:[UIColor clearColor]];
    [hideBtn addTarget:self action:@selector(hideBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [branchDetailBackView addSubview:hideBtn];
    
    // 导航按钮
    UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBtn.frame = CGRectMake((self.view.bounds.size.width - Width_NavigationBtn) / 2, 10+20*2+5, Width_NavigationBtn, Height_NavigationBtn);
    [navigationBtn setTitle:@"路线导航" forState:UIControlStateNormal];
    [navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [navigationBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
    [navigationBtn addTarget:self action:@selector(navigationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [branchDetailBackView addSubview:navigationBtn];
}

// 搜索框即搜索按钮的显示
-(void)drawSearchView:(float)originY
{
    float originX = 15;
    float width = self.view.bounds.size.width - originX * 2;
    float height = 44;
    
    // 搜索框即搜索按钮的显示
    searchBackView = [[UIView alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
    searchBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchBackView];
    
    UIImageView *searchBackImgView = [[UIImageView alloc] initWithFrame:searchBackView.bounds];
    searchBackImgView.image = [UIImage imageNamed:@"login输入框.png"];
    [searchBackView addSubview:searchBackImgView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, width - Width_SearchBtn - 10, height)];
    searchTextField.delegate = self;
    searchTextField.placeholder = @"请输入目的地";
    searchTextField.returnKeyType = UIReturnKeySearch;;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchBackView addSubview: searchTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:searchTextField];
    
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
    float backToMyLocationViewOriginY = self.view.bounds.size.height - 103;
    float mapScaleBarOriginY = self.view.bounds.size.height - 145;
    
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
    m_mapView.mapScaleBarPosition = point;   // 百度地图上比例尺的位置
}

#pragma mark - 导航栏按钮点击事件
-(void)backBtnClicked
{
    [[PublicFunction ShareInstance].rootNavigationConroller popViewControllerAnimated:YES];
}

#pragma mark - 地图按钮点击事件：定位，地图放大、缩小
-(void)backToMyLocationBtnClicked
{
    if (FLOAT_IS_ZERO(newLocation.latitude) || FLOAT_IS_ZERO(newLocation.longitude))
    {
        [[LoadingClass shared] showContent:@"无法定位当前位置" andCustomImage:nil];
    }
    else
    {
        m_mapView.centerCoordinate = newLocation;    // 地图的中心点为定位到的位置
    }
}

-(void)enlargeBtnClicked
{
    mapViewZoomLevel = m_mapView.zoomLevel;
    if (mapViewZoomLevel < 19)
        mapViewZoomLevel++;
    m_mapView.zoomLevel = mapViewZoomLevel;
}

-(void)lessenBtnClicked
{
    mapViewZoomLevel = m_mapView.zoomLevel;
    if (mapViewZoomLevel > 3)
        mapViewZoomLevel--;
    m_mapView.zoomLevel = mapViewZoomLevel;
}

#pragma mark - 搜索事件
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
    
    searchKeyWord = searchTextField.text;
    currentPage = 0;
    [self sendMapSearch:searchKeyWord];
}

-(void)nextBtnCliked
{
    [searchTextField resignFirstResponder];
    [self hideBtnClicked];
    [self sendMapSearch:searchKeyWord];
}

-(void)sendMapSearch:(NSString *)keyWord
{
//    if (FLOAT_IS_ZERO(newLocation.latitude) || FLOAT_IS_ZERO(newLocation.longitude))
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请您前往设置-隐私-定位服务-享租车，打开定位服务，否则享租车无法为您提供地图相关服务哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
//    BMKNearbySearchOption *nearbySearch = [[BMKNearbySearchOption alloc] init];
//    nearbySearch.pageIndex = currentPage++;
//    nearbySearch.pageCapacity = 10;
//    nearbySearch.location = newLocation;
//    nearbySearch.radius = 5000;
//    nearbySearch.keyword = keyWord;
//    BOOL flag = [m_poisearch poiSearchNearBy:nearbySearch];
//    if(flag)
//    {
//        NSLog(@"检索发送成功");
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"没有找到相关结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }
    BMKCitySearchOption *citySearch = [[BMKCitySearchOption alloc] init];
    citySearch.pageIndex = currentPage++;
    citySearch.pageCapacity = 10;
    citySearch.keyword = keyWord;
    citySearch.city = @"南京";
    BOOL flag = [m_poisearch poiSearchInCity:citySearch];
    if(flag)
    {
        NSLog(@"检索发送成功");
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"没有找到相关结果" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - 网点详情点击事件：隐藏网点详情、导航
// 隐藏网点详情展示
-(void)hideBtnClicked
{
    branchDetailBackView.hidden = YES;
    CGRect oldFrame = backToMyLocationView.frame;
    backToMyLocationView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y + 100, Width_BackToMyLocationView, Height_BackToMyLocationView);
    
    // 百度地图上比例尺的位置
    CGPoint oldPoint = m_mapView.mapScaleBarPosition;
    CGPoint newPoint;
    newPoint.x = oldPoint.x;
    newPoint.y = oldPoint.y + 100;
    m_mapView.mapScaleBarPosition = newPoint;
}

// 网点详情路线导航按钮点击
-(void)navigationBtnClicked
{
    BMKPoiInfo *branchInfo = [branchesArray objectAtIndex:selectBranchIndex];
    
    NSMutableDictionary *endLocationDic = [NSMutableDictionary dictionary];
    [endLocationDic setObject:@"南京" forKey:@"city"];
    [endLocationDic setObject:@"0" forKey:@"type"];
    [endLocationDic setObject:branchInfo.name forKey:@"name"];
    [endLocationDic setObject:[NSString stringWithFormat:@"%f", branchInfo.pt.latitude] forKey:@"latitude"];
    [endLocationDic setObject:[NSString stringWithFormat:@"%f", branchInfo.pt.longitude] forKey:@"longitude"];
    [self locationDicSaveToHistoryList:endLocationDic];
    
    NavigationViewController *nextVC = [[NavigationViewController alloc] init];
    nextVC.enterType = NavigationViewFromGasStationView;
    [nextVC.locationsDic setObject:endLocationDic forKey:kEY_LocationDic_endAddr];
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC = nil;
}

-(void)locationDicSaveToHistoryList:(NSDictionary *)locationDic
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/baiduplist/%@", NSHomeDirectory(), @"locationHistory.plist"];
    NSMutableArray *historyArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (!historyArray)
    {
        historyArray = [[NSMutableArray alloc] init];
        [historyArray addObject:locationDic];
        [historyArray writeToFile:filePath atomically:YES];
    }
    else
    {
        if (0 == [historyArray count])
        {
            [historyArray addObject:locationDic];
            [historyArray writeToFile:filePath atomically:YES];
        }
        else
        {
            int i;  // 先看看搜索列表里选中的地址是否已存在历史记录中
            for (i = 0; i < [historyArray count]; i++)
            {
                NSDictionary *historyDic = [historyArray objectAtIndex:i];
                if ([[locationDic objectForKey:@"name"] isEqualToString:[historyDic objectForKey:@"name"]])
                {
                    break;
                }
            }
            
            if (0 == i) // 如果选中的地址在历史记录中为第一条
            {
                return;
            }
            else
            {
                if (i < [historyArray count])  // 选中的地址在历史记录中，且不为第一条
                {
                    [historyArray removeObjectAtIndex:i];
                }
                
                [historyArray insertObject:locationDic atIndex:0];
                [historyArray writeToFile:filePath atomically:YES];
            }
        }
    }
}

#pragma mark - 滑动手机键盘的收起
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

- (void)setUpForDismissKeyboard
{
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    observer1 = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        [self.view addGestureRecognizer:singleTapGR];
    }];
    
    observer2 = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        [self.view removeGestureRecognizer:singleTapGR];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClicked];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 30)
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
    NSString *AnnotationViewID = @"xidanMark";
	
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil)
    {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
	
    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    annotationView.image = [UIImage imageNamed:@"icon-定位.png"];
    
    return annotationView;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
    
    for (selectBranchIndex = 0; selectBranchIndex < [branchesArray count]; selectBranchIndex++)
    {
        BMKPoiInfo* branchInfo = [branchesArray objectAtIndex:selectBranchIndex];
        BMKPointAnnotation *point = (BMKPointAnnotation *)view.annotation;
        
        // 根据经纬度，找到选中的点
        if (branchInfo.pt.latitude == point.coordinate.latitude &&
            branchInfo.pt.longitude == point.coordinate.longitude)
        {
            m_mapView.centerCoordinate = point.coordinate;   // 地图的中心点为选中的点
            break;
        }
    }
    
    if (selectBranchIndex == [branchesArray count])
        return;
    
    BMKPoiInfo *branchInfo = [branchesArray objectAtIndex:selectBranchIndex];   // 取出网点，展示网点相关信息
    branchTitleLabel.text = [NSString stringWithFormat:@"网点地址：%@",branchInfo.name];
    //branchTitleLabel.text = branchInfo.name;
    branchAddressLabel.text = [NSString stringWithFormat:@"地址：%@", branchInfo.address];
    
    if (branchDetailBackView.hidden)    // 网点详情展示出来以后需要调整定位按钮和比例尺的位置
    {
        branchDetailBackView.hidden = NO;
        
        CGRect oldFrame = backToMyLocationView.frame;
        backToMyLocationView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y - 100, Width_BackToMyLocationView, Height_BackToMyLocationView);   // 定位按钮
        
        CGPoint oldPoint = m_mapView.mapScaleBarPosition;
        CGPoint newPoint;
        newPoint.x = oldPoint.x;
        newPoint.y = oldPoint.y - 100;
        m_mapView.mapScaleBarPosition = newPoint;    // 百度地图上比例尺的位置
    }
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}

#pragma mark - BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:m_mapView.annotations];
	[m_mapView removeAnnotations:array];
    
    [branchesArray removeAllObjects];
    [branchesArray addObjectsFromArray:result.poiInfoList];
    
    if (0 == [branchesArray count])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"没有相关加油站的信息了~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        for (int i = 0; i < branchesArray.count; i++)
        {
            BMKPoiInfo* poi = [branchesArray objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc] init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [m_mapView addAnnotation:item];
            item = nil;
            
            if (0 == i)
            {
                m_mapView.centerCoordinate = poi.pt;    // 设置地图的中心点
            }
        }
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
        if (FLOAT_IS_ZERO(newLocation.latitude) || FLOAT_IS_ZERO(newLocation.longitude))
        {
            newLocation.longitude = userLocation.location.coordinate.longitude; // 更新位置信息
            newLocation.latitude = userLocation.location.coordinate.latitude;
//            m_mapView.centerCoordinate = newLocation;    // 地图的中心点设为定位到的位置
            [self sendMapSearch:searchKeyWord];
        }
        
        [self hiddeRightBtn:NO];
        newLocation.longitude = userLocation.location.coordinate.longitude;
        newLocation.latitude = userLocation.location.coordinate.latitude;
        [m_mapView updateLocationData:userLocation];
    }
    else
    {
        [self hiddeRightBtn:YES];
        if (!baiduMapError)
        {
            //[[LoadingClass shared] showContent:@"网络异常，请稍后重试" andCustomImage:nil];
            baiduMapError = YES;
        }
        [m_mapView updateLocationData:userLocation];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied)   // 如果定位服务未打开，提示用户去设置
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请您前往设置-隐私-定位服务-享租车，打开定位服务，否则享租车无法为您提供地图相关服务哦~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

@end
