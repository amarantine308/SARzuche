//
//  PriceDetailsViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PriceDetailsViewController.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "BLNetworkManager.h"
#import "CarDataManager.h"
#import "LoadingClass.h"
#import "PublicFunction.h"
#import "UIColor+Helper.h"
#import "ConstImage.h"
#import "NextHelpViewController.h"

#define HEIGHT_ROW_LABEL            30
#define FRAME_FORMULA       CGRectMake(0, controllerViewStartY, MainScreenWidth, HEIGHT_ROW_LABEL)

#define FRAME_SCROLL_VIEW   CGRectMake(0, controllerViewStartY + HEIGHT_ROW_LABEL, MainScreenWidth, MainScreenHeight - controllerViewStartY)


#define WIDTH_COLUMN1            120 // (1 + 2 + 3 == 300)
#define WIDTH_COLUMN2            90  // (1 + 2 + 3 == 300)
#define WIDTH_COLUMN3            90  // (1 + 2 + 3 == 300)


#define ICON_OFFSET_DURRATION   25
#define ICON_OFFSET_ORIGINAL    10
#define ICON_OFFSET_PROMOTION   2

#define IMG_DURATION            @"duration.png"
#define IMG_PROMOTION           @"icon_promotion.png"
#define IMG_ORIGINAL            @"icon_originalPrice.png"
#define IMG_VERTICAL_LINE       @"verticalLine.png"


@interface PriceDetailsViewController ()
{
    UIView *m_workingDay;
    UIView *m_weekend;
    UIView *m_holiday;
    UIView *m_otherInfo;
    UIScrollView *m_scrollView;
    
    NSMutableArray *m_workingDayArr;
    NSMutableArray *m_weekendArr;
    NSMutableArray *m_holidayArr;
}

@end

