//
//  PublicFunction.m
//  SAR
//
//  Created by 徐守卫 on 14-9-9.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PublicFunction.h"
#import "SBJsonWriter.h"
#import "NSString+SBJSON.h"
#import "FBEncryptorDES.h"
#import "NSData+ExtendNSData.h"
#import "BLNetworkManager.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "ConstImage.h"
#import "CustomAlertView.h"

@implementation PublicFunction
@synthesize  serverIpPort = _serverIpPort;
@synthesize  serverUrlPrefix = _serverUrlPrefix;

@synthesize m_userID;
@synthesize m_bLogin;

@synthesize m_curVersion;
@synthesize m_newVersion;

@synthesize  rootNavigationConroller;


+(PublicFunction *)ShareInstance
{
    static PublicFunction *hanle;
    
    @synchronized(self)
    {
        if(!hanle)
        {
            hanle = [[PublicFunction alloc]init];
        }
        return hanle;
    }
    return nil;
}

-(BOOL)isFirstLaunch
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        return YES;
    }
    else
    {
        NSLog(@"已经不是第一次启动了");
        return NO;
    }
}


-(NSString *)lastVersion:(NSString *)lastVer
{
    if (nil != lastVer)
    {
        [[NSUserDefaults standardUserDefaults] setValue:lastVer forKey:@"lastVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    }
    else
    {
        NSString * ver = [[NSUserDefaults standardUserDefaults] stringForKey:@"lastVersion"];
        return ver;
    }
    
}


#pragma mark - date and time
-(NSDate *)getMinTime:(NSDate *)today
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit
    | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:today];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    NSDateComponents *cov = [[NSDateComponents alloc] init];
    [cov setYear:year];
    [cov setMonth:month];
    [cov setDay:day];
    [cov setHour:0];
    [cov setMinute:0];
    [cov setSecond:0];
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate* retDate = [myCal dateFromComponents:cov];
    
    return retDate;
}

-(NSDate *)getMaxTimeFromNow
{
    NSDate *date = [NSDate date];

    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
    NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];

    
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    [comp setMonth:month];
    [comp setDay:day];
    [comp setYear:year];
    [comp setHour:0];
    [comp setMinute:0];
    [comp setSecond:0];
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *tmpDate = [myCal dateFromComponents:comp];

    NSTimeInterval interval = 3 * 24 * 60 * 60;
    NSDate *retDate = [NSDate dateWithTimeInterval:interval sinceDate:tmpDate];
    return retDate;
}

-(NSDate *)getMaxTime:(NSDate *)curData
{
    return nil;
}


-(BOOL)isBeforeCurrentTime:(NSDate *)checkDate
{
    NSInteger interval = [checkDate timeIntervalSinceNow];
    
    if (interval < 0) {
        return YES;
    }
    
    return NO;
}


-(BOOL)inHalfAnHour:(NSDate *)dstDate
{
    NSInteger resInterval = [dstDate timeIntervalSinceNow];
    
    if (resInterval > 0 && resInterval < TIME_INTERVAL_HALFANHOUR) {
        return YES;
    }
    
    return NO;
}



-(BOOL)IsTimeToTake:(NSDate *)dstDate
{
    NSDate *date = [NSDate date];
    
    //    NSInteger resInterval = [dstDate timeIntervalSinceNow];
    NSInteger resInterval = [date timeIntervalSinceDate:dstDate];
    
    if (resInterval > -TIME_INTERVAL_5MIN) {
        return YES;
    }
    
    return NO;
}

-(BOOL)isLaterThanEffectTime:(NSDate *)dstDate
{
    NSInteger resInterval = [dstDate timeIntervalSinceNow];
    
    if (resInterval < 0) {
        return YES;
    }
    
    return NO;
}


-(NSDate *)getDateFrom:(NSString *)strDate format:(NSString *)strFormat
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strFormat];

    NSDate *date =[dateFormatter dateFromString:strDate];
    
    return date;
}


-(NSDate *)getDateFrom:(NSString *)strDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT_YMDHMS];

    NSDate *date =[dateFormatter dateFromString:strDate];
    
    return date;
}


