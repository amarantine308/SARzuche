//
//  MyOrdersData.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyOrdersData.h"
#import "JSON.h"
#import "ConstDefine.h"
#import "PublicFunction.h"


#pragma mark - MyOrderData
@implementation srvOrderData
@synthesize m_uid;
@synthesize m_backMethod;
@synthesize m_backNet;
@synthesize m_backNetName;
@synthesize m_carDesc;
@synthesize m_carId;
@synthesize m_creatTime;
@synthesize m_damageCost;
@synthesize m_damageDeposit;
@synthesize m_deposit;
@synthesize m_dispatchCost;
@synthesize m_dispatchDeposit;
@synthesize m_effectTime;
@synthesize m_endTime;
@synthesize m_inspection;
@synthesize m_invoice;
@synthesize m_lateCost;
@synthesize m_mileage;
@synthesize m_mileageCost;
@synthesize m_mileageDeposit;
@synthesize m_model;
@synthesize m_orderId;
@synthesize m_orderNum;
@synthesize m_peccancyCost;
@synthesize m_peccancyDeposit;
@synthesize m_plateNum;
@synthesize m_reserveTime;
@synthesize m_returnTime;
@synthesize m_status;
@synthesize m_takeNet;
@synthesize m_takeNetName;
@synthesize m_takeTime;
@synthesize m_timeDeposit;
@synthesize m_totalPrice;
@synthesize m_truebackTime;
@synthesize m_trueTime;
@synthesize m_timeCost;
@synthesize m_cancelTime;
@synthesize m_totalDeposit;
@synthesize m_newReturnTime;
@synthesize m_token;
@synthesize m_updateTime;
@synthesize m_lateLong;
// 根据请求返回初始化
-(id)initWithRequest:(FMNetworkRequest *)request
{
    self = [[srvOrderData alloc] init];
    if (nil != self) {
        [self getDataWithRequest:request];
    }
    return self;
}
// 根据返回订单初始化
-(id)initWithOriginalData:(NSDictionary*)orderData
{
    self = [[srvOrderData alloc] init];
    if (nil != self) {
        [self extractMyOrderData:orderData];
    }
    
    return self;
}
// 解析我的订单数据
-(void)getDataWithRequest:(FMNetworkRequest *)request
{
    [self extractMyOrderData:request.responseData];
}
// 解析我的订单数据
-(void)extractMyOrderData:(NSDictionary*)returnData
{
    if (nil == returnData) {
        return;
    }
//    NSDictionary *dic = [returnData JSONValue];
    NSDictionary *dicData = [returnData objectForKey:@"order"];
    if (nil == dicData) {
        dicData = returnData;
    }
    if (dicData) {
        
        m_orderId = [dicData objectForKey:@"id"];//id
        m_orderNum = [dicData objectForKey:@"orderNum"];//订单号
        m_uid = [dicData objectForKey:@"uid"];
        m_carId = [dicData objectForKey:@"carId"];//车辆id
        m_takeNet = [dicData objectForKey:@"takeNet"];//取车网点
        m_backNet = [dicData objectForKey:@"backNet"];//预定还车网点
        m_takeTime = [dicData objectForKey:@"takeTime"];//取车时间
        m_truebackTime = [dicData objectForKey:@"truebackTime"];//实际还车时间
        m_returnTime = [dicData objectForKey:@"returnTime"];//还车时间
        m_reserveTime = [dicData objectForKey:@"reserveTime"];//预定时长
        m_trueTime = [dicData objectForKey:@"trueTime"];//实际租车时长
        m_mileage = [dicData objectForKey:@"mileage"];//里程数
        m_status = [dicData objectForKey:@"status"];// 0预定 1生效 2取消 3租金结算 4全部结算
        m_totalPrice = [dicData objectForKey:@"totalPrice"];//结算总额
        m_endTime = [dicData objectForKey:@"endTime"];//订单结算完成时间
        m_creatTime = [dicData objectForKey:@"creatTime"];//订单创建时间
        m_deposit = [dicData objectForKey:@"deposit"];//预付费总额
        m_effectTime = [dicData objectForKey:@"effectTime"];//生效时间
        m_invoice = [dicData objectForKey:@"invoice"];//是否需要发票
        m_inspection = [dicData objectForKey:@"inspection"];//是否已巡检
        m_backMethod = [dicData objectForKey:@"backMethod"];//还车方式
        m_damageCost = [dicData objectForKey:@"damageCost"];//车损金
        m_peccancyCost = [dicData objectForKey:@"peccancyCost"];//违章金
        m_lateCost = [dicData objectForKey:@"lateCost"];//延时费
        m_dispatchCost = [dicData objectForKey:@"dispatchCost"];//调度费
        m_mileageCost = [dicData objectForKey:@"mileageCost"];//里程费
        m_mileageDeposit = [dicData objectForKey:@"mileageDeposit"];//里程预付费
        m_timeCost = [dicData objectForKey:@"timeCost"]; // 时长费
        m_timeDeposit = [dicData objectForKey:@"timeDeposit"];//时长预付费
        m_dispatchDeposit = [dicData objectForKey:@"dispatchDeposit"];//调度预付费
        m_damageDeposit = [dicData objectForKey:@"damageDeposit"];//车损预付
        m_peccancyDeposit = [dicData objectForKey:@"peccancyDeposit"];//违章预付
        m_model = [dicData objectForKey:@"model"];//车型
        m_plateNum = [dicData objectForKey:@"plateNum"];//车牌
        m_carDesc = [dicData objectForKey:@"carDesc"];//车辆信息
        m_cancelTime = [dicData objectForKey:@"cancelTime"];
        m_totalDeposit = GET([dicData objectForKey:@"totalDeposit"]);
        m_newReturnTime = GET([dicData objectForKey:@"newReturnTime"]);
        m_token = [dicData objectForKey:@"token"];
        m_updateTime = [dicData objectForKey:@"updateTime"];
        m_lateLong = [dicData objectForKey:@"lateLong"];
    }
}

