//
//  CurrentOrderView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CurrentOrderView.h"
#import "constString.h"
#import "constDefine.h"
#import "RenewRecordViewController.h"
#import "RenewOrderViewController.h"
#import "PriceDetailsView.h"
#import "PublicFunction.h"
#import "UIColor+Helper.h"
#import "ConstImage.h"

#define CAR_INFO_START_Y                10//110
#define CAR_INFO_WIDTH                  320
#define CAR_INFO_HEIGHT                 (MainScreenHeight - CAR_INFO_START_Y)

#define TITLE_START_X                   10
#define TITLE_LABEL_W                   80

#define CONTENT_START_X                 TITLE_START_X + TITLE_LABEL_W
#define CONTENT_LABEL_W                 (MainScreenWidth - TITLE_START_X * 2 - TITLE_LABEL_W)


#define FRAME_CAR_INFO                  CGRectMake(0, CAR_INFO_START_Y, CAR_INFO_WIDTH, CAR_INFO_HEIGHT)
#define FRAME_ORDER_ID_TITLE            CGRectMake(10, 10, 130, 20)
#define FRAME_ORDER_ID                  CGRectMake(140, 10, 170, 20)
#define FRAME_ORDER_TIME_TITLE          CGRectMake(10, 40, 130, 20)
#define FRAME_ORDER_TIME                CGRectMake(140, 40, 170, 20)
#define FRAME_ORDER_STATUS_TITLE        CGRectMake(10, 70, 130, 20)
#define FRAME_ORDER_STATUS              CGRectMake(140, 70, 170, 20)
#define FRAME_ORDER_RETIME_TITLE        CGRectMake(10, 100, 130, 20)
#define FRAME_ORDER_RETIME              CGRectMake(140, 100, 170, 20)
#define FRAME_ORDER_PAY_TITLE           CGRectMake(10, 130, 130, 20)
#define FRAME_ORDER_PAY                 CGRectMake(140, 130, 170, 20)

#define FRAME_TMP_RECT                  CGRectMake(0, 0, 320, 180)
#define LABEL_ROW_LABEL_HEIGHT          30
#define LABEL_ROW_LABEL_TITLE_HEIGHT    40
#define LABEL_ROW_BUTTON_HEIGHT         40

#define BOTTOM_BUTTON_HEIGHT            50
#define BOTTOM_BUTTON_STARTY_WITH_GAP            (MainScreenHeight - ORDER_SUBVIEW_STARTY - BOTTOM_BUTTON_HEIGHT - 10)
#define BOTTOM_BUTTON_STARTY            (MainScreenHeight - ORDER_SUBVIEW_STARTY - BOTTOM_BUTTON_HEIGHT)

#define FRAME_DETAIL_VIEW               CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)

#define FRAME_SCROLL_VIEW               CGRectMake(0, 0, MainScreenWidth, MainScreenHeight-ORDER_SUBVIEW_STARTY)


#define IMG_MODIFY                      @"modify.png"
#define IMG_UNSUBSCRIBE                 @"unsubscribe.png"
#define IMG_RIGHT_ARROW                 @"ringht_arrow.png"

@implementation CurrentOrderView
@synthesize delegate;
@synthesize m_bHistoryOrder;


-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder formHist:(BOOL)bHistory
{
    self = [super initWithFrame:frame];
    if (self) {
        m_bHistoryOrder = bHistory;
        // Initialization code
        [self initData:curOrder];
        [self initCurrentOrderView];
    }
    return self;
}



-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initData:curOrder];
        [self initCurrentOrderView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCurrentOrderView];
    }
    return self;
}

