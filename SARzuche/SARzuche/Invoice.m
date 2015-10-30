//
//  Invoice.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "Invoice.h"

@implementation Invoice
/*
 {
 invoices =     (
 {
 "apply_time" = "2014-10-20+16:50:45.0";
 "express_co" = "";
 "express_id" = "";
 id = 4;
 "invoice_title" = 123321;
 "order_id" = njdd23201410000005;
 price = "1000.00";
 "recip_address" = "\U6c5f\U82cf\U7701\U5357\U4eac\U5e02\U8f6f\U4ef6\U5927\U9053170\U53f7";
 "recip_name" = "\U51af\U6bc5\U6f47";
 "recip_number" = 18066108998;
 status = 0;
 uid = 23;
 }
 );
 }
 */
-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(apply_time, @"");
		DTAPI_DICT_ASSIGN_STRING(express_co, @"");
		DTAPI_DICT_ASSIGN_STRING(express_id, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(invoice_title, @"");
		DTAPI_DICT_ASSIGN_STRING(order_id, @"");
		DTAPI_DICT_ASSIGN_STRING(price, @"");
		DTAPI_DICT_ASSIGN_STRING(recip_address, @"");
		DTAPI_DICT_ASSIGN_STRING(recip_name, @"");
        DTAPI_DICT_ASSIGN_STRING(recip_number, @"");
        DTAPI_DICT_ASSIGN_STRING(status, @"");
        DTAPI_DICT_ASSIGN_STRING(uid, @"");
        
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(apply_time);
	DTAPI_DICT_EXPORT_BASICTYPE(express_co);
	DTAPI_DICT_EXPORT_BASICTYPE(express_id);
	DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(invoice_title);
	DTAPI_DICT_EXPORT_BASICTYPE(order_id);
	DTAPI_DICT_EXPORT_BASICTYPE(price);
	DTAPI_DICT_EXPORT_BASICTYPE(recip_address);
	DTAPI_DICT_EXPORT_BASICTYPE(recip_name);
    DTAPI_DICT_EXPORT_BASICTYPE(recip_number);
    DTAPI_DICT_EXPORT_BASICTYPE(status);
    DTAPI_DICT_EXPORT_BASICTYPE(uid);
    
    return md;
}

@end
