//
//  PublicFunction.h
//  SAR
//
//  Created by 徐守卫 on 14-9-9.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import "FMNetworkManager.h"
#import "NavController.h"
#import "HomeViewController.h"
#import "MyOrdersData.h"

@interface PublicFunction : NSObject
{
}

@property(nonatomic, strong)NSString *m_curVersion;
@property(nonatomic, strong)NSString *m_newVersion;

@property(nonatomic)BOOL m_bLogin;
@property(nonatomic)NSInteger m_userID;
//
@property(nonatomic,strong)NSString *serverIpPort;
@property(nonatomic,strong)NSString *serverUrlPrefix;
@property(nonatomic,strong)UINavigationController *rootNavigationConroller;


//
+(PublicFunction *)ShareInstance;
// launche
-(BOOL)isFirstLaunch;
// version
-(NSString *)lastVersion:(NSString *)lastVer;

-(NSDate *)getMaxTimeFromNow;
-(NSDate *)getDateFrom:(NSString *)strDate format:(NSString *)strFormat;
-(NSDate *)getDateFrom:(NSString *)strDate;
-(NSString *)getYMDHMString:(NSString *)srvTime;
-(BOOL)checkTimeForModifyOrder:(srvOrderData *)orderData
                      takeTime:(NSString *)takeTime
                  givebackTime:(NSString *)givebackTime
                        isTake:(BOOL)bTake;
-(BOOL)checkTime:(NSString *)takeTime givebackTime:(NSString *)givebackTime isTake:(BOOL)bTake;
-(BOOL)inHalfAnHour:(NSDate *)dstDate;
-(BOOL)isLaterThanEffectTime:(NSDate *)dstDate;
-(BOOL)isBeforeCurrentTime:(NSDate *)checkDate;
-(BOOL)IsTimeToTake:(NSDate *)dstDate;
-(BOOL)isLaterThanCurrentTime:(NSString *)takeTime;

-(NSString *)getYMDHMS:(NSString *)srvTime;

// GPS distance
-(CLLocationDistance)getDistance:(NSString *)Lon1  lat1:(NSString *)lat1 lon2:(NSString *)lon2 lat2:(NSString *)lat2;

// order
-(NSString *)getOrderStatus:(NSString *)sqlStatus;

// jump
-(void)jumpWithController:(NavController *)nav toPage:(shortMenuEnum)page;

// shortmenu
-(void)showShortMenu:(NavController *)nav;

// call
-(void)makeCall;

-(UIImageView *)getSeparatorView:(CGRect)rect;
-(UIView *)spaceViewWithRect:(CGRect)rect withColor:(UIColor *)clr;

// responseData
-(BOOL)checkResponseDataError:(NSString *)str;

// label
-(CGRect)getSubLabelRect:(UILabel *)label;
-(void)addSubLabelToLabel:(UILabel *)label  withString:(NSString *)str withColor:(UIColor*)color;
-(void)addSubLabelToLabel:(UILabel*)label  withStr:(NSString *)subStr withRect:(CGRect )subRect;
//判断密码强度
+(NSString*)strongForPassword:(NSString*)password;

// for money format
-(NSString *)checkAndFormatMoeny:(NSString *)strMoney;

// 是否wifi
+ (BOOL) IsEnableWIFI;
// 是否3G
+ (BOOL) IsEnable3G;

// REQUEST FAILED
-(void)showRequestFailed;

+(BOOL)isMatchWithString:(NSString *)password;
@end
