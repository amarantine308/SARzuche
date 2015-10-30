//
//  UserCenterViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterCellTableViewCell.h"
#import "UserInfoViewController.h"
#import "BLNetworkManager.h"
#import "MyOrdersViewController.h"
#import "MyAccountViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "constString.h"
#import "MyTicketViewController.h"
#import "MyMessageViewController.h"
#import "ChangePassWordViewController.h"
#import "LoginViewController.h"
#import "IdentifyVerificationViewController.h"
#import "RentCarViewController.h"
#import "DiscountCouponController.h"
#import "LoadingClass.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "PublicFunction.h"





#define  TAG_MYORDER  1 //我的订单
#define  TAG_RENT     2 //企业租车意向
#define  TAG_MYCOUNT  3 //我的钱包
#define  TAG_COUPON   4 // 我的优惠劵
#define  TAG_REALNAME 5 //实名认证
#define  TAG_MYTICKET 6 //我的发票


#define  TAG_USERMYINFO   11//我的资料
#define  TAG_MYMESSAGE    12//我的消息
#define  TAG_CHANGEPSW    13//修改密码

#define  TAG_MORE         1000//更多
#define  TAG_MESSAGE      1001//消息

#define  TAG_CHOOSEAVATER 100// 选择头像
#define  TAG_CAMAER       101//相机
#define  TAG_Library      102//图片库
#define  TAG_VIEWBG       103//模态背景





@interface UserCenterViewController ()
{
    shortMenuEnum m_jumpTo;
}
@end

@implementation UserCenterViewController
@synthesize m_user=_m_user;



-(id)initForShortMenu:(shortMenuEnum)page
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        m_jumpTo = page;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if ([PublicFunction ShareInstance].m_bLogin == YES)
    {
        //刷新 登陆
        _container1.hidden = YES;
        _container2.hidden = NO;
#if 1//DEBUG
        _phone.text=[User shareInstance].phone;
#else
        _phone.text=[User shareInstance].name;
#endif
        NSString *avaterStr = [NSString stringWithFormat:@"%@",[User shareInstance].headImage];
        NSURL *avaterUrl =[NSURL URLWithString:avaterStr];
        self._avater.image = [UIImage imageNamed:@"usercenter_avater2.png"];
       // [self._avater setImageWithURL:avaterUrl placeholderImage:[UIImage imageNamed:@"usercenter_avater2.png"]];
       // /*
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
        _container3.hidden = NO;

    }
    else
    {
        _container1.hidden = NO;
        
    }
  
}

-(void)viewDidAppear:(BOOL)animated
{
    if (m_jumpTo == menu_myorder)
    {
        m_jumpTo = menu_home;
        [self toMyOrder];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_MYCENTER];
    }
//    [[BLNetworkManager shareInstance] modifyOrderWithOrderId:@"23" backNet:@"2014-10-18" startTime:@"2014-10-18" endTime:@"2014-10-18" deposit:@"2014-10-18" addDeposit:@"2014-10-18" timeDeposit:@"2014-10-18" mileageDeposit:@"2014-10-18" dispatchDeposit:@"2014-10-18" delegate:self];

    _container1.userInteractionEnabled = YES;
    _table.separatorStyle=UITableViewCellSeparatorStyleNone;
    self._avater.layer.masksToBounds = YES;
    self._avater.layer.cornerRadius = 40;
}

- (IBAction)btnClick:(id)sender
{
    UIButton *btn = sender;
    if ([PublicFunction ShareInstance].m_bLogin == YES)
    {
        switch (btn.tag)
        {
            case TAG_MYCOUNT:
            {
                MyAccountViewController *count = [[MyAccountViewController alloc] init];
                [self.navigationController pushViewController:count animated:YES];
                
            }
                break;
            case TAG_MYORDER:
            {
                [self toMyOrder];
            }
                break;
            case TAG_RENT:
            {
                RentCarViewController *v = [[RentCarViewController alloc] init];
                [self.navigationController pushViewController:v animated:YES];
            }
                break;
            case TAG_COUPON:
            {
                DiscountCouponController *coupon = [[DiscountCouponController alloc] init];
                [self.navigationController pushViewController:coupon animated:YES];
            }
                break;
            case TAG_MYMESSAGE:
            {
                MyMessageViewController *message = [[MyMessageViewController alloc] init];
                [self.navigationController pushViewController:message animated:YES];
                
            }
                break;
            case TAG_REALNAME:
            {
                IdentifyVerificationViewController *idetifity = [[IdentifyVerificationViewController alloc] init];
                idetifity.enterType = IVViewFromHomeView;
                [self.navigationController pushViewController:idetifity animated:YES];
            }
                break;
            case TAG_MYTICKET:
            {
                MyTicketViewController *ticket = [[MyTicketViewController  alloc] init];
                [self.navigationController pushViewController:ticket animated:YES];
            }
                break;
            case TAG_USERMYINFO:
            {
                UserInfoViewController *user=[[UserInfoViewController alloc] init];
                [self.navigationController pushViewController:user animated:YES];
            }
                break;
            case TAG_CHANGEPSW:
            {
                ChangePassWordViewController *change = [[ChangePassWordViewController alloc] init];
                [self.navigationController pushViewController:change animated:YES];
            }
                break;
            case TAG_MESSAGE:
            {
                MyMessageViewController *message = [[MyMessageViewController alloc] init];
                [self.navigationController pushViewController:message animated:YES];
            }
                break;
            case TAG_MORE:
            {
            }
                break;
            default:
                break;
            }
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        login.isFromUserCenter = YES;

        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
}


-(void)toMyOrder
{
    MyOrdersViewController *tmpOrders = [[MyOrdersViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpOrders animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--IBAction
- (IBAction)loginAction:(id)sender
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.isFromUserCenter = YES;
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:loginNav animated:YES completion:^{
    }];
   
}
- (IBAction)chooseAvaterAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case TAG_CHOOSEAVATER:
        {
            UIView *view_bg = [[UIView alloc] initWithFrame:self.view.bounds];
            view_bg.tag=TAG_VIEWBG;
            view_bg.backgroundColor = [UIColor blackColor];
            view_bg.alpha=0.7;
            [self.view addSubview:view_bg];
            _container4.frame = CGRectMake(0,self.view.frame.size.height-_container4.frame.size.height, _container4.frame.size.width, _container4.frame.size.height);
            [view_bg addSubview:_container4];

        }
            break;
        case TAG_CAMAER:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
				UIImagePickerController *insertPicker = [[UIImagePickerController alloc] init];
				insertPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[insertPicker setDelegate:self];
                insertPicker.allowsEditing = YES;
                [self presentViewController:insertPicker animated:YES completion:^{
                    

                }];
			}
		
        }
            
            break;
        case TAG_Library:
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

- (IBAction)logOutAction:(id)sender
{
     UIAlertView *v = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     v.delegate = self;
     [v show];
}
#pragma mark ---UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [PublicFunction ShareInstance].m_bLogin = NO;
        _container1.hidden = NO;
        _container2.hidden = YES;
        _container3.hidden = YES;
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
        UIView *view_bg=[self.view viewWithTag:TAG_VIEWBG];
        [view_bg removeFromSuperview];
    }];
}
#pragma mark---dataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserLogin])
    {
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserLogin])
    {
        
    }
}

@end
