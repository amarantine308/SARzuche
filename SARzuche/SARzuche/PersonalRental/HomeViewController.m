//
//  HomeViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HomeViewController.h"
#import "constString.h"
#import "ConstDefine.h"
#import "PersonalRentalViewController.h"
#import "MyCarViewController.h"
#import "CarInfoViewController.h"
#import "UserCenterViewController.h"
#import "BLNetworkManager.h"
#import "PreferentialViewController.h"
#import "LoginViewController.h"
#import "BranchesMapViewController.h"
#import "GasStationViewController.h"
#import "NavigationViewController.h"
#import "PublicFunction.h"
#import "NewVersionPromptView.h"
#import "PublicFunction.h"
#import "AdContentViewController.h"
#import "HelpViewController.h"
#import "ConstImage.h"
#import "NSString+md5plus.h"
#import "PreOderViewController.h"
#import "GivebackViewController.h"


#define FRAME_NEW_VERSION     CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)


#define FRAME_HOME_VIEW     CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight -controllerViewStartY)
#define FRAME_MENU_BTN      CGRectMake(10, 8, 60, 30)

#define NUM_OF_ADERVERTISEMENT      @"5"


#define IMG_MENU        @"home_menu.png"

@interface HomeViewController ()
{
    /*
     * 菜单按钮
     */
    UIButton *_menuBtn;
    
    NSArray *m_adImageArr;
    
    HomeView *m_homeView;
    
    NSTimer *m_heartBeatTimer;
}

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#if 0
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getVersion]];
//    if([BLNetworkManager shareInstance].keyStr.length==0)
    {
        FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance]checkVersion_currentVersion:curVer
                                                                                               type:@"ios"
                                                                                           delegate:self ];
        
        tmpRequest=nil;
    }
#endif
    
    [self initHomeView];
    
   [self checkVersion];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(customNavBarView)
    {
        [customNavBarView setLeftButton:IMG_MENU target:self leftBtnAction:@selector(menuBtnPressed)];
    }
    
//    [customNavBarView setTitle:STR_HOME_TITLE];
    [customNavBarView setTitleBackImg:IMG_LOGO];
        
    [self getAdvertisement];
    
//    [self heartBeatStart];
    
    [self addGestureRecognizer];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self removeGestureRecognizer];
}

-(void)addGestureRecognizer
{
#if 0
    if (delegate &&[delegate respons registerGesture]) {
        [delegate ]
    }
#endif
}


-(void)removeGestureRecognizer
{
    
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    return app_Version;
}

-(NSString *)getBuildVersion
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    CFShow((__bridge CFTypeRef)(infoDictionary));

    // app build版本
    NSString *app_build = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];
    
    return app_build;
}

// 获取广告
-(void)getAdvertisement
{
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getAdvertisement:NUM_OF_ADERVERTISEMENT type:@"2" delegate:self];

    req = nil;
}

-(void)recharge:(NSDictionary *)srvData
{
    NSDictionary *dic = srvData;
    NSString *strFlowId = [dic objectForKey:@"flowId"];
    
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] rechargeWithUid:[User shareInstance].id payNum:@"" amount:@"1000000" chargeChannel:@"" cardStyle:@"" bankName:@"" cardNumber:@"" flowId:strFlowId delegate:self];
    req = nil;
}

-(void)forTest1
{
   
//    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarPriceWithCarId:@"1" startTime:@"" delegate:self];
//    req = nil;
    
 //   FMNetworkRequest *req = [[BLNetworkManager shareInstance] exchangeCouponWithUserId:@"2" authcode:@"tuw1l2" delegate:self];
 //   req = nil;

//    FMNetworkRequest *req = [[BLNetworkManager shareInstance] computeRenewWithUid:[UserLoginData shareInstance].m_id carId:@"1" duration:@"2.5" delegate:self];
    
//    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getRenewFullInfoWithUid:[UserLoginData shareInstance].m_id carId:@"1" delegate:self];
    //    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getAdvertisement:@"5" type:@"2" delegate:self];
//    req = nil;
//    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getMyCouponWithUserId:@"2" takeTime:@"" givebackTime:@"" type:@"" delegate:self];
    
//    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getCouponUseRecordWithUserId:@"2" takeTime:@"" givebackTime:@"" delegate:self];
//    request = nil;
}


-(void)forTest
{
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] loginAction_supervisionLogin:@"13851729204" password:[NSString md5Str:@""] type:@"ios" delegate:self];
    request = nil;
}

// 检查版本
-(void)checkVersion
{
#if 0
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getVersion]];
#else
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getBuildVersion]];
#endif
    FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance]checkVersion_currentVersion:curVer
                                                                                           type:@"ios"
                                                                                       delegate:self ];
    tmpRequest=nil;
}

