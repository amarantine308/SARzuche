//
//  ComplainViewController.m
//  SARzuche
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ComplainViewController.h"
#import "UIPlaceHolderTextView.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "ConstDefine.h"
#import "ConstImage.h"

#define Height_BackView         40.0

#define Height_ComplainBtn      42.0 / 2.0
#define Width_ComplainBtn       42.0 / 2.0
#define OriginY_ComplainBtn     (Height_BackView - Height_ComplainBtn) / 2.0

#define Width_ComplainLabel     50.0
#define Height_ComplainLabel    20.0
#define OriginY_ComplainLabel   (Height_BackView - Height_ComplainLabel) / 2.0

#define Width_ImageView         30.0 / 2.0
#define Height_ImageView        30.0 / 2.0
#define OriginY_ImageView       (Height_BackView - Height_ImageView) / 2.0

#define Height_TypeBtn          34.0 / 2.0
#define Width_TypeBtn           34.0 / 2.0

#define Height_TextField        32
#define OriginY_TextField       (Height_BackView - Height_TextField) / 2.0

#define Width_CommitBtn     580.0 / 2.0
#define Height_CommitBtn    88.0  / 2.0

#define Height_SpaceView    5
#define Height_SepratorView 0.5

#define Color_SpaceView     [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0]

#define TAG_TEXT_CONTACT    101 // 联系人
#define TAG_TEXT_TELEPHONE  102 // 手机号

@interface ComplainViewController ()

@end

