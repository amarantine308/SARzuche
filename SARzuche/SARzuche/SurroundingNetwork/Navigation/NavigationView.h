//
//  NavigationView.h
//  SARzuche
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationTypeSwitchView.h"

#define KEY_LocationDic_startAddr   @"startAddress"
#define kEY_LocationDic_endAddr     @"endAddress"

@protocol NavigationViewDelegate <NSObject>
-(void)enterLocationView:(NSString *)title isMyLocation:(BOOL)myLocation;
// 101-bus,102-drive,103-walk
-(void)enterStartNavigationView:(int)type;
-(void)startEndLocationChanged;
@end

@interface NavigationView : UIView<NavigationTypeSwitchViewDelegate>

@property(nonatomic, assign)id<NavigationViewDelegate> delegate;

-(void)getTextFieldStr:(NSString *)str;
-(void)setEndAddress:(NSString *)str;
@end
