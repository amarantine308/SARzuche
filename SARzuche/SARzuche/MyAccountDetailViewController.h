//
//  MyAccountDetailViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "CommonTableView.h"

@interface MyAccountDetailViewController : NavController<UITableViewDataSource,UITableViewDelegate,CommonTableViewDelegate>
{
    UITableView *_littleTable;
    BOOL _isClose;
    CommonTableView *pTableView;
    NSMutableArray *pDataSource;
    
    NSString *_type;//流水分类“type”:流水类型 1全部 2充值 3提现 4消费


}
@end
