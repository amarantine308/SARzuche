//
//  EnterpriseInfoViewController.h
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"

@interface EnterpriseInfoViewController : NavController<UITextFieldDelegate>

@property (nonatomic, retain) NSDictionary *dic_data;

@end
