//
//  ViewSelectOrderViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "OrderManager.h"
#import "CurrentOrderView.h"

@interface ViewSelectOrderViewController : NavController<CurrentOrderViewDelegate>


-(id)initWithOrder:(srvOrderData *)orderData;
@end
