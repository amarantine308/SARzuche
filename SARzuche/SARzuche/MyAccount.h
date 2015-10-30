//
//  MyAccount.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FMBean.h"

@interface MyAccount : FMBean
//{ account：{
//    “uid”:“用户id
//    “id”:”账户id
//    “usefull”:可用余额
//    “freeze”:冻结资金
//    “status”:账户状态
//}
//}

//  {  account =  {
//        freeze = 0;
//        id = 5;
//        status = 0;
//        uid = 23;
//        usefull = 2000000;
//    };
//}

@property (nonatomic ,copy) NSString *uid;
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *usefull;
@property (nonatomic ,copy) NSString *freeze;
@property (nonatomic ,copy) NSString *status;

-(id)initWithDictionary:(NSDictionary*)dict;
@end
