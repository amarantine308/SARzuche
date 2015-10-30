//
//  RBCustomDatePickerView.m
//  RBCustomDateTimePicker
//  e-mail:rbyyy924805@163.com
//  Created by renbing on 3/17/14.
//  Copyright (c) 2014 renbing. All rights reserved.
//

#import "RBCustomDatePickerView.h"
//颜色和透明度设置
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface RBCustomDatePickerView()
{
    UIView                      *timeBroadcastView; // 定时播放显示视图
    MXSCycleScrollView          *yearScrollView;    // 年份滚动视图
    MXSCycleScrollView          *monthScrollView;   // 月份滚动视图
    MXSCycleScrollView          *dayScrollView;     // 日滚动视图
    MXSCycleScrollView          *hourScrollView;    // 时滚动视图
    MXSCycleScrollView          *minuteScrollView;  // 分滚动视图
    MXSCycleScrollView          *secondScrollView;  // 秒滚动视图
    MXSCycleScrollView          *weekScrollView;    // 秒滚动视图
    NSMutableArray              *monthArray;
    NSArray                     *weekArray;
    NSString                    *selectedTime;      // 根据选择时间，确定星期几
    UILabel                     *selectTimeIsNotLegalLabel; // 所选时间是否合法
    UIButton                    *OkBtn;             // 自定义picker上的确认按钮
    
    int nowYearInt;
    int nowMonthInt;
    int nowDayInt;
    NSString *nowDateString;
    
    int markYearInt;
    int markMonthInt;
    int markDayInt;
    int markWeekInt;
}
@end

@implementation RBCustomDatePickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTimeScrollView];
    }
    return self;
}

// 通过日期求星期
- (int)fromDateToWeekIndex:(NSString*)selectDate
{
    int yearInt = [[selectDate substringWithRange:NSMakeRange(0, 4)] intValue];
    int monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].intValue;
    int dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].intValue;
    
    int c = 20;//世纪
    int y = yearInt -1;//年
    int d = dayInt;
    int m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    return w;
}

- (void)setTimeScrollView
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    nowDateString = [[NSString alloc] initWithString:[dateFormatter stringFromDate:now]];
    
    nowYearInt = [[nowDateString substringWithRange:NSMakeRange(0, 4)] intValue];
    nowMonthInt = [nowDateString substringWithRange:NSMakeRange(4, 2)].intValue;
    nowDayInt = [nowDateString substringWithRange:NSMakeRange(6, 2)].intValue;
    
    weekArray = @[@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", @"星期日"];
    monthArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++)
    {
        int tempMonth = nowMonthInt + i;
        int tempNum = tempMonth % 12;
        if (tempNum == 0)
        {
            [monthArray addObject:@"12月"];
        }
        else
        {
            [monthArray addObject:[NSString stringWithFormat:@"%02d月", tempNum]];
        }
    }
    
    markYearInt = nowYearInt;
    markMonthInt = nowMonthInt;
    markDayInt = nowDayInt;
    markWeekInt = [self fromDateToWeekIndex:nowDateString];
    
    self.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.4;
    [self addSubview:backView];
    
    timeBroadcastView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-260, self.bounds.size.width, 215)];
    [timeBroadcastView setBackgroundColor:[UIColor whiteColor]];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    timeBroadcastView.layer.masksToBounds = YES;
    CGColorRef cgColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0].CGColor;
    timeBroadcastView.layer.borderColor = cgColor;
    timeBroadcastView.layer.borderWidth = 1.0;
#endif
    [self addSubview:timeBroadcastView];
    
    UIView *middleSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 215/5*2, self.bounds.size.width, 38)];
    middleSepView.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    middleSepView.layer.borderColor = cgColor;
    middleSepView.layer.borderWidth = 1.0;
#endif
    [timeBroadcastView addSubview:middleSepView];

    UIButton *btn_cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-45, self.bounds.size.width/2, 45)];
    [btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_cancel setTitleColor:RGBA(132, 132, 132, 1) forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn_cancel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:btn_cancel];
    
    UIButton *btn_sure = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height-45, self.bounds.size.width/2, 45)];
    [btn_sure setTitle:@"确定" forState:UIControlStateNormal];
    [btn_sure setTitleColor:RGBA(43, 131, 202, 1) forState:UIControlStateNormal];
    [btn_sure addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    btn_sure.backgroundColor = [UIColor clearColor];
#if __PHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    btn_sure.layer.borderColor = [RGBA(43, 131, 202, 1) CGColor];
    btn_sure.layer.borderWidth = 1.0;
#endif
    [btn_sure setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:btn_sure];

    [self setMonthScrollView];
    [self setDayScrollView];
    [self setWeekScrollview];
}

