//
//  PriceDetailsView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PriceDetailsView.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "OrderManager.h"
#import "PublicFunction.h"


#define HEIGHT_ROW_LABEL        25
#define SUB_VIEW_START_Y        300

// PRE PAY
#define FRAME_COST_DETAIL           CGRectMake(10, 0, MainScreenWidth-20, HEIGHT_ROW_LABEL)
#define FRAME_DURATION_COST         CGRectMake(20, HEIGHT_ROW_LABEL, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_MILEAGE_COST          CGRectMake(20, HEIGHT_ROW_LABEL*2, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_SCHEDULING_COST       CGRectMake(20, HEIGHT_ROW_LABEL*3, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_DEPOSIT               CGRectMake(20, HEIGHT_ROW_LABEL*4, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_PREPAY                CGRectMake(20, HEIGHT_ROW_LABEL *5, MainScreenWidth-40, HEIGHT_ROW_LABEL)

#define FRAME_BACKGROUND_VIEW       CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
#define FRAME_SUB_VIEW              CGRectMake(0, SUB_VIEW_START_Y, MainScreenWidth, MainScreenHeight - SUB_VIEW_START_Y)

#define FRAME_DURATION_HOURS        CGRectMake(190, HEIGHT_ROW_LABEL, 110, HEIGHT_ROW_LABEL)
#define FRAME_MILEAGE_TOTAL         CGRectMake(190, HEIGHT_ROW_LABEL *2, 110, HEIGHT_ROW_LABEL)
#define FRAME_DELAY_HOURS           CGRectMake(190, HEIGHT_ROW_LABEL* 4, 110, HEIGHT_ROW_LABEL)

// COST DETAIL
#define FRAME_DELAY                 CGRectMake(20, HEIGHT_ROW_LABEL*4, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_DAMAGE                CGRectMake(20, HEIGHT_ROW_LABEL*5, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_ILLEGAL               CGRectMake(20, HEIGHT_ROW_LABEL*6, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_COUPON_DEDUCTION      CGRectMake(20, HEIGHT_ROW_LABEL*7, MainScreenWidth-40, HEIGHT_ROW_LABEL)
#define FRAME_AMOUNT                CGRectMake(20, HEIGHT_ROW_LABEL*8, MainScreenWidth-40, HEIGHT_ROW_LABEL*2)

@implementation PriceDetailsView



- (id)initWithFrame:(CGRect)frame prepay:(BOOL)prepay
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        m_bPrepay = prepay;
    }
    return self;
}


/**
 *方法描述：预付款详情
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initDetailsView:(srvOrderData *)orderData
{
//    srvOrderData *tmpOrderData = [[OrderManager ShareInstance] getCurrentOrderData];
    if (nil == orderData) {
        return;
    }
    NSString *tmpStr = nil;
    NSString *cost = nil;
    CGRect tmpRect = FRAME_COST_DETAIL;
    
    m_backgroundView = [[UIView alloc] initWithFrame:FRAME_BACKGROUND_VIEW];
    m_backgroundView.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;

    m_subView = [[UIView alloc] initWithFrame:FRAME_SUB_VIEW];
    m_subView.backgroundColor = [UIColor whiteColor];
    [m_backgroundView addSubview:m_subView];
    
//    m_costDetail = [[UILabel alloc] initWithFrame:FRAME_COST_DETAIL];
    m_costDetail = [[UILabel alloc] initWithFrame:tmpRect];
    m_costDetail.textColor = COLOR_LABEL_GRAY;
    m_costDetail.text = STR_COST_DETAILS;
    [m_subView addSubview:m_costDetail];
    m_viewHeight += HEIGHT_ROW_LABEL;
    
    CGRect separatorRect = m_costDetail.frame;
    separatorRect.origin.y += separatorRect.size.height;
    UIImageView *tmpView = [[PublicFunction ShareInstance] getSeparatorView:separatorRect];
    [m_subView addSubview:tmpView];
    m_viewHeight += tmpView.frame.size.height;
    tmpRect.origin.y += tmpView.frame.size.height;
    
    NSString *tmpCost = [NSString stringWithFormat:@"%@", orderData.m_timeDeposit];
    cost = [NSString stringWithFormat:STR_COST_FORMAT, [[PublicFunction ShareInstance] checkAndFormatMoeny: tmpCost]];
    tmpStr = [NSString stringWithFormat:@"%@: %@", STR_FORCAST_DURATION, cost];
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_duration = [[UILabel alloc] initWithFrame:tmpRect/*FRAME_DURATION_COST*/];
    m_duration.textColor = COLOR_LABEL_GRAY;
    m_duration.text = tmpStr;
    m_duration.backgroundColor = [UIColor clearColor];
    [m_subView addSubview:m_duration];
    
    tmpCost = [NSString stringWithFormat:@"%@", orderData.m_mileageDeposit];
    cost = [NSString stringWithFormat:STR_COST_FORMAT, [[PublicFunction ShareInstance] checkAndFormatMoeny: tmpCost]];
    tmpStr = [NSString stringWithFormat:@"%@: %@", STR_FORCAST_MILEAGE, cost];
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_mileage = [[UILabel alloc] initWithFrame:tmpRect/*FRAME_MILEAGE_COST*/];
    m_mileage.textColor = COLOR_LABEL_GRAY;
    m_mileage.text = tmpStr;
    [m_subView addSubview:m_mileage];
    
    if ([orderData.m_dispatchDeposit length] > 0 && NO == [orderData.m_dispatchDeposit isEqualToString:@"0"] && [GET(orderData.m_dispatchDeposit) length] > 0)
