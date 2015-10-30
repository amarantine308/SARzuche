//
//  RegisterViewController.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterProtocolViewController.h"
#import "IdentifyVerificationViewController.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "UIColor+Helper.h"
#import "ConstDefine.h"
#import "User.h"

#define Alphas  @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define Nums    @"0123456789"

#define TAG_TEXT_TELNUM     101 // 手机号输入框
#define TAG_TEXT_ICODE      102 // 验证码输入框
#define TAG_TEXT_PASSWORD   103 // 密码输入框

#define TAG_BTN_SENDIC      201 // 发送验证码按钮
#define TAG_BTN_SHOWPW      202 // 显示密码按钮
#define TAG_BTN_AGREE       203 // 同意注册协议按钮
#define TAG_BTN_PROTOCOL    204 // 协议内容按钮
#define TAG_BTN_REGISTER    205 // 注册按钮

#define Width_TextField     580.0 / 2.0
#define Height_TextField    88.0  / 2.0
#define OriginX_TextField   (self.view.bounds.size.width - Width_TextField) / 2.0

#define Width_icTextField   340.0 / 2.0

#define Width_SendICBtn     220.0 / 2.0
#define Height_SendICBtn    88.0  / 2.0

#define Width_NextBtn       580.0 / 2.0
#define Height_NextBtn      88.0  / 2.0

#define OriginY_AgreeBtn    5.0
#define Width_AgreeBtn      40.0  / 2.0
#define Height_AgreeBtn     40.0  / 2.0

#define Width_AgreeLabel    200
#define Height_AgreeLabel   (Height_AgreeBtn + OriginY_AgreeBtn * 2)

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    BOOL agreeRegister;
    int  icSeconds;
    NSTimer *timerOfIdentifyCode;
    
    UITextField *telephoneNumTextField;
    UITextField *icTextField;
    UITextField *passwordTextField;
    
    UIImageView *sendICImgView;
    UILabel *sendICLabel;
    
    BOOL passwordContainAlpha;
    BOOL passwordContainNum;
}

-(void)dealloc
{
    if (timerOfIdentifyCode)
    {
        [timerOfIdentifyCode invalidate];
        timerOfIdentifyCode = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"注册";
        
        passwordContainAlpha = NO;
        passwordContainNum = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [customNavBarView setTitle:@"注册"];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"#efeff4" alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    float textFieldSpace = 16;
    
    // 手机号输入框
    originY += textFieldSpace;
    
    UIView *telephoneNumBackView = [[UIView alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_TextField, Height_TextField)];
    [self.view addSubview:telephoneNumBackView];
    
    UIImageView *telephoneNumImgView = [[UIImageView alloc] initWithFrame:telephoneNumBackView.bounds];
    telephoneNumImgView.image = [UIImage imageNamed:@"login输入框.png"];
    [telephoneNumBackView addSubview:telephoneNumImgView];
    
    telephoneNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, Width_TextField - 5, Height_TextField)];
    telephoneNumTextField.tag = TAG_TEXT_TELNUM;
    telephoneNumTextField.font = [UIFont systemFontOfSize:14];
    telephoneNumTextField.delegate = self;
    telephoneNumTextField.placeholder = @"请输入您的手机号码";
    telephoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    telephoneNumTextField.backgroundColor = [UIColor clearColor];
    telephoneNumTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    UIColor *placeHolderColor = [UIColor colorWithHex:0xdddddd];
