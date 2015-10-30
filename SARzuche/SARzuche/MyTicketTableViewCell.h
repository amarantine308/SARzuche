//
//  MyTicketTableViewCell.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTicketTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *_name;//姓名
@property (strong, nonatomic) IBOutlet UILabel *_price;//价格
@property (strong, nonatomic) IBOutlet UILabel *_location;//地理位置
@property (strong, nonatomic) IBOutlet UILabel *_time;//时间
@property (strong, nonatomic) IBOutlet UILabel *_state;//状态
@property (strong, nonatomic) IBOutlet UILabel *_orderID;//订单
@property (strong, nonatomic) IBOutlet UILabel *postID;//邮寄单号

@end
