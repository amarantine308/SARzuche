//
//  CustomNavBarView.h
//  MediCare
//
//  Created by admin on 14-1-2.
//  Copyright (c) 2014年 ChinaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomNavBarView;
@protocol CustomNavBarViewDelegate <NSObject>

@optional
//点击了按钮的委托，type：0-左，1-右
-(void)customNavBarView:(CustomNavBarView*)view didClickButtonOfType:(int)tp;

@end

/*
 * 自定义的导航条
 */
@interface CustomNavBarView : UIView
{
    UILabel *titleLb;
}


@property(nonatomic,weak)id<CustomNavBarViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString*)titleStr;

-(void)setLeftButton:(NSString*)ltImgName target:(id)target leftBtnAction:(SEL)lAction;
-(void)setRightButton:(NSString*)rtImgName target:(id)target rightBtnAction:(SEL)rAction;

-(void)setLeftButtonWithTitle:(NSString*)title target:(id)target leftBtnAction:(SEL)lAction;
-(void)setRightButtonWithTitle:(NSString*)title target:(id)target rightBtnAction:(SEL)rAction;

-(void)setRightButtonFrame:(CGRect)frame;

-(void)setTitle:(NSString *)title;
-(void)setTitleBackImg:(NSString *)img;

-(void)hideRightButton;

@end
