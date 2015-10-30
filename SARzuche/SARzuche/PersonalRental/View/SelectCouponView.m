//
//  SelectCouponView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-11-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "SelectCouponView.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "ConstImage.h"

@implementation SelectCouponView
@synthesize m_carMode;
@synthesize m_id;
@synthesize m_scope;
@synthesize m_type;
@synthesize m_validTime;
@synthesize m_desc;
@synthesize m_leftNum;
@synthesize m_backBtn;
@synthesize m_givebackBtn;
@synthesize delegate;


#define SUBVIEW_START_X     10
#define SUBVIEW_START_Y     30
#define SUBVIEW_W             (MainScreenWidth - SUBVIEW_START_X * 2)
#define SUBVIEW_H           (MainScreenHeight - SUBVIEW_START_Y * 2)

#define LABEL_START_X1       0
#define LABEL_START_Y       0
#define LABEL_H             30

#define LABEL_START_X2       100

#define FRAME_VIEW          CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
#define FRAME_SUBVIEW       CGRectMake(SUBVIEW_START_X, SUBVIEW_START_Y, SUBVIEW_W, SUBVIEW_H)
#define FRAME_COUPON_ID     CGRectMake(LABEL_START_X1, LABEL_START_Y, SUBVIEW_W - LABEL_H, LABEL_H)
#define FRAME_TYPE          CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H, SUBVIEW_W - LABEL_START_X2, LABEL_H)
#define FRAME_VALID         CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H*2, SUBVIEW_W - LABEL_START_X2, LABEL_H)
#define FRAME_SCOPE         CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H*3, SUBVIEW_W - LABEL_START_X2, LABEL_H)
#define FRAME_MODE          CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H*5, SUBVIEW_W - LABEL_START_X2, LABEL_H)
#define FRAME_LEFT_NUM      CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H*6, SUBVIEW_W - LABEL_START_X2, LABEL_H)
#define FRAME_DESC          CGRectMake(LABEL_START_X2, LABEL_START_Y + LABEL_H*7, SUBVIEW_W - LABEL_START_X2, SUBVIEW_H - (LABEL_H*7))


#define FRAME_COUPON_ID_T     CGRectMake(LABEL_START_X1, LABEL_START_Y, LABEL_START_X2, LABEL_H)
#define FRAME_TYPE_T          CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H, LABEL_START_X2, LABEL_H)
#define FRAME_VALID_T         CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H*2, LABEL_START_X2, LABEL_H)
#define FRAME_SCOPE_T         CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H*3, LABEL_START_X2, LABEL_H)
#define FRAME_MODE_T          CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H*5, LABEL_START_X2, LABEL_H)
#define FRAME_LEFT_NUM_T      CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H*6, LABEL_START_X2, LABEL_H)
#define FRAME_DESC_T          CGRectMake(LABEL_START_X1, LABEL_START_Y + LABEL_H*7, LABEL_START_X2, LABEL_H)
#define FRAME_BUTTON            CGRectMake(SUBVIEW_W - LABEL_H, 0, LABEL_H, LABEL_H)
#define FRAME_GIVEBACK          CGRectMake(0, SUBVIEW_H - 50, SUBVIEW_W, 50)

-(id)initWithCouponData:(NSDictionary *)dic
{
    self = [super initWithFrame:FRAME_VIEW];
    if (self) {
        m_couponDic = dic;
        [self initView];
        [self addGesture];
    }
    
    return self;
}


-(void)addGesture//Recognizer:(UIGestureRecognizer *)gestureRecognizer
{
    m_upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(preCoupon)];
    m_upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    m_upSwipe.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:m_upSwipe];

    m_downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextCoupon)];
    m_downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    m_downSwipe.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self addGestureRecognizer:m_downSwipe];

}

-(void)dealloc
{
    [self removeGestureRecognizer:m_upSwipe];
    m_upSwipe = nil;
    
    [self removeGestureRecognizer:m_downSwipe];
    m_downSwipe = nil;
}



-(void)preCoupon
{
    NSLog(@"SEL PRE COUPON");
    if (delegate && [delegate respondsToSelector:@selector(selPreCoupon)])
    {
        [delegate selPreCoupon];
    }
}

-(void)nextCoupon
{
    NSLog(@"SEL NEXT COUPON");
    if (delegate && [delegate respondsToSelector:@selector(selNextCoupon)])
    {
        [delegate selNextCoupon];
    }
}

