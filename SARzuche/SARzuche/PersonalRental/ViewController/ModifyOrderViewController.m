//
//  ModifyOrderViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ModifyOrderViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "PersonalCarInfoView.h"
#import "OrderManager.h"
#import "CarDataManager.h"
#import "BLNetworkManager.h"
#import "ConstImage.h"
#import "BranchDataManager.h"
#import "CustomAlertView.h"
#import "MyAccountChargeViewController.h"
#import "PublicFunction.h"

#define TAG_START_TIME      11001
#define TAG_GIVEBACK_TIME   11002
#define ALERT_VIEW_TAG_PROMPT           11003
#define ALERT_VIEW_TAG_RECHARGE         11004
#define ALERT_VIEW_TAG_CONFIRM          11005

#define FRAME_START_X       30
#define ICON_WIDTH          (30)
#define TIME_WIDTH          (260)
#define INFO_WIDTH          (230)

#define TAKEINFO_ROW_H      30

#define FRAME_TAKE_INFO             CGRectMake(10, controllerViewStartY, 300, 20)
#define FRAME_TAKE_BRANCHE_TITLE    CGRectMake(30, 90, 80, 20)
#define FRAME_TAKE_BRANCHE          CGRectMake(110, 90, 190, 20)
#define FRAME_STRAT_TIME            CGRectMake(FRAME_START_X, 110, TIME_WIDTH, TAKEINFO_ROW_H)
#define FRAME_START_TIME_PROMPT     CGRectMake(FRAME_START_X, 150-8, 260, 20)

#define FRAME_CITY                  CGRectMake(FRAME_START_X, 170, 80, TAKEINFO_ROW_H)
#define FRAME_NETWORK               CGRectMake(110, 170, 300-110, TAKEINFO_ROW_H)

#define FRAME_GIVEBAKC_TIME         CGRectMake(FRAME_START_X, 230, TIME_WIDTH, TAKEINFO_ROW_H)
#define FRAME_END_TIME_PROMPT       CGRectMake(FRAME_START_X, 270- 8, 260, 20)

#define FRAME_MODIFY                CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)
#define FRAME_CAR_INFO              CGRectMake(0, 300, 320, 140)


@interface ModifyOrderViewController ()
{
    UILabel *m_city; // popupbutton!
    UILabel *m_takeBranche;
    UIButton *m_network;
    UIButton *m_startTime;
    UIButton *m_giveBackTime;
    
    UIImage *m_warningIcon;
    UILabel *m_promptInfo1;
    UILabel *m_promptInfo2;
    
    NSString *m_strNetWorkId;
    NSString *m_strTakeTime;
    NSString *m_strGivebackTime;
    
    PersonalCarInfoView *m_carInfo;
    
    UIButton *m_modifyBtn;
    BOOL m_isStartTimeSelected;
    
    // update order
    NSString *m_addDeposit;
    NSString *m_deposit;
    NSString *m_dispatchDeposit;
    NSString *m_mileageDeposit;
    NSString *m_timeDeposit;
    NSString *m_usefull;
}

@end

@implementation ModifyOrderViewController
@synthesize delegate;

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
    [self initModifyView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_ORDER_MODIFY_TITLE];
    }
    
}

