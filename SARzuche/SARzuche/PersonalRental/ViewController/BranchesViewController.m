//
//  BranchesViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchesViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"
#import "BranchesMapViewController.h"
#import "User.h"
#import "ConstImage.h"
#import "BranchDataManager.h"

typedef NS_ENUM(NSInteger, requestEnum)
{
    requestZero,
    requestNearly,
    requestCommon,
    requestBlock,
    requestBranches,
    requestMax
};

#define BLOCK_START_X               10
#define BRANCHES_START_X            (BLOCK_START_X + BLOCK_TABLE_WIDTH+2)
#define TABLE_START_Y               130

#define FRAME_BRANCHES_TABLE_VIEW   CGRectMake(BRANCHES_START_X, TABLE_START_Y, BRANCHE_TABLE_WIDTH, MainScreenHeight - TABLE_START_Y)
#define FRAME_BLOCK_TABLE_VIEW      CGRectMake(BLOCK_START_X, TABLE_START_Y, BLOCK_TABLE_WIDTH, MainScreenHeight - TABLE_START_Y)
#define FRAME_TEXTFIELD_VIEW        CGRectMake(10, 70, 250, 40)
#define FRAME_SEARCH_BUTTON         CGRectMake(259, 71, 50, 38)

#define FRAME_MAP_BUTTON        FRAME_RIGHT_BUTTON1

#define NUM_OF_PERPAGE              20

// img
#define IMG_SEARCH_BTN      @"icon_search.png"

@interface BranchesViewController ()
{
    BranchesTableView *m_branchesTable;
    BranchesTableView *m_blockTable;
    NSArray *m_blockArray;
    NSDictionary *m_branchesDic;
    NSArray *m_commonBranchesArray;
    BOOL m_hasCommonBranches;
    
    NSArray *m_nearBranchesArray;
    BOOL m_hasNearly;
    
    UITextField *m_searchFeild;
    UIButton *m_searchBtn;
    NSMutableArray *m_searchDataArray;
    
    BOOL m_bShowResult;
    UILabel *m_noResult;
    
    BOOL m_bUseToBranches;
    BOOL m_bNearlyBranches;
    NSString *m_selBranchesName;
    NSString *m_selBrancheID;
    NSString *m_selBlock;
    NSString *m_reqBlock;
    
    CLLocationDegrees m_latitude;
    CLLocationDegrees m_longitude;
    BOOL m_bGotGps;
    
    CLLocationManager *m_locationManager;
    
    NSInteger m_requestCount;
    
    // ego
    NSInteger m_curPage;
    NSInteger m_pageSize;
    NSInteger m_totalBranches;
}

@end

