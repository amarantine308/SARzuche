//
//  User.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-25.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "User.h"

@implementation User

+ (User *)shareInstance
{
    static User *tempUser = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        tempUser = [[User alloc] init];
    });
    return tempUser;
}

-(id)initWithDictionary:(NSDictionary*)dict
{
    if (self = [super init])
    {
		DTAPI_DICT_ASSIGN_STRING(QQ, @"");
		DTAPI_DICT_ASSIGN_STRING(address, @"");
		DTAPI_DICT_ASSIGN_STRING(birthday, @"");
		DTAPI_DICT_ASSIGN_STRING(email, @"");
		DTAPI_DICT_ASSIGN_STRING(headImage, @"");
		DTAPI_DICT_ASSIGN_STRING(nickName, @"");
		DTAPI_DICT_ASSIGN_STRING(name, @"");
		DTAPI_DICT_ASSIGN_STRING(phone, @"");
		DTAPI_DICT_ASSIGN_STRING(sex, @"");
        DTAPI_DICT_ASSIGN_STRING(income, @"");
        DTAPI_DICT_ASSIGN_STRING(id, @"");
        DTAPI_DICT_ASSIGN_STRING(cardno, @"");
        DTAPI_DICT_ASSIGN_STRING(del_flag, @"");
        DTAPI_DICT_ASSIGN_STRING(driverIdImage, @"");
        DTAPI_DICT_ASSIGN_STRING(loginIp, @"");
        DTAPI_DICT_ASSIGN_STRING(logindate, @"");
        DTAPI_DICT_ASSIGN_STRING(logintype, @"");
        DTAPI_DICT_ASSIGN_STRING(password, @"");
        DTAPI_DICT_ASSIGN_STRING(personId, @"");
        DTAPI_DICT_ASSIGN_STRING(personIdImage, @"");
        DTAPI_DICT_ASSIGN_STRING(regDate, @"");
        DTAPI_DICT_ASSIGN_STRING(regway, @"");
        DTAPI_DICT_ASSIGN_STRING(status, @"");
        DTAPI_DICT_ASSIGN_STRING(weixin, @"");
        DTAPI_DICT_ASSIGN_STRING(personIdImage2, @"");
        DTAPI_DICT_ASSIGN_STRING(remark, @"");




    }
       
    return self;
}

-(NSDictionary*)dictionaryValue
{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
	DTAPI_DICT_EXPORT_BASICTYPE(QQ);
	DTAPI_DICT_EXPORT_BASICTYPE(address);
	DTAPI_DICT_EXPORT_BASICTYPE(birthday);
	DTAPI_DICT_EXPORT_BASICTYPE(email);
	DTAPI_DICT_EXPORT_BASICTYPE(headImage);
	DTAPI_DICT_EXPORT_BASICTYPE(nickName);
	DTAPI_DICT_EXPORT_BASICTYPE(name);
	DTAPI_DICT_EXPORT_BASICTYPE(phone);
	DTAPI_DICT_EXPORT_BASICTYPE(sex);
    DTAPI_DICT_EXPORT_BASICTYPE(income);
    DTAPI_DICT_EXPORT_BASICTYPE(id);
    DTAPI_DICT_EXPORT_BASICTYPE(weixin);
    DTAPI_DICT_EXPORT_BASICTYPE(status);
    DTAPI_DICT_EXPORT_BASICTYPE(regway);
    DTAPI_DICT_EXPORT_BASICTYPE(regDate);
    DTAPI_DICT_EXPORT_BASICTYPE(personIdImage);
    DTAPI_DICT_EXPORT_BASICTYPE(personId);
    DTAPI_DICT_EXPORT_BASICTYPE(password);
    DTAPI_DICT_EXPORT_BASICTYPE(logintype);
    DTAPI_DICT_EXPORT_BASICTYPE(logindate);
    DTAPI_DICT_EXPORT_BASICTYPE(loginIp);
    DTAPI_DICT_EXPORT_BASICTYPE(driverIdImage);
    DTAPI_DICT_EXPORT_BASICTYPE(del_flag);
    DTAPI_DICT_EXPORT_BASICTYPE(cardno);
    DTAPI_DICT_EXPORT_BASICTYPE(personIdImage2);
    DTAPI_DICT_EXPORT_BASICTYPE(remark);


    
    return md;
}

@end