//    telephoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的手机号码" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    [telephoneNumBackView addSubview:telephoneNumTextField];
    
    // 验证码identifyingCode输入框
    originY += Height_TextField + textFieldSpace;
    
    UIView *icBackView = [[UIView alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_icTextField, Height_TextField)];
    [self.view addSubview:icBackView];
    
    UIImageView *icImgView = [[UIImageView alloc] initWithFrame:icBackView.bounds];
    icImgView.image = [UIImage imageNamed:@"输入验证码.png"];
    [icBackView addSubview:icImgView];
    
    icTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, Width_icTextField -  5, Height_TextField)];
    icTextField.tag = TAG_TEXT_ICODE;
    icTextField.font = [UIFont systemFontOfSize:14];
    icTextField.delegate = self;
    icTextField.placeholder = @"请输入您收到的验证码";
    icTextField.keyboardType = UIKeyboardTypeNumberPad;
    icTextField.backgroundColor = [UIColor clearColor];
    icTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [icBackView addSubview:icTextField];
    
    // 发送验证码按钮
    sendICImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - OriginX_TextField - Width_SendICBtn, originY, Width_SendICBtn, Height_TextField)];
    sendICImgView.image = [UIImage imageNamed:@"发送验证码.png"];
    sendICImgView.userInteractionEnabled = YES;
    [self.view addSubview:sendICImgView];
    
    sendICLabel = [[UILabel alloc] initWithFrame:sendICImgView.bounds];
    sendICLabel.text = @"发送验证码";
    sendICLabel.textColor = [UIColor whiteColor];
    sendICLabel.textAlignment = NSTextAlignmentCenter;
    sendICLabel.backgroundColor = [UIColor clearColor];
    [sendICImgView addSubview:sendICLabel];
    
    UIButton *sendICBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendICBtn.tag = TAG_BTN_SENDIC;
    sendICBtn.frame = sendICImgView.bounds;
    [sendICBtn setBackgroundColor:[UIColor clearColor]];
    [sendICBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendICImgView addSubview:sendICBtn];
    
    // 密码输入框
    originY += Height_TextField + textFieldSpace;
    UIView *passwordBackView = [[UIView alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, Width_TextField, Height_TextField)];
    [self.view addSubview:passwordBackView];
    
    UIImageView *passwordImgView = [[UIImageView alloc] initWithFrame:passwordBackView.bounds];
    passwordImgView.image = [UIImage imageNamed:@"login输入框.png"];
    [passwordBackView addSubview:passwordImgView];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, Width_TextField - 5, Height_TextField)];
    passwordTextField.tag = TAG_TEXT_PASSWORD;
    passwordTextField.font = [UIFont systemFontOfSize:14];
    passwordTextField.delegate = self;
    passwordTextField.backgroundColor = [UIColor clearColor];
    passwordTextField.placeholder = @"6-16位字母+数字组成的密码";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [passwordBackView addSubview:passwordTextField];
    
    // 注册按钮
    float btnSpace = 30;
    originY += Height_TextField + btnSpace;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.tag = TAG_BTN_REGISTER;
    registerBtn.frame = CGRectMake(OriginX_TextField, originY, Width_NextBtn, Height_NextBtn);
    [registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    // 同意注册协议按钮
    originY += Height_NextBtn + textFieldSpace;
    UIButton *agreeRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeRegisterBtn.tag = TAG_BTN_AGREE;
    agreeRegisterBtn.frame = CGRectMake(OriginX_TextField, originY + OriginY_AgreeBtn, Width_AgreeBtn, Height_AgreeBtn);
    [agreeRegisterBtn setBackgroundImage:[UIImage imageNamed:@"勾选-后.png"] forState:UIControlStateNormal];
    [agreeRegisterBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeRegisterBtn];
    agreeRegister = YES;
    
    // 同意注册协文字
    float agreeLabelOriginX = OriginX_TextField + agreeRegisterBtn.bounds.size.width + 5;
    
    UILabel *agreeRegisterLabel = [[UILabel alloc] initWithFrame:CGRectMake(agreeLabelOriginX, originY, Width_AgreeLabel, Height_AgreeLabel)];
    agreeRegisterLabel.text = @"同意《           》注册协议";
    agreeRegisterLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    agreeRegisterLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:agreeRegisterLabel];
    
    // 协议内容按钮
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.tag = TAG_BTN_PROTOCOL;
    protocolBtn.frame = CGRectMake(agreeRegisterLabel.frame.origin.x + 50, agreeRegisterLabel.frame.origin.y, 55, Height_AgreeLabel);
    [protocolBtn setBackgroundColor:[UIColor clearColor]];
    [protocolBtn setTitle:@"思必达" forState:UIControlStateNormal];
    [protocolBtn setTitleColor:[UIColor colorWithRed:0 green:152.0 / 255.0 blue:217.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validPhoneNum
{
    if (0 == telephoneNumTextField.text.length)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您忘记输入手机号了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[156])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:telephoneNumTextField.text] == YES) ||
        ([regextestcm evaluateWithObject:telephoneNumTextField.text] == YES) ||
        ([regextestct evaluateWithObject:telephoneNumTextField.text] == YES) ||
        ([regextestcu evaluateWithObject:telephoneNumTextField.text] == YES))
    {
        return YES;
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您输入的手机号格式有误，请重新输入~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}

-(BOOL)validIdentifyCode
{
    if (0 == icTextField.text.length)
    {
        return NO;
    }
    
    if (strlen([icTextField.text UTF8String]) < 6)
    {
        return NO;
    }
    return YES;
}

