//
//  MyAccountViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "LoadingClass.h"

@interface MyAccountViewController :NavController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *_container1;
    IBOutlet UIView *_container2;
    IBOutlet UITableView *_table;
    
    __weak IBOutlet UILabel *prepay;//预付款
    __weak IBOutlet UILabel *sumPrice;//总金额
    __weak IBOutlet UILabel *availeMoney;//可用余额
    
    NSMutableArray *pdataSource;
}
- (IBAction)detailAction:(id)sender;//查看详情
- (IBAction)chargeAction:(id)sender;//充值
- (IBAction)drawCashAction:(id)sender;//提现



@end
