//
//  UserInfoViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "UserInfoViewController.h"
#import "EditeNameEmailViewController.h"
#import "constString.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "LoadingClass.h"



#define CHOOSE_SEX      1
#define CHOOSE_PAY      2
#define TAG_DATAPICKER  3
#define CHOOSE_AVATER   4
@interface UserInfoViewController ()

@end

@implementation UserInfoViewController
@synthesize eamil=_eamil,place=_place,nikeName=_nikeName,realName=_realName;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        if (customNavBarView)
        {
            [customNavBarView setTitle:STR_MYCENTER_INFO];
            [customNavBarView setRightButtonWithTitle:@"保存" target:self rightBtnAction:@selector(motifiyAction:)]
            ;
            UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
            rightBtn.hidden = YES;
            
        }
    if (IS_IOS7)
    {
         _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    }
    else
    {
         _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds. size.height-44) style:UITableViewStylePlain];
    }
    
        _table.delegate =self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_table];

    [self readData];
    
}
//重载父类返回按钮
-(void)backClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)readData
{
    self.realName = [User shareInstance].name;
    self.nikeName = [User shareInstance].nickName;
    self.place = [User shareInstance].address;
    self.eamil =[User shareInstance].email;
    if ([[User shareInstance].sex isEqualToString:@"F"])
    {
        self.sex=@"女";
    }
    else
    {
        self.sex = @"男";
    }
    self.income=[User shareInstance].income;
    self.birthday=[User shareInstance].birthday;
    self.userId = [User shareInstance].id;
}
- (void)motifiyAction:(id)sender
{
   /*
    FMNetworkRequest *tmpRequest=  [[BLNetworkManager shareInstance] changeUserInfowithUserId:[User shareInstance].id
                                                                                         name:@"冯毅潇"
                                                                                     nikeName:@"Amarantine"
                                                                                          sex:@"F"
                                                                                     birthday:@"1991-03-08"
                                                                                       income:@"100"
                                                                                        email:@"651544620@qq.com"
                                                                                      address:@"江苏省南京市软件大道170号"
                                                                                    headImage:self._avater.image
                                                                                headImageType:@".jpg"
                                                                                     delegate:self];
    */
    //(性别 M:男F:女)
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    
    NSString *sex_;
    if ([self.sex isEqualToString:@"男"])
    {
        sex_=@"M";
    }
    else
    {
        sex_=@"F";
    }
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] changeUserInfowithUserId:self.userId
                                                                                          name:self.realName
                                                                                      nikeName:self.nikeName
                                                                                           sex:sex_
                                                                                      birthday:self.birthday
                                                                                        income:self.income
                                                                                         email:self.eamil
                                                                                       address:self.place
                                                                                     headImage:self._avater.image
                                                                                 headImageType:@".jpg" delegate:self];
   tempRequest = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.nikeName.length!=0)
    {
        UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        cell.value.text = self.nikeName;

    }
    if (self.realName.length!=0)
    {
        UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.value.text = self.realName;
        
    }
    if (self.place.length!=0)
    {
        UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
        cell.value.text = self.place;
        
    }
    if (self.eamil.length!=0)
    {
        UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        cell.value.text = self.eamil;
    }
    if ((![self.nikeName isEqualToString:[User shareInstance].nickName]) ||
        (![self.realName isEqualToString:[User shareInstance].name])||
        (![self.place isEqualToString:[User shareInstance].address])||
        (![self.eamil isEqualToString:[User shareInstance].email]))
    {
        UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
        rightBtn.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark---UIActionSheetDelegete
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    switch (actionSheet.tag)
    {
        case CHOOSE_PAY:
        {
            NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:2];
            UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:path];
            if ([title isEqualToString:@"取消"])
            {
              title=cell.value.text;
            }
            cell.value.text = title;
            
           
            if (![title isEqualToString:[User shareInstance].income])
            {
                UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
                rightBtn.hidden = NO;
            }
            
            self.income = [NSString stringWithFormat:@"%@", title];
            
        }
            break;
        case CHOOSE_SEX:
        {//(性别 M:男F:女)
            NSIndexPath *path=[NSIndexPath indexPathForRow:2 inSection:1];
            UserInfoCell *cell = (UserInfoCell*)[_table cellForRowAtIndexPath:path];
            if ([title isEqualToString:@"取消"])
            {
                title=cell.value.text;
            }
            cell.value.text = title;
            
            NSString *title_;
            if ([title isEqualToString:@"男"])
            {
                title_=@"M";
            }
            else
            {
                title_=@"F";
            }

            if (![title_ isEqualToString:[User shareInstance].sex])
            {
                UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
                rightBtn.hidden = NO;
            }

            
            self.sex = [NSString stringWithFormat:@"%@", title];
        }
            break;
         case CHOOSE_AVATER:
        {
            switch (buttonIndex) {
                case 0:
                {
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        UIImagePickerController *insertPicker = [[UIImagePickerController alloc] init];
                        insertPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        [insertPicker setDelegate:self];
                        insertPicker.allowsEditing = YES;
                        [self presentViewController:insertPicker animated:YES completion:^{
                        }];
                    }
                }
                    break;
                case 1:
                {
                    UIImagePickerController *insertPicker = [[UIImagePickerController alloc] init];
                    insertPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [insertPicker setDelegate:self];
                    insertPicker.allowsEditing = YES;
                    [self presentViewController:insertPicker animated:YES completion:^{
                    }];
                }
                    break;
                default:
                    break;
            }

            
        }
            break;
        default:
            break;
    }
}
#pragma mark ---UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *_seleteImage = [info valueForKey:UIImagePickerControllerEditedImage];
    self._avater.image=_seleteImage;
    self._avater.layer.masksToBounds=YES;
    self._avater.layer.cornerRadius=40;
    //上传头像
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
        rightBtn.hidden = NO;

    }];

}