/**
 *方法描述：新版本提示
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)newVersion:(FMNetworkRequest *)request
{
#if 0
    //    [self forTest];
    NSString *strVersion = request.responseData;
    NSString *ver = [[PublicFunction ShareInstance] lastVersion:nil];
    if(![ver isEqualToString:strVersion])
    {
        NewVersionPromptView *tmpView = [[NewVersionPromptView alloc] initWithFrame:FRAME_NEW_VERSION];
        //        [tmpView setNewVersionValue:strVersion size:@"12 MB" content:@"abcdefghijklmnopqrstuvwxyz"];
        [tmpView show];
    }
#else
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:STR_FOND_NEW_VERSION delegate:self cancelButtonTitle:STR_JUST_A_MOMENT otherButtonTitles:STR_UPDATE_VERSION, nil];
        alertView.delegate = self;
        [alertView show];
#endif
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"ALERT BUTTON 0");
    }
    else
    {
        NSLog(@"ALERT BUTTON 1");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app"]];
        //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wan-zhuan-quan-cheng/id692579125?mt=8"]];
    }
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)initHomeView
{
    m_homeView = [[HomeView alloc] initWithFrame:FRAME_HOME_VIEW];
    m_homeView.delegate = self;

    [self.view addSubview:m_homeView];
}

/**
 *方法描述：菜单按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)menuBtnPressed
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    DDMenuController *menuController = (DDMenuController*)app.menuController;
    [menuController showLeftController:YES];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)saveUserLogin:(FMNetworkRequest *)request
{
//    NSDictionary *dic = request.responseData;
//    NSDictionary *loginDic = [dic objectForKey:@"user"];
//    [[UserLoginData shareInstance] setUserLoginData:loginDic];
//    [self forTest1];
    
//    FMNetworkRequest *req = [[BLNetworkManager shareInstance] createPayNum:[User shareInstance].id delegate:self];
//    req = nil;
}

// 更新广告
-(void)updateAdvertisement:(FMNetworkRequest *)request
{
    /*{
     adLists =     (
     {
     contenturl = "";
     id = 6d812333ae3845d2b1a73bd51750b83f;
     picurl = "/upload/T1.3-targetCell.jpg";
     }
     );
     }
*/
    NSDictionary *dic = request.responseData;
    NSArray *imgArr = [dic objectForKey:@"adLists"];
    
    m_adImageArr = [[NSArray alloc] initWithArray:imgArr];
    NSLog(@" IMAGE UPDATE ");
    
    [m_homeView setImageArr:m_adImageArr];
}

// 更新广告
-(void)updateAdFailed
{
    NSDictionary *dic = nil;

    NSMutableDictionary *testDic = nil;
    NSMutableArray *testArr = [[NSMutableArray alloc] initWithCapacity:10];
    testDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSDictionary *d1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"contenturl", @"6d812333ae3845d2b1a73bd51750b83f", @"id", @"/upload/T1.3-targetCell.jpg", @"picurl", nil];
    [testArr addObject:d1];
    [testArr addObject:d1];
    [testArr addObject:d1];
    [testArr addObject:d1];
    [testArr addObject:d1];
    NSDictionary *list = [[NSDictionary alloc] initWithObjectsAndKeys:testArr, @"adLists", nil];
    dic = [[NSDictionary alloc] initWithDictionary:list];
    
    
    NSArray *imgArr = [dic objectForKey:@"adLists"];
    
    m_adImageArr = [[NSArray alloc] initWithArray:imgArr];
    NSLog(@" IMAGE UPDATE ");
    
    [m_homeView setImageArr:m_adImageArr];
}
#pragma mark FMNetworkRequest delegate

/**
 *方法描述：请求成功
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_CheckVersion])
    {
        [self newVersion:fmNetworkRequest];
//        [self saveUserLogin:fmNetworkRequest];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserLogin]) {
//        [self forTest1];
//        [self saveUserLogin:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getAdvertisement])
    {
        [self updateAdvertisement:fmNetworkRequest];
//        [self forTest];
    }

    else if([fmNetworkRequest.requestName isEqualToString:kRequest_createPayNum])
    {
        [self recharge:fmNetworkRequest.responseData];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
//    [self updateAdFailed];
}

#pragma mark -HomeView Delegate
// 选择进入广告
-(void)enterAd:(NSString*)url
{
    NSLog(@"enter ad %@", url);
    AdContentViewController *tmpCtrl = [[AdContentViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

/*
*方法描述：进入分时租车
*创建人：
*创建时间：
*修改人：
*修改原因：
*修改时间：
*/
-(void)enterPersonalRental
{
    PersonalRentalViewController *tmpPersonalController = [[PersonalRentalViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:tmpPersonalController animated:YES];
}

// 进入我的订单
-(void)enterMyOrder
{
    UserCenterViewController *user = [[UserCenterViewController alloc] initForShortMenu:menu_myorder];
    [self.navigationController pushViewController:user animated:NO];
}
//进入帮助
-(void)enterHelper
{
    HelpViewController *tmpCtrl = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:tmpCtrl animated:NO];
}

