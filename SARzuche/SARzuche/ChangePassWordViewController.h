//
//  ChangePassWordViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "BLNetworkManager.h"

@interface ChangePassWordViewController : NavController<UITextFieldDelegate>
{

    __weak IBOutlet UITextField *_passWordConfirm;
    __weak IBOutlet UITextField *_newPassWord;
    __weak IBOutlet UITextField *_currentPassWord;
    NSTimer *_timer;
    NSInteger _count;
    UIAlertView *_alert;
}
@property (nonatomic , retain)  NSTimer *timer;

- (IBAction)sureAction:(id)sender;

@end
