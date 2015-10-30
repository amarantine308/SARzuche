//
//  HistoryOrdersViewCell.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HistoryOrdersViewCell.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "BLNetworkManager.h"
#import "CarDataManager.h"
#import "User.h"
#import "PublicFunction.h"


#define TITLE_START_X                   10
#define TITLE_LABEL_W                   80

#define CONTENT_START_X                 TITLE_START_X + TITLE_LABEL_W
#define CONTENT_LABEL_W                 (MainScreenWidth - TITLE_START_X * 2 - TITLE_LABEL_W)

#define LABEL_ROW_HEIGHT            25
#define LABEL_ROW_TITLE_H           30

#define CAR_INFO_HIGHT              (m_carInfo.frame.size.height)

#define FRAME_CAR_INFO          CGRectMake(0, LABEL_ROW_HEIGHT *0, MainScreenWidth, CAR_INFO_HIGHT)
#define FRAME_ORDER_ID_TITLE    CGRectMake(TITLE_START_X, CAR_INFO_HIGHT + 0, TITLE_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_ID          CGRectMake(CONTENT_START_X, CAR_INFO_HIGHT + 0, CONTENT_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_TIME_TITLE  CGRectMake(TITLE_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT, TITLE_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_TIME        CGRectMake(CONTENT_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT, CONTENT_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_STATUS_TITLE CGRectMake(TITLE_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *2, TITLE_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_STATUS      CGRectMake(CONTENT_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *2, CONTENT_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_RETIME_TITLE    CGRectMake(TITLE_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *3, TITLE_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_RETIME          CGRectMake(CONTENT_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *3, CONTENT_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_PAY_TITLE       CGRectMake(TITLE_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *4, TITLE_LABEL_W, LABEL_ROW_HEIGHT)
#define FRAME_ORDER_PAY             CGRectMake(CONTENT_START_X, CAR_INFO_HIGHT + LABEL_ROW_HEIGHT *4, CONTENT_LABEL_W, LABEL_ROW_HEIGHT)

@implementation HistoryOrdersViewCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initOrdersViewCell];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    CANCEL_REQUEST(m_repeatList)
    CANCEL_REQUEST(m_reqCar)
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initOrdersViewCell
{
    
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CAR_INFO forUsed:forCarInfoNoPrice];
    [self.contentView addSubview:m_carInfo];
    m_nCellHeight += m_carInfo.frame.size.height;
    
    m_OrderIDTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_ID_TITLE];
    m_OrderIDTitle.text = STR_ORDER_ID;
    m_OrderIDTitle.textColor = COLOR_LABEL_GRAY;
    [self.contentView addSubview:m_OrderIDTitle];
    
    m_OrderID = [[UILabel alloc] initWithFrame:FRAME_ORDER_ID];
    m_OrderID.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_OrderID];
    m_nCellHeight += m_OrderID.frame.size.height;
    
    CGRect separatorRec = CGRectMake(0, m_OrderID.frame.origin.y + m_OrderID.frame.size.height - 1, MainScreenWidth, 1);
    [self addSubview:[[PublicFunction ShareInstance] getSeparatorView:separatorRec]];
    
    m_OrderTimeTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_TIME_TITLE];
    m_OrderTimeTitle.text = STR_ORDER_TIME;
    m_OrderTimeTitle.textColor = COLOR_LABEL_GRAY;
    [self.contentView addSubview:m_OrderTimeTitle];
    
    m_OrderTime = [[UILabel alloc] initWithFrame:FRAME_ORDER_TIME];
    m_OrderTime.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_OrderTime];
    m_nCellHeight += m_OrderTime.frame.size.height;
    
    m_OrderStatusTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_STATUS_TITLE];
    m_OrderStatusTitle.text = STR_ORDER_STATUS;
    m_OrderStatusTitle.textColor = COLOR_LABEL_GRAY;
    [self.contentView addSubview:m_OrderStatusTitle];
    
    m_OrderStatus = [[UILabel alloc] initWithFrame:FRAME_ORDER_STATUS];
    m_OrderStatus.textColor = COLOR_LABEL;
    [self.contentView addSubview:m_OrderStatus];
    m_nCellHeight += m_OrderStatus.frame.size.height;
    
#if 0
    UILabel *prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, LABEL_ROW_TITLE_H)];
    prepayCost.textColor = COLOR_LABEL_BLUE;
    prepayCost.font = BOLD_FONT_LABEL_TITLE;
    prepayCost.textAlignment = NSTextAlignmentLeft;
    prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, GET(m_orderData.m_totalPrice)];