// 设置取车网点名称
-(void)setTakeBrancheName:(NSString *)takeBranch
{
    m_takeNetName = [NSString stringWithFormat:@"%@", takeBranch];
}
// 设置还车网点名称
-(void)setGivebackBrancheName:(NSString *)givebackBranch
{
    m_backNetName = [NSString stringWithFormat:@"%@", givebackBranch];
}
@end


#pragma mark - order renew data

@implementation srvRenewData
@synthesize m_creatTime;
@synthesize m_deposit;
@synthesize m_id;
@synthesize m_mileageDeposit;
@synthesize m_newtime;
@synthesize m_oldtime;
@synthesize m_orderId;
@synthesize m_time;
@synthesize m_timeDeposit;

// 设置续订内容
-(void)setRenewData:(NSDictionary *)dicData
{
    m_creatTime =   [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"creatTime"] )];
    m_deposit =     [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"deposit"] )];
    m_id =          [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"id"] )];
    m_mileageDeposit = [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"mileageDeposit"] )];
    m_newtime =     [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"newtime"] )];
    m_oldtime =     [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"oldtime"] )];
    m_orderId =     [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"orderId"] )];
    m_time =        [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"time"] )];
    m_timeDeposit = [NSString stringWithFormat:@"%@", GET([dicData objectForKey:@"timeDeposit"] )];
}

@end


#pragma mark - OrderListData

@implementation OrderListData
//  根据请求返回，初始化
-(id)initWithOriginalData:(NSDictionary *)responseData
{
    self = [[OrderListData alloc] init];
    if (nil != self) {
        [self extractOrdersList:responseData];
    }
    
    return self;
}
//  根据请求返回初始化
-(id)initWithRequest:(FMNetworkRequest *)request
{
    self = [[OrderListData alloc] init];
    if (nil != self) {
        [self getDataWithRequest:request];
    }
    
    return self;
}

// 解析历史订单数据
-(void)getDataWithRequest:(FMNetworkRequest *)request
{
//    NSString *str = [[PublicFunction ShareInstance] decryptDataWithRequest:request];
    [self extractOrdersList:request.responseData];
}


// 解析历史订单数据
-(NSInteger)UpdateDataWithRequest:(FMNetworkRequest *)request
{
    return [self extractOrdersList:request.responseData];
}

// 解析历史订单
-(NSInteger)updateWithOriginalData:(NSDictionary *)responseData
{
    return [self extractOrdersList:responseData];
}

// 解析返回的历史订单数据
-(NSInteger)extractOrdersList:(NSDictionary *)ordersList
{
    if (nil == ordersList) {
        return 0;
    }
    m_totalNumber = [[ordersList objectForKey:@"totalNumber"] integerValue];
    
    NSArray *arrData = [ordersList objectForKey:@"orderList"];
    NSInteger arrCount = [arrData count];
    if (arrData) {
        for (NSInteger i = 0; i < arrCount; i++) {
            NSDictionary *orderDic = [arrData objectAtIndex:i];
            srvOrderData *tmpOrder = [[srvOrderData alloc] initWithOriginalData:orderDic];
            if (nil == m_ordersList) {
                m_ordersList = [[NSMutableArray alloc] init];
            }
            [m_ordersList addObject:tmpOrder];
        }
    }
    
    return arrCount;
}

// 根据索引获取历史订单
-(srvOrderData *)orderDataAtIndex:(NSInteger)index
{
    if (index < [m_ordersList count]) {
       return [m_ordersList objectAtIndex:index];
    }
    
    return nil;
}

// 已经获取到的历史订单数量
-(NSInteger)getOrderListDataNum
{
    return [m_ordersList count];
}
// 返回历史订单总数
-(NSInteger)getOrderListTotalNum
{
    return m_totalNumber;
}

// 移除所有我的历史订单
-(void)removeAll
{
    [m_ordersList removeAllObjects];
}

@end

#pragma mark - getOrderInfoData
@implementation getOrderInfoData
// 根据返回订单数据初始化
-(id)initWithRequest:(FMNetworkRequest *)request
{
    self = [[getOrderInfoData alloc] init];
    if (nil != self) {
        [self getDataWithRequest:request];
    }
    
    return self;
}

// 解析请求返回的我的订单数据
-(id)initWithOriginalData:(NSDictionary *)responseData
{
    self = [[getOrderInfoData alloc] init];
    if (nil != self) {
        [self extractData:responseData];
    }
    
    return self;
}

// 解析请求返回的我的订单数据
-(void)getDataWithRequest:(FMNetworkRequest *)request
{
    [self extractData:request.responseData];
}

// 解析请求返回的我的订单数据
-(void)extractData:(NSDictionary *)responseData
{
    m_order = [[srvOrderData alloc] initWithOriginalData:responseData];
}


@end
