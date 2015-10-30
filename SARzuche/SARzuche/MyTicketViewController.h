//
//  MyTicketViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "CommonTableView.h"

@interface MyTicketViewController : NavController<UITableViewDelegate, UITableViewDataSource, CommonTableViewDelegate>
{
    CommonTableView *pTableView;
    NSMutableArray *pDataSource;
    
}

@end
