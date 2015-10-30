//
//  GivebackViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-10-14.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "GivebackViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "PublicFunction.h"

#define LABEL_START_X           10
#define VIEW_START_Y            controllerViewStartY
#define HEIGHT_ROW_LABEL        30
#define HEIGHT_CONGRATULATIN    60
#define HEIGHT_PROMPT           60

#define LONG_LABEL_W            300
#define MIDLLE_LABEL_W          180
#define SHORT_LABEL_W           120
#define RIGHT_START_X           10 + SHORT_LABEL_W

#define IMG_MODIFY                      @"modify.png"
#define IMG_UNSUBSCRIBE                 @"unsubscribe.png"

@interface GivebackViewController ()
{
    NSDictionary *m_dicData;
    NSMutableDictionary *m_testDic;
}

@end

@implementation GivebackViewController

-(void) initTestDic
{
    m_testDic = [[NSMutableDictionary alloc] init];
    NSNumber *deposit = [[NSNumber alloc] initWithInteger:8];
    NSNumber *truePrice = [[NSNumber alloc] initWithInteger:23];
    NSString *timeLong = @"1.0";
    NSNumber *cost = [[NSNumber alloc] initWithInteger:23];
    NSNumber *milCost = [[NSNumber alloc] initWithInteger:0];
    NSNumber *lateLong = [[NSNumber alloc] initWithInteger:1];
    NSNumber *dispatchCost = [[NSNumber alloc] initWithInteger:0];
    NSNumber *token = [[NSNumber alloc] initWithInteger:0];
    NSNumber *timeCost = [[NSNumber alloc] initWithInteger:8];
    NSNumber *mil = [[NSNumber alloc] initWithInteger:0];
    NSNumber *lastCost = [[NSNumber alloc] initWithInteger:15];
    
    [m_testDic setObject:deposit forKey:@"deposit"];
    [m_testDic setObject:truePrice forKey:@"truePrice"];
    [m_testDic setObject:timeLong forKey:@"timeLong"];
    [m_testDic setObject:cost forKey:@"cost"];
    [m_testDic setObject:milCost forKey:@"milCost"];
    [m_testDic setObject:lateLong forKey:@"lateLong"];
    [m_testDic setObject:dispatchCost forKey:@"dispatchCost"];
    [m_testDic setObject:token forKey:@"token"];
    [m_testDic setObject:timeCost forKey:@"timeCost"];
    [m_testDic setObject:mil forKey:@"mil"];
    [m_testDic setObject:lastCost forKey:@"lateCost"];
}


-(id)initWithSuccessData:(NSDictionary *)dicData
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
#if 0
        if (dicData == nil)
        {
            [self initTestDic];
            m_dicData = [[NSDictionary alloc] initWithDictionary:m_testDic];
        }
        else
#endif
        {
            m_dicData = [[NSDictionary alloc] initWithDictionary:dicData];
        }
        // Custom initialization
    }
    return self;
}

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
    
    [self initGivebackView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_GIVEBACK_SUCCESS];
    }
}


-(NSString *)getCostWithFormat:(NSNumber *)price
{
//    NSString *cost = GET(price);
#if  0
    if ([cost length] == 0) {
        return [NSString stringWithFormat:STR_COST_FORMAT, @"0"];
    }
#endif
    return [NSString stringWithFormat:STR_COST_FORMAT, price];
}


-(NSString *)getCostWithNSString:(NSString *)price
{
    NSString *cost = GET(price);

    if ([cost length] == 0) {
        return [NSString stringWithFormat:STR_COST_FORMAT, @"0"];
    }

    return [NSString stringWithFormat:STR_COST_FORMAT, cost];
}



-(void)initGivebackView
{
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    CGRect rect = CGRectMake(LABEL_START_X, VIEW_START_Y, LONG_LABEL_W, HEIGHT_CONGRATULATIN);
    UILabel *congratilation = [[UILabel alloc] initWithFrame:rect];
    congratilation.text = STR_CONGRATULATION;
    congratilation.textColor = COLOR_LABEL_GRAY;
    congratilation.backgroundColor = [UIColor clearColor];
    congratilation.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:congratilation];
    
    rect.origin.y += HEIGHT_CONGRATULATIN;
    rect.size.height = HEIGHT_ROW_LABEL;
    UILabel *totalDeposit = [[UILabel alloc] initWithFrame:rect];
    totalDeposit.text = STR_TOTAL_PREPAY;
    totalDeposit.textColor = COLOR_LABEL_GRAY;
    totalDeposit.backgroundColor = [UIColor whiteColor];
