//
//  IdentifyVerificationViewController.h
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "CaptureViewController.h"

// 实名认证页面的上一级页面
typedef NS_ENUM(NSInteger, IdentifyVerificationViewEnterType)
{
    IVViewFromHomeView,        // 首页
    IVViewFromRegisterView     // 从注册页面进入实名认证页面
};

@interface IdentifyVerificationViewController : NavController<UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PassImageDelegate,UIActionSheetDelegate>

@property(nonatomic, assign)IdentifyVerificationViewEnterType enterType;
@end
