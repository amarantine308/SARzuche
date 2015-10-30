//
//  LoginViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "LoginViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "RegisterViewController.h"
#import "FindPassWordYZMViewController.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "NSString+md5plus.h"
#import "UserCenterViewController.h"
#import "LoadingClass.h"

#define TAG_PHONE_NUM_FIELD           2003
#define TAG_PASSWORD_FIELD            2004
// label
#define LABEL_START_X   (32)
#define LABEL_W         (60)
#define ROW_H           (88/2)
#define PHONE_START_Y   (controllerViewStartY + 15)

// BTN
#define FORGET_START_Y  (PHONE_START_Y + (ROW_H * 2) + 12)
#define FORGET_START_X  (MainScreenWidth - BTN_WIDTH - BTN_SIDE)

#define BTN_SIDE        16
#define BTN_MIDDLE_GAP  22
#define BTN_WIDTH      ((MainScreenWidth - BTN_SIDE - BTN_SIDE - BTN_MIDDLE_GAP) / 2)
#define BUTTON_START_Y  (35 + FORGET_START_Y)

#define START_X   BTN_SIDE


// frame
#define FRAME_LABEL_PHONE               CGRectMake(0, 1, LABEL_W, ROW_H-2)
#define FRAME_LABEL_PWD                 CGRectMake(0, 1+ ROW_H, LABEL_W, ROW_H-2)
#define FRAME_PHONE_NUM                 CGRectMake(START_X, PHONE_START_Y, MainScreenWidth - BTN_SIDE *2, ROW_H)
#define FRAME_PASSWORD                  CGRectMake(START_X, PHONE_START_Y + ROW_H, MainScreenWidth - BTN_SIDE * 2, ROW_H)
#define FRAME_FORGET_PASSWORD           CGRectMake(BTN_SIDE + BTN_WIDTH + BTN_MIDDLE_GAP, FORGET_START_Y, BTN_WIDTH, ROW_H)

#define FRAME_REGISTER                  CGRectMake(BTN_SIDE, BUTTON_START_Y, BTN_WIDTH, ROW_H)
#define FRAME_LOGIN                     CGRectMake(BTN_SIDE + BTN_WIDTH + BTN_MIDDLE_GAP, BUTTON_START_Y, BTN_WIDTH, ROW_H)

#define FRAME_DELETE_BUTTON         CGRectMake(200, 5, ROW_H, ROW_H) // for temp

// IMAGE
#define IMG_BTN_LOGIN       @"login_register.png"
#define IMG_BTN_REGISTER    @"register.png"
#define IMG_FIELD_ENTER     @"input.png"
#define IMG_FIELD_DELETE    @"delete.png"

// font
#define FONT_SIZE           FONT_INPUT

@interface LoginViewController ()
{
    UITextField *m_phoneNumField;
    UITextField *m_passwrdField;
    UIButton *m_forgetPsswrdBtn;
    UIButton *m_registerBtn;
    UIButton *m_loginBtn;
    
    UIButton *m_deleteBtn;
    UIButton *m_pwdDelBtn;
}

@end

