//
//  FlowMessage.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-11-10.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FMBean.h"

@interface FlowMessage : FMBean

@property (nonatomic , copy) NSString *flowId;//可用余额此次变化后金额
@property (nonatomic , copy) NSString *tn;//可用余额此次变化金额
@end