-(NSString *)getYMDHMString:(NSString *)srvTime
{// 2014-10-09+12:04:00.0 -> 2014-10-09 12:04
    NSString *strRet = @"";
    NSArray *dateTime = [srvTime componentsSeparatedByString:@"+"];
    if (2 == [dateTime count]) {
        NSString *date = [dateTime objectAtIndex:0];
        NSString *time = [dateTime objectAtIndex:1];
        
        NSArray *timeHMS = [time componentsSeparatedByString:@":"];
        NSString *hour = [timeHMS objectAtIndex:0];
        NSString *minutes = [timeHMS objectAtIndex:1];
        
        strRet = [NSString stringWithFormat:@"%@ %@:%@", date, hour, minutes];
    }
    return strRet;
}


-(NSString *)getYMDHMS:(NSString *)srvTime
{// 2014-10-09+12:04:00.0 -> 2014-10-09 12:04:00
    NSString *strRet = @"";
    NSArray *dateTime = [srvTime componentsSeparatedByString:@"+"];
    if (2 == [dateTime count]) {
        NSString *date = [dateTime objectAtIndex:0];
        NSString *time = [dateTime objectAtIndex:1];
        
        NSArray *timeHMS = [time componentsSeparatedByString:@":"];
        NSString *hour = [timeHMS objectAtIndex:0];
        NSString *minutes = [timeHMS objectAtIndex:1];
        
        strRet = [NSString stringWithFormat:@"%@ %@:%@:00", date, hour, minutes];
    }
    return strRet;
}


-(NSInteger)getIntervalWithDate:(NSDate *)dstDate
{
    NSInteger retInterval = [dstDate timeIntervalSinceNow];
    
    return retInterval;
}


