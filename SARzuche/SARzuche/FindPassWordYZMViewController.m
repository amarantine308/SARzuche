//
//  FindPassWordYZMViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FindPassWordYZMViewController.h"
#import "FindPassWordConfirmViewController.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "CustomAlertView.h"

#define CURRENTDATE    @"currentDate"
#define COUNT          @"count"

@interface FindPassWordYZMViewController ()

@end

@implementation FindPassWordYZMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   // Do any additional setup after loading the view from its nib.
    _phone.keyboardType =  UIKeyboardTypeNumberPad;
    _YZM.keyboardType   = UIKeyboardTypeNumberPad;
    _countDown = 60;
    
    
    NSNumber *countSave = [[NSUserDefaults standardUserDefaults] objectForKey:COUNT ];
    _count = countSave.integerValue;
    if (customNavBarView)
    {
    [customNavBarView setTitle:@"找回密码"];
    }
    
}
//获取当前时间 转化为字符串
- (NSString *)getCurrentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *locationString = [formatter stringFromDate:[NSDate date]];
    return locationString;
}
//发送验证码
- (void)sendRequestYZM
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getYZMfindMyPassWordWithPhoneNum:_phone.text
                                                                                              type:@"2"
                                                                                          delegate:self];
    request = nil;
    _countDown = 60;
    _senaYZMLabel.text = [NSString stringWithFormat:@"%d秒",_countDown];
    _sendYZM.enabled = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
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

- (IBAction)sendYZMAction:(id)sender
{
    NSString *currentData = [[NSString alloc] initWithData:[NSData data] encoding:NSUTF8StringEncoding] ;
    [[NSUserDefaults standardUserDefaults] setObject:currentData forKey:@"currentData"];
    

    if (_phone.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    _count++;
    NSNumber *countSave = [NSNumber numberWithInt:_count];
    [[NSUserDefaults standardUserDefaults] setObject:countSave forKey:COUNT];
        
            if (_count == 1)//第一次发送验证码的时候 存下当前年月日
            {
                NSString *currentDate = [self getCurrentDate];
                [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:CURRENTDATE];
            }
            //读取出来时间 对比是否是同一天
            NSString *readDate = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENTDATE];
            NSString *current = [self getCurrentDate];
            if ([ readDate isEqualToString:current])
            {
                if (_count <=3)
                {
                    [self sendRequestYZM];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"每天最多发3次重置密码的手机验证码" delegate:@"" cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];

                }
                
            }
            else//如果时间不一样，重新存下 日期 并且 count 为1 重新 存下 并且发送请求
            {
                NSString *currentDate = [self getCurrentDate];
                [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:CURRENTDATE];
                _count = 1;
                NSNumber *countSave = [NSNumber numberWithInt:_count];
                [[NSUserDefaults standardUserDefaults] setObject:countSave forKey:COUNT];
                [self sendRequestYZM];
            }
        }
}
- (IBAction)nextStepAction:(id)sender
{
   /* FindPassWordConfirmViewController *confirmPsw=[[FindPassWordConfirmViewController alloc] init];
    confirmPsw.YZM = _YZM.text;
    confirmPsw.phoneMum = _phone.text;
    [self.navigationController pushViewController:confirmPsw animated:YES];
    */
    // 传递验证码 手机号
    if (_phone.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![self validateMobile:_phone.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(_YZM.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码不能码为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] findMyPasswordCheckCode:_YZM.text delegate:self];
        tempRequest = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resignAction:(id)sender
{
    [_phone resignFirstResponder];
    [_YZM resignFirstResponder];
}

//校验手机号
 - (BOOL)validateMobile:(NSString *)mobileNum
 {
     //usereckCode.do
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
    */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
    */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
     /**
      * 中国联通：China Unicom
      * 130,131,132,152,155,156,185,186
      */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
     /**
      * 中国电信：China Telecom
      * 133,1349,153,180,189
    */
     NSString * CT = @"^1((33|53|8[091])[0-9]|349)\\d{7}$";
     /**
      * 大陆地区固话及小灵通
      * 区号：010,020,021,022,023,024,025,027,028,029
      * 号码：七位或八位
    */
     
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
     if (             ([regextestmobile evaluateWithObject:mobileNum] == YES)
         || ([regextestcm evaluateWithObject:mobileNum] == YES)
         || ([regextestct evaluateWithObject:mobileNum] == YES)
         || ([regextestcu evaluateWithObject:mobileNum] == YES)
        )
    {
                return YES;
    }
    else
    {
                return NO;
    }
}

#pragma mark-UITexFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_phone  ==  textField)
    {
        if ([aString length] > 11)
        {
            textField.text = [aString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}
#pragma mark---DataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_findMyPassWordYZM])
    {
        
        _sendYZM.enabled = NO;
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:2];
        [alert needDismisShow];
        
    }
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_checkCode])
    {
    
         FindPassWordConfirmViewController *confirmPsw=[[FindPassWordConfirmViewController alloc] init];
         confirmPsw.YZM = _YZM.text;
         confirmPsw.phoneMum = _phone.text;
         [self.navigationController pushViewController:confirmPsw animated:YES];

    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_findMyPassWordYZM])
    {
        [self.timer invalidate];
        self.timer = nil;
        _sendYZM.enabled = YES;
        _senaYZMLabel.text = @"重发验证码";

        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:3];
        [alert needDismisShow];
    }
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_checkCode])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:fmNetworkRequest.responseData
                                                       delegate:nil
                                              cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }

}




@end
