//
//  MyAccountCellTableViewCell.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *chargeStyle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *balance;//余额
@property (weak, nonatomic) IBOutlet UILabel *charage;//充值

@end
