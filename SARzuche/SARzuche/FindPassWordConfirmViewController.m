//
//  FindPassWordConfirmViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FindPassWordConfirmViewController.h"
#import "BLNetworkManager.h"
#import "NSString+md5plus.h"
#import "ConstDefine.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "LoginViewController.h"
#import "PublicFunction.h"

#define TAG_ALERTSTROG 2


@interface FindPassWordConfirmViewController ()

@end

@implementation FindPassWordConfirmViewController

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
        [customNavBarView setTitle:@"重置密码"];
    }
    // Do any additional setup after loading the view from its nib.
    
    _passwordAgin.secureTextEntry  = YES;
    _passWord.secureTextEntry      = YES;
    isSee = NO;
}
- (IBAction)showThePassWord:(id)sender
{
    isSee=!isSee;
    if (!isSee)
    {
        [isSeePassWord setImage:[UIImage imageNamed:@"findpassword_showpsw2"] forState:UIControlStateNormal];
        _passwordAgin.secureTextEntry  = YES;
        _passWord.secureTextEntry      = YES;
    }
    else
    {
        [isSeePassWord setImage:[UIImage imageNamed:@"findpassword_showpsw"] forState:UIControlStateNormal];
        _passwordAgin.secureTextEntry  = NO;
        _passWord.secureTextEntry      = NO;
    }
  
}
- (IBAction)commitAction:(id)sender
{
    //发送请求提交密码修改 成功跳转登陆界面
    if (_passWord.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(_passwordAgin.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请再次输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![_passwordAgin.text  isEqualToString:_passWord.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的密码与上次输入的密码不一致" delegate:nil cancelButtonTitle:@" 确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
        FMNetworkRequest *request = [[BLNetworkManager shareInstance] findMyPassWordWithPhoneNum:self.phoneMum YZM:self.YZM pwd:[NSString md5Str:_passWord.text ] delegate:self];
        request = nil;
    }
}


- (IBAction)resignAction:(id)sender
{
    [_passWord resignFirstResponder];
    [_passwordAgin resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--UITextfieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ((_passWord  ==  textField)||(_passwordAgin  ==  textField))
    {
        if ([aString length] > 16)
        {
            textField.text = [aString substringToIndex:16];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"密码不得多于16位"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *strong =[PublicFunction strongForPassword:_passWord.text];
    if ((textField == _passWord) && (_passWord.text.length != 0))
    {
        if (_passWord.text.length<6)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"密码不得少于6位"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            alert.tag = TAG_ALERTSTROG;
            [alert show];
            
        }
        if((strong.integerValue < 2 )&&(_passWord.text.length>=6))
        {
            UIAlertView *v = [[UIAlertView alloc] initWithTitle:nil message:@"密码强度不够，请包含字母和数字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [v show];
            
        }

    }
}
#pragma mark---DataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:fmNetworkRequest.responseData
                                                   delegate:self
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:fmNetworkRequest.responseData
                                                   delegate:nil
                                          cancelButtonTitle:@"好的"
                                          otherButtonTitles:nil, nil];
    [alert show];


}
#pragma mark---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
    
}


@end
