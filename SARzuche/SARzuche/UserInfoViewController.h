//
//  UserInfoViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "UserInfoCell.h"
#import "User.h"
@interface UserInfoViewController : NavController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *_table;
    NSString *_realName;
    NSString *_nikeName;
    NSString *_eamil;
    NSString *_place;
    
    
}
@property (nonatomic ,copy) NSString *realName;
@property (nonatomic ,copy) NSString *nikeName;
@property (nonatomic ,copy) NSString *eamil;
@property (nonatomic ,copy) NSString *place;

@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,copy) NSString *income;
@property (nonatomic ,copy)  NSString *userId;

@property (nonatomic,retain) UIImageView *_avater;




@end
