//
//  UserRecordController.h
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"

/*
  优惠卷使用记录Controller
 */

@interface UserRecordController : NavController
{
    IBOutlet UITableView *table_useRecord;
    IBOutlet UIView *vi_bottom;
    IBOutlet UILabel *lab_saveMoney;//节省的金钱
    NSArray *list_coupons;
}

@end
