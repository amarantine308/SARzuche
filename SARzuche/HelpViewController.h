//
//  HelpViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"

@interface HelpViewController : NavController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
}
@end
