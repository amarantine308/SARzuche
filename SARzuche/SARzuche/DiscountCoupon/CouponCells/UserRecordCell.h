//
//  UserRecordCell.h
//  DFV
//
//  Created by dyy on 14-10-14.
//  Copyright (c) 2014年 dyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRecordCell : UITableViewCell
{
    IBOutlet UILabel *lab_couponName;
    IBOutlet UILabel *lab_orderNo;
    IBOutlet UILabel *lab_paytime;
    IBOutlet UILabel *lab_savemoney;
    IBOutlet UIButton *btn_click;
}

@property (nonatomic, strong) IBOutlet UILabel *lab_couponName;
@property (nonatomic, strong) IBOutlet UILabel *lab_orderNo;
@property (nonatomic, strong) IBOutlet UILabel *lab_paytime;
@property (nonatomic, strong) IBOutlet UILabel *lab_savemoney;
@property (nonatomic, strong) IBOutlet UIButton *btn_click;


@end
