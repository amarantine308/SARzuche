//
//  LeftViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController :UIViewController <UITableViewDelegate,UITableViewDataSource>
{

    __weak IBOutlet UITableView *_table;
}

@end