//设置月的滚动视图
- (void)setMonthScrollView
{
    int width  = (self.bounds.size.width - 100) / 3;
    monthScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(50.0, 0, width, 215.0)];
    [monthScrollView setCurrentSelectPage:2];
    monthScrollView.delegate = self;        // MXSCycleScrollViewDelegate
    monthScrollView.datasource = self;      // MXSCycleScrollViewDatasource
    [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:monthScrollView];
}

//设置日的滚动视图
- (void)setDayScrollView
{
    int monthDays = [self getDaysAccordingYearAndMonth];
    int width  = (self.bounds.size.width - 100) / 3;
    dayScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(50 + width, 0, width, 215.0)];
    [dayScrollView setCurrentSelectPage:(markDayInt + monthDays - 3) % monthDays];
    dayScrollView.delegate = self;      // MXSCycleScrollViewDelegate
    dayScrollView.datasource = self;    // MXSCycleScrollViewDatasource
    [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:dayScrollView];
}

// 设置星期的滚动视图
- (void)setWeekScrollview
{
    int width  = (self.bounds.size.width - 100) / 3;
    weekScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(50 + width * 2, 0, 100.0, 215.0)];
    [weekScrollView setCurrentSelectPage:(markWeekInt + 7 - 3) % 7];
    weekScrollView.delegate = self;     // MXSCycleScrollViewDelegate
    weekScrollView.datasource = self;   // MXSCycleScrollViewDatasource
    weekScrollView.userInteractionEnabled = NO;
    [self setAfterScrollShowView:weekScrollView andCurrentPage:1];
    [timeBroadcastView addSubview:weekScrollView];
}

