//
//  MyAccouontWithDrawViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
@interface MyAccouontWithDrawViewController : NavController<UITextFieldDelegate>
{
    __weak IBOutlet UILabel *_avaliabeMoney;
    __weak IBOutlet UITextField *_withDrawMoney;
    __weak IBOutlet UITextField *_YZM;
    __weak IBOutlet UIButton *_sendYZM;
    __weak IBOutlet UILabel *_senaYZMLabel;
    NSInteger _countDown;
    NSTimer *_timer;
    NSString *_banlance;


    
}
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy)NSString *banlance;

- (IBAction)sureAction:(id)sender;
- (IBAction)sendYZMAction:(id)sender;
- (IBAction)resignAction:(id)sender;

@end