@implementation ComplainViewController
{
    UIView *backView3;
    UIView *backView4;
    BOOL complainBtnSelected;
    NSMutableArray *complainTypeArray;
    
    UITextField *contactTextField;
    UITextField *telephoneTexField;
    UIButton *complainBtn;
    UIButton *adviseBtn;
    UIPlaceHolderTextView *contentTextView;
    UIImageView *selectImgView;
    
    int markComplainTypeBtnTag;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:contactTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextViewTextDidChangeNotification" object:contentTextView];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"投诉建议";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
    callBtn.backgroundColor = [UIColor clearColor];
    UIImage *callImg = [UIImage imageNamed:IMG_PHONE];
    [callBtn setImage:callImg forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [customNavBarView addSubview:callBtn];
    
    float originX = 15;
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_BackView)];
    backView1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView1];
    
    // 投诉
    complainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    complainBtn.frame = CGRectMake(originX, OriginY_ComplainBtn, Width_ComplainBtn, Height_ComplainBtn);
    [complainBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议选择.png"] forState:UIControlStateNormal];
    [complainBtn addTarget:self action:@selector(complainBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:complainBtn];
    complainBtnSelected = YES;
    
    UILabel *complainLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + Width_ComplainBtn + 5, OriginY_ComplainLabel, Width_ComplainLabel, Height_ComplainLabel)];
    complainLabel.text = @"投诉";
    complainLabel.textColor = [UIColor blackColor];
    complainLabel.backgroundColor = [UIColor clearColor];
    [backView1 addSubview:complainLabel];
    
    // 建议
    adviseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adviseBtn.frame = CGRectMake(160, OriginY_ComplainBtn, Width_ComplainBtn, Height_ComplainBtn);
    [adviseBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议未选择.png"] forState:UIControlStateNormal];
    [adviseBtn addTarget:self action:@selector(adviseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView1 addSubview:adviseBtn];
    
    UILabel *adviseLabel = [[UILabel alloc] initWithFrame:CGRectMake(adviseBtn.frame.origin.x + Width_ComplainBtn + 5, OriginY_ComplainLabel, Width_ComplainLabel, Height_ComplainLabel)];
    adviseLabel.text = @"建议";
    adviseLabel.textColor = [UIColor blackColor];
    adviseLabel.backgroundColor = [UIColor clearColor];
    [backView1 addSubview:adviseLabel];
    
    UIImageView *sepratorView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, Height_BackView - Height_SepratorView, backView1.bounds.size.width, Height_SepratorView)];
    sepratorView1.image = [UIImage imageNamed:@"分割线.png"];
    [backView1 addSubview:sepratorView1];
    
    originY += Height_BackView;
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_BackView)];
    backView2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView2];
    
    // 问题类型
    UILabel *complainTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, OriginY_ComplainLabel, 80, Height_ComplainLabel)];
    complainTypeLabel.text = @"问题类型";
    complainTypeLabel.backgroundColor = [UIColor clearColor];
    [backView2 addSubview:complainTypeLabel];
    
    // 请选择包括label、imageView和btn
    
    selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - originX - Width_ImageView, OriginY_ImageView, Width_ImageView, Height_ImageView)];
    selectImgView.image = [UIImage imageNamed:@"请选择.png"];
    [backView2 addSubview:selectImgView];
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - originX  - Width_ImageView - 55, OriginY_ComplainLabel, 55, Height_ComplainLabel)];
    selectLabel.text = @"请选择";
    selectLabel.font = [UIFont systemFontOfSize:15];
    selectLabel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    selectLabel.backgroundColor = [UIColor clearColor];
    selectLabel.textAlignment = NSTextAlignmentLeft;
    [backView2 addSubview:selectLabel];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(selectLabel.frame.origin.x, 0, selectLabel.bounds.size.width + Width_ImageView, Height_BackView);
    [selectBtn setBackgroundColor:[UIColor clearColor]];
    [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:selectBtn];
    
    
    
    originY += Height_BackView;
    backView3 = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    backView3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView3];

    UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backView3.bounds.size.width, Height_SpaceView)];
    spaceView1.backgroundColor = Color_SpaceView;
    [backView3 addSubview:spaceView1];
    
    float myOriginY = Height_SpaceView;
    // 联系人
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, myOriginY + OriginY_TextField, 60, Height_TextField)];
    contactLabel.text = @"联系人";
    contactLabel.backgroundColor = [UIColor clearColor];
    [backView3 addSubview:contactLabel];
    
    contactTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX + 60, myOriginY + OriginY_TextField, backView3.bounds.size.width - 60 - originX * 2, Height_TextField)];
    contactTextField.tag = TAG_TEXT_CONTACT;
    contactTextField.delegate = self;
    contactTextField.placeholder = @"请输入您的姓名";
    contactTextField.returnKeyType = UIReturnKeyDone;
    contactTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backView3 addSubview:contactTextField];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:contactTextField];
    
    myOriginY += Height_BackView;
    // 手机号
    UILabel *telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, myOriginY + OriginY_TextField, 60, Height_TextField)];
    telephoneLabel.text = @"手机号";
    telephoneLabel.backgroundColor = [UIColor clearColor];
    [backView3 addSubview:telephoneLabel];
    
    telephoneTexField = [[UITextField alloc] initWithFrame:CGRectMake(originX + 60, myOriginY + OriginY_TextField, backView3.bounds.size.width - 60 - originX * 2, Height_TextField)];
    telephoneTexField.tag = TAG_TEXT_TELEPHONE;
    telephoneTexField.delegate = self;
    telephoneTexField.placeholder = @"请输入您的手机号码";
    telephoneTexField.returnKeyType = UIReturnKeyDone;
    telephoneTexField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [backView3 addSubview:telephoneTexField];
    
    UIImageView *sepratorView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, myOriginY, backView1.bounds.size.width, Height_SepratorView)];
    sepratorView2.image = [UIImage imageNamed:@"分割线.png"];
    [backView3 addSubview:sepratorView2];
    
    myOriginY += Height_BackView;
    UIView *backView5 = [[UIView alloc] initWithFrame:CGRectMake(0, myOriginY, backView3.bounds.size.width, backView3.bounds.size.height - myOriginY)];
    backView5.backgroundColor = Color_SpaceView;
    [backView3 addSubview:backView5];
    
    // 提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((backView5.bounds.size.width - Width_CommitBtn) / 2.0, backView5.bounds.size.height - Height_CommitBtn - 15, Width_CommitBtn, Height_CommitBtn);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backView5 addSubview:submitBtn];
    
    // 投诉/建议内容
    contentTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(originX, 10, backView5.bounds.size.width - originX * 2, 160)];
    contentTextView.delegate = self;
    contentTextView.placeholder = @"请填写500字以内的投诉建议内容。您也可拨打客服热线进行投诉或建议。";
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.backgroundColor = [UIColor whiteColor];
    [backView5 addSubview:contentTextView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:) name:@"UITextViewTextDidChangeNotification" object:contentTextView];
    
    float originY_backView4 = 10;
    float width_label = 115;
    float height_label = 30;
    float height_backView4 = originY_backView4*2 + height_label*3;
    float originY_btn = (height_label - Height_TypeBtn) / 2.0;
    backView4 = [[UIView alloc] initWithFrame:CGRectMake(backView3.frame.origin.x, backView3.frame.origin.y, self.view.bounds.size.width, height_backView4)];
    backView4.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView4];
    
    UIImageView *sepratorView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backView1.bounds.size.width, Height_SepratorView)];
    sepratorView3.image = [UIImage imageNamed:@"分割线.png"];
    [backView4 addSubview:sepratorView3];
    
    complainTypeArray = [[NSMutableArray alloc] initWithObjects:@"客户服务", @"财务服务", @"事故处理", @"车辆卫生", @"车辆故障", @"预定系统", nil];
    int count = [complainTypeArray count];
    
    for (int i = 0; i < count; i++)
    {
        float btnOriginX = 15 + i % 2 * (Width_TypeBtn + 5 + width_label);
        float labelOriginY = originY_backView4 + i / 2 * height_label;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        btn.frame = CGRectMake(btnOriginX, labelOriginY+originY_btn, Width_TypeBtn, Height_TypeBtn);
        [btn setBackgroundImage:[UIImage imageNamed:@"选项-未选.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView4 addSubview:btn];
        
        float labelOriginX = btnOriginX + Width_TypeBtn + 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelOriginX, labelOriginY, width_label, height_label)];
        label.text = [complainTypeArray objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor clearColor];
        [backView4 addSubview:label];
    }
    backView4.hidden = YES;
    markComplainTypeBtnTag = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (backView4.hidden == NO)
        [self selectBtnClicked];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
            
        default:
            break;
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    int maxLength = 10;
    
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

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (backView4.hidden == NO)
        [self selectBtnClicked];
    
    float changeHeight;
    CGRect oldFrame = self.view.frame;
    if (oldFrame.size.height <= 480)
    {
        changeHeight = 170;
    }
    else
    {
        changeHeight = 80;
    }
    
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y - changeHeight, oldFrame.size.width, oldFrame.size.height)];
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    float changeHeight;
    CGRect oldFrame = self.view.frame;
    if (oldFrame.size.height <= 480)
    {
        changeHeight = 260;
        if (backView4.hidden)
            changeHeight = 170;
    }
    else
    {
        changeHeight = 190;
        if (backView4.hidden)
            changeHeight = 80;
    }
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [self.view setFrame:CGRectMake(oldFrame.origin.x, oldFrame.origin.y + changeHeight, oldFrame.size.width, oldFrame.size.height)];
    [UIView commitAnimations];
    
    [textView resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location >= 500)
        return NO;
    return YES;
}

