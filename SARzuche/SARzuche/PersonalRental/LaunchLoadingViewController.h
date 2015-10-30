//
//  LaunchLoadingViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LaunchLoadingViewDelegate <NSObject>
-(void)exitOwn;
@end

@interface LaunchLoadingViewController : UIViewController

@property(nonatomic, weak)id<LaunchLoadingViewDelegate> delegate;

@end
