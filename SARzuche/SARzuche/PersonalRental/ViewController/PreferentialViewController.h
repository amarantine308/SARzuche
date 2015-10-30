//
//  PreferentialViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "GetPreferentialSuccessView.h"


@protocol PreferentialViewControllerDelegate <NSObject>

-(void)neeUpdateCouponData;

@end


@interface PreferentialViewController : NavController<UITextFieldDelegate, GetPreferentialSuccessViewDelegate>
{
    GetPreferentialSuccessView *tmpView;
}


@property(nonatomic, weak)id<PreferentialViewControllerDelegate> delegate;
@end
