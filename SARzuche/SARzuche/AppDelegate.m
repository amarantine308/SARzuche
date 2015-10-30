 //
//  AppDelegate.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "AppDelegate.h"
#import "ConstString.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LoadingClass.h"
#import "BLNetworkManager.h"
#import "CustomAlertView.h"
//#import "PublicFunction.h"
//#import "HomeViewController.h"
//#import "DDMenuController.h"
//#import "GuideViewController.h"
#import "User.h"
#import "FindPassWordYZMViewController.h"
//#import "LeftViewController.h"
//#import "AlixPayResult.h"
//#import "DataVerifier.h"
//// 百度导航
//#import "BNCoreServices.h"
//#import "BNaviSoundManager.h"
//#import "BLNetworkManager.h"

////百度ID
//#define BAIDUMAPID @"1Tw1jCVkKjnrkkwn9kB5pjXY"


@implementation AppDelegate
@synthesize menuController = _menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSDictionary* payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (payload)
    {
        NSLog(@" receive remote push ");
    }

//    //百度地图
//    mapManager = [[BMKMapManager alloc] init];
//    BOOL ret = [mapManager start:BAIDUMAPID generalDelegate:self]; // BMKGeneralDelegate
//    if (!ret)
//    {
//        NSLog(@"baidu map manager start failed!");
//    }
//    
//    // 初始化导航SDK引擎
//    [BNCoreServices_Instance initServices:BAIDUMAPID];
//    
//    //开启引擎，传入默认的TTS类
//    [BNCoreServices_Instance startServicesAsyn:nil fail:nil SoundService:[BNaviSoundManager getInstance]];
//
    
//    newworkView = [[NetworkStatusView alloc] initWithPromptString:nil];
    
    LaunchLoadingViewController *tmpCtrl = [[LaunchLoadingViewController alloc] initWithNibName:nil bundle:nil];
    tmpCtrl.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpCtrl];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)payload
{
    
}


//iPhone 从APNs服务器获取deviceToken后回调此方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSLog(@"deviceToken:%@", dt);
}

//注册push功能失败 后 返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Push Register Error:%@", err.description);
}


-(void)registerPush
{
    //消息推送支持的类型
    UIRemoteNotificationType types =
    (UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert);
    //注册消息推送
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
}
//
//#pragma mark - BMKGeneralDelegate
//- (void)onGetNetworkState:(int)iError
//{
//    if (0 == iError)
//    {
//        NSLog(@"联网成功");
//    }
//    else
//    {
//        NSLog(@"onGetNetworkState %d",iError);
//    }
//    
//}
//
//- (void)onGetPermissionState:(int)iError
//{
//    if (0 == iError)
//    {
//        NSLog(@"授权成功");
//    }
//    else
//    {
//        NSLog(@"onGetPermissionState %d",iError);
//    }
//}

#pragma mark - exit
-(void)exitOwn
{
    [self exitApplication];
}

- (void)exitApplication {
    
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}



- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);

             NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
             if (resultStatus.intValue == 9000)
             {
                 
                 [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
                 NSString *flowId_ = [[NSUserDefaults standardUserDefaults] objectForKey:@"flowId"];
                 NSString *payMoney_=[[NSUserDefaults standardUserDefaults] objectForKey:@"payMoney"];
                 FMNetworkRequest *temp = [[BLNetworkManager shareInstance] getChargeWithAccount:[User shareInstance].id
                                                                                       chargenum:payMoney_
                                                                                          payNum:flowId_
                                                                                        delegate:self];
                 temp  = nil;
                 
             }
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
#pragma mark--充值返回

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    //账户充值数据回来
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_AccountCharge])
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:2];
        [alert needDismisShow];
        
    }
}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_AccountCharge])
    {
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
                                                            message:fmNetworkRequest.responseData
                                                           delegate:self
                                                  cancelButtonTitle:STR_BACK
                                                  otherButtonTitles:nil
                                                withDismissInterval:2];
    [alert needDismisShow];
    
    }
}

@end
