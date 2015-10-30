//
//  FindPassWordYZMViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
@interface FindPassWordYZMViewController : NavController<UITextFieldDelegate>
{

    __weak IBOutlet UITextField *_YZM;
    __weak IBOutlet UITextField *_phone;
    __weak IBOutlet UIButton *_sendYZM;
    
    __weak IBOutlet UILabel *_senaYZMLabel;
    NSInteger _countDown;
    NSTimer *_timer;
    int _count;


}
@property (nonatomic, retain) NSTimer *timer;

- (IBAction)resignAction:(id)sender;

@end
