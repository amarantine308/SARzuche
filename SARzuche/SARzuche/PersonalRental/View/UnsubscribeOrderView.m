//
//  UnsubscribeOrderView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "UnsubscribeOrderView.h"
#import "PersonalCarInfoView.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "BLNetworkManager.h"
#import "OrderManager.h"
#import "BranchDataManager.h"
#import "PriceDetailsView.h"
#import "PublicFunction.h"

#define LABEL_START_X           0
#define LABEL_W                 320
#define LEFT_LABEL_W            140
#define RIGHT_LABEL_W           180
#define RIGHT_START_X           (LEFT_START_X + LEFT_LABEL_W)

#define ALERT_VIEW_TAG_PROMPT           2010
#define ALERT_VIEW_TAG_CONFIRM          2011
#define ALERT_VIEW_TAG_UNSUB_SUCCESS          2012

#define FRAME_CAR_INFO          CGRectMake(LABEL_START_X, 120, LABEL_W, 250)
#define FRAME_ORDER_ID_TITLE    CGRectMake(LABEL_START_X, 10, LEFT_LABEL_W, 20)
#define FRAME_ORDER_ID          CGRectMake(RIGHT_START_X, 10, RIGHT_LABEL_W, 20)
#define FRAME_ORDER_TIME_TITLE  CGRectMake(LABEL_START_X, 40, LEFT_LABEL_W, 20)
#define FRAME_ORDER_TIME        CGRectMake(RIGHT_START_X, 40, RIGHT_LABEL_W, 20)
#define FRAME_ORDER_STATUS_TITLE CGRectMake(LABEL_START_X, 70, LEFT_LABEL_W, 20)
#define FRAME_ORDER_STATUS      CGRectMake(RIGHT_START_X, 70, RIGHT_LABEL_W, 20)
#define FRAME_ORDER_RETIME_TITLE    CGRectMake(LABEL_START_X, 100, LEFT_LABEL_W, 20)
#define FRAME_ORDER_RETIME          CGRectMake(RIGHT_START_X, 100, RIGHT_LABEL_W, 20)
#define FRAME_ORDER_PAY_TITLE       CGRectMake(LABEL_START_X, LEFT_LABEL_W, LEFT_LABEL_W, 20)
#define FRAME_ORDER_PAY             CGRectMake(RIGHT_START_X, LEFT_LABEL_W, RIGHT_LABEL_W, 20)

#define FRAME_TMP_RECT          CGRectMake(0, 0, 320, 180)
#define LABEL_ROW_LABEL_HEIGHT        20
#define LABEL_ROW_BUTTON_HEIGHT        40

#define BOTTOM_BUTTON_HEIGHT            50
#define BOTTOM_BUTTON_STARTY            (MainScreenHeight - ORDER_SUBVIEW_STARTY - BOTTOM_BUTTON_HEIGHT)

#define IMG_UNSUBSCRIBE                 @"unsubscribe.png"
#define IMG_RIGHT_ARROW                 @"ringht_arrow.png"

#define FRAME_DETAIL_VIEW               CGRectMake(0, -110, MainScreenWidth, MainScreenHeight)

@implementation UnsubscribeOrderView
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData:curOrder];
        [self initView:curOrder];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initData:(srvOrderData *)curOrderData
{
}


-(void)updateCarInfo:(PersonalCarInfoView *)carView
{
    SelectedCar *curCar = [[CarDataManager shareInstance] getSelCar];
    if (nil != curCar) {
        [carView setselectCarWithUnitPrice:curCar.m_unitPrice dayPrice:curCar.m_dayPrice carModel:curCar.m_model carSerie:curCar.m_carseries carPlate:curCar.m_plateNum discount:curCar.m_discount imageUrl:curCar.m_carFile];
    }
}


-(void)updateUserInfo:(PersonalCarInfoView *)carView withOrderData:(srvOrderData *)curOrderData
{
    BrancheData *tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:YES];
    NSString *takeBranch = [NSString stringWithFormat:@"%@",tmpData.m_name];
    tmpData = [[BranchDataManager shareInstance] getBranchDataWithType:NO];
    NSString *givebackBranch = [NSString stringWithFormat:@"%@", tmpData.m_name];
    
    NSString *takeTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:curOrderData.m_effectTime]];
    NSString *backTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:curOrderData.m_returnTime]];

    
    [carView setSelectConditionWithBranche:takeBranch takeTime:takeTime backBranche:givebackBranch backTime:backTime];
}

