//
//  ConfirmOrderViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-26.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ConfirmOrderViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "BLNetworkManager.h"
#import "OrderManager.h"
#import "BLNetworkManager.h"
#import "CarDataManager.h"
#import "PriceDetailsViewController.h"
#import "User.h"
#import "LoadingClass.h"
#import "ConstImage.h"
#import "MyAccount.h"
#import "BranchesMapViewController.h"
#import "BranchDataManager.h"
#import "NextHelpViewController.h"
#import "CustomAlertView.h"
#import "MyAccountChargeViewController.h"
#import "PublicFunction.h"

#define HEIGHT_ROW_LABEL        25
#define SIDE_GAP                10

#define FRAME_SCROLL_VIEW       CGRectMake(0, controllerViewStartY, MainScreenWidth,MainScreenHeight - controllerViewStartY - bottomButtonHeight)


#define FRAME_USECAR_LABEL      CGRectMake(SIDE_GAP, 0, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_CARINFO_VIEW      CGRectMake(0, HEIGHT_ROW_LABEL, MainScreenWidth, 140)
#define FRAME_USEINFO_VIEW      CGRectMake(0, 200,MainScreenWidth, 140)

// COST DETAIL
#define FRAME_COST_DETAIL           CGRectMake(SIDE_GAP, 0, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_DURATION_COST         CGRectMake(SIDE_GAP, HEIGHT_ROW_LABEL, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_MILEAGE_COST          CGRectMake(SIDE_GAP, HEIGHT_ROW_LABEL*2, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_SCHEDULING_COST       CGRectMake(SIDE_GAP, HEIGHT_ROW_LABEL*3, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_DEPOSIT               CGRectMake(SIDE_GAP, HEIGHT_ROW_LABEL*4, MainScreenWidth-SIDE_GAP*2, HEIGHT_ROW_LABEL)
#define FRAME_PREPAY                CGRectMake(SIDE_GAP, HEIGHT_ROW_LABEL *5 + 10, MainScreenWidth-140, HEIGHT_ROW_LABEL)

#define FRAME_PRICE_DISCRIPTION     CGRectMake(MainScreenWidth-140 + SIDE_GAP*2 - 20, HEIGHT_ROW_LABEL *5 +10, 140, HEIGHT_ROW_LABEL)


#define FRAME_BOTTOM_BUTTON         CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)

#define TAG_RECHARGE            10005

@interface ConfirmOrderViewController ()
{
    UIScrollView *m_scrollView;
    NSInteger m_curHeight;
    
    UILabel* m_useCarLabel;
    PersonalCarInfoView *m_carInfo;
    PersonalCarInfoView *m_userInfo;
    
    UIView *m_costInfo;
    UILabel *m_costDetail;
    UILabel *m_duration;
    UILabel *m_mileage;
    UILabel *m_scheduling;
    UILabel *m_deposit;
    UILabel *m_prepay;
    
    UIButton *m_priceDiscription;
    UIButton *m_submitBtn;
    
    UserSelectCarCondition *m_selectCondition;
    SelectedCar *m_selCar;
    MyAccount *m_myAccount;
    
    NSDictionary *m_estimateDic;
    NSString *m_mileageDeposit;
    NSString *m_timeDeposit;
    NSString *m_peccancyDeposit;
    NSString *m_dispatchDeposit;
    NSString *m_damageDeposit;
    NSString *m_depositTotal;
    NSString *m_mileageunit;//里程单价
    NSString *m_lateunit;// 延时单价
}

@end

@implementation ConfirmOrderViewController

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
    
    [self initData];
    
    [self estimateCost];
    
    [self initComfirmOrderView];
    
//    [self getMyAccount];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateAccount) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)needUpdateAccount
{
    [self getMyAccount];
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
        [customNavBarView setTitle:STR_CONFIRM_ORDER];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        [helpBtn setImage:[UIImage imageNamed:IMG_HELP] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
        //        [self showShortMenuBtn:YES];
//        [[PublicFunction ShareInstance] showShortMenu:self];
    }
    
    [self getMyAccount];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)shortMenuPressed:(id)sender
{
    NSLog(@"SHORT MENU");
    [super shortMenuPressed:sender];
    
}
// 初始化用户和车辆信息
-(void)initData
{
    m_selectCondition = [[OrderManager ShareInstance] getCurSelectCarConditon];
    m_selCar = [[CarDataManager shareInstance] getSelCar];
}
// 帮助按钮
-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    [next setTitle:STR_SETTLEMENT];
    NSString *type = [NSString stringWithFormat:@"help%d",5];
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}