-(void)initView
{
    self.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;
    
    m_subView = [[UIView alloc] initWithFrame:FRAME_SUBVIEW];
    m_subView.backgroundColor = [UIColor whiteColor];
    [self addSubview:m_subView];
    
    NSString *strModel = [m_couponDic objectForKey:@"modle"];
    NSString *strType = [m_couponDic objectForKey:@"type"];
    // COUPON ID
    m_id = [[UILabel alloc] initWithFrame:FRAME_COUPON_ID];
    m_id.textColor = COLOR_LABEL;
    m_id.font = FONT_LABEL;
    m_id.textAlignment = NSTextAlignmentRight;
    m_id.text = [NSString stringWithFormat:@"%@%@",STR_COUPON_ID, GET([m_couponDic objectForKey:@"no"])];
    [m_subView addSubview:m_id];
    m_couponId = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"no"])];
    
    // coupon type
    UILabel *typeTitle = [[UILabel alloc] initWithFrame:FRAME_TYPE_T];
    typeTitle.text = STR_COUPON_TYPE;
    typeTitle.textColor = COLOR_LABEL;
    typeTitle.font = FONT_LABEL;
    [m_subView addSubview:typeTitle];
    m_type = [[UILabel alloc] initWithFrame:FRAME_TYPE];
    m_type.text = [self getTypeString:strType];
    m_type.textColor = COLOR_LABEL;
    m_type.font = FONT_LABEL;
    [m_subView addSubview:m_type];
    
    // valid
    UILabel *validTitle = [[UILabel alloc] initWithFrame:FRAME_VALID_T];
    validTitle.textColor = COLOR_LABEL;
    validTitle.text = STR_COUPON_VALID;
    validTitle.font = FONT_LABEL;
    [m_subView addSubview:validTitle];
    m_validTime = [[UILabel alloc] initWithFrame:FRAME_VALID];
    m_validTime.text = [NSString stringWithFormat:@"%@ ~ %@", GET([m_couponDic objectForKey:@"startdate"]), GET([m_couponDic objectForKey:@"enddate"])];
    m_validTime.textColor = COLOR_LABEL;
    m_validTime.font = FONT_LABEL;
    [m_subView addSubview:m_validTime];
    
    // car mode
    UILabel *carModeTitle = [[UILabel alloc] initWithFrame:FRAME_MODE_T];
    carModeTitle.text = STR_COUPON_CARMODE;
    carModeTitle.textColor = COLOR_LABEL;
    carModeTitle.font = FONT_LABEL;
    [m_subView addSubview:carModeTitle];
    m_carMode = [[UILabel alloc] initWithFrame:FRAME_MODE];
    m_carMode.text = [NSString stringWithFormat:@"%@", strModel ? strModel : @"所有车型"];
    m_carMode.textColor = COLOR_LABEL;
    m_carMode.font = FONT_LABEL;
    [m_subView addSubview:m_carMode];
    
    // scope
    UILabel *scopeTitle = [[UILabel alloc] initWithFrame:FRAME_SCOPE_T];
    scopeTitle.text = STR_COUPON_SCOPE;
    scopeTitle.textColor = COLOR_LABEL;
    scopeTitle.font = FONT_LABEL;
    [m_subView addSubview:scopeTitle];
    m_scope = [[UILabel alloc] initWithFrame:FRAME_SCOPE];
    m_scope.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"area"])];
    m_scope.textColor = COLOR_LABEL;
    m_scope.numberOfLines = 2;
    m_scope.font = FONT_LABEL;
    [m_subView addSubview:m_scope];
    
    // left
    UILabel *leftnumTitle = [[UILabel alloc] initWithFrame:FRAME_LEFT_NUM_T];
    leftnumTitle.text = STR_COUPON_LEFTNUM;
    leftnumTitle.textColor = COLOR_LABEL;
    leftnumTitle.font = FONT_LABEL;
    [m_subView addSubview:leftnumTitle];
    m_leftNum = [[UILabel alloc] initWithFrame:FRAME_LEFT_NUM];
    m_leftNum.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"leftnum"])];
    m_leftNum.textColor = COLOR_LABEL;
    m_leftNum.font = FONT_LABEL;
    [m_subView addSubview:m_leftNum];
    
    // description
    UILabel *descTitle = [[UILabel alloc] initWithFrame:FRAME_DESC_T];
    descTitle.text = STR_DESCRIPTION;
    descTitle.textColor = COLOR_LABEL;
    descTitle.font = FONT_LABEL;
    [m_subView addSubview:descTitle];
    m_desc = [[UITextView alloc] initWithFrame:FRAME_DESC];
    m_desc.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"remarks"])];
    m_desc.textColor = COLOR_LABEL;
    [m_subView addSubview:m_desc];
    
    m_backBtn = [[UIButton alloc] initWithFrame:FRAME_BUTTON];
    m_backBtn.backgroundColor = [UIColor grayColor];
    [m_backBtn setTitle:STR_BACK forState:UIControlStateNormal];
    [m_backBtn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_subView addSubview:m_backBtn];
    
    m_givebackBtn = [[UIButton alloc] initWithFrame:FRAME_GIVEBACK];
