//
//  OrderManager.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "OrderManager.h"
#import "ConstString.h"

#pragma mark - user select car condition
@implementation UserSelectCarCondition
@synthesize m_givebackBranche;
@synthesize m_givebackBrancheId;
@synthesize m_givebackCity;
@synthesize m_givebackTime;
@synthesize m_takeBranche;
@synthesize m_takeBrancheId;
@synthesize m_takeCity;
@synthesize m_takeTime;
@synthesize m_bNeedReqBranchId;
@end

#pragma mark - user car info
@implementation CarInfo
@synthesize m_carseries;
@synthesize m_dayPrice;
@synthesize m_id;
@synthesize m_model;
@synthesize m_plateNum;
@synthesize m_unitPrice;
@end


#pragma mark - order manager
@implementation OrderManager


+(OrderManager *)ShareInstance
{
    static OrderManager *handle;
    
    @synchronized(self)
    {
        if (nil == handle) {
            handle = [[OrderManager alloc] init];
        }
        
        return  handle;
    }
    return  nil;
}


-(void)cancelOrder
{
}


-(void)submitOrder
{
}

-(void)renewOrder
{
}



-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
}


#pragma mark - set select car condition
-(void)changeSelectCarConditionBranch:(NSString *)strBranch branchType:(BOOL)bTake
{
    if (nil == m_curSelectCarCondition) {
        return;
    }
    
    if (bTake)
    {
        m_curSelectCarCondition.m_takeBrancheId = (strBranch ? [NSString stringWithFormat:@"%@", strBranch] : nil);
    }
    else
    {
        m_curSelectCarCondition.m_givebackBrancheId = (strBranch ? [NSString stringWithFormat:@"%@", strBranch] : nil);
    }
}

