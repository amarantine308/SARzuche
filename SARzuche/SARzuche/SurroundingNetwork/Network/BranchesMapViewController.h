//
//  SBranchViewController.h
//  SARzuche
//
//  Created by admin on 14-9-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
#import "NavController.h"
#import "BranchesViewController.h"

// 周边网点地图页面的上一级页面
typedef NS_ENUM(NSInteger, BranchesMapViewEnterType)
{
    MapViewFromHomeView,        // 首页
    MapViewFromBranchesView,    // 分时租车的选择网点页面
    MapViewFromSelBranch,       // 选择网点地图图标
};

@interface BranchesMapViewController : NavController<BMKMapViewDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, BMKGeneralDelegate, BranchesViewControllerDelegate, CLLocationManagerDelegate>

@property(nonatomic, assign)BranchesMapViewEnterType enterType;
@property(nonatomic, strong)NSMutableArray *branchesArray;  // 用来存放网点列表

- (id)initWithSeleBranch:(NSArray *)branchesArr;
@end

