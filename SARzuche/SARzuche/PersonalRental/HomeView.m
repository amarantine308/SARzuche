//
//  HomeView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HomeView.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "UserCenterViewController.h"
#import "CustomDrawView.h"
#import "UIImageView+WebCache.h"
#import "PublicFunction.h"
#import "ConstImage.h"
#import "UIImageView+URL.h"

#define USE_PAGESCROLL_VIEW

// frame

//#define CONTORLLER_VIEW_H       (MainScreenHeight - kViewCaculateBarHeight)
#define CONTORLLER_VIEW_H       (MainScreenHeight)
#define AD_HEIGHT                   (140)
#define CALL_HEIGHT               bottomButtonHeight
#define CALL_ICON_W                40
#define CALL_ICON_H                 40


#define SUB_VIEW_WIDTH         (MainScreenWidth / 3)
#define SUB_VIEW_HEIGHT       SUB_VIEW_H//
#define ROW_GAP                     ((CONTORLLER_VIEW_H - AD_HEIGHT - controllerViewStartY - CALL_HEIGHT) - SUB_VIEW_HEIGHT*2)/3
// ROW 1
#define FRAME_AD_VIEW               CGRectMake(0, 0, MainScreenWidth, AD_HEIGHT)
#define FRAME_PERSON_RENTAL_VIEW    CGRectMake(0, AD_HEIGHT + ROW_GAP, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)
#define FRAME_COMPANY_RENTAL_VIEW   CGRectMake(SUB_VIEW_WIDTH + 1, AD_HEIGHT + ROW_GAP, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)
#define FRAME_PREFERENTIAL           CGRectMake(SUB_VIEW_WIDTH * 2, AD_HEIGHT + ROW_GAP, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)
// ROW 2
#define FRAME_BRANCHES_VIEW         CGRectMake(0, AD_HEIGHT + SUB_VIEW_HEIGHT + ROW_GAP *2, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)
#define FRAME_MY_INFO_VIEW          CGRectMake(SUB_VIEW_WIDTH + 1, AD_HEIGHT + SUB_VIEW_HEIGHT + ROW_GAP*2, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)
#define FRAME_MY_CAR                CGRectMake(SUB_VIEW_WIDTH * 2, AD_HEIGHT + SUB_VIEW_HEIGHT + ROW_GAP*2, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)

// BTN
#define FRAME_CALL_ICON             CGRectMake(85, 10, 20, 20)
#define FRAME_CALL_LABEL            CGRectMake(115, 0, 160, 40)
#define FRAME_CALL_BTN              CGRectMake(0, CONTORLLER_VIEW_H - CALL_HEIGHT -controllerViewStartY , MainScreenWidth, CALL_HEIGHT)

// image
#define IMG_CALLNUM_BACKGROUND        @"icon_phone_background.png"
#define IMG_COUPON                      @"icon_coupon.png"
#define IMG_COUPON_BACK                 @"icon_coupon_background.png"
#define IMG_MYINFO                      @"icon_userCenter.png"
#define IMG_MYINFO_BACK                 @"icon_userCenter_bacground.png"
#define IMG_MYCAR                       @"icon_myCar.png"
#define IMG_MYCAR_BACK                  @"icon_myCar_background.png"
#define IMG_SURROUNDING                 @"icon_surrounding.png"
#define IMG_SURROUNDING_BACE            @"icon_surrounding_background.png"
#define IMG_PERSONAL                    @"icon_personRental.png"
#define IMG_PERSONAL_BACK               @"icon_personRental_background.png"
#define IMG_COMPANY                     @"icon_enterprise.png"
#define IMG_COMPANY_BACK                @"icon_enterprise_background.png"


//#ifdef DEBUG
#define IMAGE_GUIDE1    @"banner.png"
//#endif

@interface HomeView()
{
#ifdef USE_PAGESCROLL_VIEW
    PageScrollerView *_adView;
#else
    EScrollerView *_adView;
#endif
    NSMutableArray *_adImagesArray;
    NSArray *m_srvImgArr;
    
    HomeSubView *_personal;
    HomeSubView *_company;
    HomeSubView *_branches;
    HomeSubView *_myInfo;
    
    HomeSubView *_myCar;
    HomeSubView *_preferential;
    
    UIButton *m_call;
}

@end

@implementation HomeView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHomeView];
    }
    return self;
}


-(void)initTestView
{
    CustomDrawView *tmpVew = [[CustomDrawView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight) withStyle:customText];
    [tmpVew setText:@"12345667"];
    tmpVew.backgroundColor = [UIColor redColor];
    [self addSubview:tmpVew];
}

