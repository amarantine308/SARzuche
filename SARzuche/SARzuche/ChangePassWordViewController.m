//
//  ChangePassWordViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "BLNetworkManager.h"
#import "NSString+md5plus.h"
#import "User.h"
#import "ConstDefine.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "CustomAlertView.h"
#import "HomeViewController.h"
#import "PublicFunction.h"





@interface ChangePassWordViewController ()

@end

@implementation ChangePassWordViewController
@synthesize timer =_timer;

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
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"修改密码"];
    }
    
    //UIApplicationSignificantTimeChangeNotification;
    _count = 5;
    _currentPassWord.secureTextEntry=YES;
    _newPassWord.secureTextEntry = YES;
    _passWordConfirm.secureTextEntry = YES;
    _currentPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (IBAction)resignAction:(id)sender
{
    [_currentPassWord resignFirstResponder];
    [_newPassWord resignFirstResponder];
    [_passWordConfirm resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//确认修改
- (IBAction)sureAction:(id)sender
{

    if (_currentPassWord.text.length==0)
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请输入当前密码"delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [alert needDismisShow];

    }
    else if(_currentPassWord.text.length!=0)
    {
        NSString *_currentPW=[NSString md5Str:_currentPassWord.text];
        NSString *strong =[PublicFunction strongForPassword:_newPassWord.text];

        if (![_currentPW isEqualToString:[User shareInstance].password ])
        {
            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"当前密码输入有误，请重新输入"
                                                                   delegate:self
                                                          cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [alert needDismisShow];
        }
        else
        {
            if (_newPassWord.text.length==0)
            {
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入新密码"
                                                                       delegate:self
                                                              cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
                [alert needDismisShow];
                
            }
            else if((strong.integerValue < 2 )||(_newPassWord.text.length<6)||(![PublicFunction isMatchWithString:_newPassWord.text]))
            {
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"新密码格式有误，请重新输入"
                                                                       delegate:self
                                                              cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
                [alert needDismisShow];

            }
            else if (_passWordConfirm.text.length==0)
            {
                CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"请输入确认密码"
                                                                       delegate:self
                                                              cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
                [alert needDismisShow];
                

            }
            else if (_passWordConfirm.text.length != 0)
            {
                if (![_passWordConfirm.text isEqualToString:_newPassWord.text])
                {
                    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"两次密码不一致"
                                                                           delegate:self
                                                                  cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
                    [alert needDismisShow];

                }
                else
                {
                    NSString *currentPWS =_currentPassWord.text ;
                    NSString *newPSW =_newPassWord.text;
                    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
                    FMNetworkRequest *request = [[BLNetworkManager shareInstance] changePassWordWithuserId:[User shareInstance].id
                                                                                                  passWord:[NSString md5Str:currentPWS]
                                                                                               newPassWord:[NSString md5Str:newPSW ]
                                                                                                  delegate:self];
                    request=nil;
                }
            }
    }

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
    if (_newPassWord  ==  textField)
    {
        if ([aString length] > 16)
        {
            textField.text = [aString substringToIndex:16];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                            message:@"密码不得多于18位"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil, nil];
//            [alert show];

            return NO;
        }
        
           }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidBeginEditing");
    if (textField==_passWordConfirm)
    {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(0, -100, self.view.bounds.size.width, 480);
        } completion:nil];
    }
    
}
// 文本框失去first responder 时，执行
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    if (textField==_passWordConfirm)
    {//self.view.bounds.size.height
        [UIView animateWithDuration:0.2 animations:^{
            if (IS_IPHONE5)
            {
                self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width,568 );

            }
            else
            {
                self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width,480 );

            }
        } completion:nil];
    }
    /*
    if (textField==_newPassWord)
    {
        if ((_newPassWord.text.length<6) &&(_newPassWord.text.length>0))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"密码不得少于6位"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
     */
    
}
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 100)
//    {
//        
//        HomeViewController *home = [[HomeViewController alloc] init];
//        [self.navigationController pushViewController:home animated:YES];
//    }
//}

#pragma mark - DataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    _alert = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功 \n\n5S后页面将自动返回至首页" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    _alert.tag = 100;
    [_alert show];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod: ) userInfo:nil repeats:YES];
    
    
}
- (void)timerFireMethod:(NSTimer *)theTimer
{
    _count--;
    if (_count <=0)
    {
        [_alert dismissWithClickedButtonIndex:0 animated:YES];
        HomeViewController *home = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:home animated:YES];
        [theTimer invalidate];
        self.timer = nil;
        

    }
    
}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [tmpAlert needDismisShow];

}

@end
