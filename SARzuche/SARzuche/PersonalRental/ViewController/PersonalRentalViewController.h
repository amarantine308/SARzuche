//
//  PersonalRentalViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "DateSelectView.h"
#import "BranchesViewController.h"

@interface PersonalRentalViewController : NavController<DateSelectViewDelegate, BranchesViewControllerDelegate>


-(void)setSelBranche:(NSDictionary *)branchDic;
@end