#endif
    
    m_magicTitle = [[UILabel alloc] initWithFrame:FRAME_ORDER_RETIME_TITLE];
    m_magicTitle.textColor = COLOR_LABEL_GRAY;
    [self.contentView addSubview:m_magicTitle];
    
    m_magic = [[UILabel alloc] initWithFrame:FRAME_ORDER_RETIME];
    m_magic.textColor = COLOR_LABEL;
    m_magic.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:m_magic];
    m_nCellHeight += m_magic.frame.size.height;
    
    separatorRec = CGRectMake(0, m_magic.frame.origin.y + m_magic.frame.size.height - 1, MainScreenWidth, 1);
    [self addSubview:[[PublicFunction ShareInstance] getSeparatorView:separatorRec]];
    
    m_payedBtn = [[UIButton alloc] initWithFrame:CGRectMake(m_carInfo.frame.origin.x, m_nCellHeight, m_carInfo.frame.size.width, LABEL_ROW_HEIGHT)];
    [m_payedBtn setTitle:STR_PREPAY_COST forState:UIControlStateNormal];
    [m_payedBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [m_payedBtn setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    m_payedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [m_payedBtn addTarget:self action:@selector(payedInfo:) forControlEvents:UIControlEventTouchUpInside];
    m_payedBtn.backgroundColor = [UIColor whiteColor];
    m_payedBtn.userInteractionEnabled = YES;
//    [m_payedBtn addSubview:prepayCost];
    [self addSubview: m_payedBtn];
    m_nCellHeight += m_payedBtn.frame.size.height;
    
//    CGRect separatorRec = CGRectMake(0, m_payedBtn.frame.origin.y + m_payedBtn.frame.size.height - 1, MainScreenWidth, 1);
//    [self addSubview:[[PublicFunction ShareInstance] getSeparatorView:separatorRec]];
    separatorRec = CGRectMake(0, m_nCellHeight, MainScreenWidth, 10);
    UIView *spaceView = [[PublicFunction ShareInstance] spaceViewWithRect:separatorRec withColor:COLOR_BACKGROUND];
    [self.contentView addSubview:spaceView];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)payedInfo:(id)sender
{
    NSLog(@"payed info button");
    if (delegate && [delegate respondsToSelector:@selector(showPayInfo:)])
    {
//        UIButton *tmpBtn  = sender;
        [delegate showPayInfo:self.tag];
    }
}


-(void)removeAllSubView
{
#if 0
    for(UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
#else
    
    [m_carInfo setselectCarWithUnitPrice:@"" dayPrice:@"" carModel:@"" carSerie:@"" carPlate:@"" discount:@"" imageUrl:@""];

    
    m_OrderID.text = @"";
    
    m_OrderTime.text = @"";
    
    m_OrderStatus.text = @"";
    
    m_magic.text = @"";
    
    m_magicTitle.text = @"";
    
    m_prepayCost.text = @"";
    
    if (m_reqCar) {
        CANCEL_REQUEST(m_reqCar);
    }
    
    if (m_repeatList) {
        CANCEL_REQUEST(m_repeatList);
    }
#endif
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setOrderData:(srvOrderData *)data
{
//    NSString *strTime = nil;
//    [self removeAllSubView];
//    [self initOrdersViewCell];

    m_orderData = data;
    m_OrderID.text = data.m_orderNum;

    [self initOrderCellNormal:data];
    
    [self initOrtherLabel:data];
#if 0
    strTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:data.m_reserveTime]];
    m_renewTime.text = strTime;
    
    strTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:data.m_endTime]];
    m_payTime.text = strTime;
#endif
    [m_payedBtn setTitle:STR_TOTAL_COST forState:UIControlStateNormal];
    
    NSString *tmpPrice = ([GET(m_orderData.m_totalPrice) length] == 0) ? @"0" : m_orderData.m_totalPrice;
    //如果消费0元，pay按钮不能点击
    if ([tmpPrice isEqualToString:@"0"])
    {
        m_payedBtn.enabled = NO;
    }
    NSString *checkPrice = [[PublicFunction ShareInstance] checkAndFormatMoeny:tmpPrice];
    [m_prepayCost removeFromSuperview];
    m_prepayCost = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_START_X, 0, CONTENT_LABEL_W, LABEL_ROW_TITLE_H)];
    m_prepayCost.textColor = COLOR_LABEL_BLUE;
    m_prepayCost.font = BOLD_FONT_LABEL_TITLE;
    m_prepayCost.textAlignment = NSTextAlignmentLeft;
    m_prepayCost.tag = 1001;
    m_prepayCost.text = [NSString stringWithFormat:STR_COST_FORMAT, checkPrice];
    [m_payedBtn addSubview:m_prepayCost];