#pragma mark---UITableViewDataSource,delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    if (section == 1)
    {
        return 4;
    }
    if (section == 2)
    {
        return 1;
    }
    if (section == 3)
    {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row==0))
    {
        return 130;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titles = @[@"真实姓名",@"昵称",@"性别",@"生日"];
    NSArray *titles2 = @[@"邮箱",@"居住地址"];
    static NSString* cellID = @"UserInfoCell";
    UserInfoCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell"
                                                     owner:self
                                                   options:nil];
        for(id obj in nib)
        {
            if([obj isKindOfClass:[UserInfoCell class]])
            {
                cell = (UserInfoCell *)obj ;
            }
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.value.textColor = [UIColor colorWithRed:137.0/255 green:137.0/255 blue:137.0/255 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section == 0)
    {
        if (indexPath.row==0)
        {
            cell.text.hidden=YES;
            cell.value.hidden=YES;
            cell.accessoryType = UITableViewCellAccessoryNone;

            UIView *aveter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
            self._avater = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 80, 80)];
            self._avater.layer.masksToBounds = YES;
            self._avater.layer.cornerRadius = 40;
            [aveter addSubview:self._avater];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 120, 30)];
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor blackColor];
            name.text = [User shareInstance].phone;
            name.textAlignment = NSTextAlignmentCenter;
            [aveter addSubview:name];
            [cell addSubview:aveter];
            
            NSURL *avaterUrl =[NSURL URLWithString:[User shareInstance].headImage];
            self._avater.backgroundColor = [UIColor grayColor];
            self._avater.image = [UIImage imageNamed:@"usercenter_avater2.png"];
            ///*
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:avaterUrl];
                UIImage *image = [UIImage imageWithData:data];
                if (image)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self._avater.image = image;
                    });
                }
            });
            // */
            //[self._avater setImageWithURL:avaterUrl placeholderImage:[UIImage imageNamed:@"usercenter_avater2.png"]];
        }

    }
    if (indexPath.section == 1)
    {
        cell.text.text = [titles objectAtIndex:indexPath.row];
        if (indexPath.row==0)
        {
            cell.value.text=self.realName;
        }
        if (indexPath.row==1)
        {
            cell.value.text=self.nikeName;
        }
        if (indexPath.row==2)
        {
            //(性别 M:男F:女)
            cell.value.text=self.sex;
        }
        if (indexPath.row==3)
        {
            cell.value.text =self.birthday;
        }
    }
    if (indexPath.section == 2)
    {
        cell.text.text = @" 收入水平";
        cell.value.text=self.income;
    }
    if(indexPath.section == 3)
    {
        cell.text.text = [titles2 objectAtIndex:indexPath.row];
        if (indexPath.row == 0)
        {
            cell.value.text=self.eamil;

        }
        if (indexPath.row==1)
        {
            cell.value.text=self.place;

        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        if (indexPath.row==0)
        {
            //头像
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            sheet.tag = CHOOSE_AVATER;
            [sheet showInView:self.view];
        }
    }
    else if(indexPath.section == 1)
    {
        if((indexPath.row==0)||(indexPath.row==1))
        {
            //姓名和昵称可写24字，邮箱和居住地址可写50
            EditeNameEmailViewController * edite = [[EditeNameEmailViewController alloc] init];
            [self.navigationController pushViewController:edite animated:YES];
            if (indexPath.row==0)//姓名
            {
                edite.tag=1;
                edite.strLength=24;
                edite.title = @"编辑姓名";
                edite.content = self.realName;
                
            }
            if (indexPath.row==1)//昵称
            {
                edite.tag=2;
                edite.strLength=24;
                edite.title = @"编辑昵称";
                edite.content=self.nikeName;
            }
        }
        else if (indexPath.row == 2)
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", nil];
            sheet.tag = CHOOSE_SEX;
            [sheet showInView:self.view];
        }
        else
        {
            UIView *birthdayView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.bounds.size.height-260, self.view.bounds.size.width, 260)];
            birthdayView.tag = TAG_DATAPICKER;

            NSLocale *tmpLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            UIDatePicker *  datePicker = [[UIDatePicker  alloc] init];
            datePicker.backgroundColor = [UIColor whiteColor];
            datePicker.locale = tmpLocal;
            datePicker.frame = CGRectMake(0, 0, self.view.bounds.size.width, 216);
            datePicker.datePickerMode= UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [birthdayView  addSubview:datePicker];
            
            UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            cancle.frame = CGRectMake(0, 216, self.view.bounds.size.width/2, 44);
            [cancle setTitle:@"取消" forState:UIControlStateNormal];
            [cancle setBackgroundImage:[UIImage imageNamed:@"userinfo_cancle"] forState:UIControlStateNormal];
            [cancle addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
            [birthdayView addSubview:cancle];
            
            UIButton *sure = [UIButton buttonWithType:UIButtonTypeCustom];
            [sure setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            sure.frame = CGRectMake(self.view.bounds.size.width/2, 216, self.view.bounds.size.width/2, 44);
            [sure setTintColor:[UIColor blueColor]];
            [sure setTitle:@"确定" forState:UIControlStateNormal];
            [sure setBackgroundImage:[UIImage imageNamed:@"userinfo_sure"] forState:UIControlStateNormal];
            [sure addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
            [birthdayView  addSubview:sure];
            
            [self.view addSubview:birthdayView];

        
        }
    }
    else if (indexPath.section == 2)
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"修改收入水平" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"3000以下",@"3000-5000",@"5000-1W",@"1w-2w",@"2w以上", nil];
        sheet.tag = CHOOSE_PAY;
        [sheet showInView:self.view];
    }
    else
    {
        
        //姓名和昵称可写24字，邮箱和居住地址可写50
        EditeNameEmailViewController * edite = [[EditeNameEmailViewController alloc] init];
        [self.navigationController pushViewController:edite animated:YES];
        if (indexPath.row==0)//邮箱
        {
            edite.tag=6;
            edite.strLength=50;
            edite.title = @"编辑邮箱";
            edite.content=self.eamil;
        }
        if ( indexPath.row==1)//居住地址
        {
            edite.tag=7;
            edite.strLength=50;
            edite.title = @"编辑居住地址";
            edite.content = self.place;
        }
    }
    
}
- (void)dateChanged:(id)sender
{
    UIDatePicker* datePick= (UIDatePicker*)sender;
    NSDate* date = datePick.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    UserInfoCell* cell =(UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    cell.value.text= [dateFormatter stringFromDate:date];
    if (![cell.value.text isEqualToString:[User shareInstance].birthday])
    {
        UIButton *rightBtn = (UIButton*)[self.view viewWithTag:101];
        rightBtn.hidden = NO;
    }
    
    self.birthday = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}
- (void)cancleAction:(UIButton *)sender
{
    UIView *birthdayView = [self.view viewWithTag:TAG_DATAPICKER ];
    [birthdayView removeFromSuperview];
    
    UserInfoCell* cell =(UserInfoCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    cell.value.text= self.birthday;
}
- (void)sureAction:(UIButton *)sender
{
    UIView *birthdayView = [self.view viewWithTag:TAG_DATAPICKER ];
    [birthdayView removeFromSuperview];
}
#pragma mark - FMNetworkManager delegate

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserInFo])
    {
        
    }
    else
    {
        //修改个人资料
        NSString *str =fmNetworkRequest.responseData;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:str
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
 
        FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance]getUserInfoWith:self.userId
                                                                                delegate:self];
        tempRequest=nil;
        
    }
}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserInFo])
    {
        
    }
    else
    {
        //修改个人资料
        NSString *str =fmNetworkRequest.responseData;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:str
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

@end
