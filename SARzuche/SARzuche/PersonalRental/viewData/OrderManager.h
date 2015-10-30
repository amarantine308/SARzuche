//
//  OrderManager.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNetworkManager.h"
#import "MyOrdersData.h"

typedef NS_ENUM(NSInteger, orderStatus) // 订单状态（需要根据时间来区别于存于服务器当前订单状态）
{
    orderNormal,
    orderUnsubscribe,
    orderSubscribe,
    orderRenew,
    orderDelay,
    orderPayed,
    orderFinished
};

#pragma mark - user select car condition
@interface UserSelectCarCondition : NSObject//分时租车条件选择

@property(nonatomic, strong)NSString *m_takeCity;
@property(nonatomic, strong)NSString *m_takeBranche;
@property(nonatomic, strong)NSString *m_takeBrancheId;
@property(nonatomic, strong)NSString *m_takeTime;
@property(nonatomic, strong)NSString *m_givebackCity;
@property(nonatomic, strong)NSString *m_givebackBranche;
@property(nonatomic, strong)NSString *m_givebackBrancheId;
@property(nonatomic, strong)NSString *m_givebackTime;
@property(nonatomic)BOOL m_bNeedReqBranchId;// 分时租车页面未带入网点id，频繁查看切换搜索到的车辆
@end

#pragma mark - user car info
@interface CarInfo :NSObject// 分时租车选择车辆信息

@property(nonatomic, strong)NSString *m_carseries;
@property(nonatomic, strong)NSString *m_dayPrice;
@property(nonatomic, strong)NSString *m_id;
@property(nonatomic, strong)NSString *m_model;
@property(nonatomic, strong)NSString *m_plateNum;
@property(nonatomic, strong)NSString *m_unitPrice;

@end


#pragma mark - OrderManager
/**
 *方法描述：目前只适用于当前订单流程（下订单和当前订单）
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
@interface OrderManager : NSObject<FMNetworkProtocol>
{
    UserSelectCarCondition * m_curSelectCarCondition;
    CarInfo *m_selectedCar;//
    
    // current order
    srvOrderData *m_curOrder;
    
    // history order
    srvOrderData *m_selHistoryOrder;
    
    // order renew list
    NSArray *m_orderRenewList; //object  "srvRenewData"
}


+(OrderManager *)ShareInstance;

-(void)renewOrder;
-(void)cancelOrder;
-(void)submitOrder;

// select condition
-(void)setSelectCarCondition:(UserSelectCarCondition *)condition;
-(UserSelectCarCondition *)getCurSelectCarConditon;
// select car
-(void)setCarInfo:(CarInfo *)car;
-(CarInfo *)getCarInfo;

#pragma mark - order data
-(void)setCurrentOrderData:(srvOrderData *)curData;
-(srvOrderData *)getCurrentOrderData;
-(NSString *)getStatusWithRspData:(srvOrderData *)data;
-(NSString *)getStatusWithRspStatus:(NSString *)rspStatus;

-(void)setOrderRenewList:(NSDictionary *)srvData;
-(NSArray *)getOrderRenewList;
@end