//    m_givebackBtn.backgroundColor = [UIColor grayColor];
    [m_givebackBtn setTitle:STR_SEL_AND_COMFIRM_GIVEBACK forState:UIControlStateNormal];
    [m_givebackBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_givebackBtn addTarget:self action:@selector(givebackPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_subView addSubview:m_givebackBtn];
    
}


-(void)initNewCouponView
{
    m_newCouponView = [[UIView alloc] initWithFrame:FRAME_SUBVIEW];
    m_newCouponView.backgroundColor = [UIColor whiteColor];
    [self addSubview:m_newCouponView];
    
    NSString *strModel = [m_couponDic objectForKey:@"modle"];
    NSString *strType = [m_couponDic objectForKey:@"type"];
    // COUPON ID
    m_id = [[UILabel alloc] initWithFrame:FRAME_COUPON_ID];
    m_id.textColor = COLOR_LABEL;
    m_id.font = FONT_LABEL;
    m_id.textAlignment = NSTextAlignmentRight;
    m_id.text = [NSString stringWithFormat:@"%@%@",STR_COUPON_ID, GET([m_couponDic objectForKey:@"no"])];
    [m_newCouponView addSubview:m_id];
    m_couponId = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"no"])];
    
    // coupon type
    UILabel *typeTitle = [[UILabel alloc] initWithFrame:FRAME_TYPE_T];
    typeTitle.text = STR_COUPON_TYPE;
    typeTitle.textColor = COLOR_LABEL;
    typeTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:typeTitle];
    m_type = [[UILabel alloc] initWithFrame:FRAME_TYPE];
    m_type.text = [self getTypeString:strType];
    m_type.textColor = COLOR_LABEL;
    m_type.font = FONT_LABEL;
    [m_newCouponView addSubview:m_type];
    
    // valid
    UILabel *validTitle = [[UILabel alloc] initWithFrame:FRAME_VALID_T];
    validTitle.textColor = COLOR_LABEL;
    validTitle.text = STR_COUPON_VALID;
    validTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:validTitle];
    m_validTime = [[UILabel alloc] initWithFrame:FRAME_VALID];
    m_validTime.text = [NSString stringWithFormat:@"%@ ~ %@", GET([m_couponDic objectForKey:@"startdate"]), GET([m_couponDic objectForKey:@"enddate"])];
    m_validTime.textColor = COLOR_LABEL;
    m_validTime.font = FONT_LABEL;
    [m_newCouponView addSubview:m_validTime];
    
    // car mode
    UILabel *carModeTitle = [[UILabel alloc] initWithFrame:FRAME_MODE_T];
    carModeTitle.text = STR_COUPON_CARMODE;
    carModeTitle.textColor = COLOR_LABEL;
    carModeTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:carModeTitle];
    m_carMode = [[UILabel alloc] initWithFrame:FRAME_MODE];
    m_carMode.text = [NSString stringWithFormat:@"%@", strModel ? strModel : @"所有车型"];
    m_carMode.textColor = COLOR_LABEL;
    m_carMode.font = FONT_LABEL;
    [m_newCouponView addSubview:m_carMode];
    
    // scope
    UILabel *scopeTitle = [[UILabel alloc] initWithFrame:FRAME_SCOPE_T];
    scopeTitle.text = STR_COUPON_SCOPE;
    scopeTitle.textColor = COLOR_LABEL;
    scopeTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:scopeTitle];
    m_scope = [[UILabel alloc] initWithFrame:FRAME_SCOPE];
    m_scope.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"area"])];
    m_scope.textColor = COLOR_LABEL;
    m_scope.font = FONT_LABEL;
    [m_newCouponView addSubview:m_scope];
    
    // left
    UILabel *leftnumTitle = [[UILabel alloc] initWithFrame:FRAME_LEFT_NUM_T];
    leftnumTitle.text = STR_COUPON_LEFTNUM;
    leftnumTitle.textColor = COLOR_LABEL;
    leftnumTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:leftnumTitle];
    m_leftNum = [[UILabel alloc] initWithFrame:FRAME_LEFT_NUM];
    m_leftNum.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"leftnum"])];
    m_leftNum.textColor = COLOR_LABEL;
    m_leftNum.font = FONT_LABEL;
    [m_newCouponView addSubview:m_leftNum];
    
    // description
    UILabel *descTitle = [[UILabel alloc] initWithFrame:FRAME_DESC_T];
    descTitle.text = STR_DESCRIPTION;
    descTitle.textColor = COLOR_LABEL;
    descTitle.font = FONT_LABEL;
    [m_newCouponView addSubview:descTitle];
    m_desc = [[UITextView alloc] initWithFrame:FRAME_DESC];
    m_desc.text = [NSString stringWithFormat:@"%@", GET([m_couponDic objectForKey:@"remarks"])];
    m_desc.textColor = COLOR_LABEL;
    [m_newCouponView addSubview:m_desc];
    
    m_backBtn = [[UIButton alloc] initWithFrame:FRAME_BUTTON];
    m_backBtn.backgroundColor = [UIColor grayColor];
    [m_backBtn setTitle:STR_BACK forState:UIControlStateNormal];
    [m_backBtn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_newCouponView addSubview:m_backBtn];
    
    m_givebackBtn = [[UIButton alloc] initWithFrame:FRAME_GIVEBACK];
    //    m_givebackBtn.backgroundColor = [UIColor grayColor];
    [m_givebackBtn setTitle:STR_SEL_AND_COMFIRM_GIVEBACK forState:UIControlStateNormal];
    [m_givebackBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_givebackBtn addTarget:self action:@selector(givebackPressed) forControlEvents:UIControlEventTouchUpInside];
    [m_newCouponView addSubview:m_givebackBtn];
    
}


