//
//  PreOderViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "DateSelectView.h"
#import "BranchesViewController.h"

@interface PreOderViewController : NavController<DateSelectViewDelegate, BranchesViewControllerDelegate>

-(id)initWithCarData:(NSDictionary *)carData;
-(id)initWithCarId:(NSString *)carId;
-(id)initFromOrderHistory;
@end