/**
 *方法描述：进入企业租车
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)enterCompanyRental
{
    NSLog(@"enterCompanyRental");
    CarInfoViewController *nextVC = [[CarInfoViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
    nextVC = nil;
}

// 进入个人租车
-(void)enterPreRentl
{
    NSLog(@"ENTER PRERENTAL");
    PreOderViewController *ctrl = [[PreOderViewController alloc] initFromOrderHistory];
    [self.navigationController pushViewController:ctrl animated:YES];
    ctrl  = nil;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 进入周边网点
-(void)enterBranches
{
    NSLog(@"enterBranches");
    
    //周边网点
    BranchesMapViewController *vc1 = [[BranchesMapViewController alloc] init];
    vc1.enterType = MapViewFromHomeView;
    UINavigationController *navi1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    UIView *branchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIImageView *branchimg = [[UIImageView alloc] initWithFrame:branchView.bounds];
    branchimg.image = [UIImage imageNamed:@"icon-定位.png"];
    [branchView addSubview:branchimg];
//    UIImage *testImg = [self makeImageWithView:branchView];
//    UIEdgeInsets edge;
//    edge.top = 10;
//    edge.left = -20;
//    edge.right = 20;
//    edge.bottom = -10;
//    testImg = [testImg imageWithAlignmentRectInsets:edge];

    
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"网点" image:nil tag:1];
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"icon-定位.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon-定位-灰.png"]];
#if    1
    [item1 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
#else
    [item1 setTitlePositionAdjustment:UIOffsetMake(20, -15)];
    [item1 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
    [item1 setImageInsets:UIEdgeInsetsMake(5, -30, -5, 30)];
#endif
    navi1.tabBarItem = item1;
    
    //加油站
    GasStationViewController *vc2 = [[GasStationViewController alloc] init];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"加油站" image:nil tag:2];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"icon-加油站.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon-加油站-灰.png"]];
#if    1
    [item2 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
#else
    [item2 setTitlePositionAdjustment:UIOffsetMake(20, -15)];
    [item2 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
    [item2 setImageInsets:UIEdgeInsetsMake(5, -35, -5, 35)];
#endif
    navi2.tabBarItem = item2;
    
    //导航
    NavigationViewController *vc3 = [[NavigationViewController alloc] init];
    vc3.enterType = NavigationViewFromHomeView;
    UINavigationController *navi3 = [[UINavigationController alloc] initWithRootViewController:vc3];

    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"导航" image:nil tag:3];
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"icon-导航.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon-导航-灰.png"]];
#if    1
    [item3 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
#else
    [item3 setTitlePositionAdjustment:UIOffsetMake(20, -15)];
    [item3 setTitleTextAttributes:@{UITextAttributeFont:FONT_LABEL} forState:UIControlStateNormal];
    [item3 setImageInsets:UIEdgeInsetsMake(5, -30, -5, 30)];
#endif
    navi3.tabBarItem = item3;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:navi1, navi2, navi3, nil]];
    [self.navigationController pushViewController:tabBarController animated:YES];
    
    vc1 = nil;
    vc2 = nil;
    vc3 = nil;
    
    item1 = nil;
    item2 = nil;
    item3 = nil;
    
    navi1 = nil;
    navi2 = nil;
    navi3 = nil;
    tabBarController = nil;
}

/**
 *方法描述：进入个人中心
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)enterMyInfo
{
    NSLog(@"enterMyInfo");
    UserCenterViewController *user = [[UserCenterViewController alloc] init];
    [self.navigationController pushViewController:user animated:YES];
}

/**
 *方法描述：进入我的车辆
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)enterMyCar
{
    if ([PublicFunction ShareInstance].m_bLogin)
    {
        NSLog(@"enterMyCar");
        MyCarViewController *tmpMyCarCtrl = [[MyCarViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:tmpMyCarCtrl animated:YES];
    }
    else
    {
        LoginViewController *tmpCtrl = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:tmpCtrl];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
}


/**
 *方法描述：进入兑换优惠券
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)enterPreferential
{
    
#if 0
    GivebackViewController *ctrl = [[GivebackViewController alloc] initWithSuccessData:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
    return;
#endif
    if ([PublicFunction ShareInstance].m_bLogin)
    {
        NSLog(@"enterPreferential");
        PreferentialViewController *tmpController = [[PreferentialViewController alloc]initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:tmpController animated:YES];
    }
    else
    {
        LoginViewController *tmpCtrl = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:tmpCtrl];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
    
}


/**
 *方法描述：注册推送
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)registerPush
{
#if 0
    //消息推送支持的类型
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
#endif
}

#pragma mark - heart beat
-(void)heartBeatStart
{
    m_heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(heartBeatTimer) userInfo:nil repeats:YES];
}


-(void)heartBeatTimer
{
    if ([BLNetworkManager needHeartBeatReq])
    {
        NSLog(@"!! CHECK VERSION REQUEST !!");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self checkVersion];
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        });
    }

}

-(void)heartBeatStop
{
    [m_heartBeatTimer invalidate];
    m_heartBeatTimer = nil;
}

-(void)dealloc
{
    [self heartBeatStop];
}

@end
