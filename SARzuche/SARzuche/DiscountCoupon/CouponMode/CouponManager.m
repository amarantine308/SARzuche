//
//  CouponManager.m
//  SARzuche
//
//  Created by dyy on 14-10-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CouponManager.h"

@implementation CouponManager

+ (instancetype)sharedInstance
{
    static CouponManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CouponManager alloc] init];
    });
    return manager;
}



@end
