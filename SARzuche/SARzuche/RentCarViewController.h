//
//  RentCarViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "RentCarCell.h"
#import "RentCarView.h"
#import "CommonTableView.h"


@interface RentCarViewController : NavController<UITableViewDataSource,UITableViewDelegate,RentCarCellDelegate,RentCarViewDelegate,CommonTableViewDelegate>
{
    CommonTableView *_table;
    RentCarView *vi_rentCar;//企业意向详情
    NSMutableArray *list_intensionlist;
    NSArray *list_tenancy;
    NSString *_totalCount;
}
@end
