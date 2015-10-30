//
//  TenancySelectView.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "DateSelectView.h"
#import "constString.h"
#import "PublicFunction.h"
#import "ConstDefine.h"
#import "ConstImage.h"


#define FRAME_BACKGROUND_VIEW       CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)


#define IMG_BTN_OK       @"userinfo_sure.png"
#define IMG_BTN_CANCEL    @"userinfo_cancle.png"

@implementation DateSelectView
{
    UITableView *pTableView;
}
@synthesize pDataSource, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pDataSource = [[NSMutableArray alloc] init];
        
        pTableView = [[UITableView alloc] initWithFrame: self.bounds style: UITableViewStylePlain];
        pTableView.delegate = self;
        pTableView.dataSource = self;
        [self addSubview:pTableView];
    }
    return self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"DateSelectViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    cell.textLabel.text = [pDataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegate && [delegate respondsToSelector:@selector(selectString:)])
    {
        [delegate selectString:[pDataSource objectAtIndex:indexPath.row]];
    }
}

@end


@implementation DateSelectView (UIUseDatePicker)
//@synthesize m_subViewRect;


-(id)initWithFrame:(CGRect)frame StartDate:(NSDate *)startDate
{
//    m_subViewRect = frame;
    
    self = [super initWithFrame:FRAME_BACKGROUND_VIEW];
    if (self) {
        [self initDatePickerView:startDate withSubFrame:frame];
    }
    
    return self;
}

-(void)setTitle:(NSString*)strTitle
{
    BOOL bSet = NO;
    
    for (UIView *subView in [self subviews])
    {
        if ([[subView subviews] count])
        {
            for (UIView *tmpView in [subView subviews]) {
                if (tmpView.tag == 999/*1000*/)
                {
                    UILabel *tmpLabel = (UILabel *)([[tmpView subviews] objectAtIndex:0]);
                    tmpLabel.text = strTitle;
                    bSet = YES;
                    break;
                }
            }
        }
        
        if (bSet)
        {
            break;
        }
        if (subView.tag == 999/*1000*/)
        {
            UILabel *tmpLabel = (UILabel *)([[subView subviews] objectAtIndex:0]);
            tmpLabel.text = strTitle;
            break;
        }
    }
}

-(void)initDatePickerView:(NSDate *)startDate withSubFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:FRAME_BACKGROUND_VIEW];
    backgroundView.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;
    [self addSubview:backgroundView];
    
    CGRect tmpRect = frame;
    if (NO == IS_IOS7) {
        tmpRect.origin.y -= 20;
    }
    
    UIView *subView = [[UIView alloc] initWithFrame:tmpRect];
    subView.backgroundColor = [UIColor whiteColor];
    [self addSubview:subView];

    UIImage *img = [UIImage imageNamed:IMG_BTN_CANCEL];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    imageView.tag = 999;
    [imageView setImage:img];
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    tmpLabel.text = STR_TAKE_CAR_TIME;
    tmpLabel.textColor = COLOR_LABEL_GRAY;
    tmpLabel.tag = 1000;
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:tmpLabel];
    [subView addSubview:imageView];

//    NSDate *maxDate = [[PublicFunction ShareInstance] getMaxTimeFromNow];
    NSLocale *tmpLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(subView.frame.origin.x, 40, 320, subView.frame.size.height - 80)];
    datePicker.datePickerMode  = UIDatePickerModeDateAndTime;
//    datePicker.maximumDate = maxDate;
//    datePicker.minimumDate = startDate;
    datePicker.locale = tmpLocal;
    [subView addSubview:datePicker];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(subView.frame.size.width / 2, subView.frame.size.height - 40, subView.frame.size.width/2, 40)];
    [okBtn setTitleColor:COLOR_LABEL_BLUE forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_OK] forState:UIControlStateNormal];
    [okBtn setTitle:STR_OK forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:okBtn];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, subView.frame.size.height - 40, subView.frame.size.width/2, 40)];
    [cancelBtn setTitleColor:COLOR_LABEL forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:IMG_BTN_CANCEL] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:STR_CANCEL forState:UIControlStateNormal];
    [subView addSubview:cancelBtn];
}


-(void)okBtnPressed
{
    NSLog(@"ok to select date");
    
    for(UIView *subView in [self subviews])
    {
        for (UIView *tmpView in [subView subviews]) {
            
            if ([tmpView isKindOfClass:[UIDatePicker class]]) {
                UIDatePicker *tmpDatePicker = (UIDatePicker *)tmpView;
                NSDate *selected = [tmpDatePicker date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                NSString *destDateString = [dateFormatter stringFromDate:selected];
                if (delegate && [delegate respondsToSelector:@selector(selectString:)])
                {
                    [delegate selectString:destDateString];
                }
            }
        }
    }
    
    [self removeFromSuperview];
}

-(void)cancelBtnPressed
{
    NSLog(@"cancel selecting date");
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end


