//
//  NavigationTypeSwitchView.h
//  SARzuche
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTypeViewCell.h"

#define TAG_NavigationTypeBtn_bus       101
#define TAG_NavigationTypeBtn_driving   102
#define TAG_NavigationTypeBtn_walking   103

@protocol NavigationTypeSwitchViewDelegate<NSObject>
-(void)navigationTypeSelected:(int)type;
-(void)hideNavigationTypeSwitchView;
@end

@interface NavigationTypeSwitchView : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, NavigationTypeViewCellDelegate>

@property(nonatomic, assign)id<NavigationTypeSwitchViewDelegate> delegate;

@end