// 初始化修改界面
-(void)initModifyView
{
    // 当前订单数据
    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    m_strNetWorkId = [NSString stringWithFormat:@"%@", tmpOrderData.m_backNet];
    if (nil == tmpOrderData) {
        return;
    }
    UILabel *takeInfo = [[UILabel alloc] initWithFrame:FRAME_TAKE_INFO];
    takeInfo.text = STR_TAKE_INFO;
    [self.view addSubview:takeInfo];
    
    UILabel *labelTake = [[UILabel alloc] initWithFrame:FRAME_TAKE_BRANCHE_TITLE];
    labelTake.textColor = [UIColor blackColor];
    labelTake.text = STR_TAKE_BRANCHES;
    [self.view addSubview:labelTake];
    // 取车网点
    BrancheData *tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:YES];
    m_takeBranche = [[UILabel alloc] initWithFrame:FRAME_TAKE_BRANCHE];
    m_takeBranche.text = tmpData.m_name;//tmpOrderData.m_takeNetName;
    m_takeBranche.textColor = COLOR_LABEL;
    [self.view addSubview:m_takeBranche];
    // 取车时间
    NSString *takeTime = [[PublicFunction ShareInstance] getYMDHMString:tmpOrderData.m_effectTime];
    m_startTime = [[UIButton alloc] initWithFrame:FRAME_STRAT_TIME];
    m_startTime.tag = TAG_START_TIME;
    [m_startTime setTitle:takeTime forState:UIControlStateNormal];
    [m_startTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [m_startTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [m_startTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_startTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    m_startTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:m_startTime];
    m_strTakeTime = [NSString stringWithFormat:@"%@", takeTime];
    
    //提示信息
    m_promptInfo1 = [[UILabel alloc] initWithFrame:FRAME_START_TIME_PROMPT];
    m_promptInfo1.text = STR_AHEAD_OF_TAKETIME;
    m_promptInfo1.textColor = [UIColor redColor];
    m_promptInfo1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:m_promptInfo1];
    // 城市
    m_city = [[UILabel alloc] initWithFrame:FRAME_CITY];
    m_city.textColor = [UIColor blackColor];
    m_city.text = STR_NANJING;
    m_city.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_city];
    
    // 还车网点
    tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:NO];
    m_network = [[UIButton alloc] initWithFrame:FRAME_NETWORK];
    [m_network setTitle:tmpData.m_name/*tmpOrderData.m_backNetName*/ forState:UIControlStateNormal];
    [m_network addTarget:self action:@selector(selectNetwork) forControlEvents:UIControlEventTouchUpInside];
    [m_network setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [m_network setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_network setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    m_network.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:m_network];
#if 0
    UILabel *labelReturn = [[UILabel alloc] initWithFrame:FRAME_RETURN_LABEL];
    labelReturn.textColor = [UIColor blackColor];
    labelReturn.text = STR_GIVEBACK_INFO;
    [self.view addSubview:labelReturn];
#endif
    // 还车时间
    NSString *backTime = [[PublicFunction ShareInstance] getYMDHMString:tmpOrderData.m_returnTime];
    m_giveBackTime = [[UIButton alloc] initWithFrame:FRAME_GIVEBAKC_TIME];
    m_giveBackTime.tag = TAG_GIVEBACK_TIME;
    [m_giveBackTime setTitle:backTime forState:UIControlStateNormal];
    [m_giveBackTime setTitleColor:COLOR_LABEL forState:UIControlStateNormal];
    [m_giveBackTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [m_giveBackTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_giveBackTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    m_giveBackTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:m_giveBackTime];
    m_strGivebackTime = [NSString stringWithFormat:@"%@", backTime];
    
    m_promptInfo2 = [[UILabel alloc] initWithFrame:FRAME_END_TIME_PROMPT];
    m_promptInfo2.text = STR_BEHIND_OF_GIVEBACK;
    m_promptInfo2.textColor = [UIColor redColor];
    m_promptInfo2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:m_promptInfo2];

    // 车辆信息
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CAR_INFO forUsed:forSelectCar];
    [self updateCarInfo:m_carInfo];
    [self.view addSubview:m_carInfo];
    
    // 修改按钮
    m_modifyBtn = [[UIButton alloc] initWithFrame:FRAME_MODIFY];
    [m_modifyBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_modifyBtn setTitle:STR_CONFIRM_MODIFY forState:UIControlStateNormal];
    [m_modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_modifyBtn addTarget:self action:@selector(ModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_modifyBtn];
}

// 更新车辆信息
-(void)updateCarInfo:(PersonalCarInfoView *)carView
{
    SelectedCar *curCar = [[CarDataManager shareInstance] getSelCar];
    if (nil != curCar) {
        [carView setselectCarWithUnitPrice:curCar.m_unitPrice dayPrice:curCar.m_dayPrice carModel:curCar.m_model carSerie:curCar.m_carseries carPlate:curCar.m_plateNum discount:curCar.m_discount imageUrl:curCar.m_carFile];
    }
}

