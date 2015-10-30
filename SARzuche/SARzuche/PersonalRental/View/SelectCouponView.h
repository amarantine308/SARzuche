//
//  SelectCouponView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-11-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectCouponViewDelegate <NSObject>

-(void)givebackWithCouponId:(NSString *)couponId;
-(void)selNextCoupon;
-(void)selPreCoupon;
-(void)viewExit;
@end


@interface SelectCouponView : UIView
{
    NSDictionary *m_couponDic;
    NSString *m_couponId;
    
    UISwipeGestureRecognizer *m_upSwipe;
    UISwipeGestureRecognizer *m_downSwipe;
    
    UIView *m_subView;
    UIView *m_newCouponView;
}

@property (strong, nonatomic) UILabel *m_id;
@property (strong, nonatomic) UILabel *m_type;
@property (strong, nonatomic) UILabel *m_validTime;
@property (strong, nonatomic) UILabel *m_scope;
@property (strong, nonatomic) UILabel *m_carMode;
@property (strong, nonatomic) UILabel *m_leftNum;
@property (strong, nonatomic) UITextView *m_desc;
@property (strong, nonatomic) UIButton *m_backBtn;
@property (strong, nonatomic) UIButton *m_givebackBtn;
@property(nonatomic, strong)id<SelectCouponViewDelegate> delegate;

-(id)initWithCouponData:(NSDictionary *)dic;
-(void)setCouponData:(NSDictionary *)dic;
@end
