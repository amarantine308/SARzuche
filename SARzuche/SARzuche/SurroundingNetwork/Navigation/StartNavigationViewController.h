//
//  StartNavigationViewController.h
//  SARzuche
//
//  Created by admin on 14-9-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "NavController.h"
#import "BNCoreServices.h"

@interface StartNavigationViewController : NavController<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKRouteSearchDelegate, BNNaviRoutePlanDelegate, BNNaviUIManagerDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, BMKGeneralDelegate>

@property(nonatomic, strong)NSMutableDictionary *locationDic;

- (id)init:(int)type;

@end
