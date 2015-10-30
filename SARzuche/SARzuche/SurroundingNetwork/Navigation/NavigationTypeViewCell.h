//
//  NavigationTypeViewCell.h
//  SARzuche
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationTypeViewCellDelegate<NSObject>
-(void)cellBtnClicked:(id)sender;
@end

@interface NavigationTypeViewCell : UITableViewCell

@property(nonatomic, retain)UIButton *cellBtn;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UIImageView *selectedView;
@property(nonatomic, assign)id<NavigationTypeViewCellDelegate> delegate;

@end
