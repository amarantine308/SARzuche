//
//  MyAccount.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyAccount.h"
#import "DTApiBaseBean.h"


@implementation MyAccount
//{ account：{
//    “uid”:“用户id
//    “id”:”账户id
//    “usefull”:可用余额
//    “frezee”:冻结资金
//    “status”:账户状态
//}
//}
-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        id obj=[dict objectForKey:@"uid"];\
        if([obj isKindOfClass:[NSString class]]) self.uid = obj;\
        else if ([obj isKindOfClass:[NSNumber class]]) self.uid = [NSString stringWithFormat:@"%@", obj];\
        else self.uid = @"";\
        
		DTAPI_DICT_ASSIGN_STRING(uid, @"");
		DTAPI_DICT_ASSIGN_STRING(id, @"");
		DTAPI_DICT_ASSIGN_STRING(usefull, @"");
		DTAPI_DICT_ASSIGN_STRING(freeze, @"");
		DTAPI_DICT_ASSIGN_STRING(status, @"");
		        
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(uid);
    DTAPI_DICT_EXPORT_BASICTYPE(id);
	DTAPI_DICT_EXPORT_BASICTYPE(usefull);
	DTAPI_DICT_EXPORT_BASICTYPE(freeze);
	DTAPI_DICT_EXPORT_BASICTYPE(status);

    return md;
}

@end
