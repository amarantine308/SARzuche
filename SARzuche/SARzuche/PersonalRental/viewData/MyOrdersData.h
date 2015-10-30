//
//  MyOrdersData.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLNetworkManager.h"

#pragma mark -MyOrderData
// / order / orderinfo
@interface srvOrderData : NSObject
{
}

@property(nonatomic, strong) NSString* m_orderId;//id
@property(nonatomic, strong)NSString* m_orderNum;//订单号
@property(nonatomic, strong)NSString* m_uid;//用户id
@property(nonatomic, strong)NSString* m_carId;//车辆id
@property(nonatomic, strong)NSString* m_takeNet;//驱车网点
@property(nonatomic, strong)NSString* m_backNet;//预定还车网点
@property(nonatomic, strong)NSString* m_takeNetName;//驱车网点
@property(nonatomic, strong)NSString* m_backNetName;//预定还车网点
@property(nonatomic, strong)NSString* m_takeTime;//取车时间
@property(nonatomic, strong)NSString* m_truebackTime;//实际还车时间
@property(nonatomic, strong)NSString* m_returnTime;//还车时间
@property(nonatomic, strong)NSString* m_reserveTime;//预定时长
@property(nonatomic, strong)NSString* m_trueTime;//实际租车时长
@property(nonatomic, strong)NSString* m_mileage;//里程数
@property(nonatomic, strong)NSString* m_status;// 0预定 1生效 2取消 3租金结算 4全部结算
@property(nonatomic, strong)NSString* m_totalPrice;//结算总额
@property(nonatomic, strong)NSString* m_endTime;//订单结算完成时间
@property(nonatomic, strong)NSString* m_creatTime;//订单创建时间
@property(nonatomic, strong)NSString* m_deposit;//预付费总额
@property(nonatomic, strong)NSString* m_effectTime;//生效时间
@property(nonatomic, strong)NSString* m_invoice;//是否需要发票
@property(nonatomic, strong)NSString* m_inspection;//是否已巡检
@property(nonatomic, strong)NSString* m_backMethod;//还车方式
@property(nonatomic, strong)NSString* m_damageCost;//车损金
@property(nonatomic, strong)NSString* m_peccancyCost;//违章金
@property(nonatomic, strong)NSString* m_lateCost;//延时费
@property(nonatomic, strong)NSString* m_lateLong;//延时时长
@property(nonatomic, strong)NSString* m_dispatchCost;//调度费
@property(nonatomic, strong)NSString* m_mileageCost;//里程费
@property(nonatomic, strong)NSString* m_mileageDeposit;//里程预付费
@property(nonatomic, strong)NSString* m_timeCost;//时长费
@property(nonatomic, strong)NSString* m_timeDeposit;//时长预付费
@property(nonatomic, strong)NSString* m_dispatchDeposit;//调度预付费
@property(nonatomic, strong)NSString* m_damageDeposit;//车损预付
@property(nonatomic, strong)NSString* m_peccancyDeposit;//违章预付
@property(nonatomic, strong)NSString* m_model;//车型
@property(nonatomic, strong)NSString* m_plateNum;//车牌
@property(nonatomic, strong)NSString* m_carDesc;//车辆信息
@property(nonatomic, strong)NSString* m_cancelTime;//还车时间
@property(nonatomic, strong)NSString* m_totalDeposit;//总的预付款
@property(nonatomic, strong)NSString* m_newReturnTime;//续订后结束时间
@property(nonatomic, strong)NSString* m_token; // 优惠券优惠金额
@property(nonatomic, strong)NSString* m_updateTime; // 修改时间



-(id)initWithRequest:(FMNetworkRequest *)request;
-(id)initWithOriginalData:(NSDictionary*)responseData;
-(void)setTakeBrancheName:(NSString *)takeBranch;
-(void)setGivebackBrancheName:(NSString *)givebackBranch;
@end


#pragma mark - OrderListData
// ${basePath}/ order/ orderlist
@interface OrderListData : NSObject
{
    NSMutableArray *m_ordersList;
    
    NSInteger m_totalNumber;
}

-(srvOrderData *)orderDataAtIndex:(NSInteger)index;
-(NSInteger)getOrderListDataNum;
-(NSInteger)getOrderListTotalNum;

-(id)initWithRequest:(FMNetworkRequest *)request;
-(id)initWithOriginalData:(NSDictionary *)responseData;
-(NSInteger)UpdateDataWithRequest:(FMNetworkRequest *)request;
-(NSInteger)updateWithOriginalData:(NSDictionary *)responseData;

-(void)removeAll;
@end


#pragma mark - order renew list
@interface srvRenewData : NSObject

@property(nonatomic, strong)NSString *m_creatTime;// = "2014-10-14+18:28:09.0";
@property(nonatomic, strong)NSString *m_deposit;// = 230;
@property(nonatomic, strong)NSString *m_id;// = "6b885490-311e-431b-9f2c-b96e3f24a186";
@property(nonatomic, strong)NSString *m_mileageDeposit;// = 100;
@property(nonatomic, strong)NSString *m_newtime;// = "2014-10-14+18:58:00.0";
@property(nonatomic, strong)NSString *m_oldtime;// = "2014-10-14+16:58:00.0";
@property(nonatomic, strong)NSString *m_orderId;// = njdd3201410000005;
@property(nonatomic, strong)NSString *m_time;// = "1.5";
@property(nonatomic, strong)NSString *m_timeDeposit;// = 130;

-(void)setRenewData:(NSDictionary *)dicData;

@end


#pragma mark - get Order info
//${basePath}/ order /getOrderInfo
@interface getOrderInfoData : NSObject
{
    srvOrderData *m_order;
}

-(id)initWithRequest:(FMNetworkRequest *)request;
-(id)initWithOriginalData:(NSDictionary *)responseData;
@end
