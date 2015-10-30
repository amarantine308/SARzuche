//
//  ConfirmGivebackViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ConfirmGivebackViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "PreferentialCouponViewController.h"
#import "GivebackViewController.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "OrderManager.h"
#import "ConstImage.h"
#import "LoadingClass.h"
#import "CustomAlertView.h"


#define START_X         10
#define LABEL_H         20
#define LABEL_START_Y   180
#define LABEL_W         (MainScreenWidth - START_X * 2)

#define FRAME_IMAGE     CGRectMake(30, 140, 40, 40)
#define FRAME_PROMPT    CGRectMake(START_X, 160, 200, LABEL_H)
#define FRAME_PROMPT1   CGRectMake(START_X, LABEL_START_Y, LABEL_W, LABEL_H)
#define FRAME_PROMPT2   CGRectMake(START_X, LABEL_START_Y + LABEL_H, LABEL_W, LABEL_H * 2)
#define FRAME_PROMPT3   CGRectMake(START_X, LABEL_START_Y + LABEL_H * 3, LABEL_W, LABEL_H * 2)
#define FRAME_PROMPT4   CGRectMake(START_X, LABEL_START_Y + LABEL_H * 5, LABEL_W, LABEL_H)

#define FRAME_RIGHT_COUPON_BTN  FRAME_RIGHT_BUTTON1

#define FRAME_UNUSE_BTN             CGRectMake(0, 0, MainScreenWidth/2, bottomButtonHeight)
#define FRAME_USE_BTN               CGRectMake(MainScreenWidth / 2, 0, MainScreenWidth / 2, bottomButtonHeight)

#define FRAME_COUPON_VIEW           CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)
#define FRAME_COMFIRM_GIVEBACK      FRAME_COUPON_VIEW

#define IMG_BTN_USE         @"modify.png"
#define IMG_BTN_UNUSE       @"unsubscribe.png"

@interface ConfirmGivebackViewController ()
{
    UIView *m_useCouponView;
    UIButton *m_useCouponBtn;
    UIButton *m_unuseCouponBtn;
    UIButton *m_rightCoupontBtn;
    
    NSMutableArray *m_validCoupons;
    
    UIImageView* m_image;
    UILabel* m_prompt;
    UILabel* m_prompt1;
    UILabel* m_prompt2;
    UILabel* m_prompt3;
    UILabel* m_prompt4;
    
    UIButton *m_comfirmBtn;
}
@end

@implementation ConfirmGivebackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initConfirmView];
    [self sendMyCouponUrl:0 :1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_COMFIRM_GIVEBACK];
        [customNavBarView addSubview:m_rightCoupontBtn];
    }
    
//    [self showUseCouponView];
    
}


-(void)showCouponAbout:(BOOL)bShow
{
    BOOL bHidden = !bShow;
    m_useCouponBtn.hidden = bHidden;
    m_unuseCouponBtn.hidden = bHidden;
    m_useCouponView.hidden = bHidden;
    m_rightCoupontBtn.hidden = bHidden;
    
    m_prompt4.hidden = bHidden;
    m_rightCoupontBtn.hidden = bHidden;
}


-(void)initConfirmView
{
    m_useCouponView = [[UIView alloc] initWithFrame:FRAME_COUPON_VIEW];
    m_useCouponView.backgroundColor = [UIColor lightGrayColor];
    
    m_useCouponBtn = [[UIButton alloc] initWithFrame:FRAME_USE_BTN];
    [m_useCouponBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_USE] forState:UIControlStateNormal];
    [m_useCouponBtn setTitle:STR_USE  forState:UIControlStateNormal];
    [m_useCouponBtn addTarget:self action:@selector(useCouponBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_useCouponView addSubview:m_useCouponBtn];
    
    m_unuseCouponBtn = [[UIButton alloc] initWithFrame:FRAME_UNUSE_BTN];
    [m_unuseCouponBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_UNUSE] forState:UIControlStateNormal];
    [m_unuseCouponBtn setTitle:STR_NOT_USE forState:UIControlStateNormal];
    [m_unuseCouponBtn addTarget:self action:@selector(unuseCouponBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_useCouponView addSubview:m_unuseCouponBtn];
    [self.view addSubview:m_useCouponView];
    
    m_rightCoupontBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_COUPON_BTN];
    [m_rightCoupontBtn setTitle:STR_COUPON forState:UIControlStateNormal];
    m_rightCoupontBtn.backgroundColor = [UIColor clearColor];
    [m_rightCoupontBtn addTarget:self action:@selector(showUseCouponView) forControlEvents:UIControlEventTouchUpInside];
    
    m_image = [[UIImageView alloc] initWithFrame:FRAME_IMAGE];
    m_image.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_image];
    
    m_prompt = [[UILabel alloc] initWithFrame:FRAME_PROMPT];
    m_prompt.text = STR_GIVEBACK_PROMPT;
    m_prompt.font = FONT_LABEL;
    [self.view addSubview:m_prompt];
    
    m_prompt1 = [[UILabel alloc] initWithFrame:FRAME_PROMPT1];
    m_prompt1.text = STR_GIVEBACK_PROMPT1;
    m_prompt1.font = FONT_LABEL;
    [self.view addSubview:m_prompt1];
    
    m_prompt2 = [[UILabel alloc] initWithFrame:FRAME_PROMPT2];
    m_prompt2.text = STR_GIVEBACK_PROMPT2;
    m_prompt2.font = FONT_LABEL;
    m_prompt2.numberOfLines = 2;
    [self.view addSubview:m_prompt2];
    
    m_prompt3 = [[UILabel alloc] initWithFrame:FRAME_PROMPT3];
    m_prompt3.text = STR_GIVEBACK_PROMPT3;
    m_prompt3.font = FONT_LABEL;
    m_prompt3.numberOfLines = 2;
    [self.view addSubview:m_prompt3];
    
    m_prompt4 = [[UILabel alloc] initWithFrame:FRAME_PROMPT4];
    m_prompt4.text = STR_GIVEBACK_PROMPT4;
    m_prompt4.font = FONT_LABEL;
    m_prompt4.textColor = [UIColor redColor];
    m_prompt4.hidden = YES;
    [self.view addSubview:m_prompt4];
    
    m_comfirmBtn = [[UIButton alloc] initWithFrame:FRAME_COUPON_VIEW];
    [m_comfirmBtn setTitle:STR_COMFIRM_GIVEBACK forState:UIControlStateNormal];