@implementation BranchesViewController
@synthesize delegate, enterType;

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
    [self initLocationManager]; // must be called before calling inidata
    
    [self initData];
    [self initBranchesView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(customNavBarView)
    {
        [customNavBarView setTitle:STR_SELECT_BRANCHES];
        
        if (enterType == BranchesViewFromPersonalRetal)
        {
            UIButton *mapBtn = [[UIButton alloc] initWithFrame:FRAME_MAP_BUTTON];
//            [mapBtn setTitle:STR_MAP forState:UIControlStateNormal];
            [mapBtn setBackgroundImage:[UIImage imageNamed:IMG_NAV_MAP] forState:UIControlStateNormal];
            [mapBtn addTarget:self action:@selector(mapBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [customNavBarView addSubview:mapBtn];
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self uninitLocationManager];
    
    [super viewWillDisappear:animated];
}

-(void)mapBtnPressed
{
    NSLog(@"map btn pressed");
    
    BranchesMapViewController *vc = [[BranchesMapViewController alloc] init];
    vc.enterType = MapViewFromBranchesView;
    vc.branchesArray = [m_branchesDic objectForKey:@"branches"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backButtonPressed
{
    if (m_bShowResult)
    {
        m_bShowResult = NO;
        [self hideSearchResult];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *方法描述：初始化界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initBranchesView
{
    // 搜索编辑框
    m_searchFeild = [[UITextField alloc] initWithFrame:FRAME_TEXTFIELD_VIEW];
//    m_searchFeild.backgroundColor = [UIColor grayColor];
    [m_searchFeild setBackground:[UIImage imageNamed:IMG_SEARCH]];
    [self.view addSubview:m_searchFeild];
    // 搜索按钮
    m_searchBtn = [[UIButton alloc] initWithFrame:FRAME_SEARCH_BUTTON];
    [m_searchBtn addTarget:self action:@selector(searchButton) forControlEvents:UIControlEventTouchUpInside];
    [m_searchBtn setImage:[UIImage imageNamed:IMG_SEARCH_BTN] forState:UIControlStateNormal];
    m_searchBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_searchBtn];
    // 区域表
    m_blockTable = [[BranchesTableView alloc] initWithFrame:FRAME_BLOCK_TABLE_VIEW forBlock:tableBlock];
    m_blockTable.delegate = self;
    [self.view addSubview:m_blockTable];
    // 网点表
    m_branchesTable = [[BranchesTableView alloc] initWithFrame:FRAME_BRANCHES_TABLE_VIEW forBlock:tableBranches];
    [m_branchesTable setPosition:m_latitude withLon:m_longitude];
    m_branchesTable.delegate = self;
    [self.view addSubview:m_branchesTable];
    
#if 0
    m_noResult = [[UILabel alloc] initWithFrame:FRAME_NO_RESULT];
    m_noResult.textAlignment = NSTextAlignmentCenter;
    m_noResult.textColor = [UIColor blackColor];
    m_noResult.backgroundColor = [UIColor grayColor];
    m_noResult.text = STR_NO_RESULT;
    m_noResult.hidden = YES;
    [self.view addSubview:m_noResult];
#endif
}

/**
 *方法描述：隐藏搜索结果
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)hideSearchResult
{
//    m_searchResult.hidden = YES;
    m_blockTable.hidden = NO;
    m_branchesTable.hidden = NO;
    m_noResult.hidden = YES;
}

/**
 *方法描述：显示搜索结果
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showSearchResultView:(NSMutableArray * )array
{
    if (0 == [array count])
    {
//        m_searchResult.hidden = YES;
        m_blockTable.hidden = YES;
        m_branchesTable.hidden = YES;
        m_noResult.hidden = NO;
    }
    else
    {
 //       m_searchResult.hidden = NO;
        m_blockTable.hidden = YES;
        m_branchesTable.hidden = YES;
        m_noResult.hidden = YES;
    }
}

/**
 *方法描述：搜索按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)searchButton
{
    NSLog(@"search button pressed");
    [m_searchFeild resignFirstResponder];

    SearchBranchesResultViewController *tmpCtrl = [[SearchBranchesResultViewController alloc] initWithSearch:m_searchFeild.text];
    tmpCtrl.delegate = self;
    [self.navigationController pushViewController:tmpCtrl animated:NO];
//    if (m_searchDataArray)
    {
//        [self showSearchResultView:m_searchDataArray];
    }
}

#pragma mark - data
-(void)initData
{
    m_blockArray = nil;
    m_curPage = 1;
    m_pageSize = NUM_OF_PERPAGE;

    [self requestData];
}

/**
 *方法描述：获取附近网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getNearlyBranches
{
    if (m_locationManager == nil)
    {
        return;
    }
    NSString *strLat = [NSString stringWithFormat:@"%.6f", m_latitude];
    NSString *strLon = [NSString stringWithFormat:@"%.6f", m_longitude];
    NSLog(@"getNearlyBranches lat : %@, lon :%@", strLat, strLon);
    FMNetworkRequest *reqBranches = [[BLNetworkManager shareInstance] getBranchListByPosition:strLon latitude:strLat pageNumber:@"1" pagesize:@"20" delegate:self];
    reqBranches = nil;
    m_requestCount++;
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
}

/**
 *方法描述：获取用户常用网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getUsedBranches
{
    NSString *userId = [User shareInstance].id;
    NSString *strPage = [NSString stringWithFormat:@"%d", m_curPage];
    NSString *strSize = [NSString stringWithFormat:@"%d", m_pageSize];
    FMNetworkRequest *reqBranches = [[BLNetworkManager shareInstance] getCommonBranchList:userId pageNumber:strPage pageSize:strSize brancheType:@"1" delegate:self];
    reqBranches = nil;
    m_requestCount++;
    
    NSLog(@"---getUsedBranches-- count = %d", m_requestCount);
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
}

/**
 *方法描述：获取城市区域
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getBlockArea
{
    FMNetworkRequest *reqArea = [[BLNetworkManager shareInstance] getAreaListByCity:STR_NANJING delegate:self];
    reqArea = nil;
    m_requestCount++;
    
    NSLog(@"---getBlockArea-- count = %d", m_requestCount);
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
}

/**
 *方法描述：根据区域获取网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getBranchesWithBlock
{
    if ([m_selBlock isEqualToString:STR_NEAR_BRANCHES])
    {
        [self getNearlyBranches];
    }
    else if([m_selBlock isEqualToString:STR_USED_BRANCHES])
    {
        [self getUsedBranches];
    }
    else
    {
        FMNetworkRequest *reqBranches = [[BLNetworkManager shareInstance] selectBranchByCondition:nil city:STR_NANJING area:GET(m_selBlock) pageNumber:m_curPage pageSize:m_pageSize delegate:self];
        m_reqBlock = [NSString stringWithFormat:@"%@", GET(m_selBlock)];
        reqBranches = nil;
        
        [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    }
    
}

/**
 *方法描述：获取城市区域和常用网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)requestData
{
//    [self getNearlyBranches];
    [self getUsedBranches];
    [self getBlockArea];
}


/**
 *方法描述：整理城市区域列表数组
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)blockArray
{
    m_requestCount--;
    NSLog(@"--blockArray--- count = %d", m_requestCount);
    NSMutableArray *blockMultArr = [[NSMutableArray alloc] initWithArray:m_blockArray];

    if (m_hasCommonBranches)
    {
        [blockMultArr insertObject:STR_USED_BRANCHES atIndex:0];
    }
    else
    {
        [blockMultArr removeObject:STR_USED_BRANCHES];
    }
    
    if (m_hasNearly)
    {
        [blockMultArr insertObject:STR_NEAR_BRANCHES atIndex:0];
    }
    else
    {
        [blockMultArr removeObject:STR_NEAR_BRANCHES];
    }
    
    NSLog(@"---<= 0-- count = %d", m_requestCount);
    if (m_requestCount <= 0)
    {
        [m_blockTable setTableData:blockMultArr withBlock:m_selBlock];
    }
    NSLog(@"----- block arr --%@", m_selBlock);
}

/**
 *方法描述：获得网点数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateBranchesData:(id)responseData
{
    if (NO == [m_reqBlock isEqualToString:m_selBlock]) {
        NSLog(@"reqest block = %@, sel block = %@", m_reqBlock, m_selBlock);
        return;
    }
    m_branchesDic = [[NSDictionary alloc] initWithDictionary:responseData];
    
    m_totalBranches = [[m_branchesDic objectForKey:@"totalNumber"] integerValue];
    m_branchesTable.m_totalsItem = m_totalBranches;
    
    NSArray *tmpArray = [m_branchesDic objectForKey:@"branches"];
    [m_branchesTable setTableData:[m_branchesDic objectForKey:@"branches"] withBlock:m_selBlock];
    if ([tmpArray count] > 0) {
        m_curPage ++;
    }
}

/**
 *方法描述：更新区域数组
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateAreaData:(id)responseData
{
    m_blockArray = [[NSArray alloc] initWithArray:[responseData objectForKey:@"areas"]];
    
    [self blockArray];
}


/**
 *方法描述：更新当前位置
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)UpdateCurrentPosition
{
//    [self getNearlyBranches];
    
    [m_branchesTable setPosition:m_latitude withLon:m_longitude];
}

/**
 *方法描述：常用网点返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotCommonBranches:(id)responseData
{
    if (nil != m_commonBranchesArray)
    {
        m_commonBranchesArray = nil;
    }
    
    m_commonBranchesArray = [[NSArray alloc] initWithArray:[responseData objectForKey:@"getbranches"]];
    
    [self processCommonBranchesData];
}

/**
 *方法描述：附近网点返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotNearBranches:(id)responseData
{
    if (nil != m_nearBranchesArray) {
        m_nearBranchesArray = nil;
    }
    
    m_nearBranchesArray = [[NSArray alloc] initWithArray:[responseData objectForKey:@"branches"]];
    
    if (m_nearBranchesArray && [m_nearBranchesArray count] > 0) {
        m_hasNearly = YES;
    }
    
    [self blockArray];
}

/**
 *方法描述：对获取到的常用网点解析处理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)processCommonBranchesData
{
    m_hasCommonBranches = NO;
    if (m_commonBranchesArray && [m_commonBranchesArray count] > 0) {
        m_hasCommonBranches = YES;
    }
    
    [self blockArray];
}

/**
 *方法描述：隐藏等待
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)hideLodingView
{
//    m_requestCount--;

    [[LoadingClass shared] hideLoadingForMoreRequest];
}

#pragma mark - subview delegate
/**
 *方法描述：选择网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selBranche:(NSDictionary *)brancheData
{
    [m_searchFeild resignFirstResponder];
    m_selBranchesName = [brancheData objectForKey:@"name"];
    m_selBrancheID = [brancheData objectForKey:@"id"];
    
    
    switch (enterType)
    {
        case BranchesViewFromPersonalRetal:
        {
#if 0
            if (delegate && [delegate respondsToSelector:@selector(selBrancheFromController: withId:)])
            {
                [delegate selBrancheFromController:m_selBranchesName withId:m_selBrancheID];
            }
#else
            if (delegate && [delegate respondsToSelector:@selector(selBrancheFromController:)])
            {
                [delegate selBrancheFromController:brancheData];
            }
#endif
        }
            break;
            
        case BranchesViewFromBaiduMap:
        {
            if (delegate && [delegate respondsToSelector:@selector(selBrancheForMapView:)])
            {
                [delegate selBrancheForMapView:brancheData];
            }
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *方法描述：选择区域
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selBlock:(NSString *)blockName
{
    [m_searchFeild resignFirstResponder];
#if 0
    if ([m_selBlock isEqualToString:blockName])
    {
        NSLog(@"SEL same block");
        return;
    }
#endif
    m_pageSize = NUM_OF_PERPAGE;
    m_curPage = 1;
    m_selBlock = blockName;
    if ([m_selBlock isEqualToString:STR_NEAR_BRANCHES])
    {
        [m_branchesTable setTableData:m_nearBranchesArray withBlock:m_selBlock];
    }
    else if([m_selBlock isEqualToString:STR_USED_BRANCHES])
    {
        [m_branchesTable setTableData:m_commonBranchesArray withBlock:m_selBlock];
    }
    else
    {
        [self getBranchesWithBlock];
    }
}

/**
 *方法描述：选择搜索到的网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectSearchBranche:(NSDictionary *)branche
{
    [[BranchDataManager shareInstance] setSelBranchDic:branche isSelTake:YES];
    [[BranchDataManager shareInstance] setSelBranchDic:branche isSelTake:NO];
    
    [self selBranche:branche];
}


/**
 *方法描述：列表加载刷新
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getMoreDate:(branchesViewType)type
{
    switch (type) {
        case tableBlock:// 区域
            [self getBlockArea];
            break;
        case tableBranches://网点
            [self getBranchesWithBlock];
            break;
        case tableSearch:
            break;
        default:
            break;
    }
}


/**
 *方法描述：重新获取数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)regetData:(branchesViewType) type
{
    switch (type) {
        case tableBlock://区域
            [self getBlockArea];
            break;
        case tableBranches:// 网点
            m_curPage = 0;
            [self getBranchesWithBlock];
            break;
        case tableSearch:
            break;
        default:
            break;
    }
}
#pragma mark - GPS

-(void)initLocationManager
{
    if([CLLocationManager locationServicesEnabled])
    {
        m_locationManager = [[CLLocationManager alloc] init];
        m_locationManager.delegate = self;
        [m_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//        m_locationManager.distanceFilter = 100.f;
        [m_locationManager startUpdatingLocation];
    }
    else
    {
        m_bGotGps = YES;
        m_hasCommonBranches = NO;
    }
    
}

-(void)uninitLocationManager
{
    if (nil != m_locationManager) {
        [m_locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied)
    {
        NSLog(@"location denied");
    }
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    m_latitude = newLocation.coordinate.latitude;
    m_longitude = newLocation.coordinate.longitude;
    
    [self UpdateCurrentPosition];
}

-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    m_latitude =  coor.latitude;
    m_longitude = coor.longitude;
    NSLog(@"lat = %.6f, long = %.6f", m_latitude, m_longitude);
    if (NO == m_bGotGps) {
        [self getNearlyBranches];
        m_bGotGps = YES;
    }
    
    [self UpdateCurrentPosition];
}

#pragma mark - textfeild

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_searchFeild resignFirstResponder];
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_searchFeild resignFirstResponder];
}

#pragma mark - FMNetworkDelegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [self hideLodingView];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getAreaListByCity])
    {// 获取城市区域
        [self updateAreaData:fmNetworkRequest.responseData];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCommonBranchList])
    {// 获取常用网点
        [self gotCommonBranches:fmNetworkRequest.responseData];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchListByPosition])
    {// 附件网点
        [self gotNearBranches:fmNetworkRequest.responseData];
    }
    else
    {
        [self updateBranchesData:fmNetworkRequest.responseData];
    }
    
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    NSLog(@" fm net work failed");
    [self hideLodingView];
    m_requestCount--;

    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getAreaListByCity])
    {// 获取城市区域
        [m_blockTable getMoreRequestFailed];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchListByPosition])
    {// 获取附近网点
        m_bGotGps = NO;
        [m_branchesTable getMoreRequestFailed];
    }
    else
    {// 其他请求处理
        [m_branchesTable getMoreRequestFailed];
    }
    
    if ([fmNetworkRequest.responseData isEqualToString:@"网络连接失败"])
    {
        [[LoadingClass shared] showContent:@"网络异常，请稍后重试" andCustomImage:nil];
    }
}

@end
