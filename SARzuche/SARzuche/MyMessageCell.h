//
//  MyMessageCell.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *_title;
@property (strong, nonatomic) IBOutlet UIImageView *_titleImage;
@property (strong, nonatomic) IBOutlet UILabel *_time;
@property (strong, nonatomic) IBOutlet UILabel *_content;

@end
