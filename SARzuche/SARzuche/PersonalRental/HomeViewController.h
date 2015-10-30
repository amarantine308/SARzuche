//
//  HomeViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "HomeView.h"


@interface HomeViewController : NavController<HomeViewDelegate>

-(void)enterPersonalRental;
-(void)enterCompanyRental;
-(void)enterBranches;
-(void)enterMyInfo;
-(void)enterMyCar;
-(void)enterPreferential;
-(void)enterMyOrder;
-(void)enterHelper;
-(void)enterPreRentl;
@end
