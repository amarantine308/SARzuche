//
//  PreferentialCouponViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PreferentialCouponViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "CouponCell.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "CouponInfoController.h"
#import "ConstImage.h"
#import "OrderManager.h"
#import "CustomAlertView.h"
#import "GivebackViewController.h"
#import "SelectCouponView.h"

#define FRAME_TABLEVIEW        CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - bottomButtonHeight)

#define FRAME_GIVEBACK_BTN      CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth,bottomButtonHeight)

@interface PreferentialCouponViewController ()
{
    UITableView *m_couponTable;
    NSArray *m_validCoupons;
    
    UIButton *m_givebackBtn;
    NSString *m_couponId;
    
    SelectCouponView *m_couponView;
    NSInteger m_nCurrentShow;
}
@end

@implementation PreferentialCouponViewController

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
    [self initSelectCouponView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(customNavBarView)
    {
        [customNavBarView setTitle:STR_SELECT_COUPON];
    }
    
    [self sendMyCouponUrl:0 :1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *方法描述：还车成功
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)givebackSuccessed:(FMNetworkRequest*)request
{
    NSDictionary *dic = request.responseData;
    GivebackViewController *tmpCtrl = [[GivebackViewController alloc] initWithSuccessData:dic];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

/**
 *方法描述：初始化选择优惠券页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initSelectCouponView
{
    m_couponTable = [[UITableView alloc] initWithFrame:FRAME_TABLEVIEW];
    m_couponTable.dataSource = self;
    m_couponTable.delegate = self;
    [m_couponTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:m_couponTable];
    
    m_givebackBtn = [[UIButton alloc] initWithFrame:FRAME_GIVEBACK_BTN];
    [m_givebackBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_givebackBtn setTitle:STR_SEL_AND_COMFIRM_GIVEBACK forState:UIControlStateNormal];
    [m_givebackBtn addTarget:self action:@selector(givebackCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_givebackBtn];
}

/**
 *方法描述：获取适合当前订单的优惠券
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)sendMyCouponUrl:(NSInteger)couponType :(NSInteger)sortType
{
    //couponType ＝＝ 0:有效 1:无效 2:全部
    //sortType == 1 默认排序 2 到期时间排序 3 分类排序
//
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    //我的优惠卷
#if 0
    NSString *userid = [User shareInstance].id;
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getMyCouponWithUserId:userid
                                                                           takeTime:@""
                                                                       givebackTime:@""
                                                                               type:[NSString stringWithFormat:@"%d", couponType]
                                                                           sortType:[NSString stringWithFormat:@"%d",sortType]
                                                                           delegate:self];
    req = nil;
#else
    srvOrderData *curData = [[OrderManager ShareInstance] getCurrentOrderData];
    
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(curData.m_orderId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getSuitableCoupon:orderId delegate:self];
    req = nil;
#endif
}

/**
 *方法描述：带优惠券还车
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)givebackCar
{
    if (m_couponId == nil || [m_couponId length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:STR_PLEASE_SELECT_COUPON delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSLog(@"giveback car with coupon ");
    [[LoadingClass shared] showLoadingForMoreRequest:STR_CACULATING];
    srvOrderData *curData = [[OrderManager ShareInstance] getCurrentOrderData];
    
    NSString *userId = [NSString stringWithFormat:@"%@", GET([User shareInstance].id)];
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(curData.m_orderId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] returnCarWithUid:userId
                                                                       orderId:orderId
                                                                     useCoupon:YES
                                                                      couponId:GET(m_couponId)
                                                                      delegate:self];
    req = nil;
}

-(void)showCouponDetail:(NSDictionary *)dic
{
    m_couponView = [[SelectCouponView alloc] initWithCouponData:dic];
    m_couponView.delegate = self;
    [self.view addSubview:m_couponView];
}

-(void)selNextCoupon
{
    m_nCurrentShow++;
    if (m_nCurrentShow >= [m_validCoupons count]) {
        m_nCurrentShow = 0;
    }
    
//    NSDictionary *dic = [m_validCoupons objectAtIndex:m_nCurrentShow];
//    m_couponView = [[SelectCouponView alloc] initWithCouponData:dic];
//    m_couponId = [dic objectForKey:@"no"];
//    NSLog(@"--- %@ -----", m_couponId);
    [self showCouponViewWithAnimation:NO];
}

-(void)selPreCoupon
{
    m_nCurrentShow--;
    if (m_nCurrentShow < 0) {
        m_nCurrentShow = [m_validCoupons count] - 1;
    }
    
    [self showCouponViewWithAnimation:YES];
//    NSLog(@"--- %@ -----", m_couponId);
}

-(void)viewExit
{
    [m_couponTable reloadData];
}

-(void)showCouponViewWithAnimation:(BOOL)bUp
{
    NSDictionary *dic = [m_validCoupons objectAtIndex:m_nCurrentShow];
    
    [m_couponView setCouponData:dic];
}

#pragma mark - uitableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
//    CouponCell *cell = (CouponCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dic = [m_validCoupons objectAtIndex:indexPath.row];
    m_couponId = [dic objectForKey:@"no"];
    m_nCurrentShow = indexPath.row;
#if 1
    CouponInfoController *couponInfo = [[CouponInfoController alloc] init];
    [self.navigationController pushViewController:couponInfo animated:YES];
    [couponInfo setCouponData:dic];
#else
    if (dic) {
        [self showCouponDetail:dic];
    }
#endif
    
    [m_couponTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [m_validCoupons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COUPON_CELL_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *couponIdentify = @"couponIdentify";
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:couponIdentify];
    if (nil == cell) {
        cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponIdentify];
    }
    [cell setCouponCellData:[m_validCoupons objectAtIndex:indexPath.row] withTag:indexPath.row];
 //   cell.tag = indexPath.row;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic = [m_validCoupons objectAtIndex:indexPath.row];
    
    NSString *couponId = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"no"])];
    cell.m_checkboxBtn.selected = NO;
    if ([couponId isEqualToString:m_couponId]) {
        cell.m_checkboxBtn.selected = YES;
    }
    return cell;
}

/**
 *方法描述：获取到优惠券
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotCoupons:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
//    m_validCoupons = [[NSArray alloc] initWithArray:[dic objectForKey:@"coupon_enable"]];
    m_validCoupons = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"suitableCoupon"]];
  
    [m_couponTable reloadData];
}


/**
 *方法描述：选择优惠券
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)radioSel:(NSString *)sel
{
    NSInteger nSelCoupon = [sel integerValue];
    NSDictionary *dic = [m_validCoupons objectAtIndex:nSelCoupon];
    
    m_couponId = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"no"])];
    NSLog(@"COUPON id = %@", m_couponId);
    [m_couponTable reloadData];
}

#pragma mark - select coupon view delegate
/**
 *方法描述：带优惠券还车
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)givebackWithCouponId:(NSString *)couponId
{
    NSLog(@"givebackWithCouponId %@ ", couponId);
    srvOrderData *curData = [[OrderManager ShareInstance] getCurrentOrderData];

    [[LoadingClass shared] showLoadingForMoreRequest:STR_CACULATING];
    NSString *userId = [NSString stringWithFormat:@"%@", GET([User shareInstance].id)];
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(curData.m_orderId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] returnCarWithUid:userId
                                                                       orderId:orderId
                                                                     useCoupon:YES
                                                                      couponId:GET(couponId)
                                                                      delegate:self];
    req = nil;

}


#pragma mark -http
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
    if ([fmNetworkRequest.requestName isEqual:kRequest_getSuitableCoupon]) {//我的优惠卷
        [self gotCoupons:fmNetworkRequest];
    }
    else if ([kRequest_returnCar isEqualToString:fmNetworkRequest.requestName])
    {// 还车成功
        [self givebackSuccessed:fmNetworkRequest];
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
    
    if([kRequest_returnCar isEqualToString:fmNetworkRequest.requestName])
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_NETWORK_RETRY delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return;
    }
#if 0
    [self showCouponDetail:nil];
#else
    CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alertView needDismisShow];
#endif
}

@end