// 选择时间
-(void)selectTime:(id)sender
{
    NSLog(@"select time");
    UIButton *tmpBtn = (UIButton *)sender;
    switch (tmpBtn.tag) {
        case TAG_START_TIME:
        {
            NSLog(@"to set start time");
            NSDate *startDate = [NSDate date];
            DateSelectView *tmpDatePicker = [[DateSelectView alloc] initWithFrame:FRAME_DATE_SELECT_VIEW StartDate:startDate];
            tmpDatePicker.delegate = self;
            m_isStartTimeSelected = YES;
            [self.view addSubview:tmpDatePicker];
        }
            break;
        case TAG_GIVEBACK_TIME:
        {
            NSLog(@"to set give up time");
            NSDate *startDate = [NSDate date];
            DateSelectView *tmpDatePicker = [[DateSelectView alloc] initWithFrame:FRAME_DATE_SELECT_VIEW StartDate:startDate];
            [tmpDatePicker setTitle:STR_GIVE_BACK_TIME];
            tmpDatePicker.delegate = self;
            m_isStartTimeSelected = NO;
            [self.view addSubview:tmpDatePicker];
        }
            break;
        default:
            break;
    }

}
// 选择网点
-(void)selectNetwork
{
    NSLog(@"select network");
    BranchesViewController *tmpBranchesController = [[BranchesViewController alloc] initWithNibName:nil bundle:nil];
    tmpBranchesController.enterType = BranchesViewFromPersonalRetal;
    tmpBranchesController.delegate = self;
    [self.navigationController pushViewController:tmpBranchesController animated:YES];
    tmpBranchesController = nil;
}
// 修改
-(void)ModifyBtn
{
    NSLog(@"modify btn");

    [self modifyOrder];
}

// 选择时间返回
-(void)selectString:(NSString *)str
{
    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    if (nil == str) {
        m_isStartTimeSelected = NO;
        return;
    }
    
    if (m_isStartTimeSelected) {
//        NSString *tmpReturnTime = [[PublicFunction ShareInstance] getYMDHMString:tmpOrderData.m_returnTime];
        
        if ([[PublicFunction ShareInstance] checkTimeForModifyOrder:tmpOrderData takeTime:str givebackTime:m_strGivebackTime isTake:YES])
        {
            [m_startTime setTitle:str forState:UIControlStateNormal];
            m_strTakeTime = [NSString stringWithFormat:@"%@", str];
        }
    }
    else
    {
        if ([[PublicFunction ShareInstance] checkTimeForModifyOrder:tmpOrderData takeTime:m_strTakeTime givebackTime:str isTake:NO]) {
            [m_giveBackTime setTitle:str forState:UIControlStateNormal];
            m_strGivebackTime = [NSString stringWithFormat:@"%@", str];
        }
    }
}

// 选择网点返回
-(void)selBrancheFromController:(NSDictionary *)brancheData
{
    NSString *brancheName = [brancheData objectForKey:@"name"];
    [m_network setTitle:brancheName forState:UIControlStateNormal];
//    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
//    tmpOrderData.m_backNet = brancheId;
//    tmpOrderData.m_backNetName = brancheName;
    m_strNetWorkId =[brancheData objectForKey:@"id"];
}

// 修改订单信息返回
/*
 addDeposit = 0;
 deposit = "2019.25";
 dispatchDeposit = 0;
 mileageDeposit = "0.00";
 timeDeposit = "59.25";
 usefull = "997980.75";
 */
