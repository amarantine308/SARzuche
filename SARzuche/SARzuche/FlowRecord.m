//
//  FlowRecord.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-27.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FlowRecord.h"
#import "DTApiBaseBean.h"


@implementation FlowRecord
/*
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

 };

 */
-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(advance_amount, @"");
		DTAPI_DICT_ASSIGN_STRING(advance_change, @"");
		DTAPI_DICT_ASSIGN_STRING(avaliable_amount, @"");
		DTAPI_DICT_ASSIGN_STRING(avaliable_change, @"");
        DTAPI_DICT_ASSIGN_STRING(bank_name, @"");
        DTAPI_DICT_ASSIGN_STRING(card_number, @"");
        DTAPI_DICT_ASSIGN_STRING(card_style, @"");
        DTAPI_DICT_ASSIGN_STRING(charge_amount, @"");
        DTAPI_DICT_ASSIGN_STRING(charge_channel, @"");
        DTAPI_DICT_ASSIGN_STRING(charge_flow_id, @"");
        DTAPI_DICT_ASSIGN_STRING(charge_status, @"");
        DTAPI_DICT_ASSIGN_STRING(flow_id, @"");
        DTAPI_DICT_ASSIGN_STRING(flow_type, @"");
        DTAPI_DICT_ASSIGN_STRING(freeze, @"");
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(operate_by, @"");
        DTAPI_DICT_ASSIGN_STRING(orderNum, @"");
		DTAPI_DICT_ASSIGN_STRING(order_id, @"");
		DTAPI_DICT_ASSIGN_STRING(remarks, @"");
        DTAPI_DICT_ASSIGN_STRING(third_flow_id, @"");
        DTAPI_DICT_ASSIGN_STRING(time, @"");
        DTAPI_DICT_ASSIGN_STRING(withdraw_amount, @"");
		DTAPI_DICT_ASSIGN_STRING(withdraw_channel, @"");
		DTAPI_DICT_ASSIGN_STRING(withdraw_status, @"");

    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(advance_amount);
    DTAPI_DICT_EXPORT_BASICTYPE(advance_change);
	DTAPI_DICT_EXPORT_BASICTYPE(avaliable_amount);
	DTAPI_DICT_EXPORT_BASICTYPE(avaliable_change);
	DTAPI_DICT_EXPORT_BASICTYPE(bank_name);
    DTAPI_DICT_EXPORT_BASICTYPE(card_number);
	DTAPI_DICT_EXPORT_BASICTYPE(card_style);
	DTAPI_DICT_EXPORT_BASICTYPE(charge_amount);
	DTAPI_DICT_EXPORT_BASICTYPE(charge_channel);
	DTAPI_DICT_EXPORT_BASICTYPE(charge_flow_id);
	DTAPI_DICT_EXPORT_BASICTYPE(charge_status);
    DTAPI_DICT_EXPORT_BASICTYPE(flow_id);
	DTAPI_DICT_EXPORT_BASICTYPE(flow_type);
	DTAPI_DICT_EXPORT_BASICTYPE(freeze);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(operate_by);
	DTAPI_DICT_EXPORT_BASICTYPE(orderNum);
	DTAPI_DICT_EXPORT_BASICTYPE(order_id);
	DTAPI_DICT_EXPORT_BASICTYPE(remarks);
	DTAPI_DICT_EXPORT_BASICTYPE(third_flow_id);
    DTAPI_DICT_EXPORT_BASICTYPE(time);
	DTAPI_DICT_EXPORT_BASICTYPE(withdraw_amount);
	DTAPI_DICT_EXPORT_BASICTYPE(withdraw_channel);
	DTAPI_DICT_EXPORT_BASICTYPE(withdraw_status);



    
    return md;
}
@end
