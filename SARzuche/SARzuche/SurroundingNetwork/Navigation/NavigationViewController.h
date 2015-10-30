//
//  NavigationViewController.h
//  SARzuche
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NavController.h"
#import "NavigationView.h"
#import "LocationViewController.h"

// 导航页面的上一级页面
typedef NS_ENUM(NSInteger, NavigationViewEnterType)
{
    NavigationViewFromHomeView,         // 首页
    NavigationViewFromMapView,          // 周边网点地图页面
    NavigationViewFromGasStationView    // 加油站
};

@interface NavigationViewController : NavController<NavigationViewDelegate, LocationViewControllerDelegate, NavigationViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong)NSMutableDictionary *locationsDic;  // 用来保存起点位置和终点位置
@property(nonatomic, assign)NavigationViewEnterType enterType;  // 上一级页面类型

@end
