//
//  ViewSelectOrderViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ViewSelectOrderViewController.h"
#import "ConstString.h"
#import "CurrentOrderView.h"
#import "ConstDefine.h"
#import "ApplyInvoiceViewController.h"
#import "BranchDataManager.h"
#import "PublicFunction.h"
#import "LoadingClass.h"
#import "RenewRecordViewController.h"
#import "PriceDetailsView.h"
#import "NavigationViewController.h"

#define FRAME_CURRENT_ORDER_SUBVIEW     CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)
#define FRAME_REQUEST_BTN               CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth/2, bottomButtonHeight)
#define FRAME_RENT_AGAIN_BTN               CGRectMake(MainScreenWidth/2, MainScreenHeight - bottomButtonHeight, MainScreenWidth/2, bottomButtonHeight)

#define FRAME_DETAIL_VIEW               CGRectMake(0, 20, MainScreenWidth, MainScreenHeight)

#define IMG_RENTED_AGAIN               @"modify.png"
#define IMG_APPLY_INVOICE              @"unsubscribe.png"

@interface ViewSelectOrderViewController ()
{
    CurrentOrderView *m_currentOrderView;
    srvOrderData *m_orderData;
    NSInteger m_branchCount;
    BranchDataManager *m_branchData;
    OrderManager *m_orderManagerForRepeat;
    
    UIButton *m_requestTicket;
    UIButton *m_rentAgain;
    
    BOOL m_bRepeatList;
    
    // request
    FMNetworkRequest *m_branchWitIdReq;
    FMNetworkRequest *m_carInfoReq;
    FMNetworkRequest *m_renewListReq;
}
@end

@implementation ViewSelectOrderViewController

-(id)initWithOrder:(srvOrderData *)orderData
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        m_orderData = orderData;
    }
    return self;
}

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
    
    [self initSelectedOrderView];
    
    [self repeatOrderList:GET(m_orderData.m_orderId)];
    
    [self getCarInfo];
    if (nil != m_orderData && m_orderData.m_takeNet != nil)
    {
        [self getBranchWithId:m_orderData.m_takeNet];
        m_branchCount = 1;
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
    if (customNavBarView) {
        [customNavBarView setTitle:STR_ORDER_DETAILS];
    }
    
    if ([self isOrderCanceled])
    {
        m_requestTicket.hidden = YES;
        
        CGRect tmpRect = m_rentAgain.frame;
        tmpRect.origin.x = 0;
        tmpRect.size.width = MainScreenWidth;
        m_rentAgain.frame = tmpRect;
    }
#if 0
    if ([m_orderData.m_invoice isEqualToString:@"1"])
    {
        [m_requestTicket setEnabled:NO];
    }
#endif
}


-(BOOL)isOrderCanceled
{
    if ([m_orderData.m_status isEqualToString:SQL_ORDER_CANCEL])
    {
        return YES;
    }
    
    return NO;
}