-(void)initView:(srvOrderData *)curOrderData
{
    if (nil == curOrderData) {
        return;
    }
    
    
    
    [self initLabelForNormal:curOrderData];
    
    NSString *strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_STATUS, STR_ORDER_STATUS_NORMAL];
    [m_OrderStatus setText:strLabel];
#if 0
    NSInteger startX = 10;//self.frame.origin.x;
    //    NSInteger startY = m_curViewHeight;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;
    strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_STATUS, @"2014.09.19 15:30"];
    m_magicLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, m_curViewHeight, width, rowHeight)];
    [m_magicLabel setText:strLabel];
    [self addSubview:m_magicLabel];
    
    m_curViewHeight += rowHeight;
#endif
    CGRect carInfoFrame = FRAME_CAR_INFO;
    carInfoFrame = CGRectMake(carInfoFrame.origin.x, m_curViewHeight, carInfoFrame.size.width, carInfoFrame.size.height);
    PersonalCarInfoView *tmpCarView = [[PersonalCarInfoView alloc] initWithFrame:carInfoFrame forUsed:forCurOrder];
//    tmpCarView.delegate = self;
    [self updateCarInfo:tmpCarView];
    [self updateUserInfo:tmpCarView withOrderData:curOrderData];
    [self addSubview:tmpCarView];
    m_curViewHeight += tmpCarView.frame.size.height;

    
    [self initButton:curOrderData];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight);
    
}




-(void)initLabelForNormal:(srvOrderData *)orderData
{
    NSInteger startX = 10;//self.frame.origin.x;
    NSInteger startY = 0;//self.frame.origin.y;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;
    NSString *strLabel = nil;
    
    m_OrderID = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_ID, orderData.m_orderNum];
    m_OrderID.text = strLabel;
    m_OrderID.textColor = COLOR_LABEL_GRAY;
    [self addSubview:m_OrderID];
    
    startY += rowHeight;
    NSString *createTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:orderData.m_creatTime]];
    strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_TIME, createTime];
    m_OrderTime = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    m_OrderTime.text = strLabel;
    m_OrderTime.textColor = COLOR_LABEL_GRAY;
    [self addSubview:m_OrderTime];
    
    startY += rowHeight;
    strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_STATUS, STR_ORDER_STATUS_NORMAL];
    m_OrderStatus = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    m_OrderStatus.text = strLabel;
    m_OrderStatus.textColor = COLOR_LABEL_GRAY;
    [self addSubview:m_OrderStatus];
    
    startY += rowHeight;
    m_curViewHeight = startY;
}



-(void)initButton:(srvOrderData *)orderData
{
    NSInteger startX = 0;
    NSInteger startY = m_curViewHeight;
    NSInteger width = MainScreenWidth;//self.frame.size.width;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    UIImage *arrowImg = [UIImage imageNamed:IMG_RIGHT_ARROW];
    CGRect arrowRec = CGRectMake(290, (LABEL_ROW_BUTTON_HEIGHT - arrowImg.size.height) /2, arrowImg.size.width, arrowImg.size.height);
    UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
    arrow.frame = arrowRec;
    
    m_prePayedBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_prePayedBtn addTarget:self action:@selector(prePayedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_prePayedBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview: m_prePayedBtn];
    m_curViewHeight += rowHeight;
    
    CGRect rect = m_prePayedBtn.frame;
    rect.origin.x = 10;
    rect.origin.y = 0;
    rect.size.width = 300;
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:rect];
    tmpLabel.text = STR_ORDER_PREPAY;
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    tmpLabel.textColor = COLOR_LABEL_GRAY;
    tmpLabel.backgroundColor = [UIColor whiteColor];
    
    NSString *totalDeposit = [GET(orderData.m_totalDeposit) length] == 0 ? @"0" : GET(orderData.m_totalDeposit);
    NSString *strDeposit = [NSString stringWithFormat:STR_COST_FORMAT, totalDeposit];
