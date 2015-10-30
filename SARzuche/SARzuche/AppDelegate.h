//
//  AppDelegate.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "BMapKit.h"
#import "LaunchLoadingViewController.h"
#import "NetworkStatusView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, LaunchLoadingViewDelegate>
{
    NetworkStatusView *newworkView;
//    BMKMapManager *mapManager;
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UINavigationController *navigationController;

@property (strong, nonatomic) DDMenuController *menuController;
@end
