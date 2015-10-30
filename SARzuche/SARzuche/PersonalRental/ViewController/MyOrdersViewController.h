//
//  MyOrdersViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "ShortMenuView.h"
#import "HistoryOrdersView.h"
#import "BLNetworkManager.h"
#import "CurrentOrderView.h"
#import "UnsubscribeOrderView.h"
#import "RenewOrderViewController.h"
#import "ModifyOrderViewController.h"

@interface MyOrdersViewController : NavController<ShortMenuViewDelegate, HistoryOrdersViwDelegate, FMNetworkProtocol, CurrentOrderViewDelegate, UnsubOrderViewDelegate, RenewOrderViewControllerDelegate,ModifyOrderViewDelegate>

@end
