//
//  CouponInfoController.h
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"

@interface CouponInfoController : NavController

@property (weak, nonatomic) IBOutlet UILabel *m_name;
@property (strong, nonatomic) IBOutlet UILabel *m_id;
@property (strong, nonatomic) IBOutlet UILabel *m_type;
@property (strong, nonatomic) IBOutlet UILabel *m_validTime;
@property (strong, nonatomic) IBOutlet UILabel *m_scope;
@property (strong, nonatomic) IBOutlet UILabel *m_carMode;
@property (strong, nonatomic) IBOutlet UILabel *m_leftNum;
@property (strong, nonatomic) IBOutlet UITextView *m_desc;


-(void)setCouponData:(NSDictionary *)dic;
@end
