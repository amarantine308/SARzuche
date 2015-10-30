//
//  FindPassWordConfirmViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
@interface FindPassWordConfirmViewController : NavController<UITextFieldDelegate,UIAlertViewDelegate>
{
    __weak IBOutlet UITextField *_passWord;
    __weak IBOutlet UITextField *_passwordAgin;
    __weak IBOutlet UIButton *isSeePassWord;
    BOOL isSee;
    
    
    
}
@property (nonatomic,copy) NSString *YZM;
@property (nonatomic,copy) NSString *phoneMum;
- (IBAction)resignAction:(id)sender;
@end
