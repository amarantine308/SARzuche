//
//  ConstDefine.h
//  SAR
//
//  Created by 徐守卫 on 14-9-9.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#ifndef SAR_ConstDefine_h
#define SAR_ConstDefine_h

#import <Foundation/Foundation.h>
#import "UIColor+Helper.h"

#define SAR_TEST    0

#define AlphaAndNums    @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

//当前设备是否为 iPhone5
#define IS_IPHONE5              ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//
#define kCommonViewBackgroundColor               ([UIColor colorWithRed:239./255. green:239./255. blue:244./255. alpha:1.0f])
#define kNavBackgroundColor                     ([UIColor colorWithRed:0x1c/255. green:0x9C/255. blue:0xD6/255. alpha:1.0f])
#define kCommonTipTextColor                      ([UIColor colorWithRed:228./255. green:1./255. blue:119./255. alpha:1.0f])

#define COLOR_TRANCLUCENT_BACKGROUND            [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]
// 当前系统版本
#define CurrentSystemVersion        ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_VERSION_ABOVE_7         ((CurrentSystemVersion >= 7.0) ? (YES) : (NO))
#define IOS_VERSION_BELOW_6         ((CurrentSystemVersion < 6.0) ? (YES) : (NO))
//状态栏高度
#define kStatusBarHeight              ((IOS_VERSION_ABOVE_7) ? 20 : 0)
#define kViewCaculateBarHeight        ((IOS_VERSION_ABOVE_7) ? 0 : 20)

//设备屏幕frame
#define SCREEN_BOUNDS               [[UIScreen mainScreen] bounds]
#define kMainScreenFrameRect        [[UIScreen mainScreen] bounds]
#define MainScreenWidth             kMainScreenFrameRect.size.width
//#define MainScreenHeight            kMainScreenFrameRect.size.height
#define MainScreenHeight            (kMainScreenFrameRect.size.height - kViewCaculateBarHeight)
//导航条高度
#define kNavigationBarHeight                     44

#define controllerViewStartY                     ((IOS_VERSION_ABOVE_7) ?(kNavigationBarHeight + kStatusBarHeight) : kNavigationBarHeight)
#define bottomButtonHeight                       40
#define spaceViewHeight                          10
#define ORDER_SUBVIEW_STARTY                     110
#define WIDTH_RIGHT_BTN                          30
#define HEIGHT_RIGHT_BTN                         30
#define RIGHT_GAP                                10
#define FRAME_RIGHT_BUTTON1             CGRectMake(MainScreenWidth - WIDTH_RIGHT_BTN - RIGHT_GAP, 5, WIDTH_RIGHT_BTN, HEIGHT_RIGHT_BTN)
#define FRAME_RIGHT_BUTTON2             CGRectMake(MainScreenWidth - (WIDTH_RIGHT_BTN + RIGHT_GAP)*2, 5, WIDTH_RIGHT_BTN, HEIGHT_RIGHT_BTN)

#define STATUS_LABEL_WIDTH                       100
#define FRAME_CERTIFICATION_STATUS       CGRectMake(MainScreenWidth - STATUS_LABEL_WIDTH - RIGHT_GAP, 0, STATUS_LABEL_WIDTH, kNavigationBarHeight)

#define FRAME_DATE_SELECT_VIEW      CGRectMake(0, MainScreenHeight/2, 320, MainScreenHeight/2)

// order status ////1生效 2取消 3租金结算 4全部结算 5续订 6延时
#define SQL_ORDER_CANCEL        @"2"

//
#define DATE_FORMAT_YMDHM               @"yyyy-MM-dd HH:mm"
//#define DATE_FORMAT_YMDHM               @"yyyy-MM-dd a hh:mm"

#define DATE_FORMAT_YMDHMS             @"yyyy-MM-dd HH:mm:ss"

#define TIME_INTERVAL_1HOUR         (1 * 60 * 60)
#define TIME_INTERVAL_3DAYS         (3 * 24 * 60 * 60)
#define TIME_INTERVAL_HALFANHOUR    (1800) // 0.5 * 60 * 60
#define TIME_INTERVAL_5MIN          (5 * 60)
// heart beat
#define HEART_BEAT_CHECK            30 // 30秒检查一次
#define HEART_BEAT_INTERVAL         ((30 -1) * 60 / HEART_BEAT_CHECK) // 30分钟不做请求动作，服务器登录会登录状态强退


#define REQUEST_DATA_ERROR              @"数据解析错误"
#define REQUEST_NETWORK_ERROR              @"网络连接失败"
#define NO_ORDER_CURRENTLY              @"您当前没有订单"

#define GET(str)                    (str ? str : @"")  //[[PublicFunction ShareInstance] getString:STR]
#define ISEMPTY(str)                  (((str == nil) || ([str length] == 0)) ? YES : NO)

#define CANCEL_REQUEST(MY_REQ)       \
{\
if (MY_REQ) \
    {\
        [[BLNetworkManager shareInstance] cancelNetworkRequest:MY_REQ];\
        MY_REQ = nil;\
    }\
}

// UIFont
#define SAR_FONT(fontSize)       ([UIFont fontWithName:@"MicrosoftYaHei" size:fontSize])
#define FONT_HOME               [UIFont systemFontOfSize:14]
#define FONT_PHONE              [UIFont systemFontOfSize:18]
#define FONT_CONTORLLER_TITLE   [UIFont systemFontOfSize:19]
#define FONT_LABEL_TITLE        [UIFont systemFontOfSize:16]
#define FONT_LABEL              [UIFont systemFontOfSize:14]//15
#define FONT_INPUT              [UIFont systemFontOfSize:14]
#define FONT_LOGIN              [UIFont systemFontOfSize:19]
#define FONT_FORGET              [UIFont systemFontOfSize:14]
#define FONT_SMALL              [UIFont systemFontOfSize:12]

#define BOLD_FONT_LABEL_TITLE              [UIFont boldSystemFontOfSize:16]
// img
#define kPlaceHolderImageName                   @"banner.png"// @"placeHolder.png"
#define kBackButtonImgName                      @"back.png"
#define IMG_MAP             @"map.png"

// color
#define COLOR_BACKGROUND            [UIColor colorWithHexString:@"#efeff4"]
#define COLOR_HOME                  [UIColor colorWithHexString:@"#606366"]
#define COLOR_CONTORLLER_TITLE      [UIColor colorWithHexString:@"#ffffff"]
#define COLOR_LABEL_GRAY            [UIColor colorWithHexString:@"#424446"]
#define COLOR_LABEL                 [UIColor colorWithHexString:@"#999999"]
#define COLOR_INPUT                 [UIColor colorWithHexString:@"#dddddd"]
#define COLOR_LABEL_BLUE                [UIColor colorWithHexString:@"#1c9cd6"]
#define COLOR_CARPLATE              [UIColor colorWithHexString:@"#8B8B8B" alpha:(0x77/255.0)]

// timer interval
#define INTERVAL_FOR_DISMISS_ALERTVIEW              2

// float
#define FLOAT_IS_ZERO(fl)       ((fl < 0.000000001 && fl > -0.000000001) ? YES : NO)
#endif
