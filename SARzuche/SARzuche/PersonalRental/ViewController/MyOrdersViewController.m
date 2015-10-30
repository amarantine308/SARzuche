//
//  MyOrdersViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "ConstString.h"
#import "constDefine.h"
#import "ViewSelectOrderViewController.h"
#import "RenewRecordViewController.h"
#import "MyOrdersData.h"
#import "PriceDetailsView.h"
#import "LoadingClass.h"
#import "OrderManager.h"
#import "BranchDataManager.h"
#import "CarDataManager.h"
#import "User.h"
#import "BranchesMapViewController.h"
#import "BranchDataManager.h"
#import "CustomAlertView.h"
#import "ConstImage.h"
#import "PublicFunction.h"
#import "NavigationViewController.h"

#define HISTORY_PAGE_SIZE       20
#define SUBVIEW_WIDTH           MainScreenWidth

#define SUBVIEW_STARTY      ORDER_SUBVIEW_STARTY
#define HISTORY_SUBVIEW_HEIGHT      (MainScreenHeight - SUBVIEW_STARTY)
#define SUBVIEW_HEIGHT      (MainScreenHeight - SUBVIEW_STARTY)

#define FRAME_SEGMENT                   CGRectMake(40, 70, 240, 32)
#define FRAME_CURRENT_ORDER_SUBVIEW     CGRectMake(0, 0, SUBVIEW_WIDTH, SUBVIEW_HEIGHT + bottomButtonHeight)
#define FRAME_CURRENT_ORDER_VIEW        CGRectMake(0, SUBVIEW_STARTY, SUBVIEW_WIDTH, SUBVIEW_HEIGHT + bottomButtonHeight)
#define FRAME_HISTORY_VIEW              CGRectMake(0, SUBVIEW_STARTY, SUBVIEW_WIDTH, HISTORY_SUBVIEW_HEIGHT)
#define FRAME_HISTORY_SUBVIEW              CGRectMake(0, 0, SUBVIEW_WIDTH, HISTORY_SUBVIEW_HEIGHT)
#define FRAME_ZERO                      CGRectMake(0, 0, 0, 0)

#define FRAME_RIGHT_BTN                 CGRectMake(280, 10, 30, 30)
#define FRAME_SHORT_MENU                CGRectMake(0, 70, MainScreenWidth, MainScreenHeight - 70)

#define FRAME_UNSUB_VIEW                CGRectMake(0, SUBVIEW_STARTY, MainScreenWidth, SUBVIEW_HEIGHT)

#define FRAME_DETAIL_VIEW               CGRectMake(0, 20, MainScreenWidth, MainScreenHeight)

#define FRAME_CAR_RENT_BTN              CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)

@interface MyOrdersViewController ()
{
    //
    NSInteger m_selSegIndex;
    UISegmentedControl *m_segment;
    NSArray *m_segmentArray;
    
    //
    UIButton *m_prePayBtn;
    UIButton *m_consumeBtn;
    
    CurrentOrderView *m_currentOrderSubView;
    HistoryOrdersView *m_historyOrdersSubView;
    UnsubscribeOrderView *m_unsubscribeView;
    UIView *m_myOrderView;
    UIView *m_historyView;
    BOOL m_noCurOrder;
    
    ShortMenuView *m_shortMenu;
    BOOL m_bShowMenu;
    
    srvOrderData *m_myOrderData;
    OrderListData *m_orderList;
    BOOL m_bOrderData;
    BOOL m_bRepeatList;
    
    NSString *m_takeBranch;
    NSString *m_givebackBranch;
    NSInteger m_branchCount;
    
    orderStatus m_curShowStatus;
    BOOL m_bShowUnsub;
    
    // request
    FMNetworkRequest *m_orderListReq;
    NSInteger m_ordersTotal;
    NSInteger m_curOrdersNum;
    NSInteger m_page;
    
    FMNetworkRequest *m_carInfoReq;
    FMNetworkRequest *m_curOrderReq;
    FMNetworkRequest *m_renewListReq;
    
    //无订单提示
    UIView *m_noOrderView;
    UILabel *m_noOrderLabel;
    UIButton *m_toRentCar;
    BOOL m_bHaveOrder;
}

@end

@implementation MyOrdersViewController

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
    
    // 导航栏按钮
    [customNavBarView setLeftButton:@"back.png" target:self leftBtnAction:@selector(backClk:)];
    self.view.backgroundColor = COLOR_BACKGROUND;
    // Do any additional setup after loading the view.
    m_page = 1;
    [self getMyOrder];
    [self getOrdersList];
    
    [self initMyOrdersView];
    [self showMyOrderView];
    [self initNoOrderView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_MY_ORDER];
