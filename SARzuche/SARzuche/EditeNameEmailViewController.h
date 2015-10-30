//
//  EditeNameEmailViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"


@interface EditeNameEmailViewController : NavController<UITextFieldDelegate>
{

    __weak IBOutlet UITextField *_text;
    __weak IBOutlet UILabel *_numberLabel;
    int _tag;
    int strLength;

}
@property (nonatomic ,assign) int tag;
@property (nonatomic ,assign) int strLength;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;

- (IBAction)resignAction:(id)sender;
- (IBAction)sureAction:(id)sender;
@end