//    [[PublicFunction ShareInstance] addSubLabelToLabel:tmpLabel withString:strDeposit withColor:COLOR_LABEL_BLUE];
    CGRect preCostRect = [[PublicFunction ShareInstance] getSubLabelRect:tmpLabel];
    UILabel *preCostLabel = [[UILabel alloc] initWithFrame:preCostRect];
    preCostLabel.text = strDeposit;
    preCostLabel.textColor = COLOR_LABEL_BLUE;
    preCostLabel.backgroundColor = [UIColor clearColor];
    [m_prePayedBtn addSubview:tmpLabel];
    [m_prePayedBtn addSubview:preCostLabel];
    [m_prePayedBtn addSubview:arrow];

    m_unsubscribeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BOTTOM_BUTTON_STARTY, width, BOTTOM_BUTTON_HEIGHT)];
    [m_unsubscribeBtn setTitle:STR_CONFIRM_UNSUBSCRIBE forState:UIControlStateNormal];
    [m_unsubscribeBtn setBackgroundImage:[UIImage imageNamed:IMG_UNSUBSCRIBE] forState:UIControlStateNormal];
    [m_unsubscribeBtn addTarget:self action:@selector(unsubscribeBtn) forControlEvents:UIControlEventTouchUpInside];
    m_unsubscribeBtn.userInteractionEnabled = YES;
    m_unsubscribeBtn.enabled = YES;
    [self addSubview:m_unsubscribeBtn];
    
    m_curViewHeight = BOTTOM_BUTTON_HEIGHT + BOTTOM_BUTTON_STARTY;
}

-(void)prePayedInfo
{
    NSLog(@"pre payed info");
    srvOrderData *tmpData = [[OrderManager ShareInstance] getCurrentOrderData];
    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:YES];
    [tmpView setOrderData:tmpData];
    [self addSubview:tmpView];
}

-(void)unsubscribeBtn
{
    NSLog(@"unsubscribe order");
    srvOrderData *tmpData = [[OrderManager ShareInstance] getCurrentOrderData];
    if (nil == tmpData)
    {
        return;
    }

    NSDate *takeDate = [[PublicFunction ShareInstance] getDateFrom:tmpData.m_takeTime];
    if ([[PublicFunction ShareInstance] inHalfAnHour:takeDate])
    {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_UNSUB_PROMPT delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        promptAlert.tag = ALERT_VIEW_TAG_PROMPT;
        [promptAlert show];
            
        return;
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:STR_CONFIRM_UNSUB_INFO delegate:self cancelButtonTitle:STR_CANCEL otherButtonTitles:STR_OK, nil];
    alertView.tag = ALERT_VIEW_TAG_CONFIRM;
    [alertView show];

}

-(void)backToPrePage
{
    if (delegate && [delegate respondsToSelector:@selector(backToPrePage:)])
    {
        [delegate backToPrePage:YES];
    }
}


-(void)unsubSuccess
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_UNSUB_SUCCESS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    promptAlert.tag = ALERT_VIEW_TAG_UNSUB_SUCCESS;
    [promptAlert show];
}

-(void)unsubOrderReq
{
    srvOrderData *tmpOrder = [[OrderManager ShareInstance] getCurrentOrderData];
    NSString *orderId = tmpOrder.m_orderId;
    if (nil == tmpOrder || nil == orderId) {
        NSLog(@"orderid is nil");
    }
    m_cancelOrderReq = [[BLNetworkManager shareInstance] cancelOrder:orderId delegate:self];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index  = %d" , buttonIndex);
    if (alertView.tag == 10000) {
        [self backToPrePage];
        return;
    }
    switch (buttonIndex) {
        case 0:
            if (alertView.tag == ALERT_VIEW_TAG_UNSUB_SUCCESS)
            {
                [self backToPrePage];
            }
            break;
        case 1:
            [self unsubOrderReq];
            break;
        default:
            break;
    }
    
}


#pragma mark - http delegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([kRequest_cancelOrder isEqualToString:fmNetworkRequest.requestName])
    {
        NSString *strLabel = [NSString stringWithFormat:@"%@:  %@", STR_ORDER_STATUS, STR_ORDER_STATUS_UNSUBSCRIBE];
        [m_OrderStatus setText:strLabel];
        
        srvOrderData *tmpData = [[OrderManager ShareInstance] getCurrentOrderData];
        tmpData.m_status = @"2";
        
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_ORDER_STATUS_UNSUBSCRIBE delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        tmpAlert.tag = 10000;
        [tmpAlert show];
        
        m_unsubscribeBtn.enabled = NO;
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    [tmpAlert show];
}


-(void)dealloc
{
    CANCEL_REQUEST(m_cancelOrderReq);
}


@end