//    [[PublicFunction ShareInstance] addSubLabelToLabel:totalDeposit withString:@"5,000元" withColor:COLOR_LABEL_BLUE];
    [self.view addSubview:totalDeposit];
    
    //deposit  总预付
    CGRect tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:totalDeposit];
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.text = [self getCostWithFormat:GET([m_dicData objectForKey:@"deposit"])];
    tmpLabel.textColor = COLOR_LABEL_BLUE;
    [self.view addSubview:tmpLabel];
    
    //cost	   总消费（时长+里程+调度+延时）
    rect.origin.y += HEIGHT_ROW_LABEL + 10;
    UILabel *totalCosts = [[UILabel alloc] initWithFrame:rect];
    totalCosts.text = STR_TOTAL_COSTS;
    totalCosts.textColor = COLOR_LABEL_GRAY;
    totalCosts.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:totalCosts];
    tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:totalCosts];
    tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.textColor = COLOR_LABEL_BLUE;
    tmpLabel.text= [self getCostWithFormat:GET([m_dicData objectForKey:@"cost"])];
    [self.view addSubview:tmpLabel];
    
    UIView *separatorView = [[PublicFunction ShareInstance] getSeparatorView:CGRectMake(totalCosts.frame.origin.x, totalCosts.frame.origin.y + totalCosts.frame.size.height - 1, totalCosts.frame.size.width, 1)];
    [self.view addSubview:separatorView];
    
    //timeCost	时长消费
    rect.origin.y += HEIGHT_ROW_LABEL;
    UILabel *timePrice = [[UILabel alloc] initWithFrame:rect];
    timePrice.text = STR_DURATION_CONSUMPTION;
    timePrice.textColor = COLOR_LABEL;
    timePrice.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:timePrice];
