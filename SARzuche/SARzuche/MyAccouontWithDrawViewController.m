//
//  MyAccouontWithDrawViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyAccouontWithDrawViewController.h"
#import "constString.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "LoadingClass.h"
#import "CustomAlertView.h"


#define TAG_WITHDRAWSUCCEED 100

@interface MyAccouontWithDrawViewController ()

@end

@implementation MyAccouontWithDrawViewController
@synthesize banlance=_banlance;

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
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_MYCENTER_WITHDRAW];
    }
    _avaliabeMoney.text=self.banlance;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (int index = 0; index<self.view.subviews.count; index++)
    {
        UIView * v= [self.view.subviews objectAtIndex:index];
        if ([v isKindOfClass:[UITextField class]])
        {
            [v becomeFirstResponder];
        }
    }
}
#pragma mark-IBAction
- (IBAction)sureAction:(id)sender
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] WithDrawByUserId:[User shareInstance].id chargenum:_withDrawMoney.text YZM:_YZM.text delegate:self];
    req = nil;
}

- (IBAction)sendYZMAction:(id)sender
{
///*//type 3 提现验证码
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getYZMfindMyPassWordWithPhoneNum:[User shareInstance].phone
                                                                                              type:@"3"
                                                                                          delegate:self];
    request = nil;
    
    _countDown = 60;
    _senaYZMLabel.text = [NSString stringWithFormat:@"%d秒",_countDown];
    _sendYZM.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
 // */

}
- (void)timerFireMethod:(NSTimer *)theTimer
{
    _countDown -- ;
    if (_countDown <= 0)
    {
        [theTimer invalidate];
        self.timer = nil;
        _sendYZM.enabled = YES;
        _senaYZMLabel.text = @"重发验证码";
    }
    else
    {
        _senaYZMLabel.text = [NSString stringWithFormat:@"%d秒",_countDown];
    }
}

- (IBAction)resignAction:(id)sender
{
    [_withDrawMoney resignFirstResponder];
    [_YZM resignFirstResponder];
}
#pragma mark-UIAlertViewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==TAG_WITHDRAWSUCCEED)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - dataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    _sendYZM.enabled = NO;
    //提现成功返回的
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_AccountWithDraw])
    {
        ///*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        alert.tag = TAG_WITHDRAWSUCCEED;
        [alert show];
        // */
        
        /*
        
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
                                                                message:fmNetworkRequest.responseData
                                                               delegate:self
                                                      cancelButtonTitle:STR_BACK
                                                      otherButtonTitles:nil
                                                    withDismissInterval:2];
        
        [alert needDismisShow];
         */
        
    }
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_findMyPassWordYZM])//提现验证码
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
                                                                message:fmNetworkRequest.responseData
                                                               delegate:self
                                                      cancelButtonTitle:STR_BACK
                                                      otherButtonTitles:nil
                                                    withDismissInterval:2];
        
        [alert needDismisShow];

    }
    

}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    _sendYZM.enabled = YES;
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_AccountWithDraw])
    {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:fmNetworkRequest.responseData delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
    }
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_findMyPassWordYZM])//提现验证码
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
                                                                message:fmNetworkRequest.responseData
                                                               delegate:self
                                                      cancelButtonTitle:STR_BACK
                                                      otherButtonTitles:nil
                                                    withDismissInterval:2];
        [alert needDismisShow];

    }

}


@end