//        if ([orderData.m_dispatchDeposit length] > 0 && NO == [orderData.m_dispatchDeposit isEqualToString:@"0"])
    {
        tmpCost = [NSString stringWithFormat:@"%@", orderData.m_dispatchDeposit];
        cost = [NSString stringWithFormat:STR_COST_FORMAT, [[PublicFunction ShareInstance] checkAndFormatMoeny: tmpCost]];
        tmpStr = [NSString stringWithFormat:@"%@: %@", STR_FORCAST_SCHEDULING, cost];
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_scheduling = [[UILabel alloc] initWithFrame:tmpRect/*FRAME_SCHEDULING_COST*/];
        m_scheduling.textColor = COLOR_LABEL_GRAY;
        m_scheduling.text = tmpStr;
        [m_subView addSubview:m_scheduling];
    }
    
    NSInteger damage = [orderData.m_damageDeposit integerValue];
    NSInteger peccancy = [orderData.m_peccancyDeposit integerValue];
    NSString  *deposit = [NSString stringWithFormat:@"%d", damage + peccancy];
    tmpCost = [[PublicFunction ShareInstance] checkAndFormatMoeny:deposit];
    cost = [NSString stringWithFormat:STR_COST_FORMAT, tmpCost];
    tmpStr = [NSString stringWithFormat:@"%@: %@", STR_DEPOSIT, cost];
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_deposit = [[UILabel alloc] initWithFrame:tmpRect/*FRAME_DEPOSIT*/];
    m_deposit.textColor = COLOR_LABEL_GRAY;
    m_deposit.text = tmpStr;
    [m_subView addSubview:m_deposit];
    
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    separatorRect = tmpRect;
    UIImageView *separator2 = [[PublicFunction ShareInstance] getSeparatorView:separatorRect];
    [m_subView addSubview:separator2];
    tmpRect.origin.y += separator2.frame.size.height;
    
    
//    NSString* total = [GET(orderData.m_totalDeposit) length] == 0 ? @"0" : GET(orderData.m_totalDeposit);
    NSString* total = [GET(orderData.m_deposit) length] == 0 ? @"0" : GET(orderData.m_deposit);
    cost = [NSString stringWithFormat:STR_COST_FORMAT, [[PublicFunction ShareInstance] checkAndFormatMoeny:total]];
//    tmpStr = [NSString stringWithFormat:@"%@: %@", STR_ORDER_PREPAY, cost];
    tmpStr = [NSString stringWithFormat:@"%@:", STR_ORDER_PREPAY];