//    [m_comfirmBtn setImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_comfirmBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_comfirmBtn addTarget:self action:@selector(comfirmGiveback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_comfirmBtn];
}


-(void)useCouponBtn
{
    NSLog(@"use coupon btn");
    PreferentialCouponViewController *tmpCtrl = [[PreferentialCouponViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

-(void)unuseCouponBtn
{
    NSLog(@"unuse coupon btn");
    
    [UIView animateWithDuration:.3 animations:^{
        m_useCouponView.frame = FRAME_RIGHT_COUPON_BTN;
    } completion:^(BOOL finished) {
        m_useCouponView.hidden = YES;
    }];

    m_comfirmBtn.hidden = NO;
}

-(void)showUseCouponView
{
    m_useCouponView.frame = FRAME_COUPON_VIEW;
    m_useCouponView.hidden = NO;
    
    m_comfirmBtn.hidden = YES;
    m_prompt4.hidden = NO;
}

-(void)givebackSuccess:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    
    GivebackViewController *tmpCtrl = [[GivebackViewController alloc] initWithSuccessData:dic];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

-(void)comfirmGiveback
{
    NSLog(@"comfirmGiveback");
    [[LoadingClass shared] showLoadingForMoreRequest:STR_CACULATING];
    srvOrderData *curData = [[OrderManager ShareInstance] getCurrentOrderData];
    
    NSString *userId = [NSString stringWithFormat:@"%@", GET([User shareInstance].id)];
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(curData.m_orderId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] returnCarWithUid:userId
                                                                       orderId:orderId
                                                                     useCoupon:NO
                                                                      couponId:@""
                                                                      delegate:self];
    req = nil;
}


/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)sendMyCouponUrl:(NSInteger)couponType :(NSInteger)sortType
{
    //couponType ＝＝ 0:有效 1:无效 2:全部
    //sortType == 1 默认排序 2 到期时间排序 3 分类排序
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    //我的优惠卷

#if 0
    NSString *userid = [User shareInstance].id;
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getMyCouponWithUserId:userid
                                                                           takeTime:@""
                                                                       givebackTime:@""
                                                                               type:[NSString stringWithFormat:@"%d", couponType]
                                                                           sortType:[NSString stringWithFormat:@"%d",sortType]
                                                                           delegate:self];
    req = nil;

    NSString *userid = [User shareInstance].id;
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getMyCouponWithUserId:userid
                                                                           takeTime:@""
                                                                       givebackTime:@""
                                                                               type:[NSString stringWithFormat:@"%d", couponType]
                                                                           sortType:[NSString stringWithFormat:@"%d",sortType]
                                                                           delegate:self];
    req = nil;
#else
    srvOrderData *curData = [[OrderManager ShareInstance] getCurrentOrderData];
    
    NSString *orderId = [NSString stringWithFormat:@"%@", GET(curData.m_orderId)];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getSuitableCoupon:orderId delegate:self];
    req = nil;
#endif
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotCoupons:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;

//    m_validCoupons = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"coupon_enable"]];
    m_validCoupons = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"suitableCoupon"]];
    
    if ([m_validCoupons count] > 0)
    {
        [self showUseCouponView];
        [self showCouponAbout:YES];
    }
    else
    {
        [self showCouponAbout:NO];
    }
}


-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqual:kRequest_getSuitableCoupon])
    {//我的优惠卷
        [self gotCoupons:fmNetworkRequest];
    }
    else if([kRequest_returnCar isEqualToString:fmNetworkRequest.requestName])
    {
        [self givebackSuccess:fmNetworkRequest];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqual:kRequest_getSuitableCoupon])
    {//我的优惠卷
        [self showCouponAbout:NO];
        return;
    }
    else if([kRequest_returnCar isEqualToString:fmNetworkRequest.requestName])
    {
//        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_NETWORK_RETRY delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
//        [tmpAlert needDismisShow];
//        return;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_OK otherButtonTitles:nil, nil];
    [alert show];
}

@end
