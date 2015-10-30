//
//  EditeNameEmailViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "EditeNameEmailViewController.h"
#import "UserInfoViewController.h"

#define TAG_REALNAME   1
#define TAG_NICKNAME   2
#define TAG_EMAIL      6
#define TAG_PLACE      7

@interface EditeNameEmailViewController ()

@end

@implementation EditeNameEmailViewController
@synthesize tag = _tag,strLength=_strLength;

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
        [customNavBarView setTitle:self.title];
    }
    // Do any additional setup after loading the view from its nib.
    _text.text=self.content;
    _numberLabel.text = [NSString stringWithFormat:@"%d/%d",_text.text.length,self.strLength];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFiledChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)resignAction:(id)sender
{
    [_text resignFirstResponder];
}

- (IBAction)sureAction:(id)sender
{
    UserInfoViewController *userInfo =[self.navigationController.viewControllers objectAtIndex:2];
    switch (self.tag) {
        case TAG_REALNAME:
        {
            userInfo.realName = _text.text;
        }
            break;
        case TAG_NICKNAME:
        {
            userInfo.nikeName=_text.text;
        }
            break;
        case TAG_EMAIL:
        {
            userInfo.eamil=_text.text;
 
        }
            break;
        case TAG_PLACE:
        {
            userInfo.place=_text.text;
        }
            break;
            
        default:
            break;
    }
     [self.navigationController popToViewController:userInfo animated:YES];
}
#pragma mark-UITexFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_text  ==  textField)
    {
        if ((self.tag==1)||(self.tag==2))
        {
            if ([aString length] > 24)
            {
                textField.text = [aString substringToIndex:24];
                return NO;
            }
        }
        else
        {
            if ([aString length] > 50)
            {
                _numberLabel.text = [NSString stringWithFormat:@"%d/%d",textField.text.length,self.strLength];
                textField.text = [aString substringToIndex:50];
                return NO;
            }
        }
        if ([@"" isEqualToString:string]) {
            _numberLabel.text = [NSString stringWithFormat:@"%d/%d",textField.text.length - 1,self.strLength];
        }
        else
        {
            _numberLabel.text = [NSString stringWithFormat:@"%d/%d",textField.text.length + [string length],self.strLength];
        }
    }
    return YES;
}

- (void)textFiledChange:(UITextField *)textfield
{
   // _numberLabel.text = [NSString stringWithFormat:@"%d/%d",textfield.text.length,self.strLength];

}
@end
