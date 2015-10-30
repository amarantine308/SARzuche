//
//  UserRecordCell.m
//  DFV
//
//  Created by dyy on 14-10-14.
//  Copyright (c) 2014年 dyy. All rights reserved.
//

#import "UserRecordCell.h"

@implementation UserRecordCell
@synthesize lab_couponName;
@synthesize lab_orderNo;
@synthesize lab_paytime;
@synthesize lab_savemoney;
@synthesize btn_click;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