@implementation LoginViewController

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
    
    //_isFromUserCenter=NO;
    // Do any additional setup after loading the view.
    [self initLoginView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_VIP_LOGIN];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initLoginView
{
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:FRAME_LABEL_PHONE];
    phoneLabel.text = STR_ACCOUNT;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = COLOR_LABEL_GRAY;
    phoneLabel.font = FONT_SIZE;
    phoneLabel.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:phoneLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:FRAME_LABEL_PWD];
    pwdLabel.text = STR_PASSWORD;
    pwdLabel.textAlignment = NSTextAlignmentCenter;
    pwdLabel.textColor = COLOR_LABEL_GRAY;
    pwdLabel.font = FONT_SIZE;
    pwdLabel.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:pwdLabel];
    
    m_deleteBtn = [[UIButton alloc] initWithFrame:FRAME_DELETE_BUTTON];
    UIImage *imageDel = [UIImage imageNamed:IMG_FIELD_DELETE];
    CGRect rect = CGRectMake(FRAME_PHONE_NUM.origin.x + FRAME_PHONE_NUM.size.width - imageDel.size.width - 28, FRAME_PHONE_NUM.origin.y, ROW_H, ROW_H);
    [m_deleteBtn setImage:imageDel forState:UIControlStateNormal];
    m_deleteBtn.userInteractionEnabled = YES;
    [m_deleteBtn addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    m_deleteBtn.frame = rect;
    m_deleteBtn.hidden = YES;
    
    UIColor *placeHolderColor = COLOR_INPUT;
    
    m_phoneNumField = [[UITextField alloc] initWithFrame:FRAME_PHONE_NUM];
    if (IOS_VERSION_BELOW_6)
    {
        m_phoneNumField.placeholder = STR_ENTER_PHONE_NUM;
    }
    else
    {
        m_phoneNumField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:STR_ENTER_PHONE_NUM attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    }
//    m_phoneNumField.placeholder = STR_ENTER_PHONE_NUM;
    m_phoneNumField.tag = TAG_PHONE_NUM_FIELD;
    m_phoneNumField.font = FONT_INPUT;
    m_phoneNumField.background = [UIImage imageNamed:IMG_FIELD_ENTER];
    m_phoneNumField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_phoneNumField.delegate = self;
//    [m_phoneNumField addSubview:m_deleteBtn];
    m_phoneNumField.leftView = phoneLabel;
    m_phoneNumField.leftViewMode = UITextFieldViewModeAlways;
    m_phoneNumField.keyboardType =  UIKeyboardTypeNumberPad;
    [self.view addSubview:m_phoneNumField];
    [self.view addSubview:m_deleteBtn];
    
    
    m_passwrdField = [[UITextField alloc] initWithFrame:FRAME_PASSWORD];
    if (IOS_VERSION_BELOW_6)
    {
        m_passwrdField.placeholder = STR_ENTER_PASSWORD;
    }
    else
    {
        m_passwrdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:STR_ENTER_PASSWORD attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    }
//    m_passwrdField.placeholder = STR_ENTER_PASSWORD;
    m_passwrdField.tag = TAG_PASSWORD_FIELD;
    m_passwrdField.delegate = self;
    m_passwrdField.secureTextEntry = YES;
    m_passwrdField.font = FONT_INPUT;
    m_passwrdField.background = [UIImage imageNamed:IMG_FIELD_ENTER];
    m_passwrdField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_passwrdField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_passwrdField.leftView = pwdLabel;
    m_passwrdField.leftViewMode = UITextFieldViewModeAlways;
//    [m_passwrdField addSubview:m_pwdDelBtn];
    
    m_pwdDelBtn = [[UIButton alloc] initWithFrame:FRAME_DELETE_BUTTON];
    imageDel = [UIImage imageNamed:IMG_FIELD_DELETE];
    rect = CGRectMake(m_passwrdField.frame.origin.x + m_passwrdField.frame.size.width - imageDel.size.width - 28, m_passwrdField.frame.origin.y, ROW_H, ROW_H);
    [m_pwdDelBtn setImage:imageDel forState:UIControlStateNormal];
    m_pwdDelBtn.userInteractionEnabled = YES;
    [m_pwdDelBtn addTarget:self action:@selector(pwdDelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    m_pwdDelBtn.frame = rect;
    m_pwdDelBtn.hidden = YES;
    [self.view addSubview:m_passwrdField];
    [self.view addSubview:m_pwdDelBtn];
    
    m_forgetPsswrdBtn = [[UIButton alloc] initWithFrame:FRAME_FORGET_PASSWORD];
    [m_forgetPsswrdBtn setTitle:STR_FORGET_PASSWORD forState:UIControlStateNormal];
    [m_forgetPsswrdBtn setTitleColor:COLOR_LABEL_BLUE forState:UIControlStateNormal];
    m_forgetPsswrdBtn.titleLabel.font = FONT_FORGET;
    m_forgetPsswrdBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [m_forgetPsswrdBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_forgetPsswrdBtn];
    
    m_registerBtn = [[UIButton alloc] initWithFrame:FRAME_REGISTER];
    [m_registerBtn setTitle:STR_REGISTER forState:UIControlStateNormal];
    [m_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_registerBtn addTarget:self action:@selector(registerBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_registerBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_REGISTER] forState:UIControlStateNormal];
    [self.view addSubview:m_registerBtn];
    
    m_loginBtn = [[UIButton alloc] initWithFrame:FRAME_LOGIN];
    [m_loginBtn setTitle:STR_LOGIN forState:UIControlStateNormal];
    [m_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_loginBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_loginBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_LOGIN] forState:UIControlStateNormal];
    [self.view addSubview:m_loginBtn];
}
-(void)backClk:(id)sender
{
//    if (self.isFromUserCenter)
    {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

-(void)loginBtn
{
    [m_phoneNumField resignFirstResponder];
    [m_passwrdField resignFirstResponder];
    NSLog(@"login btn");
#if 0//!SAR_TEST
//    FMNetworkRequest *request = [[BLNetworkManager shareInstance] loginAction_supervisionLogin:@"13451893070"//
//                                                                                      password:[NSString md5Str:@"1234567"]//13451893070
//                                                                                          type:@"ios" delegate:self];
//    FMNetworkRequest *request = [[BLNetworkManager shareInstance] loginAction_supervisionLogin:@"13851729204" password:[NSString md5Str:@""] type:@"ios" delegate:self];
   // [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] loginAction_supervisionLogin:@"18066108998" password:[NSString md5Str:@"123456"] type:@"ios" delegate:self];

    request = nil;
    
#else
    //m_phoneNumField.text = @"18061687714";
    //m_passwrdField.text = @"lw3726230";
    NSString *phoneNume = [NSString stringWithFormat:@"%@", m_phoneNumField.text];
    NSString *psswrd = [NSString md5Str:m_passwrdField.text];
    if ([phoneNume length] == 0) {
        [self showNeedEnterPhoneNumber];
    }
    else
    {
        [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
        FMNetworkRequest *request = [[BLNetworkManager shareInstance] loginAction_supervisionLogin:phoneNume password:psswrd type:@"ios" delegate:self];
        request = nil;
    }
#endif
}

-(void)showNeedEnterPhoneNumber
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

-(void)registerBtn
{
    [m_phoneNumField resignFirstResponder];
    [m_passwrdField resignFirstResponder];
    NSLog(@"register btn");
    RegisterViewController *tmpControler = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpControler animated:YES];
}

-(void)forgetPassword
{
    NSLog(@"forget password");
    FindPassWordYZMViewController *tmpController = [[FindPassWordYZMViewController alloc] init];
    [self.navigationController pushViewController:tmpController animated:YES];
}

-(void)deleteButtonPressed
{
    [m_phoneNumField resignFirstResponder];
    
    m_phoneNumField.text = @"";
    m_deleteBtn.hidden = YES;
}

-(void)pwdDelBtnPressed
{
    [m_passwrdField resignFirstResponder];
    
    m_passwrdField.text = @"";
    m_pwdDelBtn.hidden = YES;
}

#pragma mark - FMNetworkManager delegate

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    [PublicFunction ShareInstance].m_bLogin = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        }];
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    [PublicFunction ShareInstance].m_bLogin = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)hideDeleteButton:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_PHONE_NUM_FIELD:
            if ([textField.text length] > 0) {
                m_deleteBtn.hidden = NO;
            }
            else
            {
                m_deleteBtn.hidden = YES;
            }
            break;
        case TAG_PASSWORD_FIELD:
            if ([textField.text length] > 0) {
                m_passwrdField.hidden = NO;
            }
            else
            {
                m_passwrdField.hidden = YES;
            }
            
        default:
            break;
    }
}

