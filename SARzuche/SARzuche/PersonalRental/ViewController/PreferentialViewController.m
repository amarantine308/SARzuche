//
//  PreferentialViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PreferentialViewController.h"
#import "ConstString.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "MyCouponController.h"
#import "NextHelpViewController.h"
#import "ConstImage.h"
#import "ConstDefine.h"
#import "PublicFunction.h"
#import "LoginViewController.h"
#import "CustomAlertView.h"
#import "LoadingClass.h"


#define FRAME_FIELD     CGRectMake(10, 100, MainScreenWidth - 20, bottomButtonHeight)
#define FRAME_PROMPT    CGRectMake(10, 140, 240, 30)
#define FRAME_BUTTON    CGRectMake(10, 170, MainScreenWidth - 20, bottomButtonHeight)
#define FRAME_GET_PROMPT    CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)

#define IMG_FIELD_ENTER     @"input.png"

@interface PreferentialViewController ()
{
    UITextField *m_exchangeField;
    UILabel *m_promptLabel;
    UIButton *m_exchangeBtn;
}

@end

@implementation PreferentialViewController
@synthesize delegate;

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
    [self initPreferentialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_PREFERENTIAL];
        
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        UIImage *callImg = [UIImage imageNamed:IMG_PHONE];
        [callBtn setImage:callImg forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:callBtn];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON2];
        UIImage *helpImg = [UIImage imageNamed:IMG_HELP];
        [helpBtn setImage:helpImg forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 初始化兑换优惠券界面
-(void)initPreferentialView
{
    m_exchangeField = [[UITextField alloc] initWithFrame:FRAME_FIELD];
    m_exchangeField.placeholder = STR_ENTER_PREFERENTIAL;
    m_exchangeField.delegate = self;
    m_exchangeField.background = [UIImage imageNamed:IMG_FIELD_ENTER];
    [self.view addSubview:m_exchangeField];
    
    m_promptLabel = [[UILabel alloc] initWithFrame:FRAME_PROMPT];
    m_promptLabel.text = STR_EXCHANGE_CODE_PROMPT;
    m_promptLabel.hidden = YES;
    m_promptLabel.textColor = [UIColor redColor];
    [self.view addSubview:m_promptLabel];
    
    m_exchangeBtn = [[UIButton alloc] initWithFrame:FRAME_BUTTON];
    [m_exchangeBtn setTitle:STR_CONVERT forState:UIControlStateNormal];
    [m_exchangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_exchangeBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_exchangeBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateHighlighted];
    [m_exchangeBtn addTarget:self action:@selector(exchangeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_exchangeBtn];
}

// 兑换
-(void)exchangeBtn
{
    [m_exchangeField resignFirstResponder];
    
    if([@"" isEqualToString:m_exchangeField.text])
    {
        CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle:nil message:STR_EMPTY_CODE delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [alertView needDismisShow];
    }else{
        [self sendExchangeUrl];
    }
}

//兑换请求
- (void)sendExchangeUrl
{
    if ([PublicFunction ShareInstance].m_bLogin)
    {
        [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
        NSString *userid = [User shareInstance].id;
        FMNetworkRequest *req = [[BLNetworkManager shareInstance] exchangeCouponWithUserId:userid authcode:m_exchangeField.text delegate:self];
        req = nil;
    }
    else
    {
        LoginViewController *tmpCtrl = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:tmpCtrl];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
}
// 客服呼叫
-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
}
// 帮助按钮
-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    [next setTitle:@"优惠劵"];
//    NSString *type = [NSString stringWithFormat:@"help%d",6];
    next.type = nil;//type;
    [self.navigationController pushViewController:next animated:YES];
}


#pragma mark - 请求协议方法
// 请求成功
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_exchangeCoupon]) {
        NSString *tempstr = [fmNetworkRequest.responseData objectForKey:@"message"];
        NSLog(@"responseData :%@  000:%@",fmNetworkRequest.requestData,tempstr);
        
        tmpView = [[GetPreferentialSuccessView alloc] initWithFrame:FRAME_GET_PROMPT];
        tmpView.delegate = self;
        tmpView.m_promptLabel.text = tempstr;
        [self.view addSubview:tmpView];
        
        m_promptLabel.hidden = YES;
        
        if (delegate && [delegate respondsToSelector:@selector(neeUpdateCouponData)])
        {
            [delegate neeUpdateCouponData];
        }
    }
    
}

// 请求失败
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_exchangeCoupon])
    {
#if 0
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
#endif
        m_promptLabel.hidden = NO;
    }
}


// 我的优惠券
-(void)toMyPreferential
{
    MyCouponController *myCoupon = [[MyCouponController alloc] initWithNibName:@"MyCouponController" bundle:nil];
    [self.navigationController pushViewController:myCoupon animated:YES];

}
// 优惠券帮助
-(void)toKnowPreferential
{
//    NSLog(@"TO KNOW PREFERENTIAL");
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    next.title= @"优惠劵";
    next.type = nil;//@"help6";
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [m_exchangeField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_promptLabel.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_exchangeField resignFirstResponder];
}

@end