@implementation PriceDetailsViewController

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
    
    [self initData];
    [self initPriceDetailsView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_PRICE_DETAILS];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        UIImage *helpImg = [UIImage imageNamed:IMG_HELP];
        [helpBtn setImage:helpImg forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *方法描述：进入帮助页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    NSString *type = [NSString stringWithFormat:@"help%d",5];
    next.title = STR_SETTLEMENT;
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initData
{
    SelectedCar *car = [[CarDataManager shareInstance] getSelCar];
    if (nil == car) {
        return;
    }
    NSString *carId = [NSString stringWithFormat:@"%@", car.m_carId];
    
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarPriceWithCarId:carId startTime:@"" delegate:self];
    req = nil;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initPriceDetailsView
{
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    
    UILabel *formula = [[UILabel alloc] initWithFrame:FRAME_FORMULA];
    formula.text = STR_PREPAY_DETAILS;
    [self.view addSubview:formula];
    
    [self.view addSubview:m_scrollView];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initWorkDayView:(NSArray *)priceArr
{
    NSInteger nStartY = 0;//HEIGHT_ROW_LABEL;
    NSInteger nStartX = 10;
    NSInteger nHeight = 0;
    NSInteger nWidth = 320;
    NSString *tmpStr = nil;
    NSInteger nVerH  = 0;
    CGRect tmpRect = CGRectMake(0, 0, nWidth, 320);
    
    m_workingDay = [[UIView alloc] initWithFrame:tmpRect];
    m_workingDay.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_workingDay];
    
    CGRect rc1 = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    UIView *spaceView1 = [[PublicFunction ShareInstance] spaceViewWithRect:rc1 withColor:COLOR_BACKGROUND];
    [m_workingDay addSubview:spaceView1];
    nStartY += spaceViewHeight;
    nHeight += spaceViewHeight;
    
    tmpRect.origin.y = nStartY;
    tmpRect.size.height = HEIGHT_ROW_LABEL;
    nStartY += HEIGHT_ROW_LABEL;
    UILabel *workingDayLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpStr = [NSString stringWithFormat:STR_WORKINGDAY_PRICE, [[CarDataManager shareInstance] getDayPriceWithType:price_workday]];
    workingDayLabel.text = tmpStr;
    [m_workingDay addSubview:workingDayLabel];
    nHeight += HEIGHT_ROW_LABEL;
    
    CGRect rc = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    UIView *spaceView = [[PublicFunction ShareInstance] spaceViewWithRect:rc withColor:COLOR_BACKGROUND];
    [m_workingDay addSubview:spaceView];
    nStartY += spaceViewHeight;
    nHeight += spaceViewHeight;
    
    // icon
    UIImage *imgDuration = [UIImage imageNamed:IMG_DURATION];
    UIImage *imgOriginal = [UIImage imageNamed:IMG_ORIGINAL];
    UIImage *imgpromotion = [UIImage imageNamed:IMG_PROMOTION];
    CGRect iconRc = CGRectMake(ICON_OFFSET_PROMOTION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    UIImageView *viewDuration = [[UIImageView alloc] initWithImage:imgDuration];
    UIImageView *viewOriginal = [[UIImageView alloc] initWithImage:imgOriginal];
    UIImageView *viewPromotion = [[UIImageView alloc] initWithImage:imgpromotion];
    viewDuration.frame = CGRectMake(ICON_OFFSET_DURRATION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    viewOriginal.frame = CGRectMake(ICON_OFFSET_ORIGINAL, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);;
    viewPromotion.frame = iconRc;
    
    // column title
    CGRect column1 = CGRectMake(nStartX, nStartY, WIDTH_COLUMN1, HEIGHT_ROW_LABEL);
    CGRect column2 = CGRectMake(nStartX + WIDTH_COLUMN1, nStartY, WIDTH_COLUMN2, HEIGHT_ROW_LABEL);
    CGRect column3 = CGRectMake(nStartX + WIDTH_COLUMN1 + WIDTH_COLUMN2, nStartY, WIDTH_COLUMN3, HEIGHT_ROW_LABEL);
    
    UILabel *duration = [[UILabel alloc] initWithFrame:column1];
    duration.text = STR_PERIOD_OF_TIME;
    duration.textAlignment = NSTextAlignmentCenter;
    [duration addSubview:viewDuration];
    [m_workingDay addSubview:duration];
    UILabel *original = [[UILabel alloc] initWithFrame:column2];
    original.text = STR_ORIGINAL_PRICE;
    original.textAlignment = NSTextAlignmentCenter;
    [original addSubview:viewOriginal];
    [m_workingDay addSubview:original];
    UILabel *promotion = [[UILabel alloc] initWithFrame:column3];
    promotion.text = STR_PROMOTION_PRICE;
    promotion.textAlignment = NSTextAlignmentCenter;
    [promotion addSubview:viewPromotion];
    [m_workingDay addSubview:promotion];
    nHeight += HEIGHT_ROW_LABEL;
    nVerH += HEIGHT_ROW_LABEL;
    
    CGRect sRc1 = CGRectMake(10, nHeight-1, MainScreenWidth - 20, 1);
    UIImageView *sepView1 = [[PublicFunction ShareInstance] getSeparatorView:sRc1];
    [m_workingDay addSubview:sepView1];
    nHeight += sepView1.frame.size.height;
    // row
    for (NSInteger i = 0; i < [priceArr count]; i++)
    {
        NSDictionary *tmpDic = [priceArr objectAtIndex:i];
        NSString *strDuration = [tmpDic objectForKey:@"duration"];
        NSString *strOriginal = [NSString stringWithFormat:STR_PRICE_FORMAT, GET([tmpDic objectForKey:@"price"])];
        NSString *tmpPromotion = GET([tmpDic objectForKey:@"disPrice"]);
        NSString *strPromotion = [NSString stringWithFormat:STR_PRICE_FORMAT, tmpPromotion];
        column1.origin.y += HEIGHT_ROW_LABEL;
        column2.origin.y += HEIGHT_ROW_LABEL;
        column3.origin.y += HEIGHT_ROW_LABEL;
        nHeight += HEIGHT_ROW_LABEL;
        
        duration = [[UILabel alloc] initWithFrame:column1];
        duration.textAlignment = NSTextAlignmentCenter;
        duration.text = strDuration;
        duration.textColor = COLOR_LABEL;
        [m_workingDay addSubview:duration];
        original = [[UILabel alloc] initWithFrame:column2];
        original.textAlignment = NSTextAlignmentCenter;
        original.text = [NSString stringWithFormat:@"%@%@",strOriginal, STR_PER_HOUR];
        original.textColor = COLOR_LABEL;
        [m_workingDay addSubview:original];
        if ([tmpPromotion length] > 0)
        {
            promotion = [[UILabel alloc] initWithFrame:column3];
            promotion.textAlignment = NSTextAlignmentCenter;
            promotion.text = [NSString stringWithFormat:@"%@%@",strPromotion, STR_PER_HOUR];
            promotion.textColor = COLOR_LABEL;
            [m_workingDay addSubview:promotion];
        }
        
        CGRect sRc = CGRectMake(10, nHeight-1, MainScreenWidth - 20, 1);
        UIImageView *sepView = [[PublicFunction ShareInstance] getSeparatorView:sRc];
        [m_workingDay addSubview:sepView];
        nHeight += sepView.frame.size.height;
        nVerH +=HEIGHT_ROW_LABEL;
    }
    
    tmpRect = m_workingDay.frame;
    tmpRect.size.height = nHeight;
    m_workingDay.frame = tmpRect;
    
    CGRect vLine1 = CGRectMake(column1.origin.x + column1.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nVerH);
    CGRect vLine2 = CGRectMake(column2.origin.x + column2.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nVerH);
    UIImageView *vLineView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView1.frame = vLine1;
    [m_workingDay addSubview:vLineView1];
    UIImageView *vLineView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView2.frame = vLine2;
    [m_workingDay addSubview:vLineView2];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initWeekendView:(NSArray *)priceArr
{
    NSInteger nStartY = m_workingDay.frame.origin.y + m_workingDay.frame.size.height + spaceViewHeight;
    NSInteger nStartX = 10;
    NSInteger nHeight = 0;
    NSInteger nWidth = 320;
    NSString *tmpStr = nil;
    CGRect tmpRect = CGRectMake(0, nStartY, nWidth, 320);
    
    m_weekend = [[UIView alloc] initWithFrame:tmpRect];
    m_weekend.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_weekend];
    
    CGRect rc1 = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    UIView *spaceView1 = [[PublicFunction ShareInstance] spaceViewWithRect:rc1 withColor:COLOR_BACKGROUND];
    [m_workingDay addSubview:spaceView1];
    nStartY += spaceViewHeight;
    nHeight += spaceViewHeight;
    
    tmpRect.origin.y = nHeight;
    tmpRect.size.height = HEIGHT_ROW_LABEL;
    nHeight += HEIGHT_ROW_LABEL;
    UILabel *workingDayLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpStr = [NSString stringWithFormat:STR_WEEKEND_PRICE, [[CarDataManager shareInstance] getDayPriceWithType:price_weekend]];
    workingDayLabel.text = tmpStr;
    [m_weekend addSubview:workingDayLabel];
    
    CGRect rc = CGRectMake(0, nHeight, MainScreenWidth, spaceViewHeight);
    UIView *spaceView = [[PublicFunction ShareInstance] spaceViewWithRect:rc withColor:COLOR_BACKGROUND];
    [m_weekend addSubview:spaceView];
    nHeight += spaceViewHeight;
    // icon
    UIImage *imgDuration = [UIImage imageNamed:IMG_DURATION];
    UIImage *imgOriginal = [UIImage imageNamed:IMG_ORIGINAL];
    UIImage *imgpromotion = [UIImage imageNamed:IMG_PROMOTION];
    CGRect iconRc = CGRectMake(ICON_OFFSET_PROMOTION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    UIImageView *viewDuration = [[UIImageView alloc] initWithImage:imgDuration];
    UIImageView *viewOriginal = [[UIImageView alloc] initWithImage:imgOriginal];
    UIImageView *viewPromotion = [[UIImageView alloc] initWithImage:imgpromotion];
    viewDuration.frame = CGRectMake(ICON_OFFSET_DURRATION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    viewOriginal.frame = CGRectMake(ICON_OFFSET_ORIGINAL, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);;
    viewPromotion.frame = iconRc;
    // column title
    CGRect column1 = CGRectMake(nStartX, nHeight, WIDTH_COLUMN1, HEIGHT_ROW_LABEL);
    CGRect column2 = CGRectMake(nStartX + WIDTH_COLUMN1, nHeight, WIDTH_COLUMN2, HEIGHT_ROW_LABEL);
    CGRect column3 = CGRectMake(nStartX + WIDTH_COLUMN1 + WIDTH_COLUMN2, nHeight, WIDTH_COLUMN3, HEIGHT_ROW_LABEL);
    
    UILabel *duration = [[UILabel alloc] initWithFrame:column1];
    duration.text = STR_PERIOD_OF_TIME;
    duration.textAlignment = NSTextAlignmentCenter;
    [duration addSubview:viewDuration];
    [m_weekend addSubview:duration];
    UILabel *original = [[UILabel alloc] initWithFrame:column2];
    original.text = STR_ORIGINAL_PRICE;
    original.textAlignment = NSTextAlignmentCenter;
    [original addSubview:viewOriginal];
    [m_weekend addSubview:original];
    UILabel *promotion = [[UILabel alloc] initWithFrame:column3];
    promotion.text = STR_PROMOTION_PRICE;
    promotion.textAlignment = NSTextAlignmentCenter;
    [promotion addSubview:viewPromotion];
    [m_weekend addSubview:promotion];
    nHeight += HEIGHT_ROW_LABEL;
    
    CGRect sRc1 = CGRectMake(10, nHeight, MainScreenWidth - 20, 1);
    UIImageView *sepView1 = [[PublicFunction ShareInstance] getSeparatorView:sRc1];
    [m_weekend addSubview:sepView1];
    nHeight += sepView1.frame.size.height;
    // row
    for (NSInteger i = 0; i < [priceArr count]; i++)
    {
        NSDictionary *tmpDic = [priceArr objectAtIndex:i];
        NSString *strDuration = [tmpDic objectForKey:@"duration"];
        NSString *strOriginal = [NSString stringWithFormat:STR_PRICE_FORMAT, [tmpDic objectForKey:@"price"]];
        NSString *strPromotion = [NSString stringWithFormat:STR_PRICE_FORMAT, [tmpDic objectForKey:@"disPrice"]];
        column1.origin.y += HEIGHT_ROW_LABEL;
        column2.origin.y += HEIGHT_ROW_LABEL;
        column3.origin.y += HEIGHT_ROW_LABEL;
        nHeight += HEIGHT_ROW_LABEL;
        
        duration = [[UILabel alloc] initWithFrame:column1];
        duration.textAlignment = NSTextAlignmentCenter;
        duration.text = strDuration;
        duration.textColor = COLOR_LABEL;
        [m_weekend addSubview:duration];
        original = [[UILabel alloc] initWithFrame:column2];
        original.textAlignment = NSTextAlignmentCenter;
        original.textColor = COLOR_LABEL;
        original.text = [NSString stringWithFormat:@"%@%@", strOriginal, STR_PER_HOUR];
        [m_weekend addSubview:original];
        promotion = [[UILabel alloc] initWithFrame:column3];
        promotion.textAlignment = NSTextAlignmentCenter;
        promotion.textColor = COLOR_LABEL;
        promotion.text = [NSString stringWithFormat:@"%@%@", strPromotion, STR_PER_HOUR];
        [m_weekend addSubview:promotion];
        
        CGRect sRc = CGRectMake(10, nHeight, MainScreenWidth - 20, 1);
        UIImageView *sepView = [[PublicFunction ShareInstance] getSeparatorView:sRc];
        [m_weekend addSubview:sepView];
        nHeight += sepView.frame.size.height;
    }
    
    tmpRect = m_weekend.frame;
    tmpRect.size.height = nHeight;
    m_weekend.frame = tmpRect;
    
    CGRect vLine1 = CGRectMake(column1.origin.x + column1.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nHeight- (HEIGHT_ROW_LABEL + spaceViewHeight * 2));
    CGRect vLine2 = CGRectMake(column2.origin.x + column2.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nHeight - (HEIGHT_ROW_LABEL + spaceViewHeight * 2));
    UIImageView *vLineView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView1.frame = vLine1;
    [m_weekend addSubview:vLineView1];
    UIImageView *vLineView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView2.frame = vLine2;
    [m_weekend addSubview:vLineView2];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initHolidayView:(NSArray *)priceArr
{
    NSInteger nStartY = m_weekend.frame.origin.y + m_weekend.frame.size.height + spaceViewHeight;
    NSInteger nStartX = 10;
    NSInteger nHeight = 0;
    NSInteger nWidth = 320;
    NSString *tmpStr = nil;
    CGRect tmpRect = CGRectMake(0, nStartY, nWidth, 320);
    
    m_holiday = [[UIView alloc] initWithFrame:tmpRect];
    m_holiday.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_holiday];
    
    CGRect rc1 = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    UIView *spaceView1 = [[PublicFunction ShareInstance] spaceViewWithRect:rc1 withColor:[UIColor colorWithHexString:@"#efeff4"]];
    [m_workingDay addSubview:spaceView1];
    nStartY += spaceViewHeight;
    nHeight += spaceViewHeight;
    
    tmpRect.origin.y = nHeight;
    tmpRect.size.height = HEIGHT_ROW_LABEL;
    nHeight += HEIGHT_ROW_LABEL;
    UILabel *workingDayLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpStr = [NSString stringWithFormat:STR_HOLIDAY_PRICE, [[CarDataManager shareInstance] getHolidayDateString], [[CarDataManager shareInstance] getDayPriceWithType:price_holiday]];
    workingDayLabel.text = tmpStr;
    [m_holiday addSubview:workingDayLabel];
    
    CGRect rc = CGRectMake(0, nHeight, MainScreenWidth, spaceViewHeight);
    UIView *spaceView = [[PublicFunction ShareInstance] spaceViewWithRect:rc withColor:[UIColor colorWithHexString:@"#efeff4"]];
    [m_holiday addSubview:spaceView];
    nHeight += spaceViewHeight;
    
    CGRect column1 = CGRectMake(nStartX, nHeight, WIDTH_COLUMN1, HEIGHT_ROW_LABEL);
    CGRect column2 = CGRectMake(nStartX + WIDTH_COLUMN1, nHeight, WIDTH_COLUMN2, HEIGHT_ROW_LABEL);
    CGRect column3 = CGRectMake(nStartX + WIDTH_COLUMN1 + WIDTH_COLUMN2, nHeight, WIDTH_COLUMN3, HEIGHT_ROW_LABEL);
    // icon
    UIImage *imgDuration = [UIImage imageNamed:IMG_DURATION];
    UIImage *imgOriginal = [UIImage imageNamed:IMG_ORIGINAL];
    UIImage *imgpromotion = [UIImage imageNamed:IMG_PROMOTION];
    CGRect iconRc = CGRectMake(ICON_OFFSET_PROMOTION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    UIImageView *viewDuration = [[UIImageView alloc] initWithImage:imgDuration];
    UIImageView *viewOriginal = [[UIImageView alloc] initWithImage:imgOriginal];
    UIImageView *viewPromotion = [[UIImageView alloc] initWithImage:imgpromotion];
    viewDuration.frame = CGRectMake(ICON_OFFSET_DURRATION, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);
    viewOriginal.frame = CGRectMake(ICON_OFFSET_ORIGINAL, (HEIGHT_ROW_LABEL - imgpromotion.size.height) / 2, imgpromotion.size.width, imgpromotion.size.height);;
    viewPromotion.frame = iconRc;
    // column title
    UILabel *duration = [[UILabel alloc] initWithFrame:column1];
    duration.text = STR_PERIOD_OF_TIME;
    duration.textAlignment = NSTextAlignmentCenter;
    [duration addSubview:viewDuration];
    [m_holiday addSubview:duration];

    UILabel *original = [[UILabel alloc] initWithFrame:column2];
    original.text = STR_ORIGINAL_PRICE;
    original.textAlignment = NSTextAlignmentCenter;
    [original addSubview:viewOriginal];
    [m_holiday addSubview:original];
    UILabel *promotion = [[UILabel alloc] initWithFrame:column3];
    promotion.text = STR_PROMOTION_PRICE;
    promotion.textAlignment = NSTextAlignmentCenter;
    [promotion addSubview:viewPromotion];
    [m_holiday addSubview:promotion];
    nHeight += HEIGHT_ROW_LABEL;
    
    CGRect sRc1 = CGRectMake(10, nHeight, MainScreenWidth - 20, 1);
    UIImageView *sepView1 = [[PublicFunction ShareInstance] getSeparatorView:sRc1];
    [m_holiday addSubview:sepView1];
    nHeight += sepView1.frame.size.height;
    // row
    for (NSInteger i = 0; i < [priceArr count]; i++)
    {
        NSDictionary *tmpDic = [priceArr objectAtIndex:i];
        NSString *strDuration = [tmpDic objectForKey:@"duration"];
        NSString *strOriginal = [NSString stringWithFormat:STR_PRICE_FORMAT, [tmpDic objectForKey:@"price"]];
        NSString *strPromotion = [NSString stringWithFormat:STR_PRICE_FORMAT, [tmpDic objectForKey:@"disPrice"]];
        column1.origin.y += HEIGHT_ROW_LABEL;
        column2.origin.y += HEIGHT_ROW_LABEL;
        column3.origin.y += HEIGHT_ROW_LABEL;
        nHeight += HEIGHT_ROW_LABEL;
        
        duration = [[UILabel alloc] initWithFrame:column1];
        duration.textAlignment = NSTextAlignmentCenter;
        duration.text = strDuration;
        duration.textColor = COLOR_LABEL;
        [m_holiday addSubview:duration];
        original = [[UILabel alloc] initWithFrame:column2];
        original.textAlignment = NSTextAlignmentCenter;
        original.text = [NSString stringWithFormat:@"%@%@", strOriginal, STR_PER_HOUR];
        original.textColor = COLOR_LABEL;
        [m_holiday addSubview:original];
        promotion = [[UILabel alloc] initWithFrame:column3];
        promotion.textAlignment = NSTextAlignmentCenter;
        promotion.textColor = COLOR_LABEL;
        promotion.text = [NSString stringWithFormat:@"%@%@", strPromotion, STR_PER_HOUR];
        [m_holiday addSubview:promotion];
        
        CGRect sRc = CGRectMake(10, nHeight, MainScreenWidth - 20, 1);
        UIImageView *sepView = [[PublicFunction ShareInstance] getSeparatorView:sRc];
        [m_holiday addSubview:sepView];
        nHeight += sepView.frame.size.height;
    }
    
    tmpRect = m_holiday.frame;
    tmpRect.size.height = nHeight;
    m_holiday.frame = tmpRect;
    
    
    CGRect vLine1 = CGRectMake(column1.origin.x + column1.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nHeight);
    CGRect vLine2 = CGRectMake(column2.origin.x + column2.size.width, HEIGHT_ROW_LABEL + spaceViewHeight * 2, 1, nHeight);
    UIImageView *vLineView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView1.frame = vLine1;
    [m_holiday addSubview:vLineView1];
    UIImageView *vLineView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView2.frame = vLine2;
    [m_holiday addSubview:vLineView2];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initOtherView
{
    CGRect tmpRect;
    
    if (m_holiday) {
        tmpRect = CGRectMake(0, m_holiday.frame.origin.y + m_holiday.frame.size.height + spaceViewHeight, 320, 300);
    }
    else if(m_weekend)
    {
        tmpRect = CGRectMake(0, m_weekend.frame.origin.y + m_weekend.frame.size.height + spaceViewHeight, 320, 300);
    }
    else if(m_workingDay)
    {
        tmpRect = CGRectMake(0, m_workingDay.frame.origin.y + m_workingDay.frame.size.height + spaceViewHeight, 320, 300);
    }
    m_otherInfo = [[UIView alloc] initWithFrame:tmpRect];
    m_otherInfo.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_otherInfo];
    
    NSInteger nStartX = 10;
    NSInteger nHeight = 0;
    NSInteger nWidth = 300;
    CGRect column1 = CGRectMake(nStartX, nHeight, (nWidth/3) * 2, HEIGHT_ROW_LABEL);
    CGRect column2 = CGRectMake(nStartX + ((nWidth/3) * 2), nHeight, nWidth/3, HEIGHT_ROW_LABEL);
    
    UILabel *mileageTitle = [[UILabel alloc] initWithFrame:column1];
    mileageTitle.text = STR_MILEAGE_PRICE;
    [m_otherInfo addSubview:mileageTitle];
    UILabel *mileage = [[UILabel alloc] initWithFrame:column2];
    NSString *strMileage = [NSString stringWithFormat:STR_COST_FORMAT, [[CarDataManager shareInstance] getMileage]];
    mileage.text = strMileage;
    mileage.textAlignment = NSTextAlignmentCenter;
    mileage.textColor = COLOR_LABEL;
    [m_otherInfo addSubview:mileage];
    
    column1.origin.y += HEIGHT_ROW_LABEL;
    column2.origin.y += HEIGHT_ROW_LABEL;
    nHeight += HEIGHT_ROW_LABEL;
    UILabel *scheduleTitle = [[UILabel alloc] initWithFrame:column1];
    scheduleTitle.text = STR_SCHEDULING_PRICE;
    [m_otherInfo addSubview:scheduleTitle];
    UILabel *schedule = [[UILabel alloc] initWithFrame:column2];
    schedule.text = [NSString stringWithFormat:STR_COST_FORMAT, [[CarDataManager shareInstance] getScheduling]];
    schedule.textAlignment = NSTextAlignmentCenter;
    schedule.textColor = COLOR_LABEL;
    [m_otherInfo addSubview:schedule];
    
    column1.origin.y += HEIGHT_ROW_LABEL;
    column2.origin.y += HEIGHT_ROW_LABEL;
    nHeight += HEIGHT_ROW_LABEL;
    UILabel *depositTitle = [[UILabel alloc] initWithFrame:column1];
    depositTitle.text = STR_DEPOSIT;
    [m_otherInfo addSubview:depositTitle];
    UILabel *deposit = [[UILabel alloc] initWithFrame:column2];
    deposit.text = [NSString stringWithFormat:STR_COST_FORMAT, [[CarDataManager shareInstance] getDeposit]];
    deposit.textAlignment = NSTextAlignmentCenter;
    deposit.textColor = COLOR_LABEL;
    [m_otherInfo addSubview:deposit];
    
    nHeight += HEIGHT_ROW_LABEL;
    
    tmpRect = m_otherInfo.frame;
    tmpRect.size.height = nHeight;
    m_otherInfo.frame = tmpRect;
    
    CGRect vLine1 = CGRectMake(column1.origin.x + column1.size.width, 0, 1, nHeight);
    UIImageView *vLineView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_VERTICAL_LINE]];
    vLineView1.frame = vLine1;
    [m_otherInfo addSubview:vLineView1];

    m_scrollView.contentSize = CGSizeMake(MainScreenWidth, m_otherInfo.frame.origin.y + m_otherInfo.frame.size.height + HEIGHT_ROW_LABEL * 2);
}


-(void)gotCarPrice:(FMNetworkRequest*)request
{
    NSDictionary *dic = request.responseData;
    
    NSDictionary *holiday = [dic objectForKey:@"holiday"];
    NSDictionary *workday = [dic objectForKey:@"weekday"];
    NSDictionary *weekend = [dic objectForKey:@"weekend"];
    
    [[CarDataManager shareInstance] setCarPrice:holiday withType:price_holiday];
    [[CarDataManager shareInstance] setCarPrice:workday withType:price_workday];
    [[CarDataManager shareInstance] setCarPrice:weekend withType:price_weekend];
    
    [self showCarPrice];
}


-(void)showCarPrice
{
    m_workingDayArr = [[NSMutableArray alloc] initWithArray:[[CarDataManager shareInstance]getCarPriceArray:price_workday]] ;
    m_weekendArr = [[NSMutableArray alloc] initWithArray:[[CarDataManager shareInstance]getCarPriceArray:price_weekend]];
    m_holidayArr = [[NSMutableArray alloc] initWithArray:[[CarDataManager shareInstance]getCarPriceArray:price_holiday]];
    
    if ([m_workingDayArr count] > 0) {
        [self initWorkDayView:m_workingDayArr];
    }
    
    if ([m_weekendArr count] > 0) {
        [self initWeekendView:m_weekendArr];
    }
    
    if ([m_holidayArr count] > 0) {
        [self initHolidayView:m_holidayArr];
    }
    
    [self initOtherView];
}

#pragma mark - http delegate

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCarPrice])
    {
        [self gotCarPrice:fmNetworkRequest];
    }
    
    [[LoadingClass shared] hideLoading];
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
}

@end
