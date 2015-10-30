//
//  PreferentialCouponViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "CouponCell.h"
#import "SelectCouponView.h"

@interface PreferentialCouponViewController : NavController<UITableViewDataSource, UITableViewDelegate, SelectCouponViewDelegate, CouponCellDelegate>

@end
