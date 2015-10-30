//
//  DiscountCouponController.h
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "PreferentialViewController.h"
#import "MyCouponController.h"

/*
    优惠卷Controller
 */

@interface DiscountCouponController : NavController<MyCouponControllerDelegate,PreferentialViewControllerDelegate>
{
    IBOutlet UILabel *lab_useNum;//使用次数
    IBOutlet UILabel *lab_saveMoney;//节省金钱
    IBOutlet UILabel *lab_coupons;//我的优惠卷
    
    BOOL m_bNeedUpdate;
}

@end