#if 0
        UIButton *tmpBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BTN];
        [tmpBtn addTarget:self action:@selector(menuBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        tmpBtn.backgroundColor = [UIColor grayColor];
        [customNavBarView addSubview:tmpBtn];
#endif
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initNoOrderView
{
    m_noOrderView = [[UIView alloc] initWithFrame:FRAME_CURRENT_ORDER_VIEW];
    m_noOrderView.backgroundColor = [UIColor whiteColor];
    m_noOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (MainScreenHeight- SUBVIEW_STARTY)/2 - 60, MainScreenWidth - 20, 40)];
    m_noOrderLabel.text = STR_NO_ORDER;
    m_noOrderLabel.textColor = [UIColor blackColor];
    m_noOrderLabel.textAlignment = NSTextAlignmentCenter;
    [m_noOrderView addSubview:m_noOrderLabel];
    
    CGRect tmpRect = CGRectMake(0, m_noOrderView.frame.size.height - bottomButtonHeight - 40, m_noOrderView.frame.size.width, bottomButtonHeight);
    m_toRentCar = [[UIButton alloc] initWithFrame:tmpRect];
    [m_toRentCar setTitle:STR_TO_RENT forState:UIControlStateNormal];
    [m_toRentCar setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_toRentCar addTarget:self action:@selector(toRentCar) forControlEvents:UIControlEventTouchUpInside];
    [m_noOrderView addSubview:m_toRentCar];
    
    m_noOrderView.hidden = YES;
    [self.view addSubview:m_noOrderView];
}


// 跳转分时租车
-(void)toRentCar
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_personal];
}

