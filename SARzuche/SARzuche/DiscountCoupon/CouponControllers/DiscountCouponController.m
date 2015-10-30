//
//  DiscountCouponController.m
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "DiscountCouponController.h"
#import "UserRecordController.h"
#import "FMNetworkManager.h"
#import "BLNetworkManager.h"
#import "ConstDefine.h"
#import "NextHelpViewController.h"
#import "User.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "ConstImage.h"

//#import "UserLoginData"

// right button
#define FRAME_CALL_BUTTON   FRAME_RIGHT_BUTTON1
#define FRAME_HELP_BUTTON   FRAME_RIGHT_BUTTON2

@interface DiscountCouponController ()

@end

@implementation DiscountCouponController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];

    if (m_bNeedUpdate) {
        [self sendCouponUrl];
    }
}


- (void)sendCouponUrl
{
    NSString *userid = [User shareInstance].id;
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
 
    //优惠劵使用统计
    FMNetworkRequest *statistics = [[BLNetworkManager shareInstance] getCouponStatisticsWithUserId:userid delegate:self];
    statistics = nil;
    
    m_bNeedUpdate = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"优惠劵"];
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_CALL_BUTTON];
        [callBtn setImage:[UIImage imageNamed:IMG_PHONE] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(phoneServer) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:callBtn];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_HELP_BUTTON];
        [helpBtn setImage:[UIImage imageNamed:IMG_HELP] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(couponHelp) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
    }
    
    //优惠劵接口
    [self sendCouponUrl];
}

//优惠劵使用帮助
- (void)couponHelp
{
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    next.title= @"优惠劵";
    next.type = nil;//= @"help7";
    [self.navigationController pushViewController:next animated:YES];
}

//电话客服了解详情
- (void)phoneServer
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//兑换优惠卷
- (IBAction)clickButtonOnExchangeCoupon
{
    PreferentialViewController *per = [[PreferentialViewController alloc] init];
    per.delegate = self;
    [self.navigationController pushViewController:per animated:YES];
}

//我的优惠卷
- (IBAction)clickButtonOnMyCoupon
{
    MyCouponController *myCoupon = [[MyCouponController alloc] initWithNibName:@"MyCouponController" bundle:nil];
    myCoupon.delegate = self;
    [self.navigationController pushViewController:myCoupon animated:YES];
}
//使用记录
- (IBAction)clickButtonOnUseRecord
{
    UserRecordController *userRecord = [[UserRecordController alloc] initWithNibName:@"UserRecordController" bundle:nil];
    [self.navigationController pushViewController:userRecord animated:YES];
}


-(void)neeUpdateCouponData
{
    m_bNeedUpdate = YES;
}


#pragma mark - http
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_getCouponStatistic]) {
        //优惠卷使用统计
        NSDictionary *dic = [fmNetworkRequest.responseData objectForKey:@"couponStatistics"];
        NSNumber *times = [dic objectForKey:@"totalnum"];
        lab_useNum.text = [NSString stringWithFormat:@"%@次",times];
        NSNumber *coupons = [fmNetworkRequest.responseData objectForKey:@"leftCoupon"];
        lab_coupons.text = [NSString stringWithFormat:@"%@",coupons];
        NSNumber *fee = [dic objectForKey:@"totalfee"];
        lab_saveMoney.text = [NSString stringWithFormat:@"%@元",fee];
        if ([lab_saveMoney.text isEqualToString:@"元"])
        {
            lab_saveMoney.text = @"0元";
        }
    }
}


-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
}

@end
