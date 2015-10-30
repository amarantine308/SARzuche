//
//  CarInfoView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PersonalCarInfoView.h"
#import "constString.h"
#import "CustomDrawView.h"
#import "BLNetworkManager.h"
#import "ConstDefine.h"
#import "PublicFunction.h"
#import "UIColor+Helper.h"
#import "ConstDefine.h"
#import "UIImageView+URL.h"

#define TAG_TAKE_BRANCHE_BTN             10000
#define TAG_GIVEBACK_BRANCHE_BTN        10001

#define LABEL_START_X_FORORDER    10

#define ORDERINFO_START_X        90

#define CAR_W                   120
#define CAR_H                   90

#define PRICE_START_X1           140
#define PRICE_START_X2           240
#define LABEL_ROW_HEIGHT         25
#define TITLE_ROW_HEIGHT         40
#define LABEL_ROW_LENGTH        (MainScreenWidth - PRICE_START_X1 -10)

#define FRAME_CAR_IMAGE                 CGRectMake(10, 5, CAR_W, CAR_H)
#define FRAME_CAR_PLATE_LABEL           CGRectMake(0, 70, CAR_W, LABEL_ROW_HEIGHT)
#define FRAME_CAR_SERIE_LABEL           CGRectMake(PRICE_START_X1, 0, LABEL_ROW_LENGTH, LABEL_ROW_HEIGHT)
#define FRAME_CAR_MODEL_LABEL           CGRectMake(PRICE_START_X1,LABEL_ROW_HEIGHT, LABEL_ROW_LENGTH, LABEL_ROW_HEIGHT)
#define FRAME_CAR_PRICE_HOUR_LABEL      CGRectMake(PRICE_START_X1, LABEL_ROW_HEIGHT * 2, 100, LABEL_ROW_HEIGHT)
#define FRAME_CAR_PRICE_DAY_LABEL       CGRectMake(PRICE_START_X1, LABEL_ROW_HEIGHT * 3, 100, LABEL_ROW_HEIGHT)
#define FRAME_CAR_PRICE_DETAILS         CGRectMake(PRICE_START_X2, LABEL_ROW_HEIGHT * 3, 100, LABEL_ROW_HEIGHT)
#define FRAME_CAR_DISCOUNT_LABEL        CGRectMake(PRICE_START_X2 - 50, 50, 80, LABEL_ROW_HEIGHT)
#define FRAME_CAR_RENT_BTN              CGRectMake(PRICE_START_X2, 30+50, 60, LABEL_ROW_HEIGHT)


#define FRAME_CAR_PRICE_LINE      FRAME_CAR_DISCOUNT_LABEL


// my car
#define FRAME_TAKE_CAR_BRANCHE_TITLE            CGRectMake(10, 100, 120, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_CAR_BRANCHE                  CGRectMake(130, 100, 160, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_CAR_TIME_TITLE               CGRectMake(10, 120, 120, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_CAR_TIME                     CGRectMake(130, 120, 160, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_CAR_BRANCHE_TITLE        CGRectMake(10, 140, 120, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_CAR_BRANCHE              CGRectMake(130, 140, 160, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_CAR_TIME_TITLE           CGRectMake(10, 160, 120, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_CAR_TIME                 CGRectMake(130, 160, 160, LABEL_ROW_HEIGHT)
// order info
#define FRAME_TAKE_TIME_TITLE_FORINFO               CGRectMake(LABEL_START_X_FORORDER, 0, 90, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_TIME_FORINFO                     CGRectMake(ORDERINFO_START_X, 0, 190, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_TIME_TITLE_FORINFO           CGRectMake(LABEL_START_X_FORORDER, LABEL_ROW_HEIGHT, 90, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_TIME_FORINFO                 CGRectMake(ORDERINFO_START_X, LABEL_ROW_HEIGHT, 190, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_BRANCHE_TITLE_FORINFO           CGRectMake(LABEL_START_X_FORORDER, LABEL_ROW_HEIGHT * 2, 90, LABEL_ROW_HEIGHT)
#define FRAME_TAKE_BRANCHE_FORINFO                  CGRectMake(ORDERINFO_START_X, LABEL_ROW_HEIGHT * 2, 190, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_BRANCHE_TITLE_FORINFO        CGRectMake(LABEL_START_X_FORORDER, LABEL_ROW_HEIGHT * 3, 90, LABEL_ROW_HEIGHT)
#define FRAME_GIVEBACK_BRANCHE_FORINFO              CGRectMake(ORDERINFO_START_X, LABEL_ROW_HEIGHT * 3, 190, LABEL_ROW_HEIGHT)
// History car info
#define FRAME_CAR_SERIE_HISTORY           CGRectMake(PRICE_START_X1, 10, 200, LABEL_ROW_HEIGHT)
#define FRAME_CAR_MODEL_HISTORY           CGRectMake(PRICE_START_X1, 40, 200, LABEL_ROW_HEIGHT)


