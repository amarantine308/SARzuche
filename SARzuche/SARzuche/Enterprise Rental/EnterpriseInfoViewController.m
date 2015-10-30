//
//  EnterpriseInfoViewController.m
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "EnterpriseInfoViewController.h"
#import "User.h"
#import "UIColor+Helper.h"
#import "ConstImage.h"
#import "NextHelpViewController.h"
#import "CustomAlertView.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "ConstDefine.h"
#import "ConstString.h"

#define FRAME_BACKGROUND    CGRectMake(0,controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)

#define HEIGHT_OF_VIEW      200
#define HEIGHT_OF_BTN       40
#define WIDTH_OF_VIEW       280

#define FRAME_SUCCESS       CGRectMake(20, 80, WIDTH_OF_VIEW, HEIGHT_OF_VIEW)
#define FRAME_LABEL1        CGRectMake(10, 10, WIDTH_OF_VIEW-20, 60)
#define FRAME_LABEL2        CGRectMake(10, 70, WIDTH_OF_VIEW-20, 30)
#define FRAME_BTN_1         CGRectMake(0, HEIGHT_OF_VIEW - HEIGHT_OF_BTN, WIDTH_OF_VIEW/2, HEIGHT_OF_BTN)
#define FRAME_BTN_2         CGRectMake(WIDTH_OF_VIEW/2, HEIGHT_OF_VIEW - HEIGHT_OF_BTN, WIDTH_OF_VIEW/2, HEIGHT_OF_BTN)

#define Width_NextBtn       580.0 / 2.0
#define Height_NextBtn      88.0  / 2.0
#define OriginX_NextBtn     (self.view.bounds.size.width - Width_NextBtn) / 2.0

#define TAG_TEXT_NAME       101 // 企业名称
#define TAG_TEXT_CONTACT    102 // 联系人
#define TAG_TEXT_TELEPHONE  103 // 手机号

#define DIC_FOR_CITYNAME    @"DIC_FOR_CITYNAME"  //城市
#define DIC_FOR_TAKEDATE    @"DIC_FOR_TAKEDATE"  //取车日期
#define DIC_FOR_CARTYPE     @"DIC_FOR_CARTYPE"    //意向车型
#define DIC_FOR_TENANCY     @"DIC_FOR_TENANCY"      //租期
#define DIC_FOR_CARNUMBER   @"DIC_FOR_CARNUMBER"  //车辆数
#define DIC_FOR_DRIVINGSERVICE @"DIC_FOR_DRIVINGSERVICE" //是否代驾
#define DIC_FOR_CAEBRAND    @"DIC_FOR_CAEBRAND"  //意向汽车品牌

#define IMG_BTN_TOHOME      @"modify.png"
#define IMG_BTN_MORE        @"unsubscribe.png"

@interface EnterpriseInfoViewController ()
{
    UITextField *m_nameTextField;
    UITextField *m_contactTextField;
    UITextField *m_telephoneTextField;
    CGRect constantFrame;
}

@end

