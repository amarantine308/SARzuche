//
//  LaunchLoadingViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchLoadingViewController.h"
#import "ConstDefine.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "DDMenuController.h"
#import "GuideViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "PublicFunction.h"
#import "BLNetworkManager.h"
#import "ConstImage.h"


#define IMG_BACKGROUND_480          @"default.png"
#define IMG_BACKGROUND_568          @"Default-320w-568h.png"

#define FRAME_LOGO              CGRectMake(100, 100, 100, 100)
#define FRAME_BACK_VIEW         CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
#define FRAME_PROMPT            CGRectMake(10, MainScreenHeight / 2, MainScreenWidth, 40)

@interface LaunchLoadingViewController ()
{
    UILabel *m_network_donot_work;
    
    NSInteger m_tryCount;
}

@end

@implementation LaunchLoadingViewController
@synthesize delegate;

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
    //隐藏系统导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
    [self getPreData];
    
    [self initLaunchLoadingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    NSInteger nInterval = 0;
#if 0//SAR_TEST
    nInterval = 1;
#else
    nInterval = 3;
#endif
//    [NSTimer scheduledTimerWithTimeInterval:nInterval target:self selector:@selector(nextStep) userInfo:nil repeats:NO];
}

-(void)getPreData
{
#if 0
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getVersion]];
#else
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getBuildVersion]];
#endif
    [PublicFunction ShareInstance].m_curVersion = curVer;
    
//    if([BLNetworkManager shareInstance].keyStr)
    {
        [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
        
        FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance]checkVersion_currentVersion:curVer
                                                                                               type:@"ios"
                                                                                           delegate:self ];
        
        tmpRequest=nil;
        
        m_tryCount++;
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

-(void)initLaunchLoadingView
{
    UIImage *backgroundImage = [UIImage imageNamed:IMG_BACKGROUND_480];
    if (IS_IPHONE5) {
        backgroundImage = [UIImage imageNamed:IMG_BACKGROUND_568];
    }
    
    UIImageView *backView = [[UIImageView alloc] initWithImage:backgroundImage];
    backView.frame = FRAME_BACK_VIEW;
    
//    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LOGO]];
//    logoView.frame = FRAME_LOGO;
    
    m_network_donot_work = [[UILabel alloc] initWithFrame:FRAME_PROMPT];
    m_network_donot_work.text = STR_NETWORK_DONOT_WORK;
    m_network_donot_work.textColor = COLOR_LABEL_GRAY;//[UIColor whiteColor];
    m_network_donot_work.textAlignment = NSTextAlignmentCenter;
    m_network_donot_work.hidden = YES;
    m_network_donot_work.backgroundColor = [UIColor clearColor];
    [backView addSubview:m_network_donot_work];
    
//    [backView addSubview:logoView];
    
    [self.view addSubview:backView];
}

-(void)nextStep
{
    NSLog(@"Launching...");
    BOOL bFirstLaunch = [[PublicFunction ShareInstance] isFirstLaunch];
    if (bFirstLaunch) {
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        GuideViewController *tmpGuideController = [[GuideViewController alloc] initWithNibName:nil bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tmpGuideController];
        app.window.rootViewController = nav;
    }
    else
    {
        [self jumpToHomePage];
    }
}


-(void)needMoreTry
{
    m_network_donot_work.hidden = NO;
    
    UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [Tap setNumberOfTapsRequired:1];
    [Tap setNumberOfTouchesRequired:1];
    self.view.userInteractionEnabled=YES;
    [self.view addGestureRecognizer:Tap];

}


-(void)exitAPP
{
    if (delegate && [delegate respondsToSelector:@selector(exitOwn)]) {
        [delegate exitOwn];
    }
}

-(void)imagePressed:(UITapGestureRecognizer *)sender
{
    m_network_donot_work.hidden = YES;
    
    [self getPreData];
}

-(void)jumpToHomePage
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    HomeViewController *tmpHomeController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:tmpHomeController];

    app.navigationController = naviController;
    [PublicFunction ShareInstance].rootNavigationConroller = naviController;
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:naviController];
    app.menuController = rootController;
    
    LeftViewController *tmpGuideController = [[LeftViewController alloc] initWithNibName:nil bundle:nil];
    rootController.leftViewController = tmpGuideController;
    rootController.rightViewController = nil;
    
    app.window.rootViewController = app.menuController;
}


#pragma mark FMNetworkRequest delegate

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_CheckVersion]) {
        [self nextStep];
    }
    
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    NSLog(@"loading failed");
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_CheckVersion]) {
        if ([@"" isEqualToString:fmNetworkRequest.responseData] || [@"已是最新版本" isEqualToString:fmNetworkRequest.responseData])
        {
            [self nextStep];
            return;
        }
    }
#if 0//SAR_TEST
    [self nextStep];
#else
    [[LoadingClass shared] hideLoading];
    if (m_tryCount > 3)
    {
        [self exitAPP];
    }
    else
    {
        [self needMoreTry];
    }
#endif
}

@end