-(void)textViewEditChanged:(NSNotification *)obj
{
    UITextView *textView = (UITextView *)obj.object;
    int maxLength = 500;
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"])
    { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > maxLength)
            {
                textView.text = [toBeString substringToIndex:maxLength];
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
            textView.text = [toBeString substringToIndex:maxLength];
        }
    }
}

#pragma mark - 按钮点击事件
-(void)selectBtnClicked
{
    if (backView4.hidden)
    {
        selectImgView.image = [UIImage imageNamed:@"请选择-展开.png"];
        backView4.hidden = NO;
        CGRect backView3Frame = backView3.frame;
        backView3.frame = CGRectMake(0, backView3Frame.origin.y + backView4.bounds.size.height, self.view.bounds.size.width, backView3Frame.size.height);
    }
    else
    {
        selectImgView.image = [UIImage imageNamed:@"请选择.png"];
        backView4.hidden = YES;
        CGRect backView3Frame = backView3.frame;
        backView3.frame = CGRectMake(0, backView3Frame.origin.y - backView4.bounds.size.height, self.view.bounds.size.width, backView3Frame.size.height);
    }
}

-(void)complainBtnClicked
{
    UIButton *oldBtn = (UIButton *)[backView4 viewWithTag:markComplainTypeBtnTag];
    [oldBtn setBackgroundImage:[UIImage imageNamed:@"选项-未选.png"] forState:UIControlStateNormal];
    markComplainTypeBtnTag = -1;
    contentTextView.text = @"";
    
    if (complainBtnSelected)
    {
        complainBtnSelected = NO;
        [complainBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议未选择.png"] forState:UIControlStateNormal];
        [adviseBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议选择.png"] forState:UIControlStateNormal];
    }
    else
    {
        complainBtnSelected = YES;
        [complainBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议选择.png"] forState:UIControlStateNormal];
        [adviseBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议未选择.png"] forState:UIControlStateNormal];
    }
}

-(void)adviseBtnClicked
{
    UIButton *oldBtn = (UIButton *)[backView4 viewWithTag:markComplainTypeBtnTag];
    [oldBtn setBackgroundImage:[UIImage imageNamed:@"选项-未选.png"] forState:UIControlStateNormal];
    markComplainTypeBtnTag = -1;
    contentTextView.text = @"";
    
    if (complainBtnSelected)
    {
        complainBtnSelected = NO;
        [complainBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议未选择.png"] forState:UIControlStateNormal];
        [adviseBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议选择.png"] forState:UIControlStateNormal];
    }
    else
    {
        complainBtnSelected = YES;
        [complainBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议选择.png"] forState:UIControlStateNormal];
        [adviseBtn setBackgroundImage:[UIImage imageNamed:@"投诉建议未选择.png"] forState:UIControlStateNormal];
    }
}

-(void)typeBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == markComplainTypeBtnTag)
    {
        return;
    }
    else
    {
        UIButton *oldBtn = (UIButton *)[backView4 viewWithTag:markComplainTypeBtnTag];
        [oldBtn setBackgroundImage:[UIImage imageNamed:@"选项-未选.png"] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"选项-已选.png"] forState:UIControlStateNormal];
        markComplainTypeBtnTag = btn.tag;
    }
}

-(void)submitBtnClicked
{
    if (markComplainTypeBtnTag < 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您忘记选择问题类型了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    if (![self validContactMan])
    {
        return;
    }
    
    if (![self validPhoneNum])
    {
        return;
    }
    
    if(![self validContent])
    {
        return;
    }
    NSString *userName = contactTextField.text;
    NSString *phoneNum = telephoneTexField.text;
    NSString *content = contentTextView.text;
    
    NSString *type;
    if (complainBtnSelected)
        type = @"0";
    else
        type = @"1";
    
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] complain:userName phoneNum:phoneNum complainType:type content:content contentType:[complainTypeArray objectAtIndex:markComplainTypeBtnTag - 100] delegate:self];
    request = nil;
}

#pragma mark - 一系列校验函数
-(BOOL)validContent
{
    if (0 == contentTextView.text.length)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请您输入要投诉或建议的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

-(BOOL)validContactMan
{
    if (0 == contactTextField.text.length)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您忘记输入姓名了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (BOOL)validPhoneNum
{
    if (0 == telephoneTexField.text.length)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您忘记输入手机号了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:telephoneTexField.text] == YES) ||
        ([regextestcm evaluateWithObject:telephoneTexField.text] == YES) ||
        ([regextestct evaluateWithObject:telephoneTexField.text] == YES) ||
        ([regextestcu evaluateWithObject:telephoneTexField.text] == YES))
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

#pragma mark - FMNetworkManager delegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_complain])
    {
        NSString *showMsg;
        if (complainBtnSelected)
        {
            showMsg = @"您的问题我们会尽快处理。\n因为有你，我们会越来越好。";
        }
        else
        {
            showMsg = @"非常感谢您宝贵的建议。\n因为有你，我们会越来越好。";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功" message:showMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 888;
        [alertView show];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_complain])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交建议失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 888;
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (888 == alertView.tag)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
