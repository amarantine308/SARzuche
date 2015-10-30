//
//  RenewOrderViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
@protocol RenewOrderViewControllerDelegate <NSObject>

-(void)backToPrePage:(BOOL)bUpdateHistory;
@required
-(void)renewListChanged;

@end


@interface RenewOrderViewController : NavController<UITextFieldDelegate>

@property(nonatomic,weak)id<RenewOrderViewControllerDelegate> delegate;

@end
