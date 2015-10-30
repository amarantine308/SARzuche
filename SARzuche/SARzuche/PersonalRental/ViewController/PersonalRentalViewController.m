//
//  PersonalRentalViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PersonalRentalViewController.h"
#import "ConstString.h"
#import "constDefine.h"
#import "SelectCarViewController.h"
#import "PublicFunction.h"
#import "OrderManager.h"
#import "NextHelpViewController.h"
#import "ConstImage.h"
#import "BranchesMapViewController.h"
#import "BranchDataManager.h"

#define TAG_START_TIME      11001
#define TAG_GIVEBACK_TIME   11002

#define FRAME_START_X       10
#define TIME_WIDTH          (200)
#define INFO_WIDTH          (280)
#define ROW_H               30
#define ROW_GAP             5

#define TAKE_START_Y        (5 + controllerViewStartY)
#define BACK_START_Y        (TAKE_START_Y + (ROW_H + ROW_GAP)*3 + ROW_GAP)
#define PROMPT_START_Y      (BACK_START_Y + (ROW_H + ROW_GAP)*2 + ROW_GAP)

#define FRAME_CALL_BUTTON   FRAME_RIGHT_BUTTON1
#define FRAME_HELP_BUTTON   FRAME_RIGHT_BUTTON2
// TAKE
#define FRAME_TAKE_LABEL    CGRectMake(FRAME_START_X, TAKE_START_Y, 180, ROW_H)
#define FRAME_CITY          CGRectMake(FRAME_START_X, TAKE_START_Y + ROW_H + 5, 80, ROW_H)
#define FRAME_NETWORK       CGRectMake(80 + FRAME_START_X+10, TAKE_START_Y + ROW_H + 5, 210, ROW_H)
#define FRAME_STRAT_TIME    CGRectMake(FRAME_START_X, TAKE_START_Y + ROW_H*2 + 5*2, TIME_WIDTH, ROW_H)
// BACK
#define FRAME_RETURN_LABEL  CGRectMake(FRAME_START_X, BACK_START_Y, 180, ROW_H)
#define FRAME_GIVEBAKC_TIME       CGRectMake(FRAME_START_X, BACK_START_Y + ROW_H + ROW_GAP, TIME_WIDTH, ROW_H)
// PROMPT
#define FRAME_INFO1         CGRectMake(FRAME_START_X, PROMPT_START_Y, INFO_WIDTH, 20)
#define FRAME_INFO2         CGRectMake(FRAME_START_X, PROMPT_START_Y + 30, INFO_WIDTH, 20)
// BUTTON
#define BTN_W           (MainScreenWidth - FRAME_START_X * 2)
#define FRAME_SELECT_CAR    CGRectMake(FRAME_START_X, MainScreenHeight - bottomButtonHeight - controllerViewStartY, BTN_W, bottomButtonHeight)


// IMG
#define IMG_AREA            @"block.png"
#define IMG_BTN_BG          @"bottom_long_btn.png"

// font size
#define SIZE_PROMPT         14
#define SIZE_ROW            20


@interface PersonalRentalViewController ()
{
    UIButton *_city; // popupbutton!
    UIButton *_network;
    UIButton *_startTime;
    UIButton *_giveBackTime;
    
    UIImage *_warningIcon;
    UILabel *_promptInfo1;
    UILabel *_promptInfo2;
    
    UIButton *_toSelectCar;
    BOOL m_isStartTimeSelected;
    
    NSString *m_takeBranche;
    NSString *m_takeBrancheId;
    NSString *m_startTime;
    NSString *m_endTime;
    NSDate *m_curDate;
}

@end