- (void)setAfterScrollShowView:(MXSCycleScrollView*)scrollview  andCurrentPage:(NSInteger)pageNumber
{
    UILabel *oneLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber];
    [oneLabel setFont:[UIFont systemFontOfSize:13]];
    [oneLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    [oneLabel setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *twoLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+1];
    [twoLabel setFont:[UIFont systemFontOfSize:15]];
    [twoLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    [twoLabel setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *currentLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+2];
    [currentLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [currentLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    [currentLabel setTextAlignment:NSTextAlignmentLeft];
    [currentLabel setBackgroundColor:[UIColor clearColor]];
    
    UILabel *threeLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+3];
    [threeLabel setFont:[UIFont systemFontOfSize:15]];
    [threeLabel setTextColor:RGBA(113.0, 113.0, 113.0, 1.0)];
    [threeLabel setTextAlignment:NSTextAlignmentLeft];
    
    UILabel *fourLabel = [[(UILabel*)[[scrollview subviews] objectAtIndex:0] subviews] objectAtIndex:pageNumber+4];
    [fourLabel setFont:[UIFont systemFontOfSize:13]];
    [fourLabel setTextColor:RGBA(186.0, 186.0, 186.0, 1.0)];
    [fourLabel setTextAlignment:NSTextAlignmentLeft];
}

////设置年月日时分的滚动视图
//- (void)setYearScrollView
//{
//    yearScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 73.0, 245.0)];
//    NSInteger yearint = [self setNowTimeShow:ScrollViewType_year];
//    NSLog(@"yearint:%d",yearint);
//    [yearScrollView setCurrentSelectPage:(yearint-2002)];
//    yearScrollView.delegate = self;
//    yearScrollView.datasource = self;
//    [self setAfterScrollShowView:yearScrollView andCurrentPage:1];
////    [timeBroadcastView addSubview:yearScrollView];
//}
//
////设置时的滚动视图
//- (void)setHourScrollView
//{
//    int width  = (self.bounds.size.width-100)/3;
//    hourScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(159.5, 0, width, 190.0)];
//    NSInteger hourint = [self setNowTimeShow:ScrollViewType_hour];
//    [hourScrollView setCurrentSelectPage:(hourint-2)];
//    hourScrollView.delegate = self;
//    hourScrollView.datasource = self;
//    [self setAfterScrollShowView:hourScrollView andCurrentPage:1];
//    [timeBroadcastView addSubview:hourScrollView];
//}
//
////设置分的滚动视图
//- (void)setMinuteScrollView
//{
//    minuteScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(198.5, 0, 37.0, 190.0)];
//    NSInteger minuteint = [self setNowTimeShow:ScrollViewType_minute];
//    [minuteScrollView setCurrentSelectPage:(minuteint-2)];
//    minuteScrollView.delegate = self;
//    minuteScrollView.datasource = self;
//    [self setAfterScrollShowView:minuteScrollView andCurrentPage:1];
//    [timeBroadcastView addSubview:minuteScrollView];
//}
//
////设置秒的滚动视图
//- (void)setSecondScrollView
//{
//    secondScrollView = [[MXSCycleScrollView alloc] initWithFrame:CGRectMake(235.5, 0, 43.0, 190.0)];
//    NSInteger secondint = [self setNowTimeShow:ScrollViewType_second];
//    [secondScrollView setCurrentSelectPage:(secondint-2)];
//    secondScrollView.delegate = self;
//    secondScrollView.datasource = self;
//    [self setAfterScrollShowView:secondScrollView andCurrentPage:1];
//    [timeBroadcastView addSubview:secondScrollView];
//}
//
////设置现在时间
//- (NSInteger)setNowTimeShow:(ScrollViewType)type
//{
//    NSDate *now = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *dateString = [dateFormatter stringFromDate:now];
//    switch (type)
//    {
//        case ScrollViewType_year:
//        {
//            NSRange range = NSMakeRange(0, 4);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
//
//        case ScrollViewType_month:
//        {
//            NSRange range = NSMakeRange(4, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
//
//        case ScrollViewType_day:
//        {
//            NSRange range = NSMakeRange(6, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
//
//        case ScrollViewType_hour:
//        {
//            NSRange range = NSMakeRange(8, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
//
//        case ScrollViewType_minute:
//        {
//            NSRange range = NSMakeRange(10, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//            break;
//
//        case ScrollViewType_second:
//        {
//            NSRange range = NSMakeRange(12, 2);
//            NSString *yearString = [dateString substringWithRange:range];
//            return yearString.integerValue;
//        }
//
//        case ScrollViewType_week:
//        {
//            int w = [self getWeekIndex:dateString];
//            return w;
//        }
//            break;
//
//        default:
//            break;
//    }
//    return 0;
//}

-(int)getDaysAccordingYearAndMonth
{
    switch (markMonthInt)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
            break;
            
        default:
        {
            if ([self isLeapYear])
                return 29;
            else
                return 28;
        }
            break;
    }
}

-(BOOL)isLeapYear
{
    if (markYearInt % 4 == 0)
    {
        if (markYearInt % 400 == 0)
        {
            return YES;
        }
        else
        {
            if (markYearInt % 100 == 0)
                return NO;
            else
                return YES;
        }
    }
    else
        return NO;
}

#pragma mark - MXSCycleScrollViewDatasource
- (NSInteger)numberOfPages:(MXSCycleScrollView*)scrollView
{
    if (scrollView == monthScrollView)
    {
        return 4;
    }
    else if (scrollView == dayScrollView)
    {
        return [self getDaysAccordingYearAndMonth];
    }
    else if (scrollView == weekScrollView)
    {
        return 7;
    }
    //    else if (scrollView == hourScrollView)
    //    {
    //        return 24;
    //    }
    //    else if (scrollView == minuteScrollView)
    //    {
    //        return 60;
    //    }
    //
    //    else if (scrollView == yearScrollView)
    //    {
    //        return 99;
    //    }
    return 0;
}

- (UIView *)pageAtIndex:(NSInteger)index andScrollView:(MXSCycleScrollView *)scrollView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width,scrollView.bounds.size.height / 5)];
    label.tag = index + 1;
    
    if (scrollView == monthScrollView)
    {
        label.text = [monthArray objectAtIndex:index];
    }
    else if (scrollView == dayScrollView)
    {
        label.text = [NSString stringWithFormat:@"%02d", 1 + index];
    }
    else if (scrollView == weekScrollView)
    {
        label.text = [weekArray objectAtIndex:index];
    }
    return label;
    //    else if (scrollView == hourScrollView)
    //    {
    //        if (index < 10)
    //        {
    //            l.text = [NSString stringWithFormat:@"0%d",index];
    //        }
    //        else
    //        {
    //            l.text = [NSString stringWithFormat:@"%d",index];
    //        }
    //    }
    //    else if (scrollView == minuteScrollView)
    //    {
    //        if (index < 10)
    //        {
    //            l.text = [NSString stringWithFormat:@"0%d",index];
    //        }
    //        else
    //        {
    //            l.text = [NSString stringWithFormat:@"%d",index];
    //        }
    //    }
    //    else if (scrollView == yearScrollView)
    //    {
    //        l.text = [NSString stringWithFormat:@"%d年",2000+index];
    //    }
    //    else
    //    {
    //        if (index < 10)
    //        {
    //            l.text = [NSString stringWithFormat:@"%@",[weekArray objectAtIndex:index]];
    //        }
    //        else
    //        {
    //            l.text = [NSString stringWithFormat:@"%@",[weekArray objectAtIndex:index]];
    //        }
    //    }
    //    l.font = [UIFont systemFontOfSize:12];
    //    l.textAlignment = NSTextAlignmentLeft;
    //    l.backgroundColor = [UIColor clearColor];
}