#define IMG_AREA            @"block.png"

@interface PersonalCarInfoView()
{
    CustomImageView *m_carPhoto;
    
    UILabel *m_carPlate;
    UILabel *m_carSerie;
    UILabel *m_carModel;
    UILabel *m_pricePerHour;
    UILabel *m_pricePerDay;
    UILabel *m_discount;
    
    
    NSString *m_strPlate;
    NSString *m_strSerie;
    NSString *m_strModel;
    NSString *m_strPerHour;
    NSString *m_strPerDay;
    NSString *m_strDiscount;
    
    UIButton *m_toRentCar;
    CustomDrawView *m_lineView;
    
    NSString *m_imageName;
    
    useType m_forUsed;
    NSInteger m_curHeight;
    
    UILabel *m_takeTime;
    UILabel *m_giveBackTime;
    UILabel *m_takeBranche;
    UILabel *m_givebackBranche;
    
    // request
    FMNetworkRequest *m_imgReq;
}
@end

@implementation PersonalCarInfoView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        m_forUsed = forDefault;
        // Initialization code
        [self initCarInfoView];
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame forUsed:(useType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        m_forUsed = type;
        switch (m_forUsed) {
            case forDefault:
                [self initCarInfoView];
                break;
            case forSelectCar:
                [self initCarInfoView];
                break;
            case forMyCar:
                [self initCarInfoView];
                [self initUserInfoWithCarView];
                break;
            case forUserInfo:
                [self initUserInfoView];
                break;
            case forCarInfoNoPrice:
                [self initCarInfoNoPriceView];
                break;
            case forCurOrder:
                [self initCurOrderView];
                break;
            default:
                break;
        }

        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, m_curHeight);
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/**
 *方法描述：初始化当前订单中车辆信息和取还车信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCurOrderView
{
//    [self initCarInfoNoPriceView];
    [self initCarInfoView];
    
    CGRect tmpRect = CGRectMake(0, m_curHeight, MainScreenWidth, spaceViewHeight);
    UIColor *clr = [UIColor colorWithHexString:@"#efeff4"];
    UIView *tmpView = [[PublicFunction ShareInstance] spaceViewWithRect:tmpRect withColor:clr];
    [self addSubview:tmpView];
    m_curHeight += tmpView.frame.size.height;
    
    [self initUserInfoForOrderView];
}

/**
 *方法描述：订单页面个人取还车信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initUserInfoForOrderView
{
    NSInteger nStartHeight = m_curHeight;
    // title
    CGRect tmpRect = CGRectMake(LABEL_START_X_FORORDER, nStartHeight, MainScreenWidth - 20, TITLE_ROW_HEIGHT);
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:tmpRect];
    tmpLabel.text = STR_TAKE_GIVEBACK_CAR;
    tmpLabel.textColor = COLOR_LABEL_GRAY;
    tmpLabel.font = FONT_LABEL_TITLE;
    tmpLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:tmpLabel];
    m_curHeight += TITLE_ROW_HEIGHT;
    // separator
    tmpRect.origin.y += tmpRect.size.height;
    UIImageView *separator = [[PublicFunction ShareInstance] getSeparatorView:tmpRect];
    [self addSubview:separator];
    m_curHeight += separator.frame.size.height;
    // take title
    tmpRect = FRAME_TAKE_TIME_TITLE_FORINFO;
    tmpRect.origin.y = m_curHeight;
    UILabel *takeTimeTitle    = [[UILabel alloc] initWithFrame:tmpRect];
    takeTimeTitle.text = STR_TAKE_CAR_TIME;
    takeTimeTitle.textColor = [UIColor blackColor];
    takeTimeTitle.font = FONT_LABEL;
    [self addSubview:takeTimeTitle];
    // take time
    tmpRect = FRAME_TAKE_TIME_FORINFO;
    tmpRect.origin.y = m_curHeight;
    m_takeTime = [[UILabel alloc] initWithFrame:tmpRect];
    m_takeTime.textColor = COLOR_LABEL;
    m_takeTime.font = FONT_LABEL;
    [self addSubview:m_takeTime];
    m_curHeight += LABEL_ROW_HEIGHT;
    // giveback title
    tmpRect = FRAME_GIVEBACK_TIME_TITLE_FORINFO;
    tmpRect.origin.y = m_curHeight;
    UILabel *giveBackTimeTitle = [[UILabel alloc] initWithFrame:tmpRect];
    giveBackTimeTitle.text = STR_GIVE_BACK_TIME;
    giveBackTimeTitle.textColor = [UIColor blackColor];
    giveBackTimeTitle.font = FONT_LABEL;
    [self addSubview:giveBackTimeTitle];
    // giveback time
    tmpRect = FRAME_GIVEBACK_TIME_FORINFO;
    tmpRect.origin.y = m_curHeight;
    m_giveBackTime = [[UILabel alloc] initWithFrame:tmpRect];
    m_giveBackTime.textColor = COLOR_LABEL;
    m_giveBackTime.font = FONT_LABEL;
    [self addSubview:m_giveBackTime];
    m_curHeight += LABEL_ROW_HEIGHT;
    
    //take branche title
    tmpRect = FRAME_TAKE_BRANCHE_TITLE_FORINFO;
    tmpRect.origin.y  = m_curHeight;
    UILabel *takeTitle   = [[UILabel alloc] initWithFrame:tmpRect];
    takeTitle.text = STR_TAKE_BRANCHES;
    takeTitle.font = FONT_LABEL;
    takeTitle.textColor = [UIColor blackColor];
    [self addSubview:takeTitle];
    // take branche
    tmpRect = FRAME_TAKE_BRANCHE_FORINFO;
    tmpRect.origin.y  = m_curHeight;
    m_takeBranche = [[UILabel alloc] initWithFrame:tmpRect];
    m_takeBranche.textColor = COLOR_LABEL;
    m_takeBranche.font = FONT_LABEL;
    [self addMapBtnToView:m_takeBranche withTag:TAG_TAKE_BRANCHE_BTN];
    [self addSubview:m_takeBranche];
    m_curHeight += LABEL_ROW_HEIGHT;
    // giveback branche title
    tmpRect = FRAME_GIVEBACK_BRANCHE_TITLE_FORINFO;
    tmpRect.origin.y  = m_curHeight;
    UILabel *giveBackTitle = [[UILabel alloc] initWithFrame:tmpRect];
    giveBackTitle.text = STR_GIVEBACK_BRANCHES;
    giveBackTitle.font = FONT_LABEL;
    giveBackTitle.textColor = [UIColor blackColor];
    [self addSubview:giveBackTitle];
    // giveback branche
    tmpRect = FRAME_GIVEBACK_BRANCHE_FORINFO;
    tmpRect.origin.y  = m_curHeight;
    m_givebackBranche = [[UILabel alloc] initWithFrame:tmpRect];
    m_givebackBranche.textColor = COLOR_LABEL;
    m_givebackBranche.font = FONT_LABEL;
    [self addMapBtnToView:m_givebackBranche withTag:TAG_GIVEBACK_BRANCHE_BTN];
    [self addSubview:m_givebackBranche];
    m_curHeight += LABEL_ROW_HEIGHT;
    self.backgroundColor = [UIColor greenColor];
}

/**
 *方法描述：初始化无车辆价格的View
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfoNoPriceView
{
    if (nil == m_imageName) {
        m_imageName = @"defaultcarimage.png";
    }
    UIImage *tmpImageView = [UIImage imageNamed:m_imageName];
    m_carPhoto = [[CustomImageView alloc]initWithImage:tmpImageView];
    m_carPhoto.frame = FRAME_CAR_IMAGE;
    m_carPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_carPhoto];
    m_curHeight += (m_carPhoto.frame.size.height + 5);
    
    m_carPlate = [[UILabel alloc] initWithFrame:FRAME_CAR_PLATE_LABEL];
    m_carPlate.textColor = [UIColor whiteColor];
    m_carPlate.textAlignment = NSTextAlignmentCenter;
    m_carPlate.backgroundColor = COLOR_CARPLATE;
//    [self addSubview:m_carPlate];
    [m_carPhoto addSubview:m_carPlate];
    
    m_carSerie = [[UILabel alloc] initWithFrame:FRAME_CAR_SERIE_HISTORY];
    m_carSerie.textColor = COLOR_LABEL;
    [self addSubview:m_carSerie];
    
    m_carModel = [[UILabel alloc] initWithFrame:FRAME_CAR_MODEL_HISTORY];
    m_carModel.textColor = COLOR_LABEL;
    [self addSubview:m_carModel];
}


-(void)mapPressed:(id)sender
{
    NSLog(@"map pressed");
    UIButton *btn = sender;
    if (delegate && [delegate respondsToSelector:@selector(jumpToMapWithBranche:)])
    {
        [delegate jumpToMapWithBranche:(btn.tag == TAG_TAKE_BRANCHE_BTN) ? YES : NO];
    }
}

/**
 *方法描述：初始化用户选择的用车条件View
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initUserInfoView
{
    UILabel *takeTimeTitle    = [[UILabel alloc] initWithFrame:FRAME_TAKE_TIME_TITLE_FORINFO];
    takeTimeTitle.text = STR_TAKE_CAR_TIME;
    takeTimeTitle.font = FONT_LABEL;
    takeTimeTitle.textColor = COLOR_LABEL_GRAY;
    [self addSubview:takeTimeTitle];

    UILabel *giveBackTimeTitle = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_TIME_TITLE_FORINFO];
    giveBackTimeTitle.text = STR_GIVE_BACK_TIME;
    giveBackTimeTitle.font = FONT_LABEL;
    giveBackTimeTitle.textColor = COLOR_LABEL_GRAY;
    [self addSubview:giveBackTimeTitle];
    
    m_curHeight += LABEL_ROW_HEIGHT;

    m_takeTime = [[UILabel alloc] initWithFrame:FRAME_TAKE_TIME_FORINFO];
    m_takeTime.textColor = COLOR_LABEL;
    m_takeTime.font = FONT_LABEL;
    [self addSubview:m_takeTime];

    m_giveBackTime = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_TIME_FORINFO];
    m_giveBackTime.textColor = COLOR_LABEL;
    m_giveBackTime.font = FONT_LABEL;
    [self addSubview:m_giveBackTime];
    m_curHeight += LABEL_ROW_HEIGHT;

    //
    UILabel *takeTitle   = [[UILabel alloc] initWithFrame:FRAME_TAKE_BRANCHE_TITLE_FORINFO];
    takeTitle.text = STR_TAKE_BRANCHES;
    takeTitle.textColor = COLOR_LABEL_GRAY;
    takeTitle.font = FONT_LABEL;
    [self addSubview:takeTitle];
    
    m_takeBranche = [[UILabel alloc] initWithFrame:FRAME_TAKE_BRANCHE_FORINFO];
    m_takeBranche.textColor = COLOR_LABEL;
    m_takeBranche.font = FONT_LABEL;
    [self addMapBtnToView:m_takeBranche withTag:TAG_TAKE_BRANCHE_BTN];
    [self addSubview:m_takeBranche];
    m_curHeight += LABEL_ROW_HEIGHT;
    
    UILabel *giveBackTitle = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_BRANCHE_TITLE_FORINFO];
    giveBackTitle.text = STR_GIVEBACK_BRANCHES;
    giveBackTitle.textColor = COLOR_LABEL_GRAY;
    giveBackTitle.font = FONT_LABEL;
    [self addSubview:giveBackTitle];
    
    m_givebackBranche = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_BRANCHE_FORINFO];
    m_givebackBranche.textColor = COLOR_LABEL;
    m_givebackBranche.font = FONT_LABEL;
    [self addMapBtnToView:m_givebackBranche withTag:TAG_GIVEBACK_BRANCHE_BTN];
    [self addSubview:m_givebackBranche];
    m_curHeight += LABEL_ROW_HEIGHT;
}

/**
 *方法描述：初始化用户选择的信息View 并带有车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initUserInfoWithCarView
{
    UILabel *takeTitle   = [[UILabel alloc] initWithFrame:FRAME_TAKE_CAR_BRANCHE_TITLE];
    takeTitle.text = STR_TAKE_BRANCHES;
    takeTitle.textColor = [UIColor blackColor];
    [self addSubview:takeTitle];
    m_curHeight += LABEL_ROW_HEIGHT;
    
    m_takeBranche    = [[UILabel alloc] initWithFrame:FRAME_TAKE_CAR_BRANCHE];
    m_takeBranche.textColor = [UIColor blackColor];
    [self addSubview:m_takeBranche];

    UILabel *takeTimeTitle    = [[UILabel alloc] initWithFrame:FRAME_TAKE_CAR_TIME_TITLE];
    takeTimeTitle.text = STR_TAKE_CAR_TIME;
    takeTimeTitle.textColor = [UIColor blackColor];
    [self addSubview:takeTimeTitle];
    m_curHeight += LABEL_ROW_HEIGHT;

    m_takeTime = [[UILabel alloc] initWithFrame:FRAME_TAKE_CAR_TIME];
    m_takeTime.textColor = [UIColor blackColor];
    [self addSubview:m_takeTime];

    UILabel *giveBackTitle = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_CAR_BRANCHE_TITLE];
    giveBackTitle.text = STR_GIVEBACK_BRANCHES;
    giveBackTitle.textColor = [UIColor blackColor];
    [self addSubview:giveBackTitle];
    m_curHeight += LABEL_ROW_HEIGHT;

    m_givebackBranche = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_CAR_BRANCHE];
    m_givebackBranche.textColor = [UIColor blackColor];
    [self addSubview:m_givebackBranche];

    UILabel *giveBackTimeTitle = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_CAR_TIME_TITLE];
    giveBackTimeTitle.text = STR_GIVE_BACK_TIME;
    giveBackTimeTitle.textColor = [UIColor blackColor];
    [self addSubview:giveBackTimeTitle];
    m_curHeight += LABEL_ROW_HEIGHT;

    m_giveBackTime = [[UILabel alloc] initWithFrame:FRAME_GIVEBACK_CAR_TIME];
    m_giveBackTime.textColor = [UIColor blackColor];
    [self addSubview:m_giveBackTime];
    
}

/**
 *方法描述：初始化车辆View
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfoView
{
    self.backgroundColor = [UIColor whiteColor];
    if (nil == m_imageName) {
        m_imageName = @"defaultcarimage.png";
    }
    UIImage *tmpImageView = [UIImage imageNamed:m_imageName];
    m_carPhoto = [[CustomImageView alloc]initWithImage:tmpImageView];
    m_carPhoto.frame = FRAME_CAR_IMAGE;
    [self addSubview:m_carPhoto];
    m_curHeight += m_carPhoto.frame.size.height + 5;
    
    m_carPlate = [[UILabel alloc] initWithFrame:FRAME_CAR_PLATE_LABEL];
    m_carPlate.textColor = [UIColor whiteColor];
    m_carPlate.backgroundColor = COLOR_CARPLATE;
    m_carPlate.textAlignment = NSTextAlignmentCenter;
    [self addSubview:m_carPlate];
    [m_carPhoto addSubview:m_carPlate];
    
    m_carSerie = [[UILabel alloc] initWithFrame:FRAME_CAR_SERIE_LABEL];
    m_carSerie.textColor = COLOR_LABEL_GRAY;
    [self addSubview:m_carSerie];
    
    m_carModel = [[UILabel alloc] initWithFrame:FRAME_CAR_MODEL_LABEL];
    m_carModel.textColor = COLOR_LABEL_GRAY;
    [self addSubview:m_carModel];
    
    m_pricePerHour = [[UILabel alloc] initWithFrame:FRAME_CAR_PRICE_HOUR_LABEL];
    m_pricePerHour.textColor = COLOR_LABEL_BLUE;
    m_pricePerHour.font = FONT_LABEL;
    [self addSubview:m_pricePerHour];
    m_pricePerDay = [[UILabel alloc] initWithFrame:FRAME_CAR_PRICE_DAY_LABEL];
    m_pricePerDay.textColor = COLOR_LABEL_BLUE;
    m_pricePerDay.font = FONT_LABEL;
    [self addSubview:m_pricePerDay];
    m_discount = [[UILabel alloc] initWithFrame:FRAME_CAR_DISCOUNT_LABEL];
    m_discount.textColor = [UIColor grayColor];
    m_discount.font = [UIFont systemFontOfSize:14];
    m_discount.textAlignment = NSTextAlignmentCenter;
    [self addSubview:m_discount];
    
    m_toRentCar = [[UIButton alloc] initWithFrame:FRAME_CAR_RENT_BTN];
    [m_toRentCar setTitle:STR_TO_RENT forState:UIControlStateNormal];
    m_toRentCar.backgroundColor = COLOR_LABEL_BLUE;//[UIColor grayColor];
    [m_toRentCar addTarget:self action:@selector(toRentCar) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:m_toRentCar];
    
    m_lineView = [[CustomDrawView alloc]initWithFrame:FRAME_CAR_PRICE_LINE withStyle:customLine];
    [m_lineView drawLine:2.0];
    m_lineView.hidden = YES;
    [self addSubview:m_lineView];
    
    m_curHeight += 10;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)toRentCar
{
    NSLog(@" TO rent car");
    if (delegate && [delegate respondsToSelector:@selector(toOrder)]) {
        [delegate toOrder];
    }
}

/**
 *方法描述：删除车辆信息上的所有子视图
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)removeAllSubview
{
    for(UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
}

/**
 *方法描述：更新车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateSelectCarInfo
{
    if (nil == m_imageName) {
        m_imageName = @"defaultcarimage.png";
    }
    UIImage *tmpImageView = [UIImage imageNamed:m_imageName];
    [m_carPhoto setImage:tmpImageView];
    m_carPhoto.frame = FRAME_CAR_IMAGE;
    [self addSubview:m_carPhoto];
    m_curHeight += m_carPhoto.frame.size.height;
    
    m_carPlate.text = m_strPlate;
    m_carSerie.text = m_strSerie;
    m_carModel.text = m_strModel;
    m_pricePerHour.text = [NSString stringWithFormat:STR_PRICE_FORMAT, m_strPerHour];
    [self priceLabelColor:m_pricePerHour WithUnit:STR_PER_HOUR];
    //m_pricePerDay.text=@"1000000000";
    m_pricePerDay.text = [NSString stringWithFormat:STR_PRICE_FORMAT, m_strPerDay];
    [self priceLabelColor:m_pricePerDay WithUnit:STR_PER_DAY];
    if (m_strDiscount.length!=0)
    {
        m_discount.text = [NSString stringWithFormat:STR_YUAN_PERHOUER, m_strDiscount];
    }
    else
    {
     m_discount.text =@"";
    }
    m_discount.text = [NSString stringWithFormat:STR_YUAN_PERHOUER, m_strDiscount];

    if (m_strDiscount == nil || [m_strDiscount length] <= 0)
    {
        m_discount.hidden = YES;
        m_lineView.hidden = YES;
    }
    else
    {
        m_pricePerHour.text = [NSString stringWithFormat:STR_PRICE_FORMAT, m_strDiscount];
        [self priceLabelColor:m_pricePerHour WithUnit:STR_PER_HOUR];
        if (m_strPerHour.length!=0)
        {
            m_discount.text = [NSString stringWithFormat:STR_YUAN_PERHOUER, m_strPerHour];
        }
        else
        {
         m_discount.text = @"";
        }
        m_lineView.hidden = NO;
        m_discount.hidden = NO;
    }
}

/**
 *方法描述：设置带有价格的车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setselectCarWithUnitPrice:(NSString *)unitPrice
           dayPrice:(NSString *)dPrice
           carModel:(NSString *)model
           carSerie:(NSString *)serie
           carPlate:(NSString *)plate
           discount:(NSString *)discount
           imageUrl:(NSString *)url
{
    m_strPerDay = dPrice;
    m_strPerHour = unitPrice;
    m_strModel = model;
    m_strSerie = serie;
    m_strPlate = plate;
    m_strDiscount = discount;
    
    [self updateSelectCarInfo];
    m_imageName = url;
    [self setNeedsDisplay];
    [self updateCarImgae:url];
}

/**
 *方法描述：设置用户选择的网点和时间
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setSelectConditionWithBranche:(NSString *)tBhranche
                            takeTime:(NSString *)tTime
                         backBranche:(NSString *)bBranche
                            backTime:(NSString *)bTime
{
//    [self initMyCarView];
    
    m_takeBranche.text = [NSString stringWithFormat:@"%@", tBhranche];
    m_takeTime.text = [NSString stringWithFormat:@"%@", tTime];
    m_givebackBranche.text = [NSString stringWithFormat:@"%@", bBranche];
    m_giveBackTime.text = [NSString stringWithFormat:@"%@", bTime];

    if (nil == tBhranche || 0 == [tBhranche length])
    {
        for(UIView *subView in [self subviews])
        {
            if (subView.tag == TAG_TAKE_BRANCHE_BTN) {
                subView.hidden = YES;
            }
        }
    }
    
    if (nil == bBranche || 0 == [bBranche length])
    {
        for(UIView *subView in [self subviews])
        {
            if (subView.tag == TAG_GIVEBACK_BRANCHE_BTN) {
                subView.hidden = YES;
            }
        }
    }

}

/**
 *方法描述：更新车辆数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateCarImgae:(NSString *)imageUrl
{
    if (imageUrl == nil && [imageUrl length] == 0) {
        m_carPhoto.image = [UIImage imageNamed:@"defaultcarimage.png"];
        return;
    }
#if 0
//    m_imgReq = [[BLNetworkManager shareInstance] getImageWithUrl:imageUrl delegate:self];
    if ([imageUrl hasPrefix:@"http://"] || [imageUrl hasPrefix:@"https://"])
    {
#if 1
        m_carPhoto.image = [UIImage imageNamed:@"defaultcarimage.png"];
        __weak UIImageView *wself = m_carPhoto;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            UIImage *tmpImage = [UIImage imageWithData:tmpData];
            if (tmpImage)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.image = tmpImage;
                });
            }
        });
#else

        [m_carPhoto setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defaultcarimage.png"] options:SDWebImageRetryFailed];
#endif
    }
#else
    [m_carPhoto removeFromSuperview];
    m_carPhoto = [[CustomImageView alloc] initWithImage:@"defaultcarimage.png" withUrl:imageUrl];
    m_carPhoto.frame = FRAME_CAR_IMAGE;
    m_carPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:m_carPhoto];
    [m_carPhoto addSubview:m_carPlate];
#endif
}


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
//    m_carPhoto.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeScaleToFill;//
    m_carPhoto.image = [UIImage imageWithData:fmNetworkRequest.responseData];
    [m_carPhoto addSubview:m_carPlate];
}

/**
 *方法描述：请求失败
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    m_carPhoto.image = [UIImage imageNamed:@"defaultcarimage.png"];
    [m_carPhoto addSubview:m_carPlate];
}


-(void)dealloc
{
    CANCEL_REQUEST(m_imgReq);
}


#pragma mark - sub controll custom
// 获取当前Label上已经显示的字符串所占有的尺寸
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
            CGRect rec = [label.text boundingRectWithSize:CGSizeMake(self.frame.size.width,self.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil];
            sz = CGSizeMake(rec.size.width, rec.size.height);
#endif
        }
    }
    else
    {
        sz = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(self.frame.size.width,self.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return sz;
}

// 按照指定的颜色显示价格
-(void)priceLabelColor:(UILabel *)label  WithUnit:(NSString *)unit
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
    NSInteger subStartX = titleTextSize.width + 10;
    NSInteger subW = label.frame.size.width - titleTextSize.width + 10;
    CGRect subRect = CGRectMake(subStartX, 0, subW, label.frame.size.height);
    subLabel.frame = subRect;
    subLabel.textColor = COLOR_LABEL;
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.text = unit;
    subLabel.font = label.font;
    subLabel.tag = 1000;
    
    [label addSubview:subLabel];
    
}

#if 1
// 在网点后添加地图跳转
-(void)addMapBtnToView:(UILabel *)view withTag:(NSInteger)tag
{
    UIImage *tmpImg = [UIImage imageNamed:IMG_MAP];
    CGRect tmpRect = CGRectMake(view.frame.origin.x + view.frame.size.width , view.frame.origin.y, tmpImg.size.width*2, view.frame.size.height);
    UIImageView *mapIcon = [[UIImageView alloc] initWithImage:tmpImg];
    mapIcon.frame = CGRectMake((tmpRect.size.width - tmpImg.size.width) / 2, (tmpRect.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    mapIcon.userInteractionEnabled = NO;
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:tmpRect];
    [mapBtn addSubview:mapIcon];
    [mapBtn setEnabled:YES];
    mapBtn.tag = tag;
    mapBtn.backgroundColor = [UIColor whiteColor];
    [mapBtn addTarget:self action:@selector(mapPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mapBtn];
}

#else
-(void)addMapBtnToView:(UILabel *)view withTag:(NSInteger)tag
{
    UIImage *tmpImg = [UIImage imageNamed:IMG_MAP];
    CGRect tmpRect = CGRectMake(view.frame.size.width , 0, tmpImg.size.width*2, view.frame.size.height);
    UIImageView *mapIcon = [[UIImageView alloc] initWithImage:tmpImg];
    mapIcon.frame = CGRectMake((tmpRect.size.width - tmpImg.size.width) / 2, (tmpRect.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    mapIcon.userInteractionEnabled = NO;
    UIButton *mapBtn = [[UIButton alloc] initWithFrame:tmpRect];
    [mapBtn addSubview:mapIcon];
    [mapBtn setEnabled:YES];
    mapBtn.backgroundColor = [UIColor whiteColor];
    [mapBtn addTarget:self action:@selector(mapPressed:) forControlEvents:UIControlEventTouchUpInside];
    mapBtn.tag = tag;
    [view addSubview:mapBtn];
}
#endif



@end
