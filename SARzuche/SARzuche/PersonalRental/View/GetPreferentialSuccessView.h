//
//  GetPreferentialSuccessView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetPreferentialSuccessViewDelegate <NSObject>

-(void)toMyPreferential;
-(void)toKnowPreferential;

@end

@interface GetPreferentialSuccessView : UIView
{
    UIImageView *m_image;
    UILabel *m_promptLabel;
    
    UIButton *m_mine;
    UIButton *m_toKnow;
}

@property(nonatomic, weak)id<GetPreferentialSuccessViewDelegate> delegate;
@property(nonatomic, strong) UILabel *m_promptLabel;

@end