// 初始化用户信息View
-(void)initUserInfo
{
    
    CGRect tmpRect = m_carInfo.frame;
    tmpRect.origin.y = m_carInfo.frame.origin.y + m_carInfo.frame.size.height + 10;
    tmpRect.size.height = HEIGHT_ROW_LABEL;
    UIView *tmpView = [[UIView alloc] initWithFrame:tmpRect];
    tmpView.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:tmpView];
    
    tmpRect.origin.x += 10;
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpLabel.text = STR_TAKE_GIVEBACK_CAR;
    tmpLabel.textColor = [UIColor blackColor];
    tmpLabel.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:tmpLabel];
    m_curHeight += tmpLabel.frame.size.height + 10;
    
    UIImageView *tmpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPARATOR]];
    tmpRect = tmpImgView.frame;
    tmpRect.origin.y = tmpLabel.frame.origin.y + tmpLabel.frame.size.height;
    tmpRect.origin.x = tmpLabel.frame.origin.x;
    tmpRect.size.width = tmpLabel.frame.size.width;
    tmpImgView.frame = tmpRect;
    [m_scrollView addSubview:tmpImgView];
    m_curHeight+=tmpImgView.frame.size.height;
    
    tmpRect.origin.x -= 10;
    tmpRect.origin.y = tmpImgView.frame.origin.y + tmpImgView.frame.size.height;
    tmpRect.size.height  =  200;
    m_userInfo = [[PersonalCarInfoView alloc] initWithFrame:tmpRect forUsed:forUserInfo];
    m_userInfo.delegate = self;
    [m_userInfo setSelectConditionWithBranche:m_selectCondition.m_takeBranche takeTime:m_selectCondition.m_takeTime backBranche:m_selectCondition.m_givebackBranche backTime:m_selectCondition.m_givebackTime];
    m_userInfo.backgroundColor =[UIColor whiteColor];
    [m_scrollView addSubview:m_userInfo];
    m_curHeight += m_userInfo.frame.size.height;
    UIButton *givebtn = (UIButton *)[m_userInfo viewWithTag:10000];
    givebtn.hidden = YES;
    UIButton *Backbtn = (UIButton *)[m_userInfo viewWithTag:10001];
    Backbtn.hidden = YES;

}

