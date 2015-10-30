//
//  GetPreferentialSuccessView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "GetPreferentialSuccessView.h"
#import "ConstString.h"
#import "ConstDefine.h"

#define START_X             10
#define BTN_W                   140
#define BTN_GAP                 20
#define SUBVIEW_START_Y         100
#define GAP_H                   20
#define PROMPT_H                60
#define SIZE_DEFAULT_W          191
#define SIZE_DEFAULT_H          128

#define FRAME_IMAGE             CGRectMake((MainScreenWidth - SIZE_DEFAULT_W)/2, SUBVIEW_START_Y, SIZE_DEFAULT_W, SIZE_DEFAULT_H)
#define FRAME_PROMPT            CGRectMake(START_X, SUBVIEW_START_Y + SIZE_DEFAULT_H + GAP_H, MainScreenWidth - START_X * 2, PROMPT_H)
#define FRAME_MY_BUTTON         CGRectMake(START_X, SUBVIEW_START_Y + SIZE_DEFAULT_H + PROMPT_H + GAP_H * 2, BTN_W, bottomButtonHeight)
#define FRAME_TOKNOW_BUTTON     CGRectMake(START_X + BTN_W + BTN_GAP, SUBVIEW_START_Y + SIZE_DEFAULT_H + PROMPT_H + GAP_H * 2, BTN_W, bottomButtonHeight)

#define IMG_COUPON_DEFATUL  @"coupon.png"//@"default_coupon.png"

#define IMG_MINE                      @"unsubscribe.png"
#define IMG_TOKNOW                 @"modify.png"

@implementation GetPreferentialSuccessView
@synthesize delegate;
@synthesize m_promptLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initGetSuccessView];
    }
    return self;
}

-(void)initGetSuccessView
{
    self.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;
    
    m_image = [[UIImageView alloc] initWithFrame:FRAME_IMAGE];
//    m_image.backgroundColor = [UIColor whiteColor];
    [m_image setImage:[UIImage imageNamed:IMG_COUPON_DEFATUL]];
    [self addSubview:m_image];
    
    m_promptLabel = [[UILabel alloc] initWithFrame:FRAME_PROMPT];
    NSString *formatStr = STR_GET_PREFERENTIAL;
    NSString *tmpStr = [NSString stringWithFormat:formatStr, @"时长抵用券"];
    m_promptLabel.text = tmpStr;
    m_promptLabel.numberOfLines  = 2;
    m_promptLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:m_promptLabel];
    
    m_mine = [[UIButton alloc] initWithFrame:FRAME_MY_BUTTON];
    [m_mine setTitle:STR_MY_PREFERENTIAL forState:UIControlStateNormal];
    [m_mine addTarget:self action:@selector(myPreferential) forControlEvents:UIControlEventTouchUpInside];
    m_mine.backgroundColor = [UIColor greenColor];
    [m_mine setBackgroundImage:[UIImage imageNamed:IMG_MINE] forState:UIControlStateNormal];
    [self addSubview:m_mine];
    
    m_toKnow = [[UIButton alloc] initWithFrame:FRAME_TOKNOW_BUTTON];
    [m_toKnow setTitle:STR_TO_KNOW_PREFERENTIAL forState:UIControlStateNormal];
    [m_toKnow addTarget:self action:@selector(toKnowPreferential) forControlEvents:UIControlEventTouchUpInside];
    m_toKnow.backgroundColor = [UIColor greenColor];
    [m_toKnow setBackgroundImage:[UIImage imageNamed:IMG_TOKNOW] forState:UIControlStateNormal];
    [self addSubview:m_toKnow];
}


-(void)myPreferential
{
    NSLog(@"my preferential button");
    if (delegate && [delegate respondsToSelector:@selector(toMyPreferential)]) {
        [delegate toMyPreferential];
    }
}


-(void)toKnowPreferential
{
    NSLog(@"to know preferential");
    if (delegate && [delegate respondsToSelector:@selector(toKnowPreferential)]) {
        [delegate toKnowPreferential];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