//    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_total = [[UILabel alloc] initWithFrame:tmpRect/*FRAME_PREPAY*/];
    m_total.textColor = COLOR_LABEL_GRAY;
    m_total.text = tmpStr;
    [m_subView addSubview:m_total];
    
    CGRect totalCostRect = m_total.frame;
    totalCostRect.origin.x += 100;
    UILabel *totalCostL = [[UILabel alloc] initWithFrame:totalCostRect];
    totalCostL.text = cost;//[NSString stringWithFormat:STR_COST_FORMAT, orderData.m_totalPrice];
    totalCostL.textColor = COLOR_LABEL_BLUE;
    totalCostL.backgroundColor = [UIColor whiteColor];
    [m_subView addSubview: totalCostL];
    
    NSInteger w = m_subView.frame.size.width;
    NSInteger h = tmpRect.origin.y + HEIGHT_ROW_LABEL + HEIGHT_ROW_LABEL; // last lable y + h + first label h
    NSInteger x = m_subView.frame.origin.x;
    NSInteger y = m_subView.frame.origin.y + m_subView.frame.size.height - h;
    m_subView.frame = CGRectMake(x, y , w, h);
    
    [self addSubview:m_backgroundView];
}


/**
 *方法描述：点击返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

/**
 *方法描述：初始化结算完成费用明细
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initConsumptionView:(srvOrderData *)orderData
{
    NSString *strTmp = nil;
    m_backgroundView = [[UIView alloc] initWithFrame:FRAME_BACKGROUND_VIEW];
    m_backgroundView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    
    m_subView = [[UIView alloc] initWithFrame:FRAME_SUB_VIEW];
    m_subView.backgroundColor = [UIColor whiteColor];
    [m_backgroundView addSubview:m_subView];
    
    m_costDetail = [[UILabel alloc] initWithFrame:FRAME_COST_DETAIL];
    m_costDetail.textColor = COLOR_LABEL_GRAY;
    m_costDetail.text = STR_COST_DETAILS;
    [m_subView addSubview:m_costDetail];
    m_viewHeight += HEIGHT_ROW_LABEL;
 
    CGRect tmpRect = m_costDetail.frame;
    tmpRect.origin.y += tmpRect.size.height;
    UIImageView *tmpView = [[PublicFunction ShareInstance] getSeparatorView:tmpRect];
    [m_subView addSubview:tmpView];
    m_viewHeight += tmpView.frame.size.height;
    // 时长费
    m_duration = [[UILabel alloc] initWithFrame:FRAME_DURATION_COST];
    tmpRect = m_duration.frame;
    tmpRect.origin.y = tmpView.frame.origin.y + tmpView.frame.size.height;
    m_duration.frame = tmpRect;
    m_duration.textColor = COLOR_LABEL_GRAY;
    m_duration.text = STR_DURATION_CONSUMPTION;
    strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_timeCost)];
    m_duration.text = [NSString stringWithFormat:@"%@           %@", STR_DURATION_CONSUMPTION, strTmp];
    [m_subView addSubview:m_duration];
    m_viewHeight += HEIGHT_ROW_LABEL;
    
    m_durationTotalHours = [[UILabel alloc] initWithFrame:FRAME_DURATION_HOURS];
    m_durationTotalHours.backgroundColor = [UIColor clearColor];
    m_durationTotalHours.text = STR_TOTAL_HOURS;
    m_durationTotalHours.textAlignment = NSTextAlignmentRight;
    m_durationTotalHours.text = [NSString stringWithFormat:STR_TOTAL_HOURS, [self getDurationTotalHours:orderData]];
    [m_subView addSubview:m_durationTotalHours];
    // 里程费
    tmpRect.origin.y += HEIGHT_ROW_LABEL;
    m_mileage = [[UILabel alloc] initWithFrame:FRAME_MILEAGE_COST];
    m_mileage.textColor = COLOR_LABEL_GRAY;
    m_mileage.text = STR_MILEAGE_CONSUMPTION;
    strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_mileageCost)];
    m_mileage.text = [NSString stringWithFormat:@"%@           %@",STR_MILEAGE_CONSUMPTION, strTmp];
    [m_subView addSubview:m_mileage];
    m_viewHeight += HEIGHT_ROW_LABEL;
    
    m_kilometerTotal = [[UILabel alloc] initWithFrame:FRAME_MILEAGE_TOTAL];
    m_kilometerTotal.backgroundColor = [UIColor clearColor];
    m_kilometerTotal.text = STR_TOTAL_MILOMETER;
    strTmp = [NSString stringWithFormat:@"%@", [GET(orderData.m_mileage) length] > 0 ? GET(orderData.m_mileage) : @"0"];
    m_kilometerTotal.text = [NSString stringWithFormat:STR_TOTAL_MILOMETER, strTmp];
    m_kilometerTotal.textAlignment = NSTextAlignmentRight;
    [m_subView addSubview:m_kilometerTotal];
    // 调度费
    if ([GET(orderData.m_dispatchCost) length] > 0 && 0 < [orderData.m_dispatchCost floatValue]) {
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_scheduling = [[UILabel alloc] initWithFrame:tmpRect];
        m_scheduling.textColor = COLOR_LABEL_GRAY;
        m_scheduling.text = STR_SCHEDULING_CONSUMPTION;
        strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_dispatchCost)];
        m_scheduling.text = [NSString stringWithFormat:@"%@           %@", STR_SCHEDULING_CONSUMPTION, strTmp];
        [m_subView addSubview:m_scheduling];
        m_viewHeight += HEIGHT_ROW_LABEL;
    }
    // 延时费
    if ([GET(orderData.m_lateCost) length] > 0 && 0 < [orderData.m_lateCost floatValue]) {
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_delay = [[UILabel alloc] initWithFrame:tmpRect];
        m_delay.textColor = COLOR_LABEL_GRAY;
        m_delay.text = STR_DELAY_CONSUMPTION;
        strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_lateCost)];
        m_delay.text = [NSString stringWithFormat:@"%@           %@", STR_DELAY_CONSUMPTION, strTmp];
        [m_subView addSubview:m_delay];
        m_viewHeight += HEIGHT_ROW_LABEL;
        
        CGRect delayRect = tmpRect;
        delayRect.origin.x = FRAME_DELAY_HOURS.origin.x;
        delayRect.size.width = FRAME_DELAY_HOURS.size.width;
        m_delayHour = [[UILabel alloc] initWithFrame:delayRect];
        m_delayHour.backgroundColor = [UIColor clearColor];
        m_delayHour.text = STR_TOTAL_HOURS;
        m_delayHour.textAlignment = NSTextAlignmentRight;
        strTmp = [NSString stringWithFormat:@"%@", GET(orderData.m_lateLong)];
        m_delayHour.text = [NSString stringWithFormat:STR_TOTAL_HOURS, strTmp];
        [m_subView addSubview:m_delayHour];
    }
    // 事故费
    if ([GET(orderData.m_damageCost) length] > 0 && 0 < [orderData.m_damageCost floatValue]) {
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_damage = [[UILabel alloc] initWithFrame:tmpRect];
        m_damage.textColor = COLOR_LABEL_GRAY;
        m_damage.text = STR_DAMAGE_COST;
        strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_damageCost)];
        m_damage.text = [NSString stringWithFormat:@"%@           %@", STR_DAMAGE_COST, strTmp];
        [m_subView addSubview:m_damage];
        m_viewHeight += HEIGHT_ROW_LABEL;
    }
    // 违章费
    if ([GET(orderData.m_peccancyCost) length] > 0 && 0 < [orderData.m_peccancyCost floatValue]) {
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_illegal = [[UILabel alloc] initWithFrame:FRAME_ILLEGAL];
        m_illegal.textColor = COLOR_LABEL_GRAY;
        strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_peccancyCost)];
        m_illegal.text = [NSString stringWithFormat:@"%@           %@", STR_ILLEGAL_COST, strTmp];
        [m_subView addSubview:m_illegal];
        m_viewHeight += HEIGHT_ROW_LABEL;
    }
    
    // 优惠券
    if ([GET(orderData.m_token) length] > 0 && 0 < [GET(orderData.m_token) floatValue]) {
        tmpRect.origin.y += HEIGHT_ROW_LABEL;
        m_couponDeduction = [[UILabel alloc] initWithFrame:tmpRect];
        m_couponDeduction.textColor = COLOR_LABEL_GRAY;
        m_couponDeduction.text = STR_COUPON_DEDUCTION;
        strTmp = [NSString stringWithFormat:STR_COST_FORMAT, GET(orderData.m_token)];
        m_couponDeduction.text = [NSString stringWithFormat:@"%@    %@", STR_COUPON_DEDUCTION, strTmp];
        [m_subView addSubview:m_couponDeduction];
        m_viewHeight += HEIGHT_ROW_LABEL;        
    }

//    m_viewHeight += HEIGHT_ROW_LABEL;
    
    CGRect sRect = tmpRect;
    sRect.origin.y += sRect.size.height;
    sRect.origin.x = 10;
    sRect.size.width = 300;
    UIImageView *separator2 = [[PublicFunction ShareInstance] getSeparatorView:sRect];
    [m_subView addSubview:separator2];
    m_viewHeight += separator2.frame.size.height;

    // 总消费
    tmpRect = separator2.frame;
    tmpRect.origin.y += tmpRect.size.height;
    tmpRect.size.height = FRAME_AMOUNT.size.height;
    m_total = [[UILabel alloc] initWithFrame:tmpRect];
    m_total.backgroundColor = [UIColor clearColor];
    m_total.text = STR_AMOUNT;
//    m_total.text = [NSString stringWithFormat:@"%@        %@", STR_AMOUNT, orderData.m_totalPrice];
    [m_subView addSubview:m_total];
    m_viewHeight += HEIGHT_ROW_LABEL * 2;
    
    CGRect totalCostRect = tmpRect;
    totalCostRect.origin.x += 100;
    UILabel *totalCostL = [[UILabel alloc] initWithFrame:totalCostRect];
    NSString *total = [GET(orderData.m_totalPrice) length] == 0 ?  @"0" : GET(orderData.m_totalPrice);
    NSString *checkTotal = [[PublicFunction ShareInstance] checkAndFormatMoeny:total];
    totalCostL.text = [NSString stringWithFormat:STR_COST_FORMAT, checkTotal];
    totalCostL.textColor = COLOR_LABEL_BLUE;
    totalCostL.backgroundColor = [UIColor whiteColor];
    [m_subView addSubview:totalCostL];
    
    
    m_subView.frame = CGRectMake(m_subView.frame.origin.x, MainScreenHeight - m_viewHeight - 20, m_subView.frame.size.width, m_viewHeight);
    [self addSubview:m_backgroundView];
}


/**
 *方法描述：获取总的时长
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getDurationTotalHours:(srvOrderData *)curData
{
#if 0
    NSString *givebackTime = [[PublicFunction ShareInstance] getYMDHMString:curData.m_returnTime];
    NSString *takeTime = [[PublicFunction ShareInstance] getYMDHMString:curData.m_effectTime];
    
    NSDate *takeDate = [[PublicFunction ShareInstance]getDateFrom:takeTime format:DATE_FORMAT_YMDHM];
    NSDate *givebackDate = [[PublicFunction ShareInstance] getDateFrom:givebackTime format:DATE_FORMAT_YMDHM];
    
    NSInteger nInterval = [givebackDate timeIntervalSinceDate:takeDate];
    
    CGFloat hour = nInterval / 60.0 / 90.0;
    return [NSString stringWithFormat:@"%.1f", hour];
#endif
    return [NSString stringWithFormat:@"%@", curData.m_trueTime];
}


/**
 *方法描述：设置订单数据，以备显示
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setOrderData:(srvOrderData *)orderData
{
    if (nil == orderData)
    {
        return;
    }
#if 0
    if (m_bPrepay) {
        
        tmpStr = [NSString stringWithFormat:@"%@: %@", STR_FORCAST_MILEAGE, GET(orderData.m_mileageDeposit)];
        m_mileage.text = tmpStr;

        tmpStr = [NSString stringWithFormat:@"%@: %@", STR_FORCAST_SCHEDULING, GET(orderData.m_dispatchDeposit)];
        m_scheduling.text = tmpStr;
        
        NSInteger damage = [orderData.m_damageDeposit integerValue];
        NSInteger peccancy = [orderData.m_peccancyDeposit integerValue];
        NSString  *deposit = [NSString stringWithFormat:@"%d", damage + peccancy];
        NSString  *cost = [NSString stringWithFormat:STR_COST_FORMAT, deposit];
        tmpStr = [NSString stringWithFormat:@"%@: %@", STR_DEPOSIT, cost];
        m_deposit.text = tmpStr;
        
        NSString* total = [GET(orderData.m_totalDeposit) length] == 0 ? @"0" : GET(orderData.m_totalDeposit);
        cost = [NSString stringWithFormat:STR_COST_FORMAT, total];
        tmpStr = [NSString stringWithFormat:@"%@: %@", STR_ORDER_PREPAY, cost];
        m_total.text = tmpStr;
    }
#endif
    if (m_bPrepay) {
        [self initDetailsView:orderData];
    }
    else
    {
        [self initConsumptionView:orderData];
    }
}

@end