#pragma mark - text field
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case TAG_PHONE_NUM_FIELD:
            if ([textField.text length] > 0) {
                m_deleteBtn.hidden = NO;
            }
            else
            {
                m_deleteBtn.hidden = YES;
            }
            break;
        case TAG_PASSWORD_FIELD:
            if ([textField.text length] > 0) {
                m_pwdDelBtn.hidden = NO;
            }
            else
            {
                m_pwdDelBtn.hidden = YES;
            }

        default:
            break;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_passwrdField resignFirstResponder];
    [m_phoneNumField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case TAG_PHONE_NUM_FIELD:   // 手机号输入框
        {
            if (range.location >= 11)
            {
                return NO;
            }
            if ([@"" isEqualToString:string] && [textField.text length] == 1) {
                m_deleteBtn.hidden = YES;
            }
            else
            {
                m_deleteBtn.hidden = NO;
            }
            return YES;
        }
            break;
            
        case TAG_PASSWORD_FIELD:   // 密码输入框
        {
            if (range.location >= 16)
                return NO;
            
            if ([@"" isEqualToString:string] && [textField.text length] == 1) {
                m_pwdDelBtn.hidden = YES;
            }
            else
            {
                m_pwdDelBtn.hidden = NO;
            }
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
    switch (textField.tag)
    {
        case TAG_PHONE_NUM_FIELD:   // 手机号输入框
        {
            if (strlen([textField.text UTF8String]) < 11)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
            break;
            
        case TAG_PASSWORD_FIELD:   // 密码输入框
        {
            if (strlen([textField.text UTF8String]) < 6)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入6-16位字母+数字组成的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    return YES;
}

@end
