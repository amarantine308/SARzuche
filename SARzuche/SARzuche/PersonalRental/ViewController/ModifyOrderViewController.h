//
//  ModifyOrderViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "DateSelectView.h"
#import "BranchesViewController.h"

@protocol ModifyOrderViewDelegate <NSObject>

-(void)backToPrePage:(BOOL)bUpdateHistory; // 返回到上一页，用于刷新数据

@end

@interface ModifyOrderViewController : NavController<DateSelectViewDelegate, BranchesViewControllerDelegate>

@property(nonatomic, weak)id<ModifyOrderViewDelegate> delegate;

@end
