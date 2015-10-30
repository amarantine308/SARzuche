//
//  RenewOrderViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RenewOrderViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "PersonalCarInfoView.h"
#import "CarTimeTableView.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "OrderManager.h"
#import "CarDataManager.h"
#import "LoadingClass.h"
#import "MyAccount.h"
#import "ConstImage.h"
#import "PublicFunction.h"
#import "CustomAlertView.h"
#import "MyAccountChargeViewController.h"

#define TAG_RECHARGE            10001
#define TAG_RENEW_CONFORM       10002
#define TAG_RENEW_SUCCESS       10013

#define HEIGHT_ROW_LABEL           20
#define HEIGHT_RENEW_CONTROLLER     40
#define WIDTH_RENEW_CONTROLLER      40
#define WIDTH_RENEW_FIELD           65

#define TITLE_START_X               10
#define CONTENT_START_X             140
#define CONTENT_W                   150

#define FRAME_CAR_INFO      CGRectMake(0, 0, 320, 140)
#define FRAME_CUSTOM_DRAW_VIEW      CGRectMake(0, 140, 320, 150)
#define FRAME_ORDER_GIVEBACK        CGRectMake(TITLE_START_X, 290, 300, HEIGHT_ROW_HEIGHT)
#define FRAME_MAX_RENEW_TIME        CGRectMake(TITLE_START_X, 310, 300, HEIGHT_ROW_HEIGHT)
#define FRAME_RENEW_DURATION        CGRectMake(TITLE_START_X, 340, 100, HEIGHT_ROW_HEIGHT)
#define FRAME_RENEW_CONTROLLER      CGRectMake(CONTENT_START_X, 330, 160, HEIGHT_RENEW_CONTROLLER)
#define FRAME_RENEW_DEPOSIT         CGRectMake(TITLE_START_X, 370, 150, HEIGHT_ROW_HEIGHT)
#define FRAME_RENEW_BALANCE         CGRectMake(160,370, 150, HEIGHT_ROW_HEIGHT)


#define FRAME_SCROLLVIEW            CGRectMake(0, controllerViewStartY,MainScreenWidth, MainScreenHeight - bottomButtonHeight - controllerViewStartY)

#define FRAME_RENEW_BTN             CGRectMake(0, MainScreenHeight - bottomButtonHeight, 320, bottomButtonHeight)

#define  IMG_DURATION_SUB   @"duration_sub.png"
#define  IMG_DURATION_ADD   @"duration_add.png"
#define  IMG_DURATION_UNSEL @"duration_unsel.png"
#define  IMG_DURATION_INPUT @"duration_input.png"
#define  IMG_DURATION_SEL   @"duration_sel.png"


@implementation UIScrollView (UITouchEvent)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end

@interface RenewOrderViewController ()
{
    PersonalCarInfoView *m_carInfo;
    CarTimeTableView *m_customDraw;
    
    UILabel *m_orderGivebackTime;
    UILabel *m_maxRenewDuration;
    UILabel *m_renewDuration;
    UILabel *m_renewDeposit;
    UILabel *m_balance;

    UITextField *m_numTextField;
    NSInteger m_time;
    
    UIButton *m_renewBtn;
    NSInteger m_maxRenew;
    NSString *m_strMax;
    
    UIButton *m_subBtn;
    UIButton *m_addBtn;
    UIScrollView *m_scrollView;
    
    SelectedCar *m_curCar;
    NSArray *m_checking1;
    NSArray *m_checking2;
    NSArray *m_checking3;
    NSArray *m_using1;
    NSArray *m_using2;
    NSArray *m_using3;
    
    NSInteger m_nRequeCount;
    CGFloat m_totalDeposit;
    NSString *m_kiloDeposit;
    NSString *m_timeDeposit;
    
    MyAccount *m_myAccount;
    CGRect m_constantFrame;
    
    NSString *m_startTime;
    NSString *m_endTime;
    NSString *m_usefull;
    
    FMNetworkRequest *m_renewReq;
}

@end