// 初始化相关费用view
-(void)initCostInfo
{
    CGRect tmpRect = m_userInfo.frame;
    tmpRect.origin.y = m_userInfo.frame.origin.y + m_userInfo.frame.size.height + 10;
    m_costInfo = [[UIView alloc] initWithFrame:tmpRect];
    tmpRect.size.height = 0;
    
    m_costDetail = [[UILabel alloc] initWithFrame:FRAME_COST_DETAIL];
    m_costDetail.textColor = COLOR_LABEL_GRAY;
    m_costDetail.text = STR_COST_DETAILS;
    [m_costInfo addSubview:m_costDetail];
    tmpRect.size.height += m_costDetail.frame.size.height;
    
    
    UIImageView *tmpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPARATOR]];
    CGRect imgRect = tmpImgView.frame;
    imgRect.origin.y = m_costDetail.frame.origin.y + m_costDetail.frame.size.height;
    imgRect.origin.x = m_costDetail.frame.origin.x;
    imgRect.size.width = m_costDetail.frame.size.width;
    tmpImgView.frame = imgRect;
    [m_costInfo addSubview:tmpImgView];
    tmpRect.size.height += imgRect.size.height;

    m_duration = [[UILabel alloc] initWithFrame:FRAME_DURATION_COST];
    m_duration.textColor = COLOR_LABEL_GRAY;
    m_duration.font = FONT_LABEL;
    m_duration.text = STR_FORCAST_DURATION;
    [m_costInfo addSubview:m_duration];
    tmpRect.size.height += m_duration.frame.size.height;
    
    m_mileage = [[UILabel alloc] initWithFrame:FRAME_MILEAGE_COST];
    m_mileage.textColor = COLOR_LABEL_GRAY;
    m_mileage.font = FONT_LABEL;
    m_mileage.text = STR_FORCAST_MILEAGE;
    [m_costInfo addSubview:m_mileage];
    tmpRect.size.height += m_mileage.frame.size.height;
    
    m_scheduling = [[UILabel alloc] initWithFrame:FRAME_SCHEDULING_COST];
    m_scheduling.textColor = COLOR_LABEL_GRAY;
    m_scheduling.font = FONT_LABEL;
    m_scheduling.text = STR_FORCAST_SCHEDULING;
    [m_costInfo addSubview:m_scheduling];
    tmpRect.size.height += m_scheduling.frame.size.height;
    
    m_deposit = [[UILabel alloc] initWithFrame:FRAME_DEPOSIT];
    m_deposit.textColor = COLOR_LABEL_GRAY;
    m_deposit.font = FONT_LABEL;
    m_deposit.text = STR_DEPOSIT;
    [m_costInfo addSubview:m_deposit];
    tmpRect.size.height += m_deposit.frame.size.height;
    
    CGRect gap = CGRectMake(0, HEIGHT_ROW_LABEL *5, MainScreenWidth, 10);
    UIView *gapView= [[UIView alloc] initWithFrame:gap];
    gapView.backgroundColor = COLOR_BACKGROUND;
    [m_costInfo addSubview:gapView];
    tmpRect.size.height += 10;
    
    m_prepay = [[UILabel alloc] initWithFrame:FRAME_PREPAY];
    m_prepay.textColor = COLOR_LABEL_GRAY;
    m_prepay.text = STR_ORDER_PREPAY;
    [m_costInfo addSubview:m_prepay];
    tmpRect.size.height += m_prepay.frame.size.height;
    m_costInfo.frame = tmpRect;
    
    m_priceDiscription = [[UIButton alloc] initWithFrame:FRAME_PRICE_DISCRIPTION];
    [m_priceDiscription setTitle:STR_CAR_PRICE_DECLARE forState:UIControlStateNormal];
    [m_priceDiscription setTitleColor:COLOR_LABEL forState:UIControlStateNormal];
    [m_priceDiscription addTarget:self action:@selector(priceDetail) forControlEvents:UIControlEventTouchUpInside];
    [m_costInfo addSubview:m_priceDiscription];
    
    m_costInfo.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_costInfo];
    m_curHeight += m_costInfo.frame.size.height;
}

// 初始化确认订单界面
-(void)initComfirmOrderView
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    m_scrollView.backgroundColor = [UIColor clearColor];
    
    m_useCarLabel = [[UILabel alloc] initWithFrame:FRAME_USECAR_LABEL];
    m_useCarLabel.text = STR_SEL_CONDITION;
    m_useCarLabel.textColor = [UIColor blackColor];
    [m_scrollView addSubview:m_useCarLabel];
    m_curHeight += m_useCarLabel.frame.size.height;
    
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CARINFO_VIEW forUsed:forSelectCar];
    [m_carInfo setselectCarWithUnitPrice:m_selCar.m_unitPrice
                                dayPrice:m_selCar.m_dayPrice
                                carModel:m_selCar.m_model
                                carSerie:m_selCar.m_carseries
                                carPlate:m_selCar.m_plateNum
                                discount:m_selCar.m_discount
                                imageUrl:m_selCar.m_carFile];
    [m_scrollView addSubview:m_carInfo];
    m_curHeight += m_carInfo.frame.size.height;
    
    [self initUserInfo];
    
    [self initCostInfo];
    
    [m_scrollView setContentSize:CGSizeMake(0, m_curHeight + 10)];
    [self.view addSubview:m_scrollView];
    
    m_submitBtn = [[UIButton alloc] initWithFrame:FRAME_BOTTOM_BUTTON];
    [m_submitBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_submitBtn addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_submitBtn setTitle:STR_SUBMIT_ORDER forState:UIControlStateNormal];
    [self.view addSubview:m_submitBtn];
    
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