-(void)initHomeData
{
    if (nil == _adImagesArray) {
//        _adImagesArray = [[NSMutableArray alloc] init];
//        _adImagesArray
    }
}

-(void)initHomeView
{
    // ad view
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE1]];
    NSArray *imagesArray = [[NSArray alloc] initWithObjects:image1, nil];
    _adImagesArray = [[NSMutableArray alloc] initWithArray:imagesArray];

    _adView = [[PageScrollerView alloc] initWithFrame:FRAME_AD_VIEW withImages:_adImagesArray];
    _adView.delegate = self;
    [_adView autoScrollEnalbed:YES];
    [self addSubview:_adView];
    
    // personal rent
    _personal = [[HomeSubView alloc] initWithFrame:FRAME_PERSON_RENTAL_VIEW title:STR_PERSONAL_RENTAL image:IMG_PERSONAL withBgdImg:IMG_PERSONAL_BACK];
    [_personal addTarget:self action:@selector(enterPersonalRental) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_personal];
    
    // company rent
    _company = [[HomeSubView alloc] initWithFrame:FRAME_COMPANY_RENTAL_VIEW title:STR_COMPANY_RENTAL image:IMG_COMPANY withBgdImg: IMG_COMPANY_BACK];
    [_company addTarget:self action:@selector(enterCompanyRental) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_company];
    
    // branches
    _branches = [[HomeSubView alloc] initWithFrame:FRAME_BRANCHES_VIEW title:STR_BRANCHES image:IMG_SURROUNDING withBgdImg:IMG_SURROUNDING_BACE];
    [_branches addTarget:self action:@selector(enterBranches) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_branches];
    
    // my info
    _myInfo = [[HomeSubView alloc] initWithFrame:FRAME_MY_INFO_VIEW title:STR_MY_INFO image:IMG_MYINFO withBgdImg:IMG_MYINFO_BACK];
    [_myInfo addTarget:self action:@selector(enterMyInfo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_myInfo];
    
    // my car
    _myCar = [[HomeSubView alloc] initWithFrame:FRAME_MY_CAR title:STR_MY_CAR image:IMG_MYCAR withBgdImg:IMG_MYCAR_BACK];
    [_myCar addTarget:self action:@selector(enterMyCar) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_myCar];
    // 优惠券
    _preferential = [[HomeSubView alloc] initWithFrame:FRAME_PREFERENTIAL title:STR_PREFERENTIAL image:IMG_COUPON withBgdImg:IMG_COUPON_BACK];
    [_preferential addTarget:self action:@selector(enterPreferential) forControlEvents:UIControlEventTouchUpInside];
    [_preferential setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:_preferential];
    // 客服电话
    m_call = [[UIButton alloc] initWithFrame:FRAME_CALL_BTN];
    [m_call setBackgroundImage:[UIImage imageNamed:IMG_CALLNUM_BACKGROUND] forState:UIControlStateNormal];
    [m_call addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];

    UIImage *phoneImg = [UIImage imageNamed:IMG_PHONE];
    UIImageView *phoneImgView = [[UIImageView alloc] initWithFrame:FRAME_CALL_ICON];
    phoneImgView.image = phoneImg;
    
    UILabel *phoneNum = [[UILabel alloc] initWithFrame:FRAME_CALL_LABEL];
    phoneNum.text = STR_SERVICE_TEL;
    phoneNum.textColor = [UIColor whiteColor];
    phoneNum.font = FONT_PHONE;
    phoneNum.backgroundColor = [UIColor clearColor];
    [m_call addSubview:phoneNum];
    [m_call addSubview:phoneImgView];
    [self addSubview:m_call];
}


-(void)updateAdData:(NSArray *)srvImgArr
{
//    _adImagesArray
}

-(void)makeCall
{
    NSLog(@"make call");
    [[PublicFunction ShareInstance] makeCall];
}

// 设置广告图片
-(void)setImageArr:(NSArray *)imgArr
{
    if (nil == imgArr) {
        return;
    }
    
    m_srvImgArr = [[NSArray alloc] initWithArray:imgArr];
    
    [self updateImage];
}

