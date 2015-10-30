//
//  UserCenterViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "ChangePassWordViewController.h"
#import "User.h"

//个人中心
@interface UserCenterViewController :  NavController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    User *_m_user;
    __weak IBOutlet UILabel *_phone;
    
    IBOutlet UIView *_container1;//租车欢迎您（未登陆的情况下）
    IBOutlet UIView *_container2;//头像（登陆的情况下）
    IBOutlet UIView *_container3;//退出
    IBOutlet UITableView *_table;
    IBOutlet UIView *_container4;//选择照片
}
@property (retain,nonatomic)User *m_user;
@property (weak, nonatomic) IBOutlet UIImageView *_avater;
- (IBAction)btnClick:(id)sender;

-(id)initForShortMenu:(shortMenuEnum)page;

@end