@implementation RenewOrderViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_constantFrame = self.view.frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self fullinfo];
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
        [customNavBarView setTitle:STR_ORDER_CONTINUE_TITLE];
    }
    [self getMyAccount];
    //[self fullinfo];

}
/**
 *方法描述：获取当前车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initData
{
    m_curCar = [[CarDataManager shareInstance] getSelCar];
}

/**
 *方法描述：获取车辆相关信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fullinfo
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *uid = [User shareInstance].id;
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getRenewFullInfoWithUid:uid carId:m_curCar.m_carId delegate:self];
    req = nil;
}

/**
 *方法描述：计算车辆可续订时间
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getRenewTime
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *uid = [User shareInstance].id;
    SelectedCar *curCar = [[CarDataManager shareInstance] getSelCar];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] computeRenewWithUid:uid carId:curCar.m_carId duration:[NSString stringWithFormat:@"%.1f", (m_time/10.0)] delegate:self];
    req = nil;
}


/**
 *方法描述：获取车辆已经预定的时间
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarSchedule
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];

    FMNetworkRequest *req = [[BLNetworkManager shareInstance] selectOrderTimeByCarId:m_curCar.m_carId delegate:self];
    req = nil;

}

/**
 *方法描述：根据车辆信息创建车辆视图
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)carInfoView
{
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CAR_INFO forUsed:forSelectCar];
    [m_carInfo setselectCarWithUnitPrice:m_curCar.m_unitPrice
                                dayPrice:m_curCar.m_dayPrice
                                carModel:m_curCar.m_model
                                carSerie:m_curCar.m_carseries
                                carPlate:m_curCar.m_plateNum
                                discount:m_curCar.m_discount
                                imageUrl:m_curCar.m_carFile];
    
    [m_scrollView addSubview:m_carInfo];
}

/**
 *方法描述：绘制车辆时间刻度表
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)customDrawView
{
    CGRect tmpRect = m_carInfo.frame;
    tmpRect.origin.y = m_carInfo.frame.origin.y + m_carInfo.frame.size.height;
    m_customDraw = [[CarTimeTableView alloc] initWithFrame:tmpRect];
    [m_scrollView addSubview:m_customDraw];
}

/**
 *方法描述：将获取到的车辆使用时间更新到时刻表上
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateOrderTimeByCarId:(NSDictionary *)responseDate
{
    m_checking1 = [responseDate objectForKey:@"checking1"];
    m_checking2 = [responseDate objectForKey:@"checking2"];
    m_checking3 = [responseDate objectForKey:@"checking3"];
    m_using1 = [responseDate objectForKey:@"using1"];
    m_using2 = [responseDate objectForKey:@"using2"];
    m_using3 = [responseDate objectForKey:@"using3"];

    [m_customDraw updateChecking:m_checking1 check2:m_checking2 check3:m_checking3];
    [m_customDraw updateUsing:m_using1 use2:m_using2 check3:m_using3];
    [m_customDraw setNeedsDisplay];
}

/**
 *方法描述：初始化续订订单页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initRenewView
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLLVIEW];
    [self.view addSubview:m_scrollView];
    
    NSInteger startY = 0;
    NSInteger height = 0;
    CGRect tmpRect = FRAME_CAR_INFO;
    CGRect subLabelRec = CGRectMake(CONTENT_START_X, 0, CONTENT_W, HEIGHT_ROW_LABEL);
    
    [self carInfoView];
    
    tmpRect = m_carInfo.frame;
    tmpRect.origin.y = m_carInfo.frame.origin.y + m_carInfo.frame.size.height;
    m_customDraw = [[CarTimeTableView alloc] initWithFrame:tmpRect];
    [m_scrollView addSubview:m_customDraw];
    
    startY = m_customDraw.frame.origin.y + m_customDraw.frame.size.height;
    height = HEIGHT_ROW_LABEL;
    tmpRect.origin.y = startY;
    tmpRect.size.height = height;
    srvOrderData *curOrder = [[OrderManager ShareInstance] getCurrentOrderData];
    m_orderGivebackTime = [[UILabel alloc] initWithFrame:tmpRect];
    m_orderGivebackTime.textColor = [UIColor blackColor];
    NSString *givebackTime = [[PublicFunction ShareInstance]getYMDHMString:curOrder.m_returnTime];
    m_orderGivebackTime.text = [NSString stringWithFormat:@"%@", STR_ORDER_GIVEBACK_TIME];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_orderGivebackTime withStr:givebackTime withRect:subLabelRec];
    [m_scrollView addSubview:m_orderGivebackTime];
    
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_maxRenewDuration = [[UILabel alloc] initWithFrame:tmpRect];
    m_maxRenewDuration.text = [NSString stringWithFormat:@"%@", STR_GO_ON_MOST_TIME];
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_maxRenewDuration withStr:GET(m_strMax) withRect:subLabelRec];
    m_maxRenewDuration.textColor = [UIColor blackColor];
    [m_scrollView addSubview:m_maxRenewDuration];
    
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    tmpRect.size.height = HEIGHT_RENEW_CONTROLLER;
    m_renewDuration = [[UILabel alloc] initWithFrame:tmpRect];
    m_renewDuration.text = STR_GO_ON_TIME;
    m_renewDuration.textColor = [UIColor blackColor];
    [m_scrollView addSubview:m_renewDuration];
    
    
    m_time = 0.0;
    float btnWidth = WIDTH_RENEW_CONTROLLER;
    float btnHeight = HEIGHT_RENEW_CONTROLLER;
    CGRect rect = FRAME_RENEW_CONTROLLER;
    float startX = rect.origin.x;
    startY = tmpRect.origin.y;//rect.origin.y;
    m_addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_addBtn.frame = CGRectMake(startX + rect.size.width - btnWidth - 5, startY, btnWidth, btnHeight);
    [m_addBtn setBackgroundImage:[UIImage imageNamed:IMG_DURATION_ADD] forState:UIControlStateNormal];
    [m_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [m_scrollView addSubview:m_addBtn];
    
    float numWidth = WIDTH_RENEW_FIELD;
    m_numTextField = [[UITextField alloc] initWithFrame:CGRectMake(startX + rect.size.width - btnWidth - numWidth - 10, startY, numWidth, btnHeight)];
    m_numTextField.keyboardType = UIKeyboardTypeNumberPad;
    m_numTextField.textAlignment = NSTextAlignmentCenter;
    m_numTextField.delegate = self;
    [m_numTextField setBackground:[UIImage imageNamed:IMG_DURATION_INPUT]];
    m_numTextField.text = [NSString stringWithFormat:@"%.1f", (m_time/10.0)/* + 0.05*/];
    [m_scrollView addSubview:m_numTextField];
    
    m_subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_subBtn.frame = CGRectMake(startX, startY, btnWidth, btnHeight);
    [m_subBtn setBackgroundImage:[UIImage imageNamed:IMG_DURATION_SUB] forState:UIControlStateNormal];
    [m_subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_subBtn addTarget:self action:@selector(subBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [m_scrollView addSubview:m_subBtn];

    tmpRect.origin.y += HEIGHT_RENEW_CONTROLLER;
    m_renewDeposit = [[UILabel alloc] initWithFrame:tmpRect];
    m_renewDeposit.textColor = [UIColor blackColor];
    m_renewDeposit.text = [NSString stringWithFormat:@"%@", STR_GO_ON_DEPOSIT];
    [m_scrollView addSubview:m_renewDeposit];
    
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_balance = [[UILabel alloc] initWithFrame:tmpRect];
    m_balance.textColor = [UIColor blackColor];
    m_balance.textAlignment =NSTextAlignmentLeft;
    m_balance.text = [NSString stringWithFormat:@"%@",STR_AVAILABLE_BALANCE];
    [m_scrollView addSubview:m_balance];
    
    m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width, tmpRect.origin.y + tmpRect.size.height);
    
    m_renewBtn = [[UIButton alloc] initWithFrame:FRAME_RENEW_BTN];
    [m_renewBtn setTitle:STR_CONFIRM_GO_ON forState:UIControlStateNormal];
    [m_renewBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_renewBtn addTarget:self action:@selector(renewBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_renewBtn];
}


-(void)dealloc
{
    CANCEL_REQUEST(m_renewReq);
}

/**
 *方法描述：续订时间增加半小时
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)addBtnClicked
{
    NSLog(@"add btn");
    m_time += 5;
    m_numTextField.text = [NSString stringWithFormat:@"%.1f", (m_time/10.0)/* + 0.05*/];
    
    if (((m_time + 5) * 360) > m_maxRenew)
    {
        [m_addBtn setEnabled:NO];
        [m_subBtn setEnabled:YES];
    }

    [self caculateReq];
}

