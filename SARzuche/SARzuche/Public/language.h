//
//  language.h
//  lan
//
//  Created by china on 14-8-7.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LANGUAGE_EN     @"en"
#define LANGUAGE_CHS    @"zh-Hans"

@interface language : NSObject

+(NSString *)getLocalString:(NSString *)str;
@end
