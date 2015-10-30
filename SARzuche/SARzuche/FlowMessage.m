//
//  FlowMessage.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-11-10.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FlowMessage.h"
#import "DTApiBaseBean.h"


@implementation FlowMessage
-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
        DTAPI_DICT_ASSIGN_STRING(flowId, @"");
        DTAPI_DICT_ASSIGN_STRING(tn, @"");
        
        
    }
    
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    DTAPI_DICT_EXPORT_BASICTYPE(flowId );
    DTAPI_DICT_EXPORT_BASICTYPE(tn);
        return md;
}

@end