/**
 *方法描述：设置分时租车选择信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setSelectCarCondition:(UserSelectCarCondition *)condition
{
    if (nil == m_curSelectCarCondition)
    {
        m_curSelectCarCondition = [[UserSelectCarCondition alloc] init];
    }
    
    m_curSelectCarCondition.m_takeTime = (condition.m_takeTime? [NSString stringWithFormat:@"%@", condition.m_takeTime] : nil);
    m_curSelectCarCondition.m_takeCity = (condition.m_takeCity ? [NSString stringWithFormat:@"%@", condition.m_takeCity] : nil);
    m_curSelectCarCondition.m_takeBranche = (condition.m_takeBranche ? [NSString stringWithFormat:@"%@", condition.m_takeBranche] : nil);
    m_curSelectCarCondition.m_takeBrancheId = (condition.m_takeBrancheId ? [NSString stringWithFormat:@"%@", condition.m_takeBrancheId] : nil);
    m_curSelectCarCondition.m_givebackTime = (condition.m_givebackTime ?[NSString stringWithFormat:@"%@", condition.m_givebackTime] : nil);
    m_curSelectCarCondition.m_givebackCity = (condition.m_givebackCity ? [NSString stringWithFormat:@"%@", condition.m_givebackCity] : nil);
    m_curSelectCarCondition.m_givebackBranche = (condition.m_givebackBranche ? [NSString stringWithFormat:@"%@", condition.m_givebackBranche] : nil);
    m_curSelectCarCondition.m_givebackBrancheId = (condition.m_givebackBrancheId ? [NSString stringWithFormat:@"%@", condition.m_givebackBrancheId] : nil);
    
    m_curSelectCarCondition.m_bNeedReqBranchId = NO;
    if (m_curSelectCarCondition.m_takeBrancheId == nil || [m_curSelectCarCondition.m_takeBrancheId length] == 0)
    {
        m_curSelectCarCondition.m_bNeedReqBranchId = YES;
    }
}

-(UserSelectCarCondition *)getCurSelectCarConditon
{
    return m_curSelectCarCondition;
}



#pragma mark - set car info (in accord with selectCarsByCondition)

/**
 *方法描述：设置车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setCarInfo:(CarInfo *)car
{
    if (nil == m_selectedCar)
    {
        m_selectedCar = [[CarInfo alloc] init];
    }
    
    m_selectedCar.m_dayPrice = [NSString stringWithFormat:@"%@", car.m_dayPrice];
    m_selectedCar.m_unitPrice = [NSString stringWithFormat:@"%@", car.m_unitPrice];
    m_selectedCar.m_plateNum = [NSString stringWithFormat:@"%@", car.m_plateNum];
    m_selectedCar.m_model = [NSString stringWithFormat:@"%@", car.m_model];
    m_selectedCar.m_id = [NSString stringWithFormat:@"%@", car.m_id];
    m_selectedCar.m_carseries = [NSString stringWithFormat:@"%@", car.m_carseries];
}

/**
 *方法描述：获取车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(CarInfo *)getCarInfo
{
    return m_selectedCar;
}


#pragma mark - Order

/**
 *方法描述：设置当前订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setCurrentOrderData:(srvOrderData *)curData
{
    if (curData == nil) {
        m_curOrder = nil;
        return;
    }
    
    if (nil == m_curOrder)
    {
        m_curOrder = [[srvOrderData alloc] init];
    }
    
    m_curOrder.m_orderId = [NSString stringWithFormat:@"%@", curData.m_orderId];//id
    m_curOrder.m_orderNum = [NSString stringWithFormat:@"%@", curData.m_orderNum];//订单号
    m_curOrder.m_uid = [NSString stringWithFormat:@"%@", curData.m_uid];//用户id
    m_curOrder.m_carId = [NSString stringWithFormat:@"%@", curData.m_carId];//车辆id
    m_curOrder.m_takeNet = [NSString stringWithFormat:@"%@", curData.m_takeNet];//驱车网点
    m_curOrder.m_backNet = [NSString stringWithFormat:@"%@", curData.m_backNet];//预定还车网点
    m_curOrder.m_takeTime = [NSString stringWithFormat:@"%@", curData.m_takeTime];//取车时间
    m_curOrder.m_truebackTime = [NSString stringWithFormat:@"%@", curData.m_truebackTime];//实际还车时间
    m_curOrder.m_returnTime = [NSString stringWithFormat:@"%@", curData.m_returnTime];//还车时间
    m_curOrder.m_reserveTime = [NSString stringWithFormat:@"%@", curData.m_reserveTime];//预定时长
    m_curOrder.m_trueTime = [NSString stringWithFormat:@"%@", curData.m_trueTime];//实际租车时长
    m_curOrder.m_mileage = [NSString stringWithFormat:@"%@", curData.m_mileage];//里程数
    m_curOrder.m_status = [NSString stringWithFormat:@"%@", curData.m_status];// 0预定 1生效 2取消 3租金结算 4全部结算
    m_curOrder.m_totalPrice = [NSString stringWithFormat:@"%@", curData.m_totalPrice];//结算总额
    m_curOrder.m_endTime = [NSString stringWithFormat:@"%@", curData.m_endTime];//订单结算完成时间
    m_curOrder.m_creatTime = [NSString stringWithFormat:@"%@", curData.m_creatTime];//订单创建时间
    m_curOrder.m_deposit = [NSString stringWithFormat:@"%@", curData.m_deposit];//预付费总额
    m_curOrder.m_effectTime = [NSString stringWithFormat:@"%@", curData.m_effectTime];//生效时间
    m_curOrder.m_invoice = [NSString stringWithFormat:@"%@", curData.m_invoice];//是否需要发票
    m_curOrder.m_inspection = [NSString stringWithFormat:@"%@", curData.m_inspection];//是否已巡检
    m_curOrder.m_backMethod = [NSString stringWithFormat:@"%@", curData.m_backMethod];//还车方式
    m_curOrder.m_damageCost = [NSString stringWithFormat:@"%@", curData.m_damageCost];//车损金
    m_curOrder.m_peccancyCost = [NSString stringWithFormat:@"%@", curData.m_peccancyCost];//违章金
    m_curOrder.m_lateCost = [NSString stringWithFormat:@"%@", curData.m_lateCost];//延时费
    m_curOrder.m_dispatchCost = [NSString stringWithFormat:@"%@", curData.m_dispatchCost];//调度费
    m_curOrder.m_mileageCost = [NSString stringWithFormat:@"%@", curData.m_mileageCost];//里程费
    m_curOrder.m_mileageDeposit = [NSString stringWithFormat:@"%@", curData.m_mileageDeposit];//里程预付费
    m_curOrder.m_timeDeposit = [NSString stringWithFormat:@"%@", curData.m_timeDeposit];//时长预付费
    m_curOrder.m_dispatchDeposit = [NSString stringWithFormat:@"%@", curData.m_dispatchDeposit];//调度预付费
    m_curOrder.m_damageDeposit = [NSString stringWithFormat:@"%@", curData.m_damageDeposit];//车损预付
    m_curOrder.m_peccancyDeposit = [NSString stringWithFormat:@"%@", curData.m_peccancyDeposit];//违章预付
    m_curOrder.m_model = [NSString stringWithFormat:@"%@", curData.m_model];//车型
    m_curOrder.m_plateNum = [NSString stringWithFormat:@"%@", curData.m_plateNum];//车牌
    m_curOrder.m_carDesc = [NSString stringWithFormat:@"%@", curData.m_carDesc];//车辆信息
    m_curOrder.m_totalDeposit = [NSString stringWithFormat:@"%@", curData.m_totalDeposit];//总预付款
}


/**
 *方法描述：返回当前订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(srvOrderData *)getCurrentOrderData
{
    return m_curOrder;
}



/**
 *方法描述：根据订单获取订单状态
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getStatusWithRspData:(srvOrderData *)data
{
    return [self getStatusWithRspStatus:data.m_status];
}



/**
 *方法描述：根据返回订单状态获取对应状态字串
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getStatusWithRspStatus:(NSString *)rspStatus
{
    NSString *ret;// 0预定 1生效 2取消 3租金结算 4全部结算
    
    switch ([rspStatus integerValue]) {
        case 0:
            ret = [NSString stringWithFormat:@"%@", STR_ORDER_STATUS_NORMAL];// = "待结算";
            break;
        case 1:
            ret = [NSString stringWithFormat:@"%@", STR_ORDER_STATUS_NORMAL];// = "待结算";
            break;
        case 2:
            ret = [NSString stringWithFormat:@"%@",STR_ORDER_STATUS_UNSUBSCRIBE];//"已退订";
            break;
        case 3:
            ret = [NSString stringWithFormat:@"%@",STR_ORDER_STATUS_PAYED];// = "租金已结算";
            break;
        case 4:
            ret = [NSString stringWithFormat:@"%@",STR_ORDER_STATUS_FINISHED];//"订金结算完成";
            break;
        case 5:
            ret = [NSString stringWithFormat:@"%@",STR_ORDER_STATUS_RENEW]; // = "已续订";
            break;
        case 6:
            ret = [NSString stringWithFormat:@"%@",STR_ORDER_STATUS_DELAY];// = "已延时";
            break;
        default:
            ret = nil;
            break;
    }
    
    return ret;
}



/**
 *方法描述：设置续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
/*
 renewOrderList =     (
 {
 creatTime = "2014-10-14+18:28:09.0";
 deposit = 230;
 id = "6b885490-311e-431b-9f2c-b96e3f24a186";
 mileageDeposit = 100;
 newtime = "2014-10-14+18:58:00.0";
 oldtime = "2014-10-14+16:58:00.0";
 orderId = njdd3201410000005;
 time = "";
 timeDeposit = 130;
 },
 {
 creatTime = "2014-10-15+09:52:36.0";
 deposit = 230;
 id = "949947af-0756-4c24-b3ea-ac6aa92ee50c";
 mileageDeposit = 100;
 newtime = "2014-10-14+19:58:00.0";
 oldtime = "2014-10-14+18:58:00.0";
 orderId = njdd3201410000005;
 time = "1.5";
 timeDeposit = 130;
 }
 );
*/
-(void)setOrderRenewList:(NSDictionary *)srvData
{
    if(nil == srvData)
    {
        m_orderRenewList = nil;
        return;
    }
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSArray *srvDataArray = [srvData objectForKey:@"renewOrderList"];
    if (nil != srvDataArray)
    {
        NSInteger nCount = [srvDataArray count];
        for (NSInteger i = 0; i < nCount; i++)
        {
            srvRenewData * tmpData = [[srvRenewData alloc] init];
            [tmpData setRenewData:[srvDataArray objectAtIndex:i]];
            
            [tmpArr addObject:tmpData];
        }
        
        m_orderRenewList = [[NSArray alloc] initWithArray:tmpArr];
    }
}

/**
 *方法描述：返回续订记录
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSArray *)getOrderRenewList
{
    return m_orderRenewList;
}


@end