@implementation PersonalRentalViewController

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
    
    [self initPesronalRentalView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_curDate = [NSDate date];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *方法描述：添加导航栏
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initNavBar
{
    if(customNavBarView)
    {
        [customNavBarView setTitle:STR_PERSONAL_RENTAL];
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_CALL_BUTTON];
        callBtn.backgroundColor = [UIColor clearColor];
        UIImage *callImg = [UIImage imageNamed:IMG_PHONE];
        [callBtn setImage:callImg forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:callBtn];
        
        UIButton *helpBtn = [[UIButton alloc] initWithFrame:FRAME_HELP_BUTTON];
        UIImage *helpImg = [UIImage imageNamed:IMG_HELP];
        [helpBtn setImage:helpImg forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(helpBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [customNavBarView addSubview:helpBtn];
    }
}
/**
 *方法描述：客服电话
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
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
    NSString *type = [NSString stringWithFormat:@"help%d",3];
    next.title = STR_INSTRUCTIONS;
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}

-(void)backButtonPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *方法描述：初始化分时租车条件选择界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initPesronalRentalView
{
    UILabel *labelTake = [[UILabel alloc] initWithFrame:FRAME_TAKE_LABEL];
    labelTake.textColor = [UIColor blackColor];
    labelTake.text = STR_TAKE_INFO;
    labelTake.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelTake];
    
    _city = [[UIButton alloc] initWithFrame:FRAME_CITY];
    _city.enabled = NO;
    _city.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_city setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_city setTitle:STR_NANJING forState:UIControlStateDisabled];
    [_city setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateDisabled];
    UIImage *tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    UIImageView *selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(_city.frame.size.width - tmpImg.size.width -5, (_city.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [_city addSubview:selView];
    [self.view addSubview:_city];
    
    _network = [[UIButton alloc] initWithFrame:FRAME_NETWORK];
    [_network setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [_network setTitle:STR_NETWORK forState:UIControlStateNormal];
    if (m_takeBranche) {
        [_network setTitle:m_takeBranche forState:UIControlStateNormal];
    }
    [_network setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [_network setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    [_network setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_network addTarget:self action:@selector(selectNetwork) forControlEvents:UIControlEventTouchUpInside];
    _network.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:_network];

    _startTime = [[UIButton alloc] initWithFrame:FRAME_STRAT_TIME];
    _startTime.tag = TAG_START_TIME;
    [_startTime setTitle:STR_TAKE_CAR_TIME forState:UIControlStateNormal];
    [_startTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [_startTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    [_startTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_startTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    _startTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(_startTime.frame.size.width - tmpImg.size.width -5, (_startTime.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [_startTime addSubview:selView];
    [self.view addSubview:_startTime];
    
    UILabel *labelReturn = [[UILabel alloc] initWithFrame:FRAME_RETURN_LABEL];
    labelReturn.textColor = [UIColor blackColor];
    labelReturn.text = STR_GIVEBACK_INFO;
    labelReturn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labelReturn];

    _giveBackTime = [[UIButton alloc] initWithFrame:FRAME_GIVEBAKC_TIME];
    _giveBackTime.tag = TAG_GIVEBACK_TIME;
    [_giveBackTime setTitle:STR_GIVE_BACK_TIME forState:UIControlStateNormal];
    [_giveBackTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [_giveBackTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateHighlighted];
    [_giveBackTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_giveBackTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    _giveBackTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(_giveBackTime.frame.size.width - tmpImg.size.width -5, (_giveBackTime.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [_giveBackTime addSubview:selView];
    [self.view addSubview:_giveBackTime];
    
    _promptInfo1 = [[UILabel alloc] initWithFrame:FRAME_INFO1];
    _promptInfo1.text = STR_PERSONAL_INFO1;
    _promptInfo1.font = [UIFont systemFontOfSize:SIZE_PROMPT];
    _promptInfo1.textColor = [UIColor orangeColor];
    _promptInfo1.backgroundColor = [UIColor clearColor];
    _promptInfo2 = [[UILabel alloc] initWithFrame:FRAME_INFO2];
    _promptInfo2.text = STR_PERSONAL_INFO2;
    _promptInfo2.font = [UIFont systemFontOfSize:SIZE_PROMPT];
    _promptInfo2.textColor = [UIColor orangeColor];
    _promptInfo2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_promptInfo1];
    [self.view addSubview:_promptInfo2];
    
    _toSelectCar = [[UIButton alloc] initWithFrame:FRAME_SELECT_CAR];
    [_toSelectCar setBackgroundImage:[UIImage imageNamed:IMG_BTN_BG] forState:UIControlStateNormal];
    [_toSelectCar setTitle:STR_TO_SELECT_CAR forState:UIControlStateNormal];
    [_toSelectCar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_toSelectCar addTarget:self action:@selector(selectCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_toSelectCar];
}


-(void)mapPressed
{
    NSLog(@"map pressed");
    
    BranchesMapViewController *vc = [[BranchesMapViewController alloc] init];
    vc.enterType = MapViewFromBranchesView;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *方法描述：调出时间选择界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectTime:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    switch (tmpBtn.tag) {
        case TAG_START_TIME:
        {
            NSLog(@"to set start time");
            NSDate *startDate = [NSDate date];
            DateSelectView *tmpDatePicker = [[DateSelectView alloc] initWithFrame:FRAME_DATE_SELECT_VIEW StartDate:startDate];
            tmpDatePicker.delegate = self;
            m_isStartTimeSelected = YES;
            [self.view addSubview:tmpDatePicker];
        }
            break;
        case TAG_GIVEBACK_TIME:
        {
            NSLog(@"to set give up time");
            NSDate *startDate = [NSDate date];
            DateSelectView *tmpDatePicker = [[DateSelectView alloc] initWithFrame:FRAME_DATE_SELECT_VIEW StartDate:startDate];
            [tmpDatePicker setTitle:STR_GIVE_BACK_TIME];
            tmpDatePicker.delegate = self;
            m_isStartTimeSelected = NO;
            [self.view addSubview:tmpDatePicker];
        }
            break;
        default:
            break;
    }
}

/**
 *方法描述： 检测选择条件
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)checkInput
{
    if (nil == m_takeBranche || [m_takeBranche length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择网点" delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    NSDate *startTime = [[PublicFunction ShareInstance] getDateFrom:[_startTime currentTitle] format:DATE_FORMAT_YMDHM];
    NSDate *endTime = [[PublicFunction ShareInstance] getDateFrom:[_giveBackTime currentTitle] format:DATE_FORMAT_YMDHM];
    NSDate *maxDate = [[PublicFunction ShareInstance] getMaxTimeFromNow];
    NSTimeInterval interval = [maxDate timeIntervalSinceDate:startTime];
    if (TIME_INTERVAL_3DAYS < interval || interval < 0) {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_PERSONAL_INFO2 delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpAlert show];
        return NO;
    }
#if 0
    interval = [m_curDate timeIntervalSinceDate:startTime];
    if (interval > 0) {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_PERSONAL_INFO2 delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpAlert show];
    }
#endif
    interval = [maxDate timeIntervalSinceDate:endTime];
    if (TIME_INTERVAL_3DAYS < interval || interval < 0)
    {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_PERSONAL_INFO2 delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpAlert show];
        return NO;
    }
    
    interval = [endTime timeIntervalSinceDate:startTime];
    if (0 > interval) {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_NEED_SELECTTIME_AGAIN delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpAlert show];
        return NO;
    }
    if (TIME_INTERVAL_1HOUR > interval) {
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_LESS_THAN_1HOUR delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpAlert show];
        return NO;
    }
    
    return YES;
}
/**
 *方法描述：进入车辆选择界面，并保存当前选择条件
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectCar
{
//    if ([[PublicFunction ShareInstance] checkTime:m_startTime givebackTime:m_endTime isTake:NO])
    {
        UserSelectCarCondition *tmpCondition = [[UserSelectCarCondition alloc] init];
        tmpCondition.m_takeCity = STR_NANJING;
        tmpCondition.m_takeBranche = GET(m_takeBranche);//_network.titleLabel.text;
        tmpCondition.m_takeTime = GET(m_startTime);//_startTime.titleLabel.text;
        tmpCondition.m_givebackBranche = GET(m_takeBranche);//_network.titleLabel.text;
        tmpCondition.m_givebackCity = STR_NANJING;
        tmpCondition.m_givebackTime = GET(m_endTime);//_giveBackTime.titleLabel.text;
        tmpCondition.m_givebackBrancheId = GET(m_takeBrancheId);
        tmpCondition.m_takeBrancheId = GET(m_takeBrancheId);
        
        [[OrderManager ShareInstance] setSelectCarCondition:tmpCondition];
        tmpCondition = nil;
        NSLog(@"select car");

        SelectCarViewController *tmpSelectCarController = [[SelectCarViewController alloc] initWithCondition:STR_NANJING Branche:m_takeBranche Take:m_startTime GiveBack:m_endTime];

        NSLog(@"%@, %@, %@, %@", STR_NANJING, GET(m_takeBranche), GET(m_startTime), GET(m_endTime));
        [self.navigationController pushViewController:tmpSelectCarController animated:YES];
    }
}
/**
 *方法描述：选择网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectNetwork
{
    NSLog(@"select Network");

    BranchesViewController *tmpBranchesController = [[BranchesViewController alloc] initWithNibName:nil bundle:nil];
    tmpBranchesController.enterType = BranchesViewFromPersonalRetal;
    tmpBranchesController.delegate = self;
    [self.navigationController pushViewController:tmpBranchesController animated:YES];
    tmpBranchesController = nil;
}

/**
 *方法描述：选择时间返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectString:(NSString *)str
{
    if (nil == str) {
        m_isStartTimeSelected = NO;
        return;
    }
    
    if (m_isStartTimeSelected) {
        if ([[PublicFunction ShareInstance] checkTime:str givebackTime:GET(m_endTime) isTake:YES]) {
            m_startTime = [NSString stringWithFormat:@"%@", str];
            [_startTime setTitle:str forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([[PublicFunction ShareInstance] checkTime:m_startTime givebackTime:str isTake:NO])
        {
            m_endTime = [NSString stringWithFormat:@"%@", str];
            [_giveBackTime setTitle:str forState:UIControlStateNormal];
        }
    }
}

/**
 *方法描述：从地图选择网点进入分时租车
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setSelBranche:(NSDictionary *)branchDic
{
    [[BranchDataManager shareInstance] setSelBranchDic:branchDic isSelTake:YES];
    [[BranchDataManager shareInstance] setSelBranchDic:branchDic isSelTake:NO];
    
    m_takeBranche = [branchDic objectForKey:@"name"];
    m_takeBrancheId = [branchDic objectForKey:@"id"];
    
    [_network setTitle:m_takeBranche forState:UIControlStateNormal];
}

#pragma mark BranchesViewController delegate
/**
 *方法描述：网点选择返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)selBrancheFromController:(NSDictionary *)branchData
{
    NSString *brancheName = [branchData objectForKey:@"name"];
    NSString *brancheId = [branchData objectForKey:@"id"];
    
    [[BranchDataManager shareInstance] setSelBranchDic:branchData isSelTake:YES];
    [[BranchDataManager shareInstance] setSelBranchDic:branchData isSelTake:NO];
    
    m_takeBranche = [NSString stringWithFormat:@"%@",brancheName];
    m_takeBrancheId = [NSString stringWithFormat:@"%@",brancheId];
    
    [_network setTitle:m_takeBranche forState:UIControlStateNormal];
}

@end