//    [[PublicFunction ShareInstance] addSubLabelToLabel:timePrice withString:@"" withColor:COLOR_LABEL];
    tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:timePrice];
    tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.textColor = COLOR_LABEL;
    tmpLabel.text = [self getCostWithFormat: GET([m_dicData objectForKey:@"timeCost"])];
    tmpLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpLabel];
    
    //timeLong	时长，单位小时
    CGRect rightRect = rect;
    rightRect.origin.x = RIGHT_START_X;
    rightRect.size.width = MIDLLE_LABEL_W;
    UILabel *drovetime = [[UILabel alloc] initWithFrame:rightRect];
    NSString *hour = [NSString stringWithFormat:STR_DROVE_HH, [m_dicData objectForKey:@"timeLong"]];
    drovetime.text = [NSString stringWithFormat:@"%@: %@", STR_DROVE_TIME, hour];
    drovetime.textColor = COLOR_LABEL;
    drovetime.textAlignment = NSTextAlignmentRight;
    drovetime.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drovetime];
    
    
    //milCost	里程消费
    //mil	里程
    rect.origin.y += HEIGHT_ROW_LABEL;
    UILabel *kiloPrice = [[UILabel alloc] initWithFrame:rect];
    kiloPrice.text = STR_MILEAGE_CONSUMPTION;
    kiloPrice.textColor = COLOR_LABEL;
    kiloPrice.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:kiloPrice];
    tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:kiloPrice];
    tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.textColor = COLOR_LABEL;
    tmpLabel.text = [self getCostWithFormat:GET([m_dicData objectForKey:@"milCost"])];
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    tmpLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpLabel];
    
    NSString *kilo = [NSString stringWithFormat:STR_KILO_FORMAT, GET([m_dicData objectForKey:@"mil"])];;
    rightRect.origin.y += HEIGHT_ROW_LABEL;
    UILabel *droveKilo = [[UILabel alloc] initWithFrame:rightRect];
    droveKilo.text = [NSString stringWithFormat:@"%@: %@", STR_DROVE_KILO, kilo];
    droveKilo.textColor = COLOR_LABEL;
    droveKilo.textAlignment = NSTextAlignmentRight;
    droveKilo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:droveKilo];
    
    
    //lateCost	延时费
    //lateLong 延时时长
    NSNumber *lateCost = GET([m_dicData objectForKey:@"lateCost"]);
    if ((/*[lateCost length] != 0 &&*/ [lateCost integerValue] != 0))
    {
        
        rect.origin.y += HEIGHT_ROW_LABEL;
        UILabel *delayPrice = [[UILabel alloc] initWithFrame:rect];
        delayPrice.text = STR_DELAY_CONSUMPTION;
        delayPrice.textColor = COLOR_LABEL;
        delayPrice.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:delayPrice];
        tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:delayPrice];
        tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
        tmpLabel.textColor = COLOR_LABEL;
        tmpLabel.text = [self getCostWithFormat:lateCost];
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tmpLabel];
        
        rightRect.origin.y += HEIGHT_ROW_LABEL;
        UILabel *delay = [[UILabel alloc] initWithFrame:rightRect];
        hour = [NSString stringWithFormat:STR_DROVE_HH, [m_dicData objectForKey:@"lateLong"]];
        delay.text = [NSString stringWithFormat:@"%@  %@", STR_DELAY_TIME, hour];
        delay.textColor = COLOR_LABEL;
        delay.backgroundColor = [UIColor whiteColor];
        delay.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:delay];

    }
    
    //dispatchCost	调度费
    NSNumber *dispatchCost = GET([m_dicData objectForKey:@"dispatchCost"]);
    if (/*[dispatchCost length] != 0 && */[dispatchCost integerValue] != 0)
    {
        rect.origin.y += HEIGHT_ROW_LABEL;
        UILabel *dispatch = [[UILabel alloc] initWithFrame:rect];
        NSString *cost = [self getCostWithFormat:dispatchCost];
        dispatch.text = [NSString stringWithFormat:@"%@: %@",STR_SCHEDULING_CONSUMPTION, cost];
        dispatch.textColor = COLOR_LABEL;
        dispatch.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:dispatch];
    }
    
    UIView *separatorView1 = [[PublicFunction ShareInstance] getSeparatorView:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - 1, rect.size.width, 1)];
    [self.view addSubview:separatorView1];
    
    //token 抵用
    NSNumber *token = GET([m_dicData objectForKey:@"token"]);
    if (/*[token length] != 0 &&*/ [token integerValue] != 0)
    {
        rect.origin.y += HEIGHT_ROW_LABEL;
        UILabel *coupon = [[UILabel alloc] initWithFrame:rect];
        NSString *tokenCost = [self getCostWithFormat:token];
//        coupon.text = [NSString stringWithFormat:@"%@: %@", STR_COUPON_DEDUCTION, tokenCost];
        coupon.text = [NSString stringWithFormat:@"%@:", STR_COUPON_DEDUCTION];
        coupon.textColor = COLOR_LABEL_GRAY;
        coupon.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:coupon];
        
        tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:coupon];
        tmpRec.origin.x += 20;
        tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
        tmpLabel.textColor = COLOR_LABEL;
        tmpLabel.text = tokenCost;
        tmpLabel.textAlignment = NSTextAlignmentLeft;
        tmpLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tmpLabel];

    }
    
    // truePrice 实际扣费
    rect.origin.y += HEIGHT_ROW_LABEL;
    UILabel *total = [[UILabel alloc] initWithFrame:rect];
    total.text = [NSString stringWithFormat:@"%@:", STR_LAST_PAYED];
    total.textColor = COLOR_LABEL_GRAY;
    total.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:total];
    tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:total];
    tmpRec.origin.x += 20;
    tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.textColor = COLOR_LABEL;
    tmpLabel.text = [self getCostWithFormat:GET([m_dicData objectForKey:@"truePrice"])];
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    tmpLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpLabel];
    
    UIView *separatorView2 = [[PublicFunction ShareInstance] getSeparatorView:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - 1, rect.size.width, 1)];
    [self.view addSubview:separatorView2];
    
    // 预付款余额
    rect.origin.y += HEIGHT_ROW_LABEL;
    UILabel *balance = [[UILabel alloc] initWithFrame:rect];
    balance.text = [NSString stringWithFormat:@"%@:", STR_BALANCE_FORPREPAY];
    balance.textColor = COLOR_LABEL_GRAY;
    balance.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:balance];
    
    NSString *tmpTotal = [m_dicData objectForKey:@"deposit"];
    NSString *tmpTruecost = [m_dicData objectForKey:@"truePrice"];
    CGFloat nbalance = ([tmpTotal floatValue] - [tmpTruecost floatValue]);
    NSString *strBalance = [NSString stringWithFormat:@"%.2f", nbalance];
    tmpRec = [[PublicFunction ShareInstance] getSubLabelRect:balance];
    tmpRec.origin.x += 20;
    tmpLabel = [[UILabel alloc] initWithFrame:tmpRec];
    tmpLabel.textColor = COLOR_LABEL;
    if (nbalance < 0) {
        tmpLabel.textColor = [UIColor redColor];
        strBalance = @"0";
    }
    tmpLabel.text = [self getCostWithNSString:GET(strBalance)];
    tmpLabel.textAlignment = NSTextAlignmentLeft;
    tmpLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tmpLabel];
    
    rect.origin.y += HEIGHT_ROW_LABEL;
    rect.size.height = HEIGHT_PROMPT;
    UILabel *prompt = [[UILabel alloc] initWithFrame:rect];
    prompt.text = STR_SEVENTDAY_PROMPT;
    prompt.numberOfLines = 2;
    prompt.textColor = COLOR_LABEL;
    [self.view addSubview:prompt];