// 提交订单
-(void)submitBtn
{
    NSLog(@"SUBMIT ORDER");
    CGFloat deposit = [m_depositTotal floatValue];
    CGFloat usefull = [m_myAccount.usefull floatValue];
    if (deposit > usefull) {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_NEED_MORE_CASH delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:STR_TO_RECHARGE, nil];
        tmpAlert.tag = TAG_RECHARGE;
        [tmpAlert show];
        return;
    }
    
    NSString *userId = [NSString stringWithFormat:@"%@",GET([User shareInstance].id)];
    NSString *carId = [NSString stringWithFormat:@"%@", GET([[CarDataManager shareInstance] getSelCar].m_carId)];
    NSString *takebranchId = [NSString stringWithFormat:@"%@", [[OrderManager ShareInstance] getCurSelectCarConditon].m_takeBrancheId];
    NSString *givebackBranchId = [NSString stringWithFormat:@"%@", [[OrderManager ShareInstance] getCurSelectCarConditon].m_givebackBrancheId];
    NSString *takeTime = [NSString stringWithFormat:@"%@:00", [[OrderManager ShareInstance] getCurSelectCarConditon].m_takeTime];
    NSString *givebackTime = [NSString stringWithFormat:@"%@:00", [[OrderManager ShareInstance] getCurSelectCarConditon].m_givebackTime];
    if ([[PublicFunction ShareInstance] isLaterThanCurrentTime:takeTime])
    {
#if 0
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_CHECK_CURRENT_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        tmpAlert.tag = 10001;
        [tmpAlert show];
#endif
        return;
    }

    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] submitOrder:userId
                                                                      car:carId
                                                              getBranchId:takebranchId
                                                           returnBranchId:givebackBranchId
                                                                    start:takeTime
                                                                      end:givebackTime
                                                           mileageDeposit:GET(m_mileageDeposit)
                                                              timeDeposit:GET(m_timeDeposit)
                                                            damageDeposit:GET(m_damageDeposit)
                                                          peccancyDeposit:GET(m_peccancyDeposit)
                                                          dispatchDeposit:GET(m_dispatchDeposit)
                                                                  deposit:GET(m_depositTotal)
                                                              mileageunit:GET(m_mileageunit)
                                                                 lateunit:GET(m_lateunit)
                                                                 delegate:self];
    req = nil;
}

// 预估订单费用
-(void)estimateCost
{
    if ((m_selectCondition.m_takeTime == nil || [m_selectCondition.m_takeTime length] == 0)
        || (m_selectCondition.m_givebackTime == nil || [m_selectCondition.m_givebackTime length] == 0))
    {
        return;
    }
    NSString *takeTime = [NSString stringWithFormat:@"%@:00", GET(m_selectCondition.m_takeTime)];
    NSString *givebackTime = [NSString stringWithFormat:@"%@:00", GET(m_selectCondition.m_givebackTime)];

    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] evaluateOrderWithCarId:m_selCar.m_carId getBranch:m_selectCondition.m_takeBrancheId returnBranch:m_selectCondition.m_givebackBrancheId start:takeTime end:givebackTime delegate:self];
    req = nil;
}