@implementation EnterpriseInfoViewController
@synthesize dic_data;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:m_contactTextField];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:m_nameTextField];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"企业租车";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    constantFrame = self.view.frame;
    
    float OriginY_TitleLabel = 44;
    if (IOS_VERSION_ABOVE_7)
    {
        OriginY_TitleLabel = 64;
    }
    
    float originX_one = 15;
    float originX_two = 87;
    float titleWidth = 200;
    float screenWidth = self.view.frame.size.width;
    float vi_height = 44;
    float lab_width = 62;
    float textFieldWidth = 200;
    float middleheight = 12;
    
    float Height_TitleLabel = 35;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX_one, OriginY_TitleLabel, titleWidth, Height_TitleLabel)];
    titleLabel.text = @"企业信息";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    NSArray *list_name = @[@"企业名称",@"联系人",@"手机号码"];
    for (int i = 0; i<3; i++)
    {
        UIView *vi_bac = [[UIView alloc] initWithFrame:CGRectMake(0, OriginY_TitleLabel + Height_TitleLabel + vi_height * i + middleheight * i, screenWidth, vi_height)];
        vi_bac.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:vi_bac];
        
        UILabel *lab_content = [[UILabel alloc] initWithFrame:CGRectMake(originX_one, 0, lab_width, vi_height)];
        lab_content.font = [UIFont fontWithName:@"helvetica" size:15];
        lab_content.text = [list_name objectAtIndex:i];
        [vi_bac addSubview:lab_content];
    }
    
    // 企业名称
    m_nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX_two, OriginY_TitleLabel + Height_TitleLabel, textFieldWidth, vi_height)];
    m_nameTextField.tag = TAG_TEXT_NAME;
    m_nameTextField.delegate = self;
    m_nameTextField.placeholder = @"请输入企业名称";
    m_nameTextField.returnKeyType = UIReturnKeyDone;
    m_nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_nameTextField.font = [UIFont fontWithName:@"helvetica" size:15];
    [self.view addSubview:m_nameTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:m_nameTextField];
    
    // 联系人
    float contactOriginY = OriginY_TitleLabel + Height_TitleLabel + vi_height + middleheight;
    m_contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX_two, contactOriginY, textFieldWidth, vi_height)];
    m_contactTextField.tag = TAG_TEXT_CONTACT;
    m_contactTextField.delegate = self;
    m_contactTextField.placeholder = @"请输入您的姓名";
    m_contactTextField.returnKeyType = UIReturnKeyDone;
    m_contactTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_contactTextField.font = [UIFont fontWithName:@"helvetica" size:15];
    [self.view addSubview:m_contactTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:m_contactTextField];
    
    // 手机号
    float telephoneOriginY = OriginY_TitleLabel + Height_TitleLabel + vi_height*2 + middleheight*2;;
    m_telephoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX_two, telephoneOriginY, textFieldWidth, vi_height)];
    m_telephoneTextField.tag = TAG_TEXT_TELEPHONE;
    m_telephoneTextField.font = [UIFont fontWithName:@"helvetica" size:15];
    m_telephoneTextField.delegate = self;
    m_telephoneTextField.placeholder = @"请输入您的手机号";
    m_telephoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    m_telephoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:m_telephoneTextField];
    
    float btnoriginY = 87;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(OriginX_NextBtn, self.view.bounds.size.height - btnoriginY, Width_NextBtn, Height_NextBtn);
    [submitBtn setTitle:@"提交意向" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    if(customNavBarView)
    {
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        callBtn.backgroundColor = [UIColor clearColor];
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

/**
 *方法描述：客服电话
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
}
/**
 *方法描述：进入帮助页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    NSString *type = [NSString stringWithFormat:@"help%d",2];
    next.title = STR_BISNESS_INTRODUCTION;
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkPhoneNumber
{
    NSString *regex = @"^[0-9]{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isMatch = [pred evaluateWithObject:m_telephoneTextField.text];
    return isMatch;
}


-(void)submitBtnClicked
{
#if 0
    [self showSuccessView];
#else
    //企业名称非必填
//    if (m_nameTextField.text.length == 0) {
//        [self showalertWithString:@"请补全所有信息"];
//        return;
//    }
    if (m_contactTextField.text.length == 0) {
        [self showalertWithString:@"请补全所有信息"];
        return;
    }
    if (m_telephoneTextField.text.length == 0) {
        [self showalertWithString:@"请补全所有信息"];
        return;
    }
    if (![self checkPhoneNumber]) {
        [self showalertWithString:@"你的电话信息不正确"];
        return;
    }
    NSString *companyName = m_nameTextField.text;
    NSString *contact = m_contactTextField.text;
    NSString *phone = m_telephoneTextField.text;
    
    //用户id
    NSString *userid = [User shareInstance].id;
    if (NO == [PublicFunction ShareInstance].m_bLogin)
    {
        userid = @"";
    }
    
//    NSLog(@"self_dicdata:%@ %@ %@ %@ %@ %@ %@",[self.dic_data objectForKey:DIC_FOR_CARTYPE],
//          [self.dic_data objectForKey:DIC_FOR_CARNUMBER],
//          [self.dic_data objectForKey:DIC_FOR_TAKEDATE],
//          [self.dic_data objectForKey:DIC_FOR_CITYNAME],
//          [self.dic_data objectForKey:DIC_FOR_TENANCY],
//          [self.dic_data objectForKey:DIC_FOR_CAEBRAND],
//          [self.dic_data objectForKey:DIC_FOR_DRIVINGSERVICE]);
    
    //企业意向订单请求
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] sendCompanyConsultWithUserId:userid
                                                                                     phone:phone
                                                                                    carNum:[self.dic_data objectForKey:DIC_FOR_CARNUMBER]
                                                                                      time:[self.dic_data objectForKey:DIC_FOR_TENANCY]
                                                                                      city:[self.dic_data objectForKey:DIC_FOR_CITYNAME]
                                                                                   useTime:[self.dic_data objectForKey:DIC_FOR_TAKEDATE]
                                                                                    remark:@""
                                                                                   company:companyName
                                                                                   linkman:contact
                                                                                    carseries:[self.dic_data objectForKey:DIC_FOR_CARTYPE]
                                                                                     brand:[self.dic_data objectForKey:DIC_FOR_CAEBRAND]
                                                                         designated_driver:[self.dic_data objectForKey:DIC_FOR_DRIVINGSERVICE]
                                                                                  delegate:self];
    req = nil;
#endif
}

- (void)showalertWithString:(NSString *)str
{
#if 1
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:nil cancelButtonTitle:STR_OK otherButtonTitles:nil, nil];
    [alert show];
#else
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"温馨提示哦,亲" message:str delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alert needDismisShow];
#endif
}


-(void)showSuccessView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:FRAME_BACKGROUND];
    backgroundView.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;
    [self.view addSubview:backgroundView];
    
    UIView *success = [[UIView alloc] initWithFrame:FRAME_SUCCESS];
    success.backgroundColor = [UIColor whiteColor];
    [success.layer setCornerRadius:8.0f];
    [success.layer setMasksToBounds:YES];
    [backgroundView addSubview:success];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:FRAME_LABEL1];
    label1.text = STR_ENTERPRISE_SUBMITSUCCESS;
    label1.textColor = [UIColor blackColor];
    label1.font = FONT_CONTORLLER_TITLE;
    label1.textAlignment = NSTextAlignmentCenter;
    UILabel *label2 = [[UILabel alloc] initWithFrame:FRAME_LABEL2];
    label2.text = STR_ENTERPRISE_CONTACT;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor blackColor];
    [success addSubview:label1];
    [success addSubview:label2];

    UIButton *moreBtn = [[UIButton alloc] initWithFrame:FRAME_BTN_1];
    [moreBtn setTitle:STR_ENTERPRISE_RENTMORE forState:UIControlStateNormal];
    [moreBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_MORE] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(morePressed) forControlEvents:UIControlEventTouchUpInside];
    [success addSubview:moreBtn];
    
    UIButton *toHOmeBtn = [[UIButton alloc] initWithFrame:FRAME_BTN_2];
    [toHOmeBtn setTitle:STR_ENTERPRISE_TOHOME forState:UIControlStateNormal];
    [toHOmeBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_TOHOME] forState:UIControlStateNormal];
    [toHOmeBtn addTarget:self action:@selector(toHOmePressed) forControlEvents:UIControlEventTouchUpInside];
    [success addSubview:toHOmeBtn];
    
}

-(void)morePressed
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_personal];
}

-(void)toHOmePressed
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_home];
}

#pragma mark - http delegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [self showSuccessView];
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [self showalertWithString:@"服务器连接失败，请下次尝试"];
//    NSLog(@"服务器连接失败，请下次尝试");
}

#pragma mark - UITextFieldDelegate

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    int maxLength = 10;
    if (textField.tag == TAG_TEXT_NAME)
    {
        maxLength = 30;
    }
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxLength)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > maxLength)
        {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case TAG_TEXT_TELEPHONE:// 手机号输入框
        {
            if (range.location >= 11)
                return NO;
            return YES;
        }
            break;
            
        case TAG_TEXT_CONTACT:
        {
            if (range.location >= 10)
            {
                return NO;
            }
            return YES;
        }
            break;
            
        case TAG_TEXT_NAME:     // 企业名称
        {
            if (range.location >= 30)
                return NO;
            return YES;
        }
            break;
            
        default:
            break;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag)
    {
        case TAG_TEXT_TELEPHONE:   // 手机号输入框
        {
            if (strlen([textField.text UTF8String]) < 11)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入11位手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_nameTextField resignFirstResponder];
    [m_contactTextField resignFirstResponder];
    [m_telephoneTextField resignFirstResponder];
//    [self DownSelfView];
}

//- (void)upSelfView
//{
//    NSInteger width = [[UIScreen mainScreen] bounds].size.width;
//    NSInteger height = [[UIScreen mainScreen] bounds].size.height;
//    
//    int y;
//    if (IS_IPHONE5) {
//        y = 0;
//    }else{
//        y = -35;
//    }
//    CGRect frame_old = CGRectMake(0, y, width, height);
//    [UIView animateWithDuration:0.5f animations:^{
//        self.view.frame = frame_old;
//    }];
//}
//
//- (void)DownSelfView
//{
//    [UIView animateWithDuration:0.5f animations:^{
//        self.view.frame = constantFrame;
//    }];
//}

@end