/**
 *方法描述：根据订单数据初始化需要显示的数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initData:(srvOrderData *)curOrderData
{
    m_orderData = curOrderData;
    
    NSInteger status = [m_orderData.m_status intValue];//1生效 2取消 3租金结算 4全部结算 5续订 6延时
    switch (status) {
        case 0:
            m_currentStatus = orderSubscribe;
            break;
        case 1:
            m_currentStatus = orderNormal;
            break;
        case 2:
            m_currentStatus = orderUnsubscribe;
            break;
        case 3:
            m_currentStatus = orderPayed;
            break;
        case 4:
            m_currentStatus = orderFinished;
            break;
        case 5:
            m_currentStatus = orderRenew;
            break;
        case 6:
            m_currentStatus = orderDelay;
            break;
        default:
            break;
    }
//    m_currentStatus = //[[PublicFunction ShareInstance] getOrderStatus:GET(curOrderData.m_status)];
}
/**
 *方法描述：设置网点信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setBranches:(NSString *)takeBranch giveback:(NSString*)givebackBranch
{
    
}


/**
 *方法描述：设置车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setCarInfo:(SelectedCar *)car
{
    if (nil == car)
    {
        return;
    }
    
    [m_CarView setselectCarWithUnitPrice:car.m_unitPrice dayPrice:car.m_dayPrice carModel:car.m_model carSerie:car.m_carseries carPlate:car.m_plateNum discount:car.m_discount imageUrl:car.m_carFile];
    [m_CarView setNeedsDisplay];
}


-(void)setRenewList:(NSArray *)renewList
{
    if (renewList == nil)
    {
        m_renewList = nil;
        return;
    }
    
    m_renewList = [[NSArray alloc] initWithArray:renewList];
}

/**
 *方法描述：设置当前订单数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setOrderData:(srvOrderData *)data
{
    m_orderData = data;
    
    NSInteger status = [m_orderData.m_status intValue];//0预定 1生效 2取消 3租金结算 4全部结算
    switch (status) {
        case 0:
            m_currentStatus = orderSubscribe;
            break;
        case 1:
            m_currentStatus = orderNormal;
            break;
        case 2:
            m_currentStatus = orderUnsubscribe;
            break;
        case 3:
            m_currentStatus = orderPayed;
            break;
        case 4:
            m_currentStatus = orderFinished;
            break;
        default:
            break;
    }

    [self adjustStatusWithOrderTime];
#ifdef DEBUG
    NSLog(@"--- m_currentStatus = %d ----", m_currentStatus);
//    m_currentStatus = orderSubscribe;
#endif
    [self removeAllView];
    [self initCurrentOrderView];
    [self setNeedsDisplay];
}

// 根据订单数据和当前时间调整订单状态
-(void)adjustStatusWithOrderTime
{
    NSString *startTime = [[PublicFunction ShareInstance] getYMDHMString:m_orderData.m_effectTime];//m_orderData.m_effectTime;
    NSDate *startDate = [[PublicFunction ShareInstance] getDateFrom:startTime format:DATE_FORMAT_YMDHM];
    
    if ([self inHalfAnHour:startDate]// 订单距离当前时间还有半小时
        && (m_currentStatus == orderSubscribe || m_currentStatus == orderNormal)) {
        m_currentStatus = orderRenew;
    }

    if ([[PublicFunction ShareInstance] isLaterThanEffectTime:startDate] // 订单时间已经过了
        && (m_currentStatus == orderSubscribe || m_currentStatus == orderNormal))
    {
        m_currentStatus = orderRenew;
    }
    
    NSArray * renewList = [[OrderManager ShareInstance] getOrderRenewList]; //当前订单有续订记录
    if (renewList && [renewList count] > 0
        && (m_currentStatus == orderNormal || m_currentStatus == orderSubscribe))
    {
        m_currentStatus = orderRenew;
    }
    
    if ([self isDelayOrder] && (m_currentStatus == orderNormal || m_currentStatus == orderSubscribe || m_currentStatus == orderRenew))
    {// 当前时间已经超过还车时间
        m_currentStatus = orderDelay;
    }
    
}

// 半小时内
-(BOOL)inHalfAnHour:(NSDate *)dstDate
{
    NSInteger resInterval = [dstDate timeIntervalSinceNow];
    
    if (resInterval > 0) {
        NSInteger nHalfanhour = TIME_INTERVAL_HALFANHOUR;
        if (resInterval < nHalfanhour) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *方法描述：删除所有View
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)removeAllView
{
    for (UIView *subView in [self subviews]) {
        [subView removeFromSuperview];
    }
    m_curViewHeight = 0;
}

#pragma mark -label in view
/**
 *方法描述：根据订单状态，确定初始化Label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelWithData
{
    switch (m_currentStatus) {
        case orderDelay:
            [self initLabelForDelay];
            break;
        case orderFinished:
            [self initLabelForFinished];
            break;
        case orderNormal:
            [self initLabelForNormal];
            break;
        case orderPayed:
            [self initLabelForPayed];
            break;
        case orderRenew:
            [self initLabelForRenew];
            break;
        case orderSubscribe:
            [self initLabelForNormal];
            break;
        case orderUnsubscribe:
            [self initLabelForUnsubscribe];
            break;
        default:
            break;
    }
}
/**
 *方法描述：初始化正常状态下的Label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForNormal
{
    NSInteger startX = TITLE_START_X;//self.frame.origin.x;
    NSInteger contentX = CONTENT_START_X;
    NSInteger startY = m_curViewHeight;//0;//self.frame.origin.y;
    NSInteger width = TITLE_LABEL_W;// self.frame.size.width;
    NSInteger contentW = CONTENT_LABEL_W;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;

    // subview background color
    CGRect tmpRect = CGRectMake(0, startY, MainScreenWidth, LABEL_ROW_LABEL_TITLE_HEIGHT);
    UIView *bkView = [[UIView alloc] initWithFrame:tmpRect];
    bkView.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:bkView];
    // 订单号
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, TITLE_LABEL_W, LABEL_ROW_BUTTON_HEIGHT)];
    title.text = STR_ORDER_ID;
    title.textColor = COLOR_LABEL_GRAY;
    [m_scrollView addSubview:title];
    // 订单号内容
    m_OrderID = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentW, LABEL_ROW_LABEL_TITLE_HEIGHT)];
    m_OrderID.text = GET(m_orderData.m_orderNum);
    m_OrderID.textColor = COLOR_LABEL;
    m_OrderID.font = FONT_LABEL_TITLE;
    [m_scrollView addSubview:m_OrderID];
    // 分割线
    CGRect rect = CGRectMake(0, m_OrderID.frame.origin.y + m_OrderID.frame.size.height - 1, MainScreenWidth, 2);
    UIImageView *tmpView = [[PublicFunction ShareInstance] getSeparatorView:rect];
    [m_scrollView addSubview:tmpView];
    startY += LABEL_ROW_LABEL_TITLE_HEIGHT;
    // 创建时间
    title = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    title.textColor = COLOR_LABEL_GRAY;
    title.text = STR_ORDER_TIME;
    title.font = FONT_LABEL;
    [m_scrollView addSubview:title];
    //创建时间内容
    NSString *createTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_creatTime)]];
    if ([GET(m_orderData.m_updateTime) length] > 0) {
        createTime =[NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_updateTime)]];
    }
    m_OrderTime = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentW, rowHeight)];
    m_OrderTime.text = GET(createTime);
    m_OrderTime.font = FONT_LABEL;
    m_OrderTime.textColor = COLOR_LABEL;
    [m_scrollView addSubview:m_OrderTime];
    startY += rowHeight;
    // 订单状态
    title = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    title.textColor = COLOR_LABEL_GRAY;
    title.text = STR_ORDER_STATUS;
    title.font = FONT_LABEL;
    [m_scrollView addSubview:title];
    // 订单状态 内容
    m_OrderStatus = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentW, rowHeight)];
    m_OrderStatus.text = [[OrderManager ShareInstance] getStatusWithRspStatus:GET(m_orderData.m_status)];
    m_OrderStatus.textColor = COLOR_LABEL;
    m_OrderStatus.font = FONT_LABEL;
    [m_scrollView addSubview:m_OrderStatus];
    
    startY += rowHeight;
    m_curViewHeight = startY;
    tmpRect = bkView.frame;
    tmpRect.size.height = startY;
    bkView.frame = tmpRect;
}
/**
 *方法描述：初始化还车状态下的Label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForPayed
{
    NSInteger startX = TITLE_START_X;
    NSInteger width = TITLE_LABEL_W;
    NSInteger contentW = CONTENT_LABEL_W;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;
    
    [self initLabelForRenew];
    
    m_OrderStatus.text = STR_ORDER_STATUS_PAYED;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(startX, m_curViewHeight, width, LABEL_ROW_LABEL_HEIGHT)];
    title.text = STR_ORDER_PAYED_TIME;
    title.textColor = COLOR_LABEL_GRAY;
    title.font = FONT_LABEL;
    [m_scrollView addSubview:title];
    
    m_magicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, m_curViewHeight, contentW, rowHeight)];
    [m_magicLabel setText:[[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_endTime) ]];
    m_magicLabel.font = FONT_LABEL;
    m_magicLabel.textColor = COLOR_LABEL;
    [m_scrollView addSubview:m_magicLabel];
    
    m_curViewHeight += rowHeight;
}
/**
 *方法描述：初始化延时状态下的Label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForDelay
{
    BOOL hasRenew = YES;
    if (hasRenew) {
        [self initLabelForRenew];
    }
    else
    {
        [self initLabelForNormal];
    }
    
    m_OrderStatus.text = STR_ORDER_STATUS_DELAY;
}
/**
 *方法描述：初始化续订状态下的Label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForRenew
{
    NSInteger startX = TITLE_START_X;
    NSInteger contentX = CONTENT_START_X;
//    NSInteger startY = m_curViewHeight;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;
    
    [self initLabelForNormal];
    
    NSInteger nCount = 0;
    if (NO == m_bHistoryOrder)
    {
        m_renewList = [[OrderManager ShareInstance] getOrderRenewList];
    }
    nCount = [m_renewList count];

    if (nCount > 0) {
        [m_OrderStatus setText:STR_ORDER_STATUS_RENEW];
        
        // subview background color
        CGRect tmpRect = CGRectMake(0, m_curViewHeight, MainScreenWidth, LABEL_ROW_LABEL_TITLE_HEIGHT);
        UIView *bkView = [[UIView alloc] initWithFrame:tmpRect];
        bkView.backgroundColor = [UIColor whiteColor];
        [m_scrollView addSubview:bkView];
        // 续订时间
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(startX, m_curViewHeight, TITLE_LABEL_W, LABEL_ROW_LABEL_HEIGHT)];
        title.text = STR_RENEW_DATETIME;
        title.font = FONT_LABEL;
        title.textColor = COLOR_LABEL_GRAY;
        [m_scrollView addSubview:title];
        // 续订时间内容
        srvRenewData * tmpRenewData = [m_renewList objectAtIndex:0/*nCount -1*/];
        m_renewTime = [[UIButton alloc] initWithFrame:CGRectMake(contentX, m_curViewHeight, width, rowHeight)];
        [m_renewTime addTarget:self action:@selector(renewInfo) forControlEvents:UIControlEventTouchUpInside];
        NSString *strRenew = [[PublicFunction ShareInstance] getYMDHMString:GET(tmpRenewData.m_creatTime)];
        [m_renewTime setTitle:strRenew forState:UIControlStateNormal];
        m_renewTime.titleLabel.font = FONT_LABEL;
        m_renewTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [m_renewTime setTitleColor:COLOR_LABEL forState:UIControlStateNormal];
        m_renewTime.backgroundColor = [UIColor whiteColor];
        [m_scrollView addSubview:m_renewTime];
        
        UIImage *arrowImg = [UIImage imageNamed:IMG_RIGHT_ARROW];
        CGRect arrowRec = CGRectMake(290 - contentX, (LABEL_ROW_LABEL_HEIGHT - arrowImg.size.height) /2, arrowImg.size.width, arrowImg.size.height);
        UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
        arrow.frame = arrowRec;
        [m_renewTime addSubview:arrow];
        
        
        
        m_curViewHeight += rowHeight;
    }
    else
    {
        [m_OrderStatus setText:STR_ORDER_STATUS_NORMAL];
    }
}
/**
 *方法描述：初始化已退订订单内容
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForUnsubscribe
{
    [self initLabelForNormal];
    
    [m_OrderStatus setText:STR_ORDER_STATUS_UNSUBSCRIBE];
}
/**
 *方法描述：初始化订单完成状态内容
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabelForFinished
{
    NSInteger startX = TITLE_START_X;
    NSInteger contentW = CONTENT_LABEL_W;
    NSInteger width = TITLE_LABEL_W;
    NSInteger rowHeight = LABEL_ROW_LABEL_HEIGHT;
    
    //    [self initLabelForNormal];
    [self initLabelForRenew];
    
    NSString *strLabel = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getOrderStatus:m_orderData.m_status]];
    [m_OrderStatus setText:strLabel];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(startX, m_curViewHeight, width, LABEL_ROW_LABEL_HEIGHT)];
    title.text = STR_ORDER_PAYED_TIME;
    title.textColor = COLOR_LABEL_GRAY;
    title.font = FONT_LABEL;
    [m_scrollView addSubview:title];
    
    m_magicLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, m_curViewHeight, contentW, rowHeight)];
    [m_magicLabel setText:[[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_endTime) ]];
    m_magicLabel.font = FONT_LABEL;
    m_magicLabel.textColor = COLOR_LABEL;
    [m_scrollView addSubview:m_magicLabel];
    
    m_curViewHeight += rowHeight;
}

#pragma mark - button in view
/**
 *方法描述：根据订单状态判断需要初始化的按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonWithData
{
    switch (m_currentStatus) {
        case orderDelay:
            [self initButtonForDelay];
            break;
        case orderFinished:
            [self initButtonForFinished];
            break;
        case orderNormal:
            [self initButtonForNormal];
            break;
        case orderPayed:
            [self initButtonForPayed];
            break;
        case orderRenew:
            [self initButtonForRenew];
            break;
        case orderSubscribe:
            [self initButtonForNormal];
            break;
        case orderUnsubscribe:
            break;
        default:
            break;
    }
}
/**
 *方法描述：初始化普通状态下的按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonForNormal
{
    NSInteger startX = 10;
    NSInteger startY = m_curViewHeight;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, MainScreenWidth, rowHeight)];
    tmpView.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:tmpView];
    
    
    m_prePayed = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_prePayed setTitle:STR_PREPAY_COST forState:UIControlStateNormal];
    [m_prePayed setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    m_prePayed.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_prePayed addTarget:self action:@selector(prePayedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_prePayed.backgroundColor = [UIColor whiteColor];
//    [m_prePayed addSubview:prepayCost];
    [self setPrepayDataToShow];
    [m_scrollView addSubview: m_prePayed];
    m_curViewHeight += rowHeight;
    
    m_unsubBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BOTTOM_BUTTON_STARTY, MainScreenWidth/2, BOTTOM_BUTTON_HEIGHT)];
    [m_unsubBtn setTitle:STR_ORDER_UNSUBSCRIBE forState:UIControlStateNormal];
    [m_unsubBtn setBackgroundImage:[UIImage imageNamed:IMG_UNSUBSCRIBE] forState:UIControlStateNormal];
    [m_unsubBtn addTarget:self action:@selector(unsubcribeOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_unsubBtn];

    m_modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth/2, BOTTOM_BUTTON_STARTY, MainScreenWidth/2, BOTTOM_BUTTON_HEIGHT)];
    [m_modifyBtn setTitle:STR_ORDER_MODIFY forState:UIControlStateNormal];
    [m_modifyBtn setBackgroundImage:[UIImage imageNamed:IMG_MODIFY] forState:UIControlStateNormal];
    [m_modifyBtn addTarget:self action:@selector(modifyOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:m_modifyBtn];
    
//    m_curViewHeight = BOTTOM_BUTTON_HEIGHT + BOTTOM_BUTTON_STARTY;
    m_scrollView.frame = CGRectMake(m_scrollView.frame.origin.x, m_scrollView.frame.origin.y, m_scrollView.frame.size.width, m_modifyBtn.frame.origin.y - m_scrollView.frame.origin.y);
}
/**
 *方法描述：初始化续订状态下的按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonForRenew
{
    NSInteger startX = 10;
    NSInteger startY = m_curViewHeight;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    NSString *strTmp = [NSString stringWithFormat:STR_PREPAY_COST, GET(m_orderData.m_deposit)];
    m_prePayed = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
//    [m_prePayed setTitle:@"预付款  2,000元" forState:UIControlStateNormal];
    [m_prePayed setTitle:strTmp forState:UIControlStateNormal];
    [m_prePayed setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    m_prePayed.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_prePayed addTarget:self action:@selector(prePayedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_prePayed.backgroundColor = [UIColor whiteColor];
    [self setPrepayDataToShow];
    [m_scrollView addSubview: m_prePayed];
    m_curViewHeight += rowHeight;

    m_renewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, BOTTOM_BUTTON_STARTY, /*width*/MainScreenWidth, BOTTOM_BUTTON_HEIGHT)];
    [m_renewBtn setTitle:STR_ORDER_RENEW forState:UIControlStateNormal];
    [m_renewBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_renewBtn addTarget:self action:@selector(renewBtn) forControlEvents:UIControlEventTouchUpInside];
    m_renewBtn.userInteractionEnabled = YES;