-(void)getUpdateOrderData:(FMNetworkRequest *)request
{
    BOOL bNeedCharge = NO;
    NSDictionary *dic = request.responseData;
    
    m_addDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"addDeposit"]];
    m_deposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"deposit"]];
    m_dispatchDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"dispatchDeposit"]];
    m_mileageDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"mileageDeposit"]];
    m_timeDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"timeDeposit"]];
    m_usefull = [NSString stringWithFormat:@"%@", [dic objectForKey:@"usefull"]];
    
    if ([m_addDeposit floatValue] > [m_usefull floatValue])
    {
        bNeedCharge = YES;
    }
    
    NSString *strConfirm = [NSString stringWithFormat:STR_MODIFY_CONFIRM_INFO, GET(m_addDeposit), GET(m_usefull)];

    if (bNeedCharge) {
        strConfirm = [NSString stringWithFormat:STR_RECHARGE_CONFIRM, GET(m_addDeposit), GET(m_usefull)];
    }
    UIAlertView *rechargeAlert = [[UIAlertView alloc] initWithTitle:nil message:strConfirm delegate:self cancelButtonTitle:STR_CANCEL otherButtonTitles:STR_OK, nil];
    rechargeAlert.tag = ALERT_VIEW_TAG_CONFIRM;
    if (bNeedCharge) {
        rechargeAlert.tag = ALERT_VIEW_TAG_RECHARGE;
    }
    [rechargeAlert show];
}
#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index  = %d" , buttonIndex);
    
    if (alertView.tag == 1000) {
        if (delegate && [delegate respondsToSelector:@selector(backToPrePage:)]) {
            [delegate backToPrePage:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            if (alertView.tag == ALERT_VIEW_TAG_CONFIRM)
            {
                [self submitModified];
            }
            else if(ALERT_VIEW_TAG_RECHARGE == alertView.tag)
            {
                [self toRecharge];
            }
                
            break;
        default:
            break;
    }
    
}


#pragma mark - request
// 修改订单请求
-(void)modifyOrder
{
    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    
//    NSString *givebackBranchId = [NSString stringWithFormat:@"%@", m_backNetId];
    NSString *takeTime = [NSString stringWithFormat:@"%@:00", m_startTime.titleLabel.text ];
    NSString *givebackTime = [NSString stringWithFormat:@"%@:00", m_giveBackTime.titleLabel.text];

    FMNetworkRequest *req = [[BLNetworkManager shareInstance] updateOrder:tmpOrderData.m_orderId backNet:m_strNetWorkId startTime:takeTime endTime:givebackTime delegate:self];
    
    req = nil;
}

// 充值
-(void)toRecharge
{
    MyAccountChargeViewController *detail =[[MyAccountChargeViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}
// 提交修改
-(void)submitModified
{
    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    
//    NSString *givebackBranchId = [NSString stringWithFormat:@"%@", m_backNetId];
    NSString *takeTime = [NSString stringWithFormat:@"%@:00", m_startTime.titleLabel.text ];
    NSString *givebackTime = [NSString stringWithFormat:@"%@:00", m_giveBackTime.titleLabel.text];
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] modifyOrderWithOrderId:tmpOrderData.m_orderId backNet:m_strNetWorkId startTime:takeTime endTime:givebackTime deposit:GET(m_deposit) addDeposit:GET(m_addDeposit) timeDeposit:GET(m_timeDeposit) mileageDeposit:GET(m_mileageDeposit) dispatchDeposit:GET(m_dispatchDeposit) delegate:self];
    
    req = nil;
}

#pragma mark - http
// 请求成功
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([kRequest_updateOrder isEqualToString:fmNetworkRequest.requestName])
    {
        [self getUpdateOrderData:fmNetworkRequest];
#if 0
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"" delegate:self cancelButtonTitle:STR_CANCEL otherButtonTitles:STR_OK, nil];
        alert.tag = ALERT_VIEW_TAG_CONFIRM;
        [alert show];
#endif
    }
    else if([kRequest_changeOrder isEqualToString:fmNetworkRequest.requestName])
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MODIFY_SUCCESS delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        alert.tag = 1000;
        [alert show];
    }
}

// 请求失败
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    NSLog(@"request failed");
    if ([kRequest_updateOrder isEqualToString:fmNetworkRequest.requestName])
    {
    }
    else if([kRequest_changeOrder isEqualToString:fmNetworkRequest.requestName])
    {
    }
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alert needDismisShow];
}

@end
