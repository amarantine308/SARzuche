//
//  BranchesViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import <CoreLocation/CoreLocation.h>
#import "BranchesTableView.h"
#import "SearchBranchesResultViewController.h"

typedef NS_ENUM(NSInteger, BranchesViewEnterType)
{
    BranchesViewFromPersonalRetal,
    BranchesViewFromBaiduMap
};

@protocol BranchesViewControllerDelegate <NSObject>

//-(void)selBrancheFromController:(NSString *)brancheName withId:(NSString *)brancheId;
-(void)selBrancheFromController:(NSDictionary *)branchData;
@optional
-(void)selBrancheForMapView:(NSDictionary *)brancheData;

@end

@interface BranchesViewController : NavController<CLLocationManagerDelegate, BranchesTableViewDelegate, SearchBranchesResultViewControllerDelegate>

@property(nonatomic, weak)id<BranchesViewControllerDelegate> delegate;
@property(nonatomic, assign)BranchesViewEnterType enterType;
@end