#pragma mark - MXSCycleScrollViewDelegate
// 滚动时上下标签显示(当前时间和是否为有效时间)
- (void)scrollviewDidChangeNumber:(MXSCycleScrollView *)scrollView
{
    if (scrollView == monthScrollView)
    {
        UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        int monthArrayIndex = monthLabel.tag - 1;
        int selectMonthInt = nowMonthInt + monthArrayIndex;
        if (selectMonthInt > 12)
        {
            selectMonthInt = selectMonthInt % 12;
        }
        
        if ([self validMonth:selectMonthInt])
        {
            [self saveYear:selectMonthInt];
            
            markMonthInt = selectMonthInt;
            
            [dayScrollView reloadData];
            [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
            
            [self reloadWeekScrollView];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您只能预订三个月内的订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            [self saveYear:selectMonthInt];
            markMonthInt = selectMonthInt;
            [self setAfterScrollShowView:dayScrollView andCurrentPage:1];
            
            [self reloadWeekScrollView];
//            int index = markMonthInt - nowMonthInt;
//            index = index < 0 ? index + 12 : index;
//            
//            [monthScrollView setCurrentSelectPage:(index + 2) % 4];
//            [monthScrollView reloadData];
//            [self setAfterScrollShowView:monthScrollView andCurrentPage:1];
        }
    }
    else if (scrollView == dayScrollView)
    {
        UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
        if (markDayInt == dayLabel.tag)
        {
            return;
        }
        
        if ([self validDay:dayLabel.tag])
        {
            markDayInt = dayLabel.tag;
            
            [self reloadWeekScrollView];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您只能预订三个月内的订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            markDayInt = dayLabel.tag;
//            int monthDays = [self getDaysAccordingYearAndMonth];
//            [dayScrollView setCurrentSelectPage:(markDayInt + monthDays - 3) % monthDays];
//            [dayScrollView reloadData];
        }
    }
    
//    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    
//    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    
//    NSInteger yearInt = yearLabel.tag + 1999;
//    NSInteger monthInt = monthLabel.tag;
//    NSInteger dayInt = dayLabel.tag;
//    NSInteger hourInt = hourLabel.tag - 1;
//    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
//    NSString *dateString = [NSString stringWithFormat:@"%d%02d%02d%02d%02d%02d",yearInt,monthInt,dayInt,hourInt,minuteInt,secondInt];
//    NSString *weekString = [self fromDateToWeek:dateString];
//    
//    //设置周末
//    //    NSInteger weekIndex = [self weekIndex:dateString];
//    //    NSLog(@"weekIndex:%d",weekIndex);
//    //    [weekScrollView setCurrentSelectPage:weekIndex];
//    //    [self setAfterScrollShowView:weekScrollView andCurrentPage:1];
//    //    [weekScrollView reloadData];
//    
//    //    [self weekScrollerViewSetValue:weekString];
//    
//    //获取选择的时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *selectTimeString = [NSString stringWithFormat:@"%d-%02d-%02d %02d:%02d:%02d",yearInt,monthInt,dayInt,hourInt,minuteInt,secondInt];
//    NSDate *selectDate = [dateFormatter dateFromString:selectTimeString];
//    NSDate *nowDate = [NSDate date];
//    NSString *nowString = [dateFormatter stringFromDate:nowDate];
//    NSDate *nowStrDate = [dateFormatter dateFromString:nowString];
//    if (NSOrderedAscending == [selectDate compare:nowStrDate]) {//选择的时间与当前系统时间做比较
//        [selectTimeIsNotLegalLabel setTextColor:RGBA(155, 155, 155, 1)];
//        selectTimeIsNotLegalLabel.text = @"温馨提示：所选时间不合法，无法提交";
//        [OkBtn setEnabled:NO];
//    }
//    else
//    {
//        selectTimeIsNotLegalLabel.text = @"";
//        [OkBtn setEnabled:YES];
//    }
}

////选择设置的播报时间
//- (void)selectSetBroadcastTime
//{
//    UILabel *yearLabel = [[(UILabel*)[[yearScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *monthLabel = [[(UILabel*)[[monthScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *dayLabel = [[(UILabel*)[[dayScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *hourLabel = [[(UILabel*)[[hourScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *minuteLabel = [[(UILabel*)[[minuteScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    UILabel *secondLabel = [[(UILabel*)[[secondScrollView subviews] objectAtIndex:0] subviews] objectAtIndex:3];
//    
//    NSInteger yearInt = yearLabel.tag + 1999;
//    NSInteger monthInt = monthLabel.tag;
//    NSInteger dayInt = dayLabel.tag;
//    NSInteger hourInt = hourLabel.tag - 1;
//    NSInteger minuteInt = minuteLabel.tag - 1;
//    NSInteger secondInt = secondLabel.tag - 1;
//    NSString *taskDateString = [NSString stringWithFormat:@"%d%02d%02d%02d%02d%02d",yearInt,monthInt,dayInt,hourInt,minuteInt,secondInt];
//    NSLog(@"Now----%@",taskDateString);
//}
//
//- (NSInteger)getWeekIndex:(NSString *)selectDate
//{
//    int yearInt = [[selectDate substringWithRange:NSMakeRange(0, 4)] intValue];
//    int monthInt = [selectDate substringWithRange:NSMakeRange(4, 2)].intValue;
//    int dayInt = [selectDate substringWithRange:NSMakeRange(6, 2)].intValue;
//    
//    NSInteger c = 20;//世纪
//    NSInteger y = yearInt -1;//年
//    NSInteger d = dayInt;
//    NSInteger m = monthInt;
//    NSInteger w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
//    return w;
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self setHidden:YES];
//}