/**
 *方法描述：初始化选择的历史订单界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initSelectedOrderView
 {
     m_currentOrderView = [[CurrentOrderView alloc] initWithFrame:FRAME_CURRENT_ORDER_SUBVIEW withData:m_orderData formHist:YES];
     m_currentOrderView.m_bHistoryOrder = YES;
     m_currentOrderView.delegate = self;

     [self.view addSubview:m_currentOrderView];
     
     m_requestTicket = [[UIButton alloc] initWithFrame:FRAME_REQUEST_BTN];
     [m_requestTicket setTitle:STR_REQUEST_TICKET forState:UIControlStateNormal];
//     m_requestTicket.backgroundColor = [UIColor redColor];
     [m_requestTicket setBackgroundImage:[UIImage imageNamed:IMG_APPLY_INVOICE] forState:UIControlStateNormal];
     [m_requestTicket setBackgroundImage:[UIImage imageNamed:IMG_APPLY_INVOICE] forState:UIControlStateDisabled];
     [m_requestTicket addTarget:self action:@selector(requestTicket) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:m_requestTicket];
     
     m_rentAgain = [[UIButton alloc] initWithFrame:FRAME_RENT_AGAIN_BTN];
     [m_rentAgain setTitle:STR_RENT_AGAIN forState:UIControlStateNormal];
     m_rentAgain.backgroundColor = [UIColor greenColor];
     [m_rentAgain setBackgroundImage:[UIImage imageNamed:IMG_RENTED_AGAIN] forState:UIControlStateNormal];
     [m_rentAgain addTarget:self action:@selector(rentAgain) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:m_rentAgain];
 }


/**
 *方法描述：续订记录请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)repeatOrderList:(NSString *)orderID
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    m_renewListReq = [[BLNetworkManager shareInstance] repeatOrderList:orderID delegate:self];
}


/**
 *方法描述：查看续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotoRenewRecord
{
    RenewRecordViewController *tmpCtrl = [[RenewRecordViewController alloc] initForHistoryRecord:m_orderData];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}


/**
 *方法描述：查看消费信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)payedInfo
{
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:NO];
    [tmpView setOrderData:m_orderData];//[[OrderManager ShareInstance] getCurrentOrderData]];
    [self.view addSubview:tmpView];
}

/**
 *方法描述：查看预付款详情
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)prepayBtnPressed
{
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:YES];
    [tmpView setOrderData:m_orderData];
    [self.view addSubview:tmpView];
}


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

/**
 *方法描述：请求车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarInfo
{
    if (nil == m_orderData || nil == m_orderData.m_carId) {
        return;
    }
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    m_carInfoReq = [[BLNetworkManager shareInstance] getCarInfo:m_orderData.m_carId delegate:self];
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
    SelectedCar *carInfo = [[CarDataManager shareInstance] getSelCar];

    [m_currentOrderView setCarInfo:carInfo];
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
    
    if (m_branchData == nil) {
        m_branchData = [[BranchDataManager alloc] init];
    }
    
    if (0 == [branchesArr count]) {
        m_branchCount = 0;
        return;
    }
    
    if (1 == m_branchCount) {
        [m_branchData setBranchData:[branchesArr objectAtIndex:0] withType:YES];
        if ([m_orderData.m_takeNet isEqualToString:m_orderData.m_backNet])
        {
            [m_branchData setBranchData:[branchesArr objectAtIndex: 0] withType:NO];
//            [self updateOrderData];
            m_branchCount = 2;
            [self updateToView];
            m_branchCount = 0;
            return;
        }
        else
        {
            [self getBranchWithId:m_orderData.m_backNet];
            m_branchCount = 2;
            return;
        }
    }
    
    if (m_branchCount == 2)
    {
        [m_branchData setBranchData:[branchesArr objectAtIndex: 0] withType:NO];
//        [self updateOrderData];
        [self updateToView];
        m_branchCount = 0;
    }
}


/**
 *方法描述：更新订单信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateOrderData
{
    BrancheData *branchData = [m_branchData getBranchDataWithType:YES];
    NSString *takeBranch = [NSString stringWithFormat:@"%@",GET(branchData.m_name)];
    branchData = [m_branchData getBranchDataWithType:NO];
    NSString *givebackBranch = [NSString stringWithFormat:@"%@", GET(branchData.m_name)];
    
    [m_orderData setTakeBrancheName:takeBranch];
    [m_orderData setGivebackBrancheName:givebackBranch];
    
    [m_currentOrderView setOrderData:m_orderData];
}


/**
 *方法描述：根据网点id 获取网点信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getBranchWithId:(NSString*)brancheId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    m_branchWitIdReq = [[BLNetworkManager shareInstance] getBranchById:brancheId delegate:self];
}


/**
 *方法描述：申请开票
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)requestTicket
{
    NSLog(@"need ticket===%@",m_orderData.m_orderNum);
    ApplyInvoiceViewController *tmpController = [[ApplyInvoiceViewController alloc] initWithNibName:nil bundle:nil];
    tmpController.m_orderData =m_orderData;
    [self.navigationController pushViewController:tmpController animated:YES];
}

/**
 *方法描述：再订一次
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)rentAgain
{
    NSLog(@"rent again");
    UserSelectCarCondition *tmpCondition = [[UserSelectCarCondition alloc] init];
    tmpCondition.m_takeCity = STR_NANJING;
    tmpCondition.m_takeBranche = [NSString stringWithFormat:@"%@", m_orderData.m_takeNetName];
    tmpCondition.m_takeTime = @"";
    tmpCondition.m_givebackBranche = [NSString stringWithFormat:@"%@", m_orderData.m_backNetName];
    tmpCondition.m_givebackCity = STR_NANJING;
    tmpCondition.m_givebackTime = @"";
    tmpCondition.m_givebackBrancheId = [NSString stringWithFormat:@"%@", m_orderData.m_takeNet];
    tmpCondition.m_takeBrancheId = [NSString stringWithFormat:@"%@", m_orderData.m_backNet];
    
    [[OrderManager ShareInstance] setSelectCarCondition:tmpCondition];
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_preRental];
}

/**
 *方法描述：历史订单续订记录返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initRepeatOrderList:(FMNetworkRequest *)request
{
    m_bRepeatList = YES;
    NSLog(@" ViewSelectOrderViewController ");
    
    NSDictionary *dic = request.responseData;
    NSArray *data = [dic objectForKey:@"renewOrderList"];
    if (data == nil || [data count] == 0) {
        [self updateToView];
        return;
    }
    //    NSDictionary *renewDic = [data objectAtIndex:[data count]-1];
    //    NSString * renewTime = [renewDic objectForKey:@"renewtime"];
//    [[OrderManager ShareInstance] setOrderRenewList:dic];
    m_orderManagerForRepeat = [[OrderManager alloc] init];
    [m_orderManagerForRepeat setOrderRenewList:dic];
    
    [m_currentOrderView setRenewList:[m_orderManagerForRepeat getOrderRenewList]];
    
    //    [self updateRepeatList];
    [self updateToView];
}

// 更新所选订单详情
-(void)updateToView
{
 //   m_bRepeatList =
    if (m_bRepeatList && m_branchCount == 2)
    {
        [self updateOrderData];
        m_branchCount = 0;
        m_bRepeatList = NO;
    }
    
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
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCarInfo])
    {
        [self initCarInfo:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchById])
    {
        [self initBranche:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_repeatOrderList])
    {
        [self initRepeatOrderList:fmNetworkRequest];
    }
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
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if([fmNetworkRequest.requestName isEqualToString:kRequest_repeatOrderList])
    {
//        [self initRepeatOrderList:fmNetworkRequest];
        m_bRepeatList = YES;
        [self updateToView];
    }
}


-(void)dealloc
{
    CANCEL_REQUEST(m_branchWitIdReq);// 退出前取消相关请求
    CANCEL_REQUEST(m_carInfoReq);
    CANCEL_REQUEST(m_renewListReq);
}


@end