// 价格详情
-(void)priceDetail
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    PriceDetailsViewController *tmpCtrl = [[PriceDetailsViewController alloc] init];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}
// 我的账号请求
-(void)getMyAccount
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getMyAccountMessageWithUserId:[User shareInstance].id delegate:self];
    request = nil;
}
// 我的账号信息返回
-(void)gotMyAccount:(FMNetworkRequest *)request
{
    m_myAccount = request.responseData;
}
// 订单预估数据返回更新
-(void)updateDepositData:(NSDictionary *)responseData
{
    NSString *strTmp = nil;
    m_estimateDic = [[NSDictionary alloc] initWithDictionary:responseData];
    
    NSString *strMileageDeposit = [responseData objectForKey:@"mileageDeposit"];
    NSString *strTimeDeposit = [responseData objectForKey:@"timeDeposit"];
    NSString *strpeccancyDeposit = [responseData objectForKey:@"peccancyDeposit"];
    NSString *strDispatchDeposit = [responseData objectForKey:@"dispatchDeposit"];
    NSString *strDamageDeposit = [responseData objectForKey:@"damageDeposit"];

    m_mileageunit = [NSString stringWithFormat:@"%@", [responseData objectForKey:@"mileageunit"]];
    m_lateunit = [NSString stringWithFormat:@"%@", [responseData objectForKey:@"lateunit"]];
    
    CGFloat mileage = [strMileageDeposit floatValue];
    CGFloat time = [strTimeDeposit floatValue];
    CGFloat peccancy = [strpeccancyDeposit floatValue];
    CGFloat dispatch = [strDispatchDeposit floatValue];
    CGFloat damage = [strDamageDeposit floatValue];
    CGFloat deposit = damage + peccancy;
    CGFloat prepay = mileage + time + peccancy + dispatch + damage;
#if 0
    m_mileageDeposit = [NSString stringWithFormat:STR_COST_FORMAT, strMileageDeposit];
    m_timeDeposit = [NSString stringWithFormat:STR_COST_FORMAT, strTimeDeposit];
    m_peccancyDeposit = [NSString stringWithFormat:STR_COST_FORMAT, strpeccancyDeposit];
    m_dispatchDeposit = [NSString stringWithFormat:STR_COST_FORMAT, strDispatchDeposit];
    m_damageDeposit = [NSString stringWithFormat:STR_COST_FORMAT, strDamageDeposit];
#else
    m_mileageDeposit = [NSString stringWithFormat:@"%@", strMileageDeposit];
    m_timeDeposit = [NSString stringWithFormat:@"%@", strTimeDeposit];
    m_peccancyDeposit = [NSString stringWithFormat:@"%@", strpeccancyDeposit];
    m_dispatchDeposit = [NSString stringWithFormat:@"%@", strDispatchDeposit];
    m_damageDeposit = [NSString stringWithFormat:@"%@", strDamageDeposit];
#endif
    m_depositTotal = [NSString stringWithFormat:@"%.2f", prepay];

    m_mileage.text = [NSString stringWithFormat:@"%@    ", STR_FORCAST_MILEAGE];
    strTmp = [[PublicFunction ShareInstance]checkAndFormatMoeny:m_mileageDeposit];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_mileage withString:[NSString stringWithFormat:STR_COST_FORMAT, strTmp] withColor:COLOR_LABEL];
    m_duration.text = [NSString stringWithFormat:@"%@    ", STR_FORCAST_DURATION];
    strTmp = [[PublicFunction ShareInstance] checkAndFormatMoeny:m_timeDeposit];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_duration withString:[NSString stringWithFormat:STR_COST_FORMAT, strTmp] withColor:COLOR_LABEL];
    NSString *strDeposit = [NSString stringWithFormat:@"%.2f", deposit];
    NSString *depositPrice = [NSString stringWithFormat:STR_COST_FORMAT, strDeposit];
    m_deposit.text = [NSString stringWithFormat:@"%@    ", STR_DEPOSIT];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_deposit withString:depositPrice withColor:COLOR_LABEL];
    m_scheduling.text = [NSString stringWithFormat:@"%@     ", STR_FORCAST_SCHEDULING];
    strTmp = [[PublicFunction ShareInstance]checkAndFormatMoeny:m_dispatchDeposit];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_scheduling withString:[NSString stringWithFormat:STR_COST_FORMAT, strTmp] withColor:COLOR_LABEL];
    m_prepay.text = [NSString stringWithFormat:@"%@    ", STR_ORDER_PREPAY];
    NSString *tmpStr = [NSString stringWithFormat:STR_COST_FORMAT, m_depositTotal];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_prepay withString:tmpStr withColor:COLOR_LABEL_BLUE];

    [self.view setNeedsDisplay];
}

// 充值
-(void)toRecharge
{
    MyAccountChargeViewController *detail =[[MyAccountChargeViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}
//
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"NEED JUMP TO ORDER");
    if (10000 == alertView.tag) {
        [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_myorder];        
    }
    
    if (TAG_RECHARGE == alertView.tag && buttonIndex == 1) {
        [self toRecharge];
    }
}


#pragma mark - http
// 请求成功
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_evaluateOrder])
    {
        [self updateDepositData:fmNetworkRequest.responseData];
    }
    else if([KRequest_getMyAccountMessage isEqualToString:fmNetworkRequest.requestName])
    {
        [self gotMyAccount:fmNetworkRequest];
    }
    else if ([kRequest_submitOrder isEqualToString:fmNetworkRequest.requestName])
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_SUBMIT_SUCCESS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        tmpAlert.tag = 10000;
        [tmpAlert needDismisShow];
    }
}

// 请求失败
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];

    [tmpAlert show];
}

@end
