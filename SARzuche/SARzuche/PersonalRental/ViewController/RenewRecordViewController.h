//
//  RenewRecordViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "OrderManager.h"

@interface RenewRecordViewController : NavController<UITableViewDataSource, UITableViewDelegate>


-(id)initForHistoryRecord:(srvOrderData *)orderData;

@end