-(void)givebackPressed
{
    NSLog(@"SEL COUPON GIVE BACK PRESSED");
    if (delegate && [delegate respondsToSelector:@selector(givebackWithCouponId:)])
    {
        [delegate givebackWithCouponId:m_couponId];
    }
}

-(void)backPressed
{
    if (delegate && [delegate respondsToSelector:@selector(viewExit)])
    {
        [delegate viewExit];
    }
    
    [self removeFromSuperview];
}

-(void)initLabel
{
    if (m_couponDic == nil) {
        return;
    }
    NSString *strModel = [m_couponDic objectForKey:@"modle"];
    NSString *strType = [m_couponDic objectForKey:@"type"];
    m_leftNum.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"leftnum"]];
    m_carMode.text = [NSString stringWithFormat:@"%@", strModel ? strModel : @"所有车型"];
    m_id.text = [NSString stringWithFormat:@"%@%@",STR_COUPON_ID, GET([m_couponDic objectForKey:@"no"])];
    m_scope.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"area"]];
    m_type.text = [self getTypeString:strType];
    m_validTime.text = [NSString stringWithFormat:@"%@ ~ %@", [m_couponDic objectForKey:@"startdate"], [m_couponDic objectForKey:@"enddate"]];
    m_desc.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"remarks"]];
}

-(void)setCouponData:(NSDictionary *)dic
{
    m_couponDic = [[NSDictionary alloc] initWithDictionary:dic];
    
    [self initNewCouponView];
    [self showNewCouponViewAnimtaion];
}


-(void)showNewCouponViewAnimtaion
{
    CGRect rect = m_newCouponView.frame;
    rect.size.height = 2;
    m_newCouponView.frame = rect;
    
    [self bringSubviewToFront:m_newCouponView];
    [UIView animateWithDuration:0.5f
                     animations:^{
                         m_newCouponView.frame = FRAME_SUBVIEW;
                     }
                     completion:^(BOOL finished){
                         [m_subView removeFromSuperview];
                         m_subView = m_newCouponView;
                     }];
}


-(NSString *)getTypeString:(NSString *)type
{
    NSInteger nInter = [type integerValue];
    switch (nInter) {
        case 1:
            return STR_DURATION_CONSUMPTION;
            break;
        case 2:
            return STR_MILEAGE_CONSUMPTION;
            break;
        case 3:
            return STR_ALL_COUPON;
            break;
        case 4:
            return STR_CASH_COUPON;
            break;
        default:
            return @"";
            break;
    }
}


@end