/**
 *方法描述：检测订单修改时间合法性
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)checkTimeForModifyOrder:(srvOrderData *)orderData
                      takeTime:(NSString *)takeTime
                  givebackTime:(NSString *)givebackTime
                        isTake:(BOOL)bTake
{
    NSString *orderStartTime = [[PublicFunction ShareInstance] getYMDHMString:GET(orderData.m_effectTime)];
    NSString *orderEndTime = [[PublicFunction ShareInstance] getYMDHMString:GET(orderData.m_returnTime)];
    NSDate *orderStartDate = [[PublicFunction ShareInstance] getDateFrom:orderStartTime format:DATE_FORMAT_YMDHM];
    NSDate *orderEndDate = [[PublicFunction ShareInstance] getDateFrom:orderEndTime format:DATE_FORMAT_YMDHM];
    
    NSDate *takeDate = [[PublicFunction ShareInstance] getDateFrom:takeTime format:DATE_FORMAT_YMDHM];
    
    NSTimeInterval interval = [orderStartDate timeIntervalSinceDate:takeDate];
    if (interval < 0) {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_AHEAD_OF_TAKETIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    
    NSDate *backDate = [[PublicFunction ShareInstance] getDateFrom:givebackTime format:DATE_FORMAT_YMDHM];
    interval = [backDate timeIntervalSinceDate:orderEndDate];
    if (interval < 0) {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_BEHIND_OF_GIVEBACK delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    
    
    //{{ 是否早于当前时间
    NSDate *curDate = [NSDate date];
    interval = [curDate timeIntervalSinceDate:takeDate];
    if (bTake && interval > 60)
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CUR_WITH_START_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    
    interval = [curDate timeIntervalSinceDate:backDate];
    if (interval > 60)
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CURRENT_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    //}} 是否早于当前时间
    
    NSDate *maxDate = [[PublicFunction ShareInstance] getMaxTimeFromNow];

    interval = [maxDate timeIntervalSinceDate:takeDate];
    if (TIME_INTERVAL_3DAYS < interval || interval < 0) {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MORE_THAN_3DAYS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    
    
    if (bTake == NO || (nil != givebackTime && 0 < [givebackTime length])) {
//        NSDate *backTime = [[PublicFunction ShareInstance] getDateFrom:givebackTime format:DATE_FORMAT_YMDHM];
        
        interval = [backDate timeIntervalSinceDate:takeDate];
        if (0 > interval) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_NEED_SELECTTIME_AGAIN delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
        if (TIME_INTERVAL_1HOUR > interval) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_LESS_THAN_1HOUR delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
        
        interval = [maxDate timeIntervalSinceDate:backDate];
        if (TIME_INTERVAL_3DAYS < interval || interval < 0) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MORE_THAN_3DAYS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
    }
    
    return YES;
}


-(BOOL)isLaterThanCurrentTime:(NSString *)takeTime
{
    NSDate *checkTime = [[PublicFunction ShareInstance] getDateFrom:takeTime format:DATE_FORMAT_YMDHM];
    if(checkTime == nil)
    {
        checkTime = [[PublicFunction ShareInstance] getDateFrom:takeTime format:DATE_FORMAT_YMDHMS];
    }
 // 是否早于当前时间
    NSDate *curDate = [NSDate date];

    NSTimeInterval interval = [curDate timeIntervalSinceDate:checkTime];
    if (interval > 60)
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CUR_WITH_START_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return YES;
    }
#if 0
    interval = [curDate timeIntervalSinceDate:backTime];
    if (interval > 60)
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CURRENT_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return YES;
    }
#endif
    return NO;
}

/**
 *方法描述：检查选择时间合法性 （3天内订单）
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)checkTime:(NSString *)takeTime givebackTime:(NSString *)givebackTime isTake:(BOOL)bTake
{
    NSDate *checkTime = [[PublicFunction ShareInstance] getDateFrom:takeTime format:DATE_FORMAT_YMDHM];
    NSDate *maxDate = [[PublicFunction ShareInstance] getMaxTimeFromNow];
#if 1 // 是否早于当前时间
    NSDate *curDate = [NSDate date];
#endif
    NSTimeInterval interval = [maxDate timeIntervalSinceDate:checkTime];
    if (TIME_INTERVAL_3DAYS < interval || interval < 0) {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MORE_THAN_3DAYS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
    
#if 1 // 是否早于当前时间
    interval = [curDate timeIntervalSinceDate:checkTime];
    if (bTake && interval > 60)
    {
        CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CUR_WITH_START_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [tmpAlert needDismisShow];
        return NO;
    }
#endif
    if (bTake == NO || (nil != givebackTime && 0 < [givebackTime length])) {
        NSDate *backTime = [[PublicFunction ShareInstance] getDateFrom:givebackTime format:DATE_FORMAT_YMDHM];
        
        interval = [backTime timeIntervalSinceDate:checkTime];
        if (0 > interval) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_NEED_SELECTTIME_AGAIN delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
        if (TIME_INTERVAL_1HOUR > interval) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_LESS_THAN_1HOUR delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
        
        interval = [maxDate timeIntervalSinceDate:backTime];
        if (TIME_INTERVAL_3DAYS < interval || interval < 0) {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_MORE_THAN_3DAYS delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
#if 1 // 是否早于当前时间
        interval = [curDate timeIntervalSinceDate:backTime];
        if (interval > 60)
        {
            CustomAlertView *tmpAlert = [[CustomAlertView alloc] initWithTitle:nil message:STR_CHECK_CURRENT_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
            [tmpAlert needDismisShow];
            return NO;
        }
#endif
    }
    return YES;
}

#pragma mark -gps
#if 0
-(CLLocationDistance)getDistance:(NSString *)Lon1  lat1:(NSString *)lat1 lon2:(NSString *)lon2 lat2:(NSString *)lat2
{
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:[lat1 doubleValue]  longitude:[Lon1 doubleValue]];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:[lat2 doubleValue] longitude:[lon2 doubleValue]];

    CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000.0;
    
    return kilometers;
}
#else
-(CLLocationDistance)getDistance:(NSString *)Lon1  lat1:(NSString *)lat1 lon2:(NSString *)lon2 lat2:(NSString *)lat2
{
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([lat1 floatValue],[Lon1 floatValue]));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([lat2 floatValue], [lon2 floatValue]));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2)/1000.0;
    return distance;
}
#endif

// order
-(NSString *)getOrderStatus:(NSString *)sqlStatus
{
    NSInteger nStatus = [sqlStatus integerValue];
    // 1生效 2取消 3租金结算 4全部结算 5续订 6延时
    switch (nStatus)
    {
//        case 0:
//            return STR_ORDER_STATUS_NORMAL;
//            break;
        case 1:
            return STR_ORDER_STATUS_NORMAL;
            break;
        case 2:
            return STR_ORDER_STATUS_UNSUBSCRIBE;
            break;
        case 3:
            return STR_ORDER_STATUS_PAYED;
            break;
        case 4:
            return STR_ORDER_STATUS_FINISHED;
            break;
        case 5:
            return STR_ORDER_STATUS_RENEW;
            break;
        case 6:
            return STR_ORDER_STATUS_DELAY;
            break;
        default:
            return @"";
            break;
    }
}

-(BOOL)needShortMenu
{
    if (4 < [self countRootViewControllers]) {
        return YES;
    }
    
    return NO;
}


-(void)showShortMenu:(NavController *)nav
{
    if ([self needShortMenu]) {
        [nav showShortMenuBtn:YES];
    }
    else
    {
        [nav showShortMenuBtn:NO];
    }
    
}

-(NSInteger)countRootViewControllers
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UINavigationController *rootController = app.navigationController;
    
    return [rootController.viewControllers count];
}

-(void)jumpWithController:(NavController *)nav toPage:(shortMenuEnum)page
{
    [nav.navigationController popToRootViewControllerAnimated:NO];
    
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UINavigationController *rootController = app.navigationController;
    UIViewController *tmpNav = [rootController.viewControllers objectAtIndex:0];
    if ([tmpNav isKindOfClass:[HomeViewController class]]) {
        HomeViewController *home = (HomeViewController *)tmpNav;
        switch (page)
        {
            case menu_usercenter:
                [home enterMyInfo];
                break;
            case menu_personal:
                [home enterPersonalRental];
                break;
            case menu_myorder:
                [home enterMyOrder];
                break;
            case menu_home:
                break;
            case menu_helper:
                [home enterHelper];
                break;
            case menu_enterprise:
                [home enterCompanyRental];
                break;
            case menu_preRental:
                [home enterPreRentl];
                break;
            default:
                break;
        }

    }
}



-(void)makeCall//:(NSString *)number
{
    NSString *txt = @"4008288517";//number;
#if 0
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]initWithPattern:@"((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:txt options:NSMatchingReportProgress range:NSMakeRange(0, txt.length)];
#else
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{4}[-]{0,1}[0-9]{4}?" options:NSRegularExpressionCaseInsensitive error:nil];
//        NSTextCheckingResult *result = [regex firstMatchInString:txt options:0 range:NSMakeRange(0, [txt length])];
#endif
//    NSString *cleanedString = [[[txt substringWithRange:[result range]] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
//	NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", txt]];
	[[UIApplication sharedApplication] openURL:telURL];
}



-(UIImageView *)getSeparatorView:(CGRect)rect
{
    CGRect tmpRect = rect;
//    tmpRect.origin.y = rect.origin.y + rect.size.height;
    
    UIImage *tmpImage = [UIImage imageNamed:IMG_SEPARATOR];
    tmpRect.size.height = tmpImage.size.height;
    
    UIImageView *tmpView = [[UIImageView alloc] initWithImage:tmpImage];
    tmpView.frame = tmpRect;
    
    return tmpView;
}

-(UIView *)spaceViewWithRect:(CGRect)rect withColor:(UIColor *)clr
{
    UIView *retView = [[UIView alloc] initWithFrame:rect];
    retView.backgroundColor = clr;
    
    return retView;
}

// responseData
-(BOOL)checkResponseDataError:(NSString *)str
{
    BOOL res = NO;
    
    if ([REQUEST_DATA_ERROR isEqualToString:str]) {
        res = YES;
    }
    
    return res;
}

// request failed
-(void)showRequestFailed
{
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:STR_REQUEST_FAILED delegate:nil cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alert needDismisShow];
}

#pragma mark - label
-(CGSize)getLabelTextSize:(UILabel *)label
{
    CGSize sz = CGSizeMake(0, 0);
    if (IOS_VERSION_ABOVE_7)
    {
        if ([label.text length] > 0) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:label.text];
            NSRange range = NSMakeRange(0, attrStr.length);
            NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
            CGRect rec = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width,label.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
            sz = CGSizeMake(rec.size.width, rec.size.height);
#endif
        }
    }
    else
    {
        sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width,label.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return sz;
}

-(void)addSubLabelToLabel:(UILabel *)label  withString:(NSString *)str withColor:(UIColor*)color
{
    for (UIView *subView in [label subviews])
    {
        if (subView.tag == 1000)
        {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *subLabel = [[UILabel alloc] init];
    CGSize titleTextSize = [self getLabelTextSize:label];
    NSInteger subStartX = titleTextSize.width + 20;
    NSInteger subW = label.frame.size.width - titleTextSize.width + 10;
    CGRect subRect = CGRectMake(subStartX, 0, subW, label.frame.size.height);
    subLabel.frame = subRect;
    subLabel.textColor = color;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = str;
    subLabel.font = label.font;
    subLabel.tag = 1000;
    
    [label addSubview:subLabel];
    
}

-(CGRect)getSubLabelRect:(UILabel *)label
{
    CGSize titleTextSize = [self getLabelTextSize:label];
    NSInteger subStartX = label.frame.origin.x + titleTextSize.width + 20;
    NSInteger subW = label.frame.size.width - titleTextSize.width + 10;
    CGRect subRect = CGRectMake(subStartX, label.frame.origin.y, subW, label.frame.size.height);

    return subRect;
}

-(void)addSubLabelToLabel:(UILabel*)label  withStr:(NSString *)subStr withRect:(CGRect )subRect
{
    for(UIView *subView in [label subviews])
    {
        [subView removeFromSuperview];
    }
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:subRect];
    subLabel.textColor = COLOR_LABEL;
    subLabel.font = BOLD_FONT_LABEL_TITLE;
//    subLabel.text = STR_PREPAY_COST;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.text = subStr;
    
    [label addSubview:subLabel];
}



//判断字符串中只含有数字和字母不含其他的
+(BOOL)isMatchWithString:(NSString *)password
{
    NSString * regex = @"^[A-Za-z0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}



//判断密码强度包含字母和数字
+(NSString*)strongForPassword:(NSString*)password
{
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil] ;
    
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil] ;
    NSString* result1 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray1 Password:password]];
    NSString* result2 = [NSString stringWithFormat:@"%d",[self judgeRange:termArray2 Password:password]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result1]];
    [resultArray addObject:[NSString stringWithFormat:@"%@",result2]];
    int intResult=0;
    for (int j=0; j<[resultArray count]; j++)
    {
        if ([[resultArray objectAtIndex:j] isEqualToString:@"1"])
        {
            intResult++;
        }
    }
    
    NSString *result=[NSString stringWithFormat:@"%d",intResult];
    
    return result;
}


+(BOOL) judgeRange:(NSArray*) _termArray Password:(NSString*) password_
{
    NSRange range;
    BOOL result =NO;
    for(int i=0; i<[_termArray count]; i++)
    {
        range = [password_ rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound)
        {
            result =YES;
        }
    }
    return result;
}


-(NSString *)checkAndFormatMoeny:(NSString *)strMoney
{
    NSString *resMoney = @"";
    
    if (nil == strMoney || [strMoney length] == 0) {
        return resMoney;
    }
    
    NSArray *moneyArr = [strMoney componentsSeparatedByString:@"."];
    if (1 == [moneyArr count])
    {
        resMoney = [NSString stringWithFormat:@"%@%@", strMoney, @".00"];
    }
    else if(2 == [moneyArr count])
    {
        NSString *point = [moneyArr objectAtIndex:1];
        if ([point length] == 1) {
            resMoney = [NSString stringWithFormat:@"%@%@", strMoney, @"0"];
        }else if([point length] == 2)
        {
            resMoney = [NSString stringWithFormat:@"%@", strMoney];
        }
    }
    
    return resMoney;
}


//
// 是否wifi
+ (BOOL) IsEnableWIFI
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 是否3G
+ (BOOL) IsEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
