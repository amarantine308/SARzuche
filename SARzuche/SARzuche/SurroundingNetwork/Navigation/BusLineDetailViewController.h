//
//  BusLineDetailViewController.h
//  SARzuche
//
//  Created by admin on 14-10-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"

@interface BusLineDetailViewController : NavController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *pDataSource;
@property(nonatomic, strong)NSString *startLocation;
@property(nonatomic, strong)NSString *endLocation;
@property(nonatomic, strong)NSString *busLine;
@end
