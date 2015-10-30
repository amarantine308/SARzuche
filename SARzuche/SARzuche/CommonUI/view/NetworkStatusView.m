//
//  NetworkStatusView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-11-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NetworkStatusView.h"
#import "ConstDefine.h"

#define PROMPT_VIEW_W           200
#define PROMPT_VIEW_H           20

#define FRAME_PROMPT_VIEW     CGRectMake((MainScreenWidth - PROMPT_VIEW_W)/2, MainScreenHeight - bottomButtonHeight - PROMPT_VIEW_H/2, PROMPT_VIEW_W, PROMPT_VIEW_H)

#define COLOR_LAEBL_BLUE_ALPHA      [UIColor colorWithHexString:@"#1c9cd6" alpha:0.5f]

@implementation NetworkStatusView
@synthesize m_hostReach;

-(id)initWithPromptString:(NSString *)promptStr
{
    self = [super initWithFrame:FRAME_PROMPT_VIEW];

    if (self) {
        m_prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, PROMPT_VIEW_W, PROMPT_VIEW_H)];
        m_prompt.textColor = [UIColor whiteColor];
        m_prompt.textAlignment = NSTextAlignmentCenter;
        m_prompt.backgroundColor = COLOR_LAEBL_BLUE_ALPHA;//[UIColor blueColor];
//        m_prompt.text = [NSString stringWithFormat:@"%@", promptStr];
        [self addSubview:m_prompt];
        
        if (nil == promptStr) {
            [self initReachability];
        }
    }
    
    return self;
}


#if 0
- (void)updateStatus {
    self.m_remoteHostStatus = [[Reachability sharedReachability] remoteHostStatus];
}

// 通知网络状态
- (void)reachabilityChanged:(NSNotification *)note {
    [self updateStatus];
    if (self.m_remoteHostStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil) message:NSLocalizedString(@"NotReachable", nil)
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

// 程序启动器，启动网络监视
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // 设置网络检测的站点
    [[Reachability sharedReachability] setHostName:@"www.baidu.com"];
    [[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
    // 设置网络状态变化时的通知函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:@"kNetworkReachabilityChangedNotification" object:nil];
    [self updateStatus];
}

- (void)dealloc {
    // 删除通知对象
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


#endif
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    if(NO == [curReach isKindOfClass:[Reachability class]])
    {
        return;
    }
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    switch (status) {
        case ReachableViaWiFi:
            NSLog(@"---WIFI----");
            m_prompt.text = @"WIFI 网络";
            [self showView];
            break;
        case ReachableViaWWAN:
            m_prompt.text = @"2G/3G 网络";
            [self showView];
            NSLog(@"---- WWAN -----");
            break;
        case NotReachable:
            m_prompt.text = @"网络断开...";
            [self showView];
            NSLog(@"----- NOT REACHABLE -----");
            break;
        default:
            NSLog(@"network status : %d", status);
            break;
    }
}

-(void)initReachability
{
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    m_hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [m_hostReach startNotifier];
}

-(void)showView
{
    NSArray* windows = [UIApplication sharedApplication].windows;
    UIWindow *window = [windows objectAtIndex:0];
    //keep the first subview
    if(window.subviews.count > 0){
        [[window.subviews objectAtIndex:0] addSubview:self];
    }
//    [self ]
    m_autoRomveTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeSelf) userInfo:nil repeats:YES];
}

-(void)removeSelf
{
    m_nCount++;
    
    if (m_nCount >= 3) {
        [self removeFromSuperview];
        m_nCount = 0;
    }
}
@end