-(void)reloadWeekScrollView
{
    NSString *dateString = [NSString stringWithFormat:@"%d%02d%02d", markYearInt,markMonthInt,markDayInt];
    markWeekInt = [self fromDateToWeekIndex:dateString];
    [weekScrollView setCurrentSelectPage:(markWeekInt + 7 - 3) % 7];
    [weekScrollView reloadData];
    [self setAfterScrollShowView:weekScrollView andCurrentPage:1];
}

-(BOOL)validDay:(int)selectDayInt
{
    if (selectDayInt < nowDayInt)   // 月份相等，而选择日期小于当前日期，则日期不合法
    {
        if (markMonthInt == nowMonthInt)
            return NO;
    }
    
    if (selectDayInt > nowDayInt)   // 如果月份为当前月份+3，而选择日期大于当前日期，则日期不合法
    {
        int temp = nowMonthInt + 3;
        temp = temp > 12 ? temp % 12 : temp;
        if (markMonthInt == temp)
            return NO;
    }
    return YES;
}

- (BOOL)validMonth:(int)selectMonthInt
{
    if (markDayInt < nowDayInt)   // 月份相等，而选择日期小于当前日期，则日期不合法
    {
        if (selectMonthInt == nowMonthInt)
            return NO;
    }
    
    if (markDayInt > nowDayInt)   // 如果月份为当前月份+3，而选择日期大于当前日期，则日期不合法
    {
        int temp = nowMonthInt + 3;
        temp = temp > 12 ? temp % 12 : temp;
        if (selectMonthInt == temp)
            return NO;
    }
    return YES;
}

-(void)saveYear:(int)selectMonthInt
{
    if (nowMonthInt == 10)
    {
        if (markMonthInt != 1 && selectMonthInt == 1)
        {
            markYearInt ++;
        }
        else if (markMonthInt == 1 && selectMonthInt != 1)
        {
            markYearInt --;
        }
    }
    else if (nowMonthInt == 11)
    {
        if (markMonthInt == 11 || markMonthInt == 12)
        {
            if (selectMonthInt == 1 || selectMonthInt == 2)
            {
                markYearInt ++;
            }
        }
        else if (markMonthInt == 1 || markMonthInt == 2)
        {
            if (selectMonthInt == 11 || selectMonthInt == 12)
            {
                markYearInt --;
            }
        }
    }
    else if (nowMonthInt == 12)
    {
        if (markMonthInt == 12 && selectMonthInt != 12)
        {
            markYearInt ++;
        }
        else if (markMonthInt != 12 && selectMonthInt == 12)
        {
            markYearInt --;
        }
    }
}

#pragma mark - 按钮点击事件

- (void)clickCancelBtn
{
    [self setHidden:YES];
}

- (void)clickSureBtn
{
    if (delegate && [delegate respondsToSelector:@selector(clickSureBtn:::)])
    {
        [delegate clickSureBtn:markYearInt :markMonthInt :markDayInt];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
//    self.hidden = YES;
}

@end