// 更新广告图片
-(void)updateImage
{
    [_adImagesArray removeAllObjects];
#if 0
    NSInteger nCount = [m_srvImgArr count];
    
    for (NSInteger i = 0; i < nCount; i++) {
        NSDictionary *dic = [m_srvImgArr objectAtIndex:i];
        
        NSLog(@"%@", [self imageUrl:dic]);
    }
#else
    NSInteger pageCount = [m_srvImgArr count];
    if (pageCount < [_adView getImages])
    {
        [_adView deleteImages];
    }
    
    for (int i=0; i<pageCount; i++)
    {
        NSDictionary *dic = [m_srvImgArr objectAtIndex:i];
//        NSString *imgURL= [NSString stringWithFormat:@"%@%@", kImageBaseUrl, [self imageUrl:dic]];
        NSString *imgURL= [NSString stringWithFormat:@"%@", [self imageUrl:dic]];
        NSLog(@"\n\n%@\n\n", imgURL);
#if 0
        UIImageView *imgView=[[UIImageView alloc] init];
        if ([imgURL hasPrefix:@"http://"] || [imgURL hasPrefix:@"https://"])
        {
#if 1
            imgView.image = [UIImage imageNamed:kPlaceHolderImageName];
            __weak UIImageView *wself = imgView;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *tmpData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
                UIImage *tmpImage = [UIImage imageWithData:tmpData];
                if (tmpImage)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        wself.image = tmpImage;
                    });
                }
            });
#else
            [imgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:kPlaceHolderImageName] options:SDWebImageRetryFailed];
#endif
        }
        else
        {
//            UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
//            [imgView setImage:img];
        }
#else
        CustomImageView *imgView = [[CustomImageView alloc] initWithImage:kPlaceHolderImageName withUrl:imgURL];
#endif
//        [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width, viewSize.size.height)];
        imgView.tag=i;
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        imgView.contentMode = UIViewContentModeScaleToFill;
        
        [_adView ReplaceImage:imgView atIndex:i];
        [_adImagesArray addObject:imgView];
    }

#endif
}

-(void)imagePressed:(UITapGestureRecognizer *)sender
{
    NSLog(@"Home view image pressed");
}


/*
 adLists =     (
 {
 contenturl = "";
 id = 6d812333ae3845d2b1a73bd51750b83f;
 picurl = "/upload/T1.3-targetCell.jpg";
 }
 );
 */
-(NSString *)imageUrl:(NSDictionary *)imgDic
{
    if (imgDic) {
        return [imgDic objectForKey:@"picurl"];
    }
    
    return nil;
}


-(NSString *)imgContentUrl:(NSDictionary *)imgDic
{
    if (imgDic) {
        return [imgDic objectForKey:@"contenturl"];
    }
    
    return nil;
}

// 进入我的车辆
-(void)enterMyCar
{
    if (delegate && [delegate respondsToSelector:@selector(enterMyCar)]) {
        [delegate enterMyCar];
    }
}

// 进入分时租车
-(void)enterPersonalRental
{
    if (delegate && [delegate respondsToSelector:@selector(enterPersonalRental)]) {
        [delegate enterPersonalRental];
    }
}

// 进入企业租车
-(void)enterCompanyRental
{
    if (delegate && [delegate respondsToSelector:@selector(enterCompanyRental)]) {
        [delegate enterCompanyRental];
    }
}

// 进入周边网点
-(void)enterBranches
{
    if (delegate && [delegate respondsToSelector:@selector(enterBranches)]) {
        [delegate enterBranches];
    }
}

// 进入个人中心
-(void)enterMyInfo
{
    if (delegate && [delegate respondsToSelector:@selector(enterMyInfo)]) {
        [delegate enterMyInfo];
    }
}

// 进入兑换优惠券
-(void)enterPreferential
{
    if (delegate && [delegate respondsToSelector:@selector(enterPreferential)]) {
        [delegate enterPreferential];
    }
}

// 进入广告内容
-(void)enterContentWithUrl:(NSInteger)index
{
    if (delegate && [delegate respondsToSelector:@selector(enterAd:)])
    {
//        NSString *contentURL= [NSString stringWithFormat:@"%@%@", kImageBaseUrl, [self imgContentUrl:[m_srvImgArr objectAtIndex:index]]];
        if (index < [m_srvImgArr count]) {
            NSString *contentURL= [NSString stringWithFormat:@"%@", [self imgContentUrl:[m_srvImgArr objectAtIndex:index]]];
            [delegate enterAd:contentURL];            
        }
    }
}

#pragma mark - HomeSubView delegate
// 模块跳转
-(void)entryModel:(NSInteger)tag
{
    switch (tag) {
        case TAG_PERSONAL_RENTAL:
            [self enterPersonalRental];
            break;
        case TAG_COMPANY_RENTAL:
            [self enterCompanyRental];
            break;
        case TAG_BRANCHES:
            [self enterBranches];
            break;
        case TAG_MYINFO:
            [self enterMyInfo];
            break;
        default:
            break;
    }
}

@end
