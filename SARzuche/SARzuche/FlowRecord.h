//
//  FlowRecord.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-27.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FMBean.h"

@interface FlowRecord : FMBean
/*
 {
    flows =     (
                 {
                     "advance_amount" = 1000;
                     "advance_change" = "-330";
                     "avaliable_amount" = 8660;
                     "avaliable_change" = 330;
                     "bank_name" = "";
                     "card_number" = "";
                     "card_style" = "";
                     "charge_amount" = "";
                     "charge_channel" = "";
                     "charge_flow_id" = "";
                     "charge_status" = "";
                     "flow_id" = 201410242000004;
                     "flow_type" = "\U6263\U9664\U65f6\U957f\U8d39";
                     freeze = 0;
                     id = "11daf6c4-3087-47b0-b46e-1a494b3f3d9e";
                     "operate_by" = "";
                     orderNum = njdd2201410000002;
                     "order_id" = 1;
                     remarks = "";
                     "third_flow_id" = "";
                     time = "2014-10-24+10:15:32.0";
                     uid = 23;
                     "withdraw_amount" = "";
                     "withdraw_channel" = "";
                     "withdraw_status" = "";
                 },
                 {
                     "advance_amount" = 0;
                     "advance_change" = 0;
                     "avaliable_amount" = 1992194;
                     "avaliable_change" = 1;
                     "bank_name" = "";
                     "card_number" = "";
                     "card_style" = "";
                     "charge_amount" = "";
                     "charge_channel" = "";
                     "charge_flow_id" = "";
                     "charge_status" = "";
                     "flow_id" = "";
                     "flow_type" = "\U51bb\U7ed3\U9884\U4ed8\U6b3e";
                     freeze = 0;
                     id = 27f5cb422ed54c5cae1bf7dd0f3cd594;
                     "operate_by" = "";
                     orderNum = "";
                     "order_id" = "";
                     remarks = "";
                     "third_flow_id" = "";
                     time = "2014-10-25+00:32:46.0";
                     uid = 23;
                     "withdraw_amount" = "";
                     "withdraw_channel" = "";
                     "withdraw_status" = "";
                 }
                 );
    total = 2;
}
*/
@property (nonatomic , copy) NSString *advance_amount;//可用余额此次变化后金额
@property (nonatomic , copy) NSString *advance_change;//可用余额此次变化金额
@property (nonatomic , copy) NSString *avaliable_amount;//冻结金额此次变化后金额
@property (nonatomic , copy) NSString *avaliable_change;//冻结金额此次变化金额
@property (nonatomic , copy) NSString *bank_name;//
@property (nonatomic , copy) NSString *card_number;//
@property (nonatomic , copy) NSString *card_style;//
@property (nonatomic , copy) NSString *charge_amount;//提现金额
@property (nonatomic , copy) NSString *charge_channel;//充值渠道
@property (nonatomic , copy) NSString *charge_flow_id;//
@property (nonatomic , copy) NSString *charge_status;//充值状态
@property (nonatomic , copy) NSString *flow_id;//流水号
@property (nonatomic , copy) NSString *flow_type;//
@property (nonatomic , copy) NSString *freeze;//
@property (nonatomic , copy) NSString *operate_by;//
@property (nonatomic , copy) NSString *remarks;//
@property (nonatomic , copy) NSString *withdraw_amount;//提现金额
@property (nonatomic , copy) NSString *withdraw_channel;//提现渠道
@property (nonatomic , copy) NSString *withdraw_status;//提现状态
@property (nonatomic , copy) NSString *id; //流水id
@property (nonatomic , copy) NSString *orderNum;//订单号
@property (nonatomic , copy) NSString *order_id;//,订单id
@property (nonatomic , copy) NSString *third_flow_id;// 第三方流水号
@property (nonatomic , copy) NSString *time;//,创建时间


@end