/**
 *方法描述：菜单按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)menuBtnPressed
{
    if (nil == m_shortMenu) {
        m_shortMenu = [[ShortMenuView alloc] initWithFrame:FRAME_SHORT_MENU];
        m_shortMenu.backgroundColor = [UIColor clearColor];
        m_shortMenu.delegate = self;
    }
    
    if (NO == m_bShowMenu) {
        [self.view addSubview:m_shortMenu];
    }
    else
    {
        [m_shortMenu removeFromSuperview];
    }
    m_bShowMenu = !m_bShowMenu;
}

/**
 *方法描述：初始化当前订单界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCurrentOrderView
{
    m_myOrderView = [[UIView alloc] initWithFrame:FRAME_CURRENT_ORDER_VIEW];
    m_myOrderView.backgroundColor = [UIColor clearColor];
    
    m_currentOrderSubView = [[CurrentOrderView alloc] initWithFrame:FRAME_CURRENT_ORDER_SUBVIEW withData:nil];
    m_currentOrderSubView.delegate = self;
    [m_myOrderView addSubview:m_currentOrderSubView];

    [self.view addSubview:m_myOrderView];
}

/**
 *方法描述：初始化历史订单界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initHistoryOrdersView
{
    m_historyView = [[UIView alloc] initWithFrame:FRAME_HISTORY_VIEW];
    m_historyView.backgroundColor = [UIColor clearColor];
    
    m_historyOrdersSubView =  [[HistoryOrdersView alloc] initWithFrame:FRAME_HISTORY_SUBVIEW];
    m_historyOrdersSubView.delegate = self;
    [m_historyView addSubview:m_historyOrdersSubView];
    
    [self.view addSubview:m_historyView];
    
}

/**
 *方法描述：初始化我的订单和历史订单界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initMyOrdersView
{
    if (nil == m_segmentArray) {
        m_segmentArray  = [[NSArray alloc] initWithObjects:STR_CURRENT_ORDER, STR_MY_ORDERS, nil];
    }
    m_segment = [[UISegmentedControl alloc] initWithItems:m_segmentArray];
    m_segment.frame = FRAME_SEGMENT;
    [m_segment addTarget:self action:@selector(segmentStatusChanged:) forControlEvents:UIControlEventValueChanged];
    [m_segment setSelectedSegmentIndex:m_selSegIndex];
    [self.view addSubview:m_segment];
 
    [self initCurrentOrderView];
    [self initHistoryOrdersView];
}

/**
 *方法描述：segment 切换
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)segmentStatusChanged:(id)sender
{
    UISegmentedControl *tmpSeg = (UISegmentedControl *)sender;
    m_selSegIndex = tmpSeg.selectedSegmentIndex;
    NSLog(@"segment status changed");
    
    switch (m_selSegIndex) {
        case 0:
            [self showMyOrderView];
            break;
        case 1:
            [self showHistoryOrdersView];
            break;
        default:
            break;
    }
}

/**
 *方法描述：显示预付款详情
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)prePayPressed
{
    NSLog(@"prepay pressed");
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:YES];
    [tmpView setOrderData:[[OrderManager ShareInstance] getCurrentOrderData]];
    [self.view addSubview:tmpView];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)consumePressed
{
    NSLog(@"consume pressed");
}

/**
 *方法描述：无我的订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)MyorderViewNoData : (BOOL)noData
{
    m_myOrderView.hidden = YES;
    m_noOrderView.hidden = NO;
}

/**
 *方法描述：显示我的订单页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showMyOrderView
{
    m_historyView.hidden = YES;
    if (m_noCurOrder)
    {
        m_myOrderView.hidden = YES;
        m_noOrderView.hidden = NO;
    }
    else
    {
        m_myOrderView.hidden = NO;
        m_noOrderView.hidden = YES;
    }

    [self removeUnsubscribeView];
}

/**
 *方法描述：显示历史订单页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showHistoryOrdersView
{
    m_historyView.hidden = NO;
    m_noOrderView.hidden = YES;
    m_myOrderView.hidden = YES;
    [self removeUnsubscribeView];
}

/**
 *方法描述：移除退订页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)removeUnsubscribeView
{
    if (m_unsubscribeView) {
        [m_unsubscribeView removeFromSuperview];
        m_unsubscribeView = nil;
    }
}

/**
 *方法描述：显示退订页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showUnsubscribeView
{
    [self removeUnsubscribeView];
    
    m_unsubscribeView = [[UnsubscribeOrderView alloc] initWithFrame:FRAME_UNSUB_VIEW withData:m_myOrderData];
    m_unsubscribeView.delegate = self;
    [self.view addSubview:m_unsubscribeView];
    
    m_historyView.hidden = YES;
    m_myOrderView.hidden = YES;
    m_noOrderView.hidden = YES;
}

/**
 *方法描述：更新订单数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateOrderData
{
    BrancheData *tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:YES];
    m_takeBranch = [NSString stringWithFormat:@"%@",tmpData.m_name];
    
    tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:NO];
    m_givebackBranch = [NSString stringWithFormat:@"%@", tmpData.m_name];
    
    [m_myOrderData setTakeBrancheName:m_takeBranch];
    [m_myOrderData setGivebackBrancheName:m_givebackBranch];
//    [m_currentOrderSubView setOrderData:m_myOrderData];
    
    m_bOrderData = YES;
    [self updateOrderToView];
}

// 更新订单信息
-(void)updateOrderToView
{
    if (m_bOrderData && m_bRepeatList)
    {
        [m_currentOrderSubView setOrderData:m_myOrderData];
    }
}

/**
 *方法描述：更新车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateCarInfo
{
    [m_currentOrderSubView setCarInfo:[[CarDataManager shareInstance] getSelCar]];
}
// 返回
-(void)backClk:(id)sender
{
    NSLog(@" my order back pressed");
    if (m_bShowUnsub == NO) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self backToPrePageFromUnsub];
    }
}
// 改变订单状态
-(void)changeOrderStatus
{
    m_bRepeatList = YES;
    [self updateOrderToView];
}

#pragma mark - current order view delegate
// 有新的续订记录
-(void)renewListChanged
{
//    [self changeOrderStatus];
    [self backToPrePage:NO];
}
/**
 *方法描述：续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotoRenewOrder
{
    RenewOrderViewController *tmpCtrl = [[RenewOrderViewController alloc] initWithNibName:nil bundle:nil];
    tmpCtrl.delegate = self;
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

/**
 *方法描述：续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotoRenewRecord
{
    RenewRecordViewController *tmpCtrl = [[RenewRecordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

/**
 *方法描述：退订订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotoUnSubscribeOrder
{
    [self showUnsubscribeView];
//    m_curShowStatus = orderUnsubscribe;
    m_bShowUnsub = YES;
}

/**
 *方法描述：修改订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotoModifyOrder
{
    ModifyOrderViewController *tmpCtrl = [[ModifyOrderViewController alloc] initWithNibName:nil bundle:nil];
    tmpCtrl.delegate = self;
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

/**
 *方法描述：显示预付款
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)prepayBtnPressed
{
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:YES];
    [tmpView setOrderData:[[OrderManager ShareInstance] getCurrentOrderData]];
    [self.view addSubview:tmpView];
}

// 跳转到地图
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance
{
    if (bTakeBrance)
    {
        NavigationViewController *nextVC = [[NavigationViewController alloc] init]; // 进入导航页面
        nextVC.enterType = NavigationViewFromHomeView;
        //[nextVC.locationsDic setObject:@"" forKey:kEY_LocationDic_endAddr];

//        [nextVC.locationsDic setObject:endLocationDic forKey:kEY_LocationDic_endAddr];
        [self.navigationController pushViewController:nextVC animated:YES];
       
        //进入网点地图
    /*  BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:YES]];
        vc.enterType = MapViewFromSelBranch;
      //vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:YES];
     [self.navigationController pushViewController:vc animated:YES];
    */
    }
    else
    {
        NavigationViewController *nextVC = [[NavigationViewController alloc] init]; // 进入导航页面
        nextVC.enterType = NavigationViewFromHomeView;
        //[nextVC.locationsDic setObject:@"" forKey:kEY_LocationDic_endAddr];
        
        //        [nextVC.locationsDic setObject:endLocationDic forKey:kEY_LocationDic_endAddr];
        [self.navigationController pushViewController:nextVC animated:YES];

        //进入网点地图
       /* BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:NO]];
        vc.enterType = MapViewFromSelBranch;
      //vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:NO];
        [self.navigationController pushViewController:vc animated:YES];
        */
    }
}
#pragma mark - get data
/**
 *方法描述：根据车辆id 请求车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarInfoWithId:(NSString *)carId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    m_carInfoReq = [[BLNetworkManager shareInstance] getCarInfo:carId delegate:self];
}

// 续订记录请求
-(void)repeatOrderList:(NSString *)orderID
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    m_renewListReq = [[BLNetworkManager shareInstance] repeatOrderList:orderID delegate:self];
}

/**
 *方法描述：根据网点id 请求网点
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
 *方法描述：我的订单请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getMyOrder
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    NSString *userId = [User shareInstance].id;
    m_curOrderReq = [[BLNetworkManager shareInstance] getCurrentOrderInfo:userId delegate:self];
    
}

/**
 *方法描述：历史订单请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getOrdersList
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *userId = [User shareInstance].id;
    NSString *page = [NSString stringWithFormat:@"%d", m_page];
    NSString *pageSize = [NSString stringWithFormat:@"%d", HISTORY_PAGE_SIZE];
    m_orderListReq = [[BLNetworkManager shareInstance] getOrdersList:userId Page:page Size:pageSize delegate:self];
}

/**
 *方法描述：我的订单数据返回
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
        return;
    }

    
    m_myOrderData = [[srvOrderData alloc] initWithOriginalData:fmRequest.responseData];
    
    [self getBranchWithId:m_myOrderData.m_takeNet];
    [self getCarInfoWithId:m_myOrderData.m_carId];
    [self repeatOrderList:m_myOrderData.m_orderId];
    m_branchCount = 1;

    
    [[OrderManager ShareInstance] setCurrentOrderData:m_myOrderData];
}

/**
 *方法描述：请求失败处理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initDataWithRequestFaile:(FMNetworkRequest *)fmRequest
{
    if([fmRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
    {
        m_noCurOrder = YES;
        [self MyorderViewNoData:YES];
    }
}

// 隐藏历史订单
-(void)hiddenHistoryView:(BOOL)bhidden
{
    m_historyOrdersSubView.hidden = bhidden;
}

/**
 *方法描述：历史订单数据返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initOrderListWithNetworkRequest:(FMNetworkRequest *)fmRequest
{
    NSInteger nCount = 0;
    
    if (nil == m_orderList)
    {
        m_orderList = [[OrderListData alloc] initWithRequest:fmRequest];
        nCount = m_orderList.getOrderListDataNum;
    }
    else
    {
        nCount = [m_orderList UpdateDataWithRequest:fmRequest];
    }

    if (nCount > 0) {
        m_page ++;
    }

    [m_historyOrdersSubView updateOrderList:m_orderList];
}

/**
 *方法描述：网点信息返回
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
        if ([m_myOrderData.m_takeNet isEqualToString:m_myOrderData.m_backNet])// 取车网点和还车网点一致
        {
            [[BranchDataManager shareInstance] setBranchData:[branchesArr objectAtIndex: 0] withType:NO];
            [[BranchDataManager shareInstance] setSelBranchDic:[branchesArr objectAtIndex:0] isSelTake:NO];
            m_branchCount = 0;
            [self updateOrderData];
        }
        else
        {// 获取还车网点
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

// 续订记录返回
-(void)initRepeatOrderList:(FMNetworkRequest *)request
{
    m_bRepeatList = YES;
    NSLog(@"my orders controller repealist");
    
    NSDictionary *dic = request.responseData;
    NSArray *data = [dic objectForKey:@"renewOrderList"];
    if (data == nil || [data count] == 0) {
        [[OrderManager ShareInstance] setOrderRenewList:nil];
        [self updateOrderToView];
        return;
    }
//    NSDictionary *renewDic = [data objectAtIndex:[data count]-1];
//    NSString * renewTime = [renewDic objectForKey:@"renewtime"];
    [[OrderManager ShareInstance] setOrderRenewList:dic];

//    [self updateRepeatList];
    [self updateOrderToView];
}

// 更新续订
-(void)updateRepeatList
{
//    NSArray *renewList = [[OrderManager ShareInstance] getOrderRenewList];
//    NSInteger nCount = [renewList count];
    
    [self updateOrderToView];
}

/**
 *方法描述：车辆信息返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfo:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
#if 0
    NSArray *carArr = [dic objectForKey:@"cars"];
    if (0 == [carArr count]) {
        return;
    }
    
    [[CarDataManager shareInstance] setSelCar:[carArr objectAtIndex:0]];
#else
    [[CarDataManager shareInstance] setSelCar:[dic objectForKey:@"cars"]];
#endif
    [self updateCarInfo];
}

#pragma mark - network delegate
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
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getOrdersList]) {// 历史订单
        [self hiddenHistoryView:NO];
        [self initOrderListWithNetworkRequest:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])//  当前订单
    {
        [self initMyOrderWithNetworkRequest:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchById])// 根据网点id 获取网点信息
    {
        [self initBranche:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCarInfo])// 获取车辆信息
    {
        [self initCarInfo:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_repeatOrderList])// 续订记录
    {
        [self initRepeatOrderList:fmNetworkRequest];
    }
    else if([kRequest_changeOrder isEqualToString:fmNetworkRequest.requestName])// 修改订单
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MODIFY_SUCCESS delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
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
    NSLog(@"%@", fmNetworkRequest);

    if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
    {
        [self initDataWithRequestFaile:fmNetworkRequest];
    }
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getOrdersList])
    {
        [self hiddenHistoryView:YES];
    }
    [[LoadingClass shared] hideLoadingForMoreRequest];
}

#pragma mark - ShortcutMenu delegate
/**
 *方法描述：右上角菜单退出
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)shortMenuExit
{
    m_bShowMenu = NO;
}

#pragma mark - HistoryOrdersView delegate
// 加载历史订单数据
-(void)GetHistoryMoreData:(BOOL)bRemove
{
    if (bRemove)
    {
        m_page = 1;
        [[CarDataManager shareInstance] clearAllHistoryCar];
    }
    
    [self getOrdersList];
}


/**
 *方法描述：显示支付详情
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showPayInfo:(NSInteger)index
{
    if (index >= [m_orderList getOrderListDataNum]) {
        NSLog(@"index more than total of orders");
        return;
    }
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:NO];
    [tmpView setOrderData:[m_orderList orderDataAtIndex:index]];
    [self.view addSubview:tmpView];
}

/**
 *方法描述：选择历史订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectOrder:(NSInteger)index
{
    NSLog(@" select order in controller");
    ViewSelectOrderViewController *tmpController = [[ViewSelectOrderViewController alloc]initWithOrder:[m_orderList orderDataAtIndex:index]];
    [self.navigationController pushViewController:tmpController animated:YES];
}

#pragma mark - Unsub order view delegate
/**
 *方法描述：bool 表示是否需要刷新历史订单。 续订，退订，修改后，需要重新刷新
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)backToPrePage:(BOOL)bUpdateHistory
{
    [self getMyOrder];
    if (bUpdateHistory) {
        m_orderList = nil;
        m_page = 1;
        [self getOrdersList];
    }
    
    [self showMyOrderView];
    m_bShowUnsub = NO;
}

// 从退订订单返回
-(void)backToPrePageFromUnsub
{
    [self showMyOrderView];
    m_bShowUnsub = NO;
}

-(void)dealloc
{
    [[CarDataManager shareInstance] clearAllHistoryCar];
    CANCEL_REQUEST(m_orderListReq);
    CANCEL_REQUEST(m_carInfoReq);
    CANCEL_REQUEST(m_curOrderReq);
    CANCEL_REQUEST(m_renewListReq);
}

@end