//    [m_scrollView addSubview:m_renewBtn];
    [self addSubview:m_renewBtn];
    
//    m_curViewHeight = BOTTOM_BUTTON_HEIGHT + BOTTOM_BUTTON_STARTY;
    
    m_scrollView.frame = CGRectMake(m_scrollView.frame.origin.x, m_scrollView.frame.origin.y, m_scrollView.frame.size.width,  m_renewBtn.frame.origin.y - m_scrollView.frame.origin.y);
    m_scrollView.contentSize = CGSizeMake(0, m_curViewHeight);
}

/**
 *方法描述：初始化延时状态下需要的按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonForDelay
{
    NSInteger startX = 10;
    NSInteger startY = m_curViewHeight;
    NSInteger width = MainScreenWidth;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    UILabel *prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, rowHeight)];
    prepayCost.textColor = COLOR_LABEL_BLUE;
    prepayCost.font = BOLD_FONT_LABEL_TITLE;
    prepayCost.textAlignment = NSTextAlignmentLeft;
    NSString *tmpDeposit = [[PublicFunction ShareInstance] checkAndFormatMoeny:GET(m_orderData.m_deposit)];
    prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, tmpDeposit];
    
    m_prePayed = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_prePayed setTitle:STR_ORDER_PREPAY forState:UIControlStateNormal];
    m_prePayed.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_prePayed addTarget:self action:@selector(prePayedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_prePayed.backgroundColor = [UIColor whiteColor];
    [m_prePayed setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    [m_prePayed addSubview:prepayCost];
    [self setPrepayDataToShow];
    [m_scrollView addSubview: m_prePayed];
    m_curViewHeight += rowHeight;
    
    //    m_scrollView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight);
}
/**
 *方法描述：初始化订单还车状态下按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonForPayed
{
//    [self initButtonForDelay];
    
    NSInteger startX = 10;
    NSInteger startY = m_curViewHeight;
    NSInteger width = MainScreenWidth;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    m_prePayed = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_prePayed setTitle:STR_PREPAY_COST forState:UIControlStateNormal];
    [m_prePayed setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    m_prePayed.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_prePayed addTarget:self action:@selector(prePayedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_prePayed.backgroundColor = [UIColor whiteColor];
    [self setPrepayDataToShow];
    [m_scrollView addSubview: m_prePayed];
    m_curViewHeight += LABEL_ROW_BUTTON_HEIGHT;
    
    startY = m_curViewHeight;
    NSString *total = [GET(m_orderData.m_totalPrice) length] == 0 ?  @"0" : GET(m_orderData.m_totalPrice);
    NSString *checkTotal = [[PublicFunction ShareInstance] checkAndFormatMoeny:total];
    UILabel *prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, rowHeight)];
    prepayCost.textColor = COLOR_LABEL_BLUE;
    prepayCost.font = BOLD_FONT_LABEL_TITLE;
    prepayCost.textAlignment = NSTextAlignmentLeft;
    prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, checkTotal];

    m_payedBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_payedBtn setTitle:STR_TOTAL_COST forState:UIControlStateNormal];
    [m_payedBtn setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    m_payedBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_payedBtn addTarget:self action:@selector(payedInfo) forControlEvents:UIControlEventTouchUpInside];
    m_payedBtn.backgroundColor = [UIColor whiteColor];
    [m_payedBtn addSubview:prepayCost];
    [m_scrollView addSubview: m_payedBtn];
    m_curViewHeight += rowHeight;
    
    UIImage *arrowImg = [UIImage imageNamed:IMG_RIGHT_ARROW];
    CGRect arrowRec = CGRectMake(290 - 10, (LABEL_ROW_BUTTON_HEIGHT - arrowImg.size.height) /2, arrowImg.size.width, arrowImg.size.height);
    UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
    arrow.frame = arrowRec;
    [m_payedBtn addSubview:arrow];
    //    m_scrollView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight);
}
/**
 *方法描述：初始化订单结算完成状态下按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initButtonForFinished
{
    NSInteger startX = 10;
    NSInteger startY = m_curViewHeight;
    NSInteger width = self.frame.size.width - 20;
    NSInteger rowHeight = LABEL_ROW_BUTTON_HEIGHT;
    
    NSString *lastCost = [GET(m_orderData.m_totalPrice) length] == 0 ? @"0" :GET(m_orderData.m_totalPrice);
    NSString *checkLastCost = [[PublicFunction ShareInstance] checkAndFormatMoeny:lastCost];
    UILabel *prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, rowHeight)];
    prepayCost.textColor = COLOR_LABEL_BLUE;
    prepayCost.font = BOLD_FONT_LABEL_TITLE;
    prepayCost.textAlignment = NSTextAlignmentLeft;
    prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, checkLastCost];
    
    m_payedBtn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, width, rowHeight)];
    [m_payedBtn setTitle:STR_TOTAL_COST forState:UIControlStateNormal];
    [m_payedBtn setTitleColor:COLOR_LABEL forState:UIControlStateNormal];
    m_payedBtn.backgroundColor = [UIColor whiteColor];
    m_payedBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [m_payedBtn addTarget:self action:@selector(payedInfo) forControlEvents:UIControlEventTouchUpInside];
    [m_payedBtn addSubview:prepayCost];
    [m_scrollView addSubview: m_payedBtn];
    m_curViewHeight += rowHeight;
    //    m_scrollView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight);
    UIImage *arrowImg = [UIImage imageNamed:IMG_RIGHT_ARROW];
    CGRect arrowRec = CGRectMake(290 - 10, (LABEL_ROW_BUTTON_HEIGHT - arrowImg.size.height) /2, arrowImg.size.width, arrowImg.size.height);
    UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
    arrow.frame = arrowRec;
    [m_payedBtn addSubview:arrow];
}
/**
 *方法描述：初始化订单相关label
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initLabel
{
    m_OrderIDTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_ID_TITLE];
    m_OrderIDTitle.text = STR_ORDER_ID;
    [m_scrollView addSubview:m_OrderIDTitle];
    
    m_OrderID = [[UILabel alloc] initWithFrame:FRAME_ORDER_ID];
    [m_scrollView addSubview:m_OrderID];
    
    m_OrderTimeTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_TIME_TITLE];
    m_OrderTimeTitle.text = STR_ORDER_TIME;
    [m_scrollView addSubview:m_OrderTimeTitle];
    
    m_OrderTime = [[UILabel alloc] initWithFrame:FRAME_ORDER_TIME];
    [m_scrollView addSubview:m_OrderTime];

    m_OrderStatusTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_STATUS_TITLE];
    m_OrderStatusTitle.text = STR_ORDER_STATUS;
    [m_scrollView addSubview:m_OrderStatusTitle];
    
    m_OrderStatus = [[UILabel alloc] initWithFrame:FRAME_ORDER_STATUS];
    [m_scrollView addSubview:m_OrderStatus];
#if 0
    m_renewTimeTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_RETIME_TITLE];
    m_renewTimeTitle.text = STR_ORDER_RENEW_TIME;
    [self addSubview:m_renewTimeTitle];

    m_renewTime = [[UILabel alloc] initWithFrame:FRAME_ORDER_RETIME];
    [self addSubview:m_renewTime];
#endif
    
    m_payTimeTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_PAY_TITLE];
    m_payTimeTitle.text = STR_ORDER_PAYED_TIME;
    [m_scrollView addSubview:m_payTimeTitle];
    
    m_payTime = [[UILabel alloc] initWithFrame:FRAME_ORDER_PAY];
    [m_scrollView addSubview:m_payTime];
}

// 判断订单延时
-(BOOL)isDelayOrder
{
    if (m_currentStatus == orderNormal || m_currentStatus == orderSubscribe|| m_currentStatus == orderRenew)
    {
        NSString *dateTime = [[PublicFunction ShareInstance] getYMDHMS:m_orderData.m_returnTime];
        NSDate *date = [[PublicFunction ShareInstance] getDateFrom:dateTime];
        
        if ((m_currentStatus == orderNormal || m_currentStatus == orderSubscribe) && [[PublicFunction ShareInstance] isBeforeCurrentTime:date])
        {
            return YES;
        }
        
        if (m_currentStatus == orderRenew) {
            dateTime = [[PublicFunction ShareInstance] getYMDHMS:m_orderData.m_newReturnTime];
            date = [[PublicFunction ShareInstance] getDateFrom:dateTime];
            if ([[PublicFunction ShareInstance] isBeforeCurrentTime:date])
            {
                return YES;
            }
        }
        
    }
    
    return NO;
}

/**
 *方法描述：订单状态变更
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)changeStatus
{
    switch (m_currentStatus) {
        case orderUnsubscribe:
            
            break;
        case orderSubscribe:
            break;
        case orderRenew:
            break;
        case orderDelay:
            break;
        case orderPayed:
            break;
        case orderFinished:
            break;
        case orderNormal:
            
            break;
        default:
            break;
    }
}
/**
 *方法描述：初始化当前订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCurrentOrderView
{
    self.backgroundColor = [UIColor whiteColor];
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    m_scrollView.backgroundColor = COLOR_BACKGROUND;
    [self addSubview:m_scrollView];
    
    NSString *takeTime = [[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_effectTime)];
    NSString *givebackTime = [[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_returnTime)];
//    NSArray *renewList = [[OrderManager ShareInstance] getOrderRenewList];
    if (NO == m_bHistoryOrder)
    {
        m_renewList = [[OrderManager ShareInstance] getOrderRenewList];
    }
    
    NSInteger nCount = [m_renewList count];
    if (nCount > 0)
    {
        NSLog(@"-- new return time: %@,   old return time: %@", m_orderData.m_newReturnTime, m_orderData.m_returnTime);
        givebackTime = [[PublicFunction ShareInstance] getYMDHMString:GET(m_orderData.m_newReturnTime)];
    }
    CGRect carInfoFrame = FRAME_CAR_INFO;
    carInfoFrame = CGRectMake(carInfoFrame.origin.x, m_curViewHeight, carInfoFrame.size.width, carInfoFrame.size.height);
    m_CarView = [[PersonalCarInfoView alloc] initWithFrame:carInfoFrame forUsed:forCurOrder];
    m_CarView.delegate = self;
    [self setCarInfo:[[CarDataManager shareInstance] getSelCar]];
    [m_CarView setSelectConditionWithBranche:GET(m_orderData.m_takeNetName) takeTime:takeTime backBranche:GET(m_orderData.m_backNetName) backTime:givebackTime];
    [m_scrollView addSubview:m_CarView];
    m_curViewHeight += m_CarView.frame.size.height;
    
    CGRect spaceRect = CGRectMake(0, m_curViewHeight, MainScreenWidth, spaceViewHeight);
    UIColor *clr = [UIColor colorWithHexString:@"#efeff4"];
    UIView *spaceView = [[PublicFunction ShareInstance]spaceViewWithRect:spaceRect withColor:clr];
    [m_scrollView addSubview:spaceView];
    m_curViewHeight += spaceViewHeight;
    
    [self initLabelWithData];
    
    CGRect spaceRect2 = CGRectMake(0, m_curViewHeight, MainScreenWidth, spaceViewHeight);
    UIColor *clr2 = [UIColor colorWithHexString:@"#efeff4"];
    UIView *spaceView2 = [[PublicFunction ShareInstance]spaceViewWithRect:spaceRect2 withColor:clr2];
    [m_scrollView addSubview:spaceView2];
    m_curViewHeight += spaceViewHeight;
    
    [self initButtonWithData];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight + bottomButtonHeight);
//    m_scrollView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.origin.y + m_curViewHeight);
    m_scrollView.contentSize = CGSizeMake(0, m_curViewHeight);
    
    takeTime = nil;
    givebackTime = nil;
}

#pragma mark - button target
// 跳转到地图
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance
{
    if (delegate &&[delegate respondsToSelector:@selector(jumpToMapWithBranche:)])
    {
        [delegate jumpToMapWithBranche:bTakeBrance];
    }
}
/**
 *方法描述：预付费信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)prePayedInfo
{
    NSLog(@"pre payed info button");
    if (delegate && [delegate respondsToSelector:@selector(prepayBtnPressed)])
    {
        [delegate prepayBtnPressed];
    }
}

/**
 *方法描述：消费信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)payedInfo
{
    NSLog(@"payed info button");
    if (delegate && [delegate respondsToSelector:@selector(payedInfo)]) {
        [delegate payedInfo];
        return;
    }

    PriceDetailsView *tmpView = [[PriceDetailsView alloc] initWithFrame:FRAME_DETAIL_VIEW prepay:NO];
    [tmpView setOrderData:m_orderData];//[[OrderManager ShareInstance] getCurrentOrderData]];
    [self addSubview:tmpView];
}

/**
 *方法描述：续订信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)renewInfo
{
    NSLog(@"renew info button");
    if (delegate && [delegate respondsToSelector:@selector(gotoRenewRecord)]) {
        [delegate gotoRenewRecord];
    }
}

/**
 *方法描述：续订订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)renewBtn
{
    NSLog(@"renew button");
    if (delegate && [delegate respondsToSelector:@selector(gotoRenewOrder)]) {
        [delegate gotoRenewOrder];
    }
}

/**
 *方法描述：退订订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)unsubcribeOrderBtn
{
    NSLog(@"unsubcribe Order Btn");
    if (delegate && [delegate respondsToSelector:@selector(gotoUnSubscribeOrder)]) {
        [delegate gotoUnSubscribeOrder];
    }
}

/**
 *方法描述：修改订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)modifyOrderBtn
{
    NSLog(@"modify Order Btn");
    if (delegate && [delegate respondsToSelector:@selector(gotoModifyOrder)]) {
        [delegate gotoModifyOrder];
    }
}


// 添加预付费
-(void)setPrepayDataToShow
{
    for(UIView *subView in [m_prePayed subviews])
    {
        [subView removeFromSuperview];
    }
    
    UILabel *prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, LABEL_ROW_BUTTON_HEIGHT)];
    prepayCost.textColor = COLOR_LABEL_BLUE;
    prepayCost.font = BOLD_FONT_LABEL_TITLE;
    prepayCost.text = STR_PREPAY_COST;
    prepayCost.textAlignment = NSTextAlignmentLeft;
    NSString *checkTotalDeposit = [[PublicFunction ShareInstance] checkAndFormatMoeny:GET(m_orderData.m_deposit/*m_orderData.m_totalDeposit*/)];
    prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, checkTotalDeposit];
    
    UIImage *arrowImg = [UIImage imageNamed:IMG_RIGHT_ARROW];
    CGRect arrowRec = CGRectMake(290 - 10, (LABEL_ROW_BUTTON_HEIGHT - arrowImg.size.height) /2, arrowImg.size.width, arrowImg.size.height);
    UIImageView *arrow = [[UIImageView alloc] initWithImage:arrowImg];
    arrow.frame = arrowRec;
    [m_prePayed addSubview:arrow];
    
    [m_prePayed addSubview:prepayCost];
}

@end
