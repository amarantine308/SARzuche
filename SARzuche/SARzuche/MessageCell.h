//
//  MessageCell.h
//  SARzuche
//
//  Created by admin on 14-10-31.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Height_Cell 80.0

@interface MessageCell : UITableViewCell

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *timeLabel;
@property(nonatomic, strong)UIImageView *separatorLine;
@property(nonatomic, strong)UILabel *contentLabel;

-(void)showNewMessageImageView:(BOOL)show;
-(void)showSpaceView:(BOOL)show;

@end