-(BOOL)validPassword
{
    if (0 == passwordTextField.text.length)
    {
        return NO;
    }
    
    if (strlen([passwordTextField.text UTF8String]) < 6)
    {
        return NO;
    }
    
    NSCharacterSet *csAlphas = [[NSCharacterSet characterSetWithCharactersInString:Alphas] invertedSet];
    NSCharacterSet *csNums = [[NSCharacterSet characterSetWithCharactersInString:Nums] invertedSet];
    NSString *tempStr = passwordTextField.text;
    
    for (int i = 0; i < tempStr.length; i++)
    {
        unichar c = [tempStr characterAtIndex:i];
        NSString *string = [NSString stringWithCharacters:&c length:1];
        
        if (!passwordContainAlpha)
        {
            NSString *filteredAlphas = [[string componentsSeparatedByCharactersInSet:csAlphas]componentsJoinedByString:@""];
            passwordContainAlpha = [string isEqualToString:filteredAlphas];
        }
        
        if (!passwordContainNum)
        {
            NSString *filteredNums = [[string componentsSeparatedByCharactersInSet:csNums]componentsJoinedByString:@""];
            passwordContainNum = [string isEqualToString:filteredNums];
        }
    }
    
    if (!passwordContainAlpha || !passwordContainNum)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - 按钮点击事件
-(void)buttonClicked:(id)sender
{
    [telephoneNumTextField resignFirstResponder];
    [icTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case TAG_BTN_SENDIC:   // 发送验证码按钮getYZMWithAccount
        {
            if (![self validPhoneNum])
            {
                return;
            }
            
            [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
            FMNetworkRequest *request = [[BLNetworkManager shareInstance] getYZMWithAccount:telephoneNumTextField.text delegate:self];
            request = nil;
        }
            break;
            
        case TAG_BTN_AGREE:   // 同意注册协议按钮
        {
            if (agreeRegister)
            {
                agreeRegister = NO;
                [btn setBackgroundImage:[UIImage imageNamed:@"勾选-前.png"] forState:UIControlStateNormal];
            }
            else
            {
                agreeRegister = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"勾选-后.png"] forState:UIControlStateNormal];
            }
        }
            break;
            
        case TAG_BTN_PROTOCOL:   // 协议内容按钮
        {
            RegisterProtocolViewController *nextVC = [[RegisterProtocolViewController alloc] init];
            [self.navigationController pushViewController:nextVC animated:YES];
            nextVC = nil;
        }
            break;
            
        case TAG_BTN_REGISTER:   // 注册按钮
        {
            if (!agreeRegister)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请您同意我们的注册协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            
            if (![self validPhoneNum])
            {
                return;
            }
            
            if (![self validIdentifyCode])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请输入您收到的6位验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            passwordContainAlpha = NO;
            passwordContainNum = NO;
            if (![self validPassword])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"请输入6-16位字母+数字组成的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
            NSString *phoneNume = [NSString stringWithFormat:@"%@", telephoneNumTextField.text];
            NSString *password = [NSString stringWithFormat:@"%@", passwordTextField.text];
            NSString *idCode = [NSString stringWithFormat:@"%@", icTextField.text];
            FMNetworkRequest *request = [[BLNetworkManager shareInstance] userRegister:phoneNume password:password identifierCode:idCode telephoneType:@"ios" delegate:self];
            request = nil;
            
        }
            break;
            
        default:
            break;
    }
}

-(void)showIdentifyCodeBtnTime
{
    sendICLabel.text = [NSString stringWithFormat:@"（%ds）", icSeconds--];
    if (icSeconds < 0)
    {
        if (timerOfIdentifyCode)
        {
            [timerOfIdentifyCode invalidate];
            timerOfIdentifyCode = nil;
        }
        
        UIButton *sendICBtn = (UIButton *)[self.view viewWithTag:TAG_BTN_SENDIC];
        sendICBtn.enabled = YES;
        
        sendICImgView.image = [UIImage imageNamed:@"发送验证码.png"];
        sendICLabel.text = @"重发验证码";
    }
}

#pragma mark - UITextFieldDelegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [telephoneNumTextField resignFirstResponder];
    [icTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case TAG_TEXT_TELNUM:   // 手机号输入框
        {
            if (range.location >= 11)
                return NO;
            return YES;
        }
            break;
            
        case TAG_TEXT_ICODE:   // 验证码输入框
        {
            if (range.location >= 6)
                return NO;
            return YES;
        }
            break;
            
        case TAG_TEXT_PASSWORD:   // 密码输入框
        {
            if (range.location >= 16)
                return NO;

            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:AlphaAndNums] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
            BOOL canChange = [string isEqualToString:filtered];
            return canChange;
        }
            break;
            
        default:
            break;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - FMNetworkManager delegate
// 请求成功
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCode])// 获取验证码
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请求验证码发送成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        
        UIButton *sendICBtn = (UIButton *)[self.view viewWithTag:TAG_BTN_SENDIC];
        sendICBtn.enabled = NO;
//        [sendICBtn setTitle:@"（60s）" forState:UIControlStateNormal];
//        [sendICBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        sendICImgView.image = [UIImage imageNamed:@"back-灰色.png"];
        sendICLabel.text = @"（60s）";
        
        icSeconds = 59;
        timerOfIdentifyCode = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showIdentifyCodeBtnTime) userInfo:nil repeats:YES];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_Register])  // 注册
    {
        [User shareInstance].phone = telephoneNumTextField.text;
        IdentifyVerificationViewController *nextVC = [[IdentifyVerificationViewController alloc] init];
        nextVC.enterType = IVViewFromRegisterView;
        [self.navigationController pushViewController:nextVC animated:YES];
        nextVC = nil;
    }
}

// 请求失败
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCode])// 获取验证码
    {
        [[LoadingClass shared] showContent:fmNetworkRequest.responseData andCustomImage:nil];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_Register])  // 注册
    {
        [[LoadingClass shared] showContent:fmNetworkRequest.responseData andCustomImage:nil];
    }
}

@end