/**
 *方法描述：续订时间减少半小时
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)subBtnClicked
{
    if (m_time <= 0) {
        return;
    }
    m_time -= 5;
    NSLog(@"sub btn");
    m_numTextField.text = [NSString stringWithFormat:@"%.1f", (m_time/10.0)/* + 0.05*/];
    
    [self caculateReq];
}

/**
 *方法描述：续订增加减少费用请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)caculateReq
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *reTime = m_numTextField.text;
    NSString *carId = m_curCar.m_carId;
    NSString *userId = [User shareInstance].id;
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] computeRenewWithUid:userId carId:carId duration:reTime delegate:self];
    req = nil;
}


/**
 *方法描述：获取我的账户信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getMyAccount
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getMyAccountMessageWithUserId:[User shareInstance].id delegate:self];
    request = nil;
}

/**
 *方法描述：获取到我到账户信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotMyAccount:(FMNetworkRequest *)request
{
    m_myAccount = request.responseData;
    NSString *balanceStr = [NSString stringWithFormat:STR_COST_FORMAT, m_myAccount.usefull];
    CGRect rect = CGRectMake(CONTENT_START_X, 0, CONTENT_W, m_balance.frame.size.height);
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_balance withStr:balanceStr withRect:rect];
}

/**
 *方法描述：续订请求
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)renewReq
{
    NSString *reTime = m_numTextField.text;
    NSString *userId = [User shareInstance].id;
    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] renewOrder:userId
                                                                 orderId:tmpOrderData.m_orderId
                                                               renewTime:reTime
                                                               startTime:m_startTime
                                                                 endTime:m_endTime
                                                          mileageDeposit:GET(m_kiloDeposit)
                                                             timeDeposit:GET(m_timeDeposit)
                                                                 Deposit:[NSString stringWithFormat:@"%.02f",m_totalDeposit]
                                                                delegate:self];
    
    req = nil;
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
}

/**
 *方法描述：续订按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)renewBtn
{
    NSLog(@"renew button");
    
    NSString *reTime = m_numTextField.text;
    if ([@"0.0" isEqualToString:reTime]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:STR_RENEW_TIME_ZERO delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
   
    if ([self moneyEnough] == NO)
    {
        //当前可用余额:100.00元，可用余额不足，请前往充值
        NSString *balance = [NSString stringWithFormat:@"%.2f",[m_myAccount.usefull floatValue]];
        NSString *strMessage = [NSString stringWithFormat:STR_RENEW_TO_RECHARGE_CONFIRM, balance ];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:strMessage delegate:self cancelButtonTitle:STR_CANCEL otherButtonTitles:STR_TO_RECHARGE, nil];
        alertView.tag = TAG_RECHARGE;
        [alertView show];
        
    }
    else
    {
        [self renewReq];
    }
    
    
}

/**
 *方法描述：判断金额不足
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)moneyEnough
{
    //m_totalDeposit       续订押金
    //m_myAccount.usefull  可用金额
    if ([m_myAccount.usefull floatValue] >= m_totalDeposit) {
        return YES;
    }
    return NO;
}

/**
 *方法描述：获取到车辆最大续订时长和时间，并进一步获取其他信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initRenewFullInfo:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    NSString *maxduration = [dic objectForKey:@"time"];
    
    NSLog(@"maxduration = %@", maxduration);
    m_strMax = [NSString stringWithFormat:@"%@", maxduration];
    m_maxRenew = [[dic objectForKey:@"timeLong"] integerValue];
    
    
    [self initRenewView];
    
    //    [self getRenewTime];
    [self getCarSchedule];
    
    //[self getMyAccount];
}

/**
 *方法描述：获取订单已经续订的续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateRepeatListReq
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    srvOrderData *tmpData = [[OrderManager ShareInstance] getCurrentOrderData];
    m_renewReq = [[BLNetworkManager shareInstance] repeatOrderList:tmpData.m_orderId delegate:self];
}


/**
 *方法描述：更新续订费用
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateDeposit:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    if (nil == dic) {
        return;
    }
    NSString *tmpStr = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"endTime"])];
    m_endTime = [tmpStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    tmpStr = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"startTime"])];
    m_startTime = [tmpStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    m_usefull = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"usefull"])];
    m_kiloDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"mileageDeposit"]];
    m_timeDeposit = [NSString stringWithFormat:@"%@", [dic objectForKey:@"timeDeposit"]];
    m_totalDeposit = [m_kiloDeposit floatValue] + [m_timeDeposit floatValue];
    NSString *total = [NSString stringWithFormat:@"%.02f 元", m_totalDeposit];

    CGRect rect = CGRectMake(CONTENT_START_X, 0, CONTENT_W, m_renewDeposit.frame.size.height);
    [[PublicFunction ShareInstance] addSubLabelToLabel:m_renewDeposit withStr:total withRect:rect];
//    m_renewDeposit.text = [NSString stringWithFormat:@"%@:  %@元", STR_GO_ON_DEPOSIT, total];
}

/**
 *方法描述：续订记录返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initRepeatOrderList:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    NSArray *data = [dic objectForKey:@"renewOrderList"];
    if (data == nil || [data count] == 0) {
        return;
    }

    [[OrderManager ShareInstance] setOrderRenewList:dic];
    
    if (delegate && [delegate respondsToSelector:@selector(renewListChanged)])
    {
        [delegate renewListChanged];
    }
//    [self updateOrderToView];
    [self renewPrompt];
}

/**
 *方法描述：提示续订成功
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)renewPrompt
{
    if (delegate && [delegate respondsToSelector:@selector(renewListChanged)])
    {
        [delegate renewListChanged];
    }
    
    NSString *strPrompt = [NSString stringWithFormat:@"%@\n %@:%@", STR_RENEW_SUCCESS, STR_GIVE_BACK_TIME, m_endTime];
    CustomAlertView *tmpAlertView = [[CustomAlertView alloc] initWithTitle:nil message:strPrompt delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    tmpAlertView.tag = TAG_RENEW_SUCCESS;
    [tmpAlertView needDismisShow];
    
}

/**
 *方法描述：去充值
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)toRecharge
{
    //if ([m_myAccount.usefull integerValue] >= m_totalDeposit)
    NSString *chargeAmount = [NSString stringWithFormat:@"%.2f",m_totalDeposit-[m_myAccount.usefull floatValue]];
    MyAccountChargeViewController *detail =[[MyAccountChargeViewController alloc] init];
    detail.chargeAmount = chargeAmount;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - alert delegate
/**
 *方法描述：提示框回调
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (TAG_RENEW_SUCCESS == alertView.tag)
    {
//        if (delegate && [delegate respondsToSelector:@selector(backToPrePage:)]) {
//            [delegate backToPrePage:NO];
//        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (alertView.tag == TAG_RENEW_CONFORM) {
        if (1 == buttonIndex) {
            [self renewReq];
        }
    }
    else if(TAG_RECHARGE == alertView.tag && 1 == buttonIndex)
    {
        [self toRecharge];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (TAG_RENEW_SUCCESS == alertView.tag)
    {
        if (delegate && [delegate respondsToSelector:@selector(backToPrePage:)]) {
            [delegate backToPrePage:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate
/**
 *方法描述：隐藏键盘使用
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [m_numTextField resignFirstResponder];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self upSelfView];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self DownSelfView];
}

/**
 *方法描述：向上移动view
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)upSelfView
{
    NSInteger width = [[UIScreen mainScreen] bounds].size.width;
    NSInteger height = [[UIScreen mainScreen] bounds].size.height;
    
    int y;
    if (IS_IPHONE5) {
        y = -100;
    }else{
        y = -170;
    }
    CGRect frame_old = CGRectMake(0, y, width, height);
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frame_old;
    }];
}

/**
 *方法描述：恢复view 显示
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)DownSelfView
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = m_constantFrame;
    }];
}

#pragma mark - http delegate
/**
 *方法描述：请求成功处理函数
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getRenewFullInfo])
    {
        [self initRenewFullInfo:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_selectOrderTimeByCarId])
    {
        [self updateOrderTimeByCarId:fmNetworkRequest.responseData];
    }
    else if ([kRequest_renewOrder isEqualToString:fmNetworkRequest.requestName])
    {
        [self renewPrompt];
//        [self updateRepeatListReq];
    }
    else if([kRequest_repeatOrderList isEqualToString:fmNetworkRequest.requestName])
    {
//        [self renewPrompt];
        [self initRepeatOrderList:fmNetworkRequest];
    }
    else if([kRequest_computeRenew isEqualToString:fmNetworkRequest.requestName])
    {
        [self updateDeposit:fmNetworkRequest];
    }
    else if([KRequest_getMyAccountMessage isEqualToString:fmNetworkRequest.requestName])
    {
        [self gotMyAccount:fmNetworkRequest];
    }
    
    [[LoadingClass shared] hideLoadingForMoreRequest];
}


/**
 *方法描述：请求失败处理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    [[LoadingClass shared] showContent:fmNetworkRequest.responseData andCustomImage:nil];
    NSLog(@" renew order view controller request failed");
}

@end
