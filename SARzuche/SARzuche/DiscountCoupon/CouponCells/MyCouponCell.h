//
//  MyCouponCell.h
//  DFV
//
//  Created by dyy on 14-10-14.
//  Copyright (c) 2014年 dyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *m_couponName;
@property (strong, nonatomic) IBOutlet UILabel *m_couponTime;
@property (strong, nonatomic) IBOutlet UILabel *m_couponDesc;
@property (strong, nonatomic) IBOutlet UIButton *m_checkboxBtn;
@end