//    [self getOrderRenewInfo];
    if (NO == [self initCarInforWithCarId:m_orderData.m_carId])
    {
        [self getCarInfo];
    }
    [self getOrderRenewInfo];
    
    
    [self setNeedsDisplay];
}


-(void)initOrderCellNormal:(srvOrderData *)data
{
    NSString *strTime = nil;
    strTime = [NSString stringWithFormat:@"%@", [[PublicFunction ShareInstance] getYMDHMString:GET(data.m_creatTime)]];
    m_OrderTime.text = strTime;
    
    m_OrderStatus.text = [NSString stringWithFormat:@"%@",[[PublicFunction ShareInstance] getOrderStatus: GET(data.m_status)]];

}


-(void)initOrtherLabel:(srvOrderData *)data
{// 1生效 2取消 3租金结算 4全部结算 5续订 6延时
    NSInteger nStatus = [data.m_status integerValue];
    switch (nStatus) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            [self cancelledToCell:data];
            break;
        case 3:
            [self payedToCell:data];
            break;
        case 4:
            [self finishedToCell:data];
            break;
        case 5:
            break;
        case 6:
            break;
        default:
            break;
    }
}


-(void)finishedToCell:(srvOrderData *)data
{
    NSString *strTime = [[PublicFunction ShareInstance] getYMDHMString:GET(data.m_endTime)];
    m_magicTitle.text = STR_ORDER_PAYED_TIME;
    
    m_magic.text = [NSString stringWithFormat:@"%@", strTime];
}

-(void)payedToCell:(srvOrderData *)data
{
    NSString *strTime = [[PublicFunction ShareInstance] getYMDHMString:GET(data.m_returnTime)];
    m_magicTitle.text = STR_ORDER_PAYED_TIME;

    m_magic.text = [NSString stringWithFormat:@"%@", strTime];
}


-(void)cancelledToCell:(srvOrderData *)data
{
    NSString *strTime = [[PublicFunction ShareInstance] getYMDHMString:GET(data.m_cancelTime)];
    m_magicTitle.text = STR_ORDER_UNSUBSCRIBE_TIME;

    m_magic.text = [NSString stringWithFormat:@"%@", strTime];
}

-(BOOL)initCarInforWithCarId:(NSString *)carId
{
    if (carId == nil || [carId length] == 0)
    {
        return NO;
    }
    SelectedCar *carInfo = [[CarDataManager shareInstance] getHistoryCar:carId];
    
    if (carInfo) {
        [m_carInfo setselectCarWithUnitPrice:carInfo.m_unitPrice dayPrice:carInfo.m_dayPrice carModel:carInfo.m_model carSerie:carInfo.m_carseries carPlate:carInfo.m_plateNum discount:carInfo.m_discount imageUrl:carInfo.m_carFile];
        [m_carInfo setNeedsDisplay];
        return YES;
    }
    
    return NO;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfo:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;

    CarDataManager *carData =  [[CarDataManager alloc] init];
    [carData setSelCar:[dic objectForKey:@"cars"]];
    SelectedCar *carInfo = [carData getSelCar];
    
    [[CarDataManager shareInstance] addHistoryCar:[dic objectForKey:@"cars"]];
    
    [m_carInfo setselectCarWithUnitPrice:carInfo.m_unitPrice dayPrice:carInfo.m_dayPrice carModel:carInfo.m_model carSerie:carInfo.m_carseries carPlate:carInfo.m_plateNum discount:carInfo.m_discount imageUrl:carInfo.m_carFile];
    [m_carInfo setNeedsDisplay];
}
/**
 *方法描述：
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
    
    m_reqCar = [[BLNetworkManager shareInstance] getCarInfo:m_orderData.m_carId delegate:self];
//    req = nil;
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getOrderRenewInfo
{
    m_repeatList = [[BLNetworkManager shareInstance] repeatOrderList:m_orderData.m_orderId  delegate:self];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void) initRenewOrderInfo:(FMNetworkRequest *)fmNetworkRequest
{
    NSDictionary *dic = fmNetworkRequest.responseData;
    NSArray *data = [dic objectForKey:@"renewOrderList"];
    if (data == nil || [data count] == 0) {
//        m_renewTime.text = @"";
        return;
    }
    NSDictionary *renewDic = [data objectAtIndex:[data count]-1];
    NSString * renewTime = [renewDic objectForKey:@"renewtime"];
    
    if (renewTime) {
//        m_renewTime.text = renewTime;
    }
    else
    {
//        m_renewTime.text = @"";
    }
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCarInfo])
    {
        [self initCarInfo:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_repeatOrderList])
    {
        NSLog(@"history cell repeat order id %@", m_orderData.m_orderId);
        [self initRenewOrderInfo:fmNetworkRequest];
    }
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
}
@end