#if 0
    rect = drovetime.frame;
    rect.origin.x = LABEL_START_X + MIDLLE_LABEL_W;
    rect.size.width = SHORT_LABEL_W;
    UILabel *timePriceFormat = [[UILabel alloc] initWithFrame:rect];
    timePriceFormat.textColor = [UIColor redColor];
    timePriceFormat.text = STR_TIME_PRICE_FORMAT;
    [self.view addSubview:timePriceFormat];
    
    rect = droveKilo.frame;
    rect.origin.x = LABEL_START_X + MIDLLE_LABEL_W;
    rect.size.width= SHORT_LABEL_W;
    UILabel *kiloFormat = [[UILabel alloc] initWithFrame:rect];
    kiloFormat.text = STR_KILO_PRICE_FROMAT;
    kiloFormat.textColor = [UIColor redColor];
    [self.view addSubview:kiloFormat];
#endif

    if (nbalance < 0) {
        rect = balance.frame;
        rect.origin.x = LABEL_START_X + MIDLLE_LABEL_W;
        rect.size.width = SHORT_LABEL_W;
        UILabel *needRecharge = [[UILabel alloc] initWithFrame:rect];
        needRecharge.textColor = [UIColor redColor];
        NSString *needStr = [NSString stringWithFormat:@"%.2f", -nbalance];
        needRecharge.text = [NSString stringWithFormat:@"%@  %@", STR_NEED_RECHARGE, [self getCostWithNSString:needStr]];
        needRecharge.numberOfLines = 0;
        [needRecharge sizeToFit];
        [self.view addSubview:needRecharge];
    }
    // 再订一次
    UIButton *rentalAgain = [[UIButton alloc] init];
    rentalAgain.frame = CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth/2, bottomButtonHeight);
    [rentalAgain setTitle:STR_RENTAL_AGAIN forState:UIControlStateNormal];
//    rentalAgain.backgroundColor = [UIColor redColor];
    [rentalAgain setBackgroundImage:[UIImage imageNamed:IMG_MODIFY] forState:UIControlStateNormal];
    [rentalAgain addTarget:self action:@selector(rentalAgainBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rentalAgain];
    // 首页
    UIButton *toHome = [[UIButton alloc] init];
    toHome.frame = CGRectMake(MainScreenWidth/2, MainScreenHeight - bottomButtonHeight, MainScreenWidth/2, bottomButtonHeight);
    toHome.backgroundColor = [UIColor grayColor];
    [toHome setBackgroundImage:[UIImage imageNamed:IMG_UNSUBSCRIBE] forState:UIControlStateNormal];
    [toHome setTitle:STR_TO_HOME forState:UIControlStateNormal];
    [toHome addTarget:self action:@selector(toHomeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toHome];
}

// 再订一次
-(void)rentalAgainBtn
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_personal];
}

// 跳转到首页
-(void)toHomeBtn
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:menu_home];
}

@end
