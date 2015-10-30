//
//  PreOderViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PreOderViewController.h"
#import "CustomDrawView.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "DateSelectView.h"
#import "PersonalCarInfoView.h"
#import "CarTimeTableView.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "LoginViewController.h"
#import "ConfirmOrderViewController.h"
#import "OrderManager.h"
#import "LoadingClass.h"
#import "CarDataManager.h"
#import "BranchDataManager.h"
#import "ConstImage.h"
#import "ConstDefine.h"
#import "NextHelpViewController.h"
#import "ConstString.h"
#import "User.h"
#import "CustomAlertView.h"
#import "IdentifyVerificationViewController.h"

#define TAG_ALERTVIEW   999
#define TAG_START_TIME          12001
#define TAG_GIVEBACK_TIME       12002
#define ALERT_VIEW_TAG_PROMPT           12003
#define ALERT_VIEW_TAG_RECHARGE         12004
#define ALERT_VIEW_TAG_CONFIRM          12005
#define TAG_TAKE_BRANCH         12006
#define TAG_GIVEBACK_BRANCH     12007

#define ROW_GAP             10
#define ROW_H               40
#define FRAME_START_X       15
#define CITY_WIDTH          100
#define TIME_WIDTH          (290)
#define BRANCHE_START_X     (FRAME_START_X + CITY_WIDTH)
#define BRANCEH_WIDTH       (TIME_WIDTH - CITY_WIDTH)
#define ICON_WIDTH          (15)
#define INFO_WIDTH          (230)
#define USE_CAR_INFO_HEIGHT (200)
// right button
#define FRAME_CALL_BUTTON   FRAME_RIGHT_BUTTON1
#define FRAME_HELP_BUTTON   FRAME_RIGHT_BUTTON2
// scroll
#define FRAME_SCROLL_VIEW           CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY - bottomButtonHeight)
#define SIZE_SCROLL_VIEW            CGSizeMake(0, 500)
// sub view
#define FRAME_USE_CAR_INFO_VIEW     CGRectMake(0, 30, 320, USE_CAR_INFO_HEIGHT)
#define FRAME_OTHER_INFO_VIEW       CGRectMake(0, FRAME_USE_CAR_INFO_VIEW.size.height + FRAME_USE_CAR_INFO_VIEW.origin.y, 320, SIZE_SCROLL_VIEW.height - USE_CAR_INFO_HEIGHT)

//
#define FRAME_TAKE_INFO             CGRectMake(10, 5, 320, 20)
#define FRAME_EXTEND_BTN            CGRectMake(280, 5, 20, 20)
// 取车
#define FRAME_TAKE_BRANCHE_TITLE    CGRectMake(FRAME_START_X, ROW_GAP, CITY_WIDTH, ROW_H)
#define FRAME_TAKE_BRANCHE          CGRectMake(BRANCHE_START_X, ROW_GAP, BRANCEH_WIDTH, ROW_H)
#define FRAME_STRAT_TIME            CGRectMake(FRAME_START_X, ROW_GAP * 2 + ROW_H, TIME_WIDTH, ROW_H)
// 还车
#define FRAME_CITY                  CGRectMake(FRAME_START_X, ROW_GAP * 3 + ROW_H * 2, CITY_WIDTH, ROW_H)
#define FRAME_GIVEBACK_NETWORK               CGRectMake(BRANCHE_START_X, ROW_GAP * 3 + ROW_H * 2, BRANCEH_WIDTH, ROW_H)
#define FRAME_GIVEBAKC_TIME         CGRectMake(FRAME_START_X, ROW_GAP * 4 + ROW_H * 3, TIME_WIDTH, ROW_H)


#define FRAME_CONFIRM_BUTTON        CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)
// car info
#define FRAME_CAR_INFO              CGRectMake(0, 0, 320, 140)
#define FRAME_CARTABLE_VIEW         CGRectMake(0, 140, 320, 140)

#if 0
#define HIGHT_CUSTOM_DRAW       10

#define FRAME_NEED_RECT     CGRectMake(10, 70, 300, 310)
//#define FRAME_STR_RECT     CGRectMake(10, 400, 300, 40)
#define FRAME_STR_RECT     CGRectMake(0, 90, MainScreenWidth, MainScreenHeight)
#define FRAME_DATE_SELECT_VIEW CGRectMake(0, MainScreenHeight - 240, 320, 240)

#define FRAME_CIR_RECT      CGRectMake(40, 270, 240, HIGHT_CUSTOM_DRAW)
#define FRAME_RED_RECT     CGRectMake(160, 270, 40, HIGHT_CUSTOM_DRAW)
#define FRAME_YELLOW_RECT     CGRectMake(140, 270, 20, HIGHT_CUSTOM_DRAW)
#endif

#define IMG_USED_TIME   @"usedTime.png"
#define IMG_IDLE_TIME   @"idleTime.png"


@interface PreOderViewController ()
{
    UIScrollView *m_scrollView;
    UIView *m_useCarInfoView;
    UIView *m_otherInfoView;
    
    UIButton *m_extendBtn;
    BOOL m_bExtended;
    NSInteger m_viewHeight;
    
    UILabel *m_take_city; // popupbutton!
    UIButton *m_takeBranche;// 取车网点
    NSString *m_takeBrancheId;//取车网点id
    UIButton *m_startTime;//开始时间
    BOOL m_bTakeBranch;// 是否是取车网点

    UILabel *m_giveback_city; // popupbutton!
    UIButton *m_giveback_branch;// 还车网点
    NSString *m_giveback_brancheId;// 还车网点
    UIButton *m_giveBackTime;// 还车时间
    
    PersonalCarInfoView *m_carInfo;// 车辆视图
    CarTimeTableView *m_carTimeTableView; // 车辆时间表
    
    UIButton *m_confirmBtn;
    BOOL m_isStartTimeSelected;// 区分取车时间和还车时间
    NSString* m_carId;// 车辆id
    
    NSArray *m_checking1;// 车辆巡检今天
    NSArray *m_checking2;// 车辆巡检明天
    NSArray *m_checking3;// 车辆巡检后天
    NSArray *m_using1;// 车辆订单时间今天
    NSArray *m_using2;// 车辆订单时间明天
    NSArray *m_using3;// 车辆订单时间后天
    
    NSDictionary *m_carDic;
    UserSelectCarCondition *m_selectCondition;// 用户选择条件
    SelectedCar *m_selectCar; // 选择的车辆信息
    
    BOOL m_bFromOrderList; // 从历史订单跳转过来
}
@end

@implementation PreOderViewController

// 根据车辆数据 初始化
-(id)initWithCarData:(NSDictionary *)carData
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        m_carDic = carData;
    }
    
    return self;
}

// 根据车辆id 初始化
-(id)initWithCarId:(NSString *)carId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        m_carId = carId; //@"12";//
    }
    
    return self;
}

// 从历史订单初始化
-(id)initFromOrderHistory
{
    self = [super init];
    if (self) {
        m_bFromOrderList = YES;
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
  
    [self initData];
    
    [self getCarSchedule];
    [self initOrderView];
//    [self initPreOrderView];
    
    if (m_selectCondition.m_bNeedReqBranchId)
    {
        NSLog(@"get branch with car info");
        [self getTakeBranchByCar];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_ORDER];
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:FRAME_CALL_BUTTON];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *方法描述：根据车辆id 请求车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarInfoWithId:(NSString *)carId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCarInfo:carId delegate:self];
    req = nil;
}


/**
 *方法描述：初始化需要带入数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initData
{
    m_selectCondition = [[OrderManager ShareInstance] getCurSelectCarConditon];
    m_selectCar = [[CarDataManager shareInstance] getSelCar];
    m_carId = [NSString stringWithFormat:@"%@", m_selectCar.m_carId];
    
}

/**
 *方法描述：根据车辆信息获取所在网点信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getTakeBranchByCar
{
    if (nil == m_selectCar) {
        return;
    }
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    
    NSString *strBranchId = GET(m_selectCar.m_branchid);
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getBranchById:strBranchId delegate:self];
    req = nil;
}

-(void)callBtnPressed
{
    NSLog(@"call button pressed");
    [[PublicFunction ShareInstance] makeCall];
}

-(void)helpBtnPressed
{
    NSLog(@"help button pressed");
    NextHelpViewController *next = [[NextHelpViewController alloc] init];
    [next setTitle:STR_SETTLEMENT];
    NSString *type = [NSString stringWithFormat:@"help%d",4];
    next.type = type;
    [self.navigationController pushViewController:next animated:YES];
}


/**
 *方法描述：初始化用户相关信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initUserInfoView
{
    NSString *tmpStr = nil;
    CGRect tmpRect = FRAME_USE_CAR_INFO_VIEW;
    tmpRect.origin.y = m_viewHeight;
    
    m_useCarInfoView = [[UIView alloc] initWithFrame:tmpRect];
    m_useCarInfoView.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:m_useCarInfoView];
    // user info ： 取车 还车
    m_take_city = [[UILabel alloc] initWithFrame:FRAME_TAKE_BRANCHE_TITLE];
    m_take_city.textColor = [UIColor blackColor];
    m_take_city.text = STR_NANJING;
    m_take_city.backgroundColor = [UIColor whiteColor];
    [m_useCarInfoView addSubview:m_take_city];
    //取车网点
    if (m_selectCondition) {
        tmpStr = GET(m_selectCondition.m_takeBranche);
    }
    m_takeBranche = [[UIButton alloc] initWithFrame:FRAME_TAKE_BRANCHE];
    m_takeBranche.tag = TAG_TAKE_BRANCH;
    [m_takeBranche setEnabled:NO];
    [m_takeBranche setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_takeBranche setTitle:tmpStr forState:UIControlStateNormal];
    [m_takeBranche setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [m_takeBranche addTarget:self action:@selector(selectNetwork:) forControlEvents:UIControlEventTouchUpInside];
    m_takeBranche.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [m_useCarInfoView addSubview:m_takeBranche];
    UIImage *tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    UIImageView *selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(m_takeBranche.frame.size.width - tmpImg.size.width -5, (m_takeBranche.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [m_takeBranche addSubview:selView];
    // 取车时间
    if (m_selectCondition) {
        tmpStr = m_selectCondition.m_takeTime;
    }
    if ([tmpStr isEqualToString:@""] || nil == tmpStr) {
        tmpStr = STR_TAKE_CAR_TIME;
    }

    m_startTime = [[UIButton alloc] initWithFrame:FRAME_STRAT_TIME];
    m_startTime.backgroundColor = [UIColor grayColor];
    m_startTime.tag = TAG_START_TIME;
    [m_startTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_startTime setTitle:tmpStr forState:UIControlStateNormal];
    [m_startTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    m_startTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [m_startTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    [m_useCarInfoView addSubview:m_startTime];
    tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(m_startTime.frame.size.width - tmpImg.size.width -5, (m_startTime.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [m_startTime addSubview:selView];

    // 还车城市
    m_giveback_city = [[UILabel alloc] initWithFrame:FRAME_CITY];
    m_giveback_city.textColor = [UIColor blackColor];
    m_giveback_city.text = STR_NANJING;
    m_giveback_city.backgroundColor = [UIColor whiteColor];
    [m_useCarInfoView addSubview:m_giveback_city];
    
    // 还车网点
    if (m_selectCondition) {
        tmpStr = m_selectCondition.m_givebackBranche;
    }
    m_giveback_branch = [[UIButton alloc] initWithFrame:FRAME_GIVEBACK_NETWORK];
    m_giveback_branch.tag = TAG_GIVEBACK_BRANCH;
    [m_giveback_branch setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    [m_giveback_branch setTitle:tmpStr forState:UIControlStateNormal];
    [m_giveback_branch setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    m_giveback_branch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [m_giveback_branch addTarget:self action:@selector(selectNetwork:) forControlEvents:UIControlEventTouchUpInside];
    [m_useCarInfoView addSubview:m_giveback_branch];
    tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(m_giveback_branch.frame.size.width - tmpImg.size.width -5, (m_giveback_branch.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [m_giveback_branch addSubview:selView];
#if 0
    UILabel *labelReturn = [[UILabel alloc] initWithFrame:FRAME_RETURN_LABEL];
    labelReturn.textColor = [UIColor blackColor];
    labelReturn.text = STR_GIVEBACK_INFO;
    [self.view addSubview:labelReturn];
#endif
    // 还车时间
    if (m_selectCondition) {
        tmpStr = m_selectCondition.m_givebackTime;
    }
    if ([tmpStr isEqualToString:@""] || nil == tmpStr)
    {
        tmpStr = STR_GIVE_BACK_TIME;
    }
    m_giveBackTime = [[UIButton alloc] initWithFrame:FRAME_GIVEBAKC_TIME];
    [m_giveBackTime setBackgroundImage:[UIImage imageNamed:IMG_AREA] forState:UIControlStateNormal];
    m_giveBackTime.tag = TAG_GIVEBACK_TIME;
    [m_giveBackTime setTitle:tmpStr forState:UIControlStateNormal];
    [m_giveBackTime setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [m_giveBackTime addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    m_giveBackTime.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   [m_useCarInfoView addSubview:m_giveBackTime];
    tmpImg = [UIImage imageNamed:IMG_SEL_PROMPT];
    selView = [[UIImageView alloc] initWithImage:tmpImg];
    selView.frame = CGRectMake(m_giveBackTime.frame.size.width - tmpImg.size.width -5, (m_giveBackTime.frame.size.height - tmpImg.size.height)/2, tmpImg.size.width, tmpImg.size.height);
    [m_giveBackTime addSubview:selView];
    
    m_viewHeight += m_useCarInfoView.frame.size.height;
}

/**
 *方法描述：初始化车辆相关信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initOtherInfoView
{
    NSInteger nStartY = 0;
    
    m_otherInfoView = [[UIView alloc] initWithFrame:FRAME_OTHER_INFO_VIEW];
    m_otherInfoView.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:m_otherInfoView];
    
    CGRect rc = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    UIView *gapView = [[PublicFunction ShareInstance] spaceViewWithRect:rc withColor:COLOR_BACKGROUND];
    [m_otherInfoView addSubview:gapView];
    m_viewHeight += spaceViewHeight;
    
    rc.origin.y = m_viewHeight;
    m_otherInfoView.frame = rc;
    // other info ：车
    m_carInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_CAR_INFO forUsed:forSelectCar];
    if (m_carDic && NO == m_bFromOrderList)
    {
        NSString *strModel = [[NSString alloc] initWithFormat:@"%@", [m_carDic objectForKey:@"model"]];
        NSString *resModel = [strModel stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        
        NSString *strTmp = [[NSString alloc] initWithFormat:@"%@",[m_carDic objectForKey:@"plateNum"]];
        NSString *strPlateNum = [strTmp stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        [m_carInfo setselectCarWithUnitPrice:GET([m_carDic objectForKey:@"unitPrice"])
                                    dayPrice:GET([m_carDic objectForKey:@"dayPrice"])
                                    carModel:GET(resModel)
                                    carSerie:GET([m_carDic objectForKey:@"carseries"])
                                    carPlate:GET(strPlateNum)
                                    discount:GET([m_carDic objectForKey:@"activePrice"])
                                    imageUrl:GET([m_carDic objectForKey:@"carFile"])];
    }
    else
    {
        if (m_bFromOrderList)
        {
            [self getCarInfoWithId:m_carId];
            m_bFromOrderList = NO;
        }
    }
    
    [m_otherInfoView addSubview:m_carInfo];
    
    nStartY = m_carInfo.frame.origin.y + m_carInfo.frame.size.height;
    rc = CGRectMake(0, nStartY, MainScreenWidth, spaceViewHeight);
    gapView = [[PublicFunction ShareInstance] spaceViewWithRect:rc withColor:COLOR_BACKGROUND];
    [m_otherInfoView addSubview:gapView];
    nStartY += spaceViewHeight;
    
    //prompt
//    NSInteger nStartY = m_viewHeight;// m_carInfo.frame.size.height + m_carInfo.frame.origin.y;
    NSInteger nStartX = MainScreenWidth / 2;
    NSInteger nWidth = MainScreenWidth / 2;
    CGRect tmpRect = CGRectMake(nStartX, nStartY, nWidth, 20);
    UIView *tmpView = [[UIView alloc] initWithFrame:tmpRect];
    
    CGRect rentedImgRect = CGRectMake(0, 0, tmpRect.size.width/4, tmpRect.size.height);
    UIImage *usedImg = [UIImage imageNamed:IMG_USED_TIME];
    UIImageView *rentedImgView = [[UIImageView alloc] initWithImage:usedImg];
    rentedImgView.frame = rentedImgRect;
    [tmpView addSubview:rentedImgView];
    
    CGRect rentedRect = CGRectMake(tmpRect.size.width/4, 0, tmpRect.size.width/4, tmpRect.size.height);
    UILabel *rented = [[UILabel alloc] initWithFrame:rentedRect];
    rented.text = STR_RENTED;
    [tmpView addSubview:rented];

    CGRect idleImgRect = CGRectMake(tmpRect.size.width/2, 0, tmpRect.size.width/4, tmpRect.size.height);
//    CustomDrawView *idleImg = [[CustomDrawView alloc] initWithFrame:idleImgRect withStyle:customCirRectangle];
    UIImage * idleImg = [UIImage imageNamed:IMG_IDLE_TIME];
    UIImageView *idleImgView = [[UIImageView alloc] initWithImage:idleImg];
//    idleImgRect.size.width = idleImg.size.width;
//    idleImgRect.size.height = idleImg.size.height;
    idleImgView.frame = idleImgRect;
    [tmpView addSubview:idleImgView];
    
    CGRect idleRect = CGRectMake((tmpRect.size.width/4) * 3, 0, tmpRect.size.width/4, tmpRect.size.height);
    UILabel *idle = [[UILabel alloc] initWithFrame:idleRect];
    idle.text = STR_IDLE;
    [tmpView addSubview:idle];

    [m_otherInfoView addSubview:tmpView];
    
    rc = CGRectMake(0, m_carInfo.frame.size.height + m_carInfo.frame.origin.y + tmpView.frame.size.height + spaceViewHeight, 320, m_carInfo.frame.size.height);
    m_carTimeTableView = [[CarTimeTableView alloc] initWithFrame:rc];
    [self updateOrderTimeByCarId:nil];
    [m_otherInfoView addSubview:m_carTimeTableView];
    
    m_otherInfoView.frame = CGRectMake(0, m_otherInfoView.frame.origin.y, 320, m_carInfo.frame.size.height + m_carTimeTableView.frame.size.height + 20);
    
}

/**
 *方法描述：初始化订单页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initOrderView
{
    m_bExtended = YES;
    // scroll view
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.contentSize = SIZE_SCROLL_VIEW;
    
    UILabel *bkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
    bkLabel.backgroundColor = [UIColor whiteColor];
    [m_scrollView addSubview:bkLabel];
    
    UIButton *takeInfo = [[UIButton alloc] initWithFrame:FRAME_TAKE_INFO];
//    takeInfo.text = STR_TAKE_INFO;
    [takeInfo setTitle:STR_TAKE_INFO forState:UIControlStateNormal];
    [takeInfo setTitleColor:COLOR_LABEL_GRAY forState:UIControlStateNormal];
    takeInfo.backgroundColor = [UIColor clearColor];
    takeInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [takeInfo addTarget:self action:@selector(extendBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_scrollView addSubview:takeInfo];
    m_viewHeight = takeInfo.frame.size.height + takeInfo.frame.origin.y;
    
    
    m_extendBtn = [[UIButton alloc] initWithFrame:FRAME_EXTEND_BTN];
//    [m_extendBtn setBackgroundImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
    [m_extendBtn setImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
    [m_extendBtn addTarget:self action:@selector(extendBtn) forControlEvents:UIControlEventTouchUpInside];
    [m_scrollView addSubview:m_extendBtn];

    [self initUserInfoView];
    
    [self initOtherInfoView];
    
    m_confirmBtn = [[UIButton alloc] initWithFrame:FRAME_CONFIRM_BUTTON];
    [m_confirmBtn setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_confirmBtn setTitle:STR_CONFIRM_ORDER forState:UIControlStateNormal];
    [m_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [m_confirmBtn addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_confirmBtn];
    
    m_scrollView.contentSize = CGSizeMake(320, m_otherInfoView.frame.origin.y + m_otherInfoView.frame.size.height + 30);
    [self.view addSubview:m_scrollView];
    
    [self extendBtn];
}


-(void)showAlert
{
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:@"取车网点不能改变" delegate:self cancelButtonTitle:STR_CANCEL otherButtonTitles:nil, nil];
    [tmpAlert show];
}

/**
 *方法描述：进入选择网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectNetwork:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    m_bTakeBranch = NO;
    if  (tmpBtn.tag == TAG_TAKE_BRANCH)
    {
        m_bTakeBranch = YES;
        if (NO == ISEMPTY(m_selectCondition.m_takeBrancheId) )
        {
            [self showAlert];
        }
    }
    NSLog(@"select network");
    BranchesViewController *tmpBranchesController = [[BranchesViewController alloc] initWithNibName:nil bundle:nil];
    tmpBranchesController.enterType = BranchesViewFromPersonalRetal;
    tmpBranchesController.delegate = self;
    [self.navigationController pushViewController:tmpBranchesController animated:YES];
    tmpBranchesController = nil;
}


/**
 *方法描述：是否显示个人选择信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)showExtendedInfo
{
    if (m_bExtended)
    {
        return;
    }
    
    [self extendBtn];
}


/**
 *方法描述：扩展信息按钮
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)extendBtn
{
    NSLog(@"extend btn");
    if (m_bExtended)
    {
//        [m_extendBtn setBackgroundImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
        [m_extendBtn setImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
        [m_useCarInfoView removeFromSuperview];
        CGRect tmpRect = m_otherInfoView.frame;
        tmpRect.origin.y -= m_useCarInfoView.frame.size.height;
        m_otherInfoView.frame = tmpRect;
    }
    else
    {
//        [m_extendBtn setBackgroundImage:[UIImage imageNamed:IMG_UNSEL_PROMPT] forState:UIControlStateNormal];
        [m_extendBtn setImage:[UIImage imageNamed:IMG_UNSEL_PROMPT] forState:UIControlStateNormal];
        [m_scrollView addSubview:m_useCarInfoView];
        CGRect tmpRect = m_otherInfoView.frame;
        tmpRect.origin.y += m_useCarInfoView.frame.size.height;
        m_otherInfoView.frame = tmpRect;
    }
    
    m_bExtended = !m_bExtended;
}

/**
 *方法描述：检查选择信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)checkSelectCondition
{
    if (ISEMPTY(m_selectCondition.m_takeBrancheId)
        ||ISEMPTY(m_selectCondition.m_givebackBrancheId)
        ||ISEMPTY(m_selectCondition.m_takeTime)
        ||ISEMPTY(m_selectCondition.m_givebackTime)
        || [m_startTime.titleLabel.text isEqualToString:STR_TAKE_CAR_TIME]
        || [m_giveBackTime.titleLabel.text isEqualToString:STR_GIVE_BACK_TIME])
    {
        [self showExtendedInfo];
        return NO;
    }
    return YES;
}

/**
 *方法描述：实名认证确认
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)noCertification
{
    UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_NO_CERTIFICATION delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tmpAlert.tag=TAG_ALERTVIEW;
    [tmpAlert show];
}

/**
 *方法描述：检查相关条件，并进入确认订单页面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)confirmBtn
{
    NSLog(@"confirm btn");
    if (NO == [self checkSelectCondition]) {
        
        UIAlertView *tmpCtrl = [[UIAlertView alloc] initWithTitle:nil message:STR_NEED_SEL_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        [tmpCtrl show];
        return;
    }
    
    if ([[PublicFunction ShareInstance] isLaterThanCurrentTime:m_selectCondition.m_takeTime])
    {
#if 0
        UIAlertView *tmpAlert = [[UIAlertView alloc] initWithTitle:nil message:STR_CHECK_CURRENT_TIME delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil, nil];
        tmpAlert.tag = 10001;
        [tmpAlert show];
#endif
        return;
    }

    if (NO == [[PublicFunction ShareInstance] checkTime:m_selectCondition.m_takeTime givebackTime:m_selectCondition.m_givebackTime isTake:NO]) {
        return;
    }
    
    if ([PublicFunction ShareInstance].m_bLogin)
    {
        if (NO == [self checkCertification])
        {
            [self getIdentifyVerificationStatus];
        }
        else
        {
            [self getCurOrder];
        }
    }
    else
    {
        LoginViewController *tmpCtrl = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:tmpCtrl];
        [self presentViewController:loginNav animated:YES completion:^{
        }];
    }
}

/**
 *方法描述：检查实名认证状态
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(BOOL)checkCertification
{
#if 0//DEBUG
    return YES;
#else
    if ([[User shareInstance].status integerValue] == 3) {
        return YES;
    }
    
    return NO;
#endif
}

/**
 *方法描述：请求个人信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getIdentifyVerificationStatus
{
    NSString *userId = [User shareInstance].id;
    if (userId && userId.length > 0)
    {
        FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getUserInfoWith:userId delegate:self];
        tempRequest = nil;
    }
}

/**
 *方法描述：个人信息返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)gotUserInfo:(NSInteger)status
{
    if (status  == 3) {
        [self getCurOrder];
    }
    else
    {
        [self noCertification];
    }
}


#pragma mark - data picker
/**
 *方法描述：选择时间界面
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectTime:(id)sender
{
    NSLog(@"select time");
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
 *方法描述：修改网点
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selBrancheFromController:(NSDictionary *)branchData
{
    NSString *brancheName = [NSString stringWithFormat:@"%@",[branchData objectForKey:@"name"]];
    NSString *brancheId = [NSString stringWithFormat:@"%@",[branchData objectForKey:@"id"]];
    
    
    if (m_bTakeBranch)
    {
        [m_takeBranche setTitle:brancheName forState:UIControlStateNormal];
        m_takeBrancheId = [NSString stringWithFormat:@"%@", brancheId];
        m_selectCondition.m_takeBrancheId = [NSString stringWithFormat:@"%@", brancheId];
        m_selectCondition.m_takeBranche = [NSString stringWithFormat:@"%@", brancheName];
    }
    else
    {
        [m_giveback_branch setTitle:brancheName forState:UIControlStateNormal];
        m_giveback_brancheId = [NSString stringWithFormat:@"%@", brancheId];
        m_selectCondition.m_givebackBrancheId = [NSString stringWithFormat:@"%@", brancheId];
        m_selectCondition.m_givebackBranche = [NSString stringWithFormat:@"%@", brancheName];
    }
}


/**
 *方法描述：修改时间
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
        if([[PublicFunction ShareInstance] checkTime:str givebackTime:GET(m_selectCondition.m_givebackTime) isTake:YES])
        {
            [m_startTime setTitle:str forState:UIControlStateNormal];
            m_selectCondition.m_takeTime = [NSString stringWithFormat:@"%@", str];
        }
    }
    else
    {
        if([[PublicFunction ShareInstance] checkTime:m_selectCondition.m_takeTime givebackTime:str isTake:NO])
        {
            [m_giveBackTime setTitle:str forState:UIControlStateNormal];
            m_selectCondition.m_givebackTime = [NSString stringWithFormat:@"%@", str];
        }
    }
}

/**
 *方法描述：网点信息返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initBranche:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    NSArray *branchesArr = [dic objectForKey:@"branches"];
    
    if (0 == [branchesArr count]) {
        return;
    }

    BrancheData *tmpBranch  = [[BrancheData alloc] init];
    [tmpBranch setBranchData:[branchesArr objectAtIndex:0]];
    
    m_selectCondition.m_takeBrancheId = [NSString stringWithFormat:@"%@", GET(m_selectCar.m_branchid)];
    m_selectCondition.m_takeBranche = [NSString stringWithFormat:@"%@", GET(tmpBranch.m_name)];
    
    [m_takeBranche setTitle:m_selectCondition.m_takeBranche forState:UIControlStateNormal];
    m_takeBrancheId = [NSString stringWithFormat:@"%@", GET(m_selectCar.m_branchid)];
    
    if (m_selectCondition.m_bNeedReqBranchId) {
        m_selectCondition.m_givebackBranche = [NSString stringWithFormat:@"%@", m_selectCondition.m_takeBranche];
        m_selectCondition.m_givebackBrancheId = [NSString stringWithFormat:@"%@", m_selectCondition.m_takeBrancheId];
        
        [m_giveback_branch setTitle:m_selectCondition.m_takeBranche forState:UIControlStateNormal];
        m_giveback_brancheId = [NSString stringWithFormat:@"%@", GET(m_selectCar.m_branchid)];
    }
}

#pragma mark - request

/**
 *方法描述：请求当前订单
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCurOrder
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    NSString *userId = [User shareInstance].id;
    FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance] getCurrentOrderInfo:userId delegate:self];
    
    tmpRequest = nil;
    
}

/**
 *方法描述：请求车辆订单信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)getCarSchedule
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];

    FMNetworkRequest *req = [[BLNetworkManager shareInstance] selectOrderTimeByCarId:m_carId delegate:self];
    req = nil;
}

/**
 *方法描述：更新车辆订单信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateOrderTimeByCarId:(NSDictionary *)responseDate
{
    m_checking1 = [responseDate objectForKey:@"checking1"];
    m_checking2 = [responseDate objectForKey:@"checking2"];
    m_checking3 = [responseDate objectForKey:@"checking3"];
    m_using1 = [responseDate objectForKey:@"using1"];
    m_using2 = [responseDate objectForKey:@"using2"];
    m_using3 = [responseDate objectForKey:@"using3"];
    NSLog(@"update OrderTime CarId ");

    [m_carTimeTableView updateChecking:m_checking1 check2:m_checking2 check3:m_checking3];
    [m_carTimeTableView updateUsing:m_using1 use2:m_using2 check3:m_using3];
}

/**
 *方法描述：更新车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)updateCarInfo
{
    SelectedCar *carInfo = [[CarDataManager shareInstance] getSelCar];
    
    [m_carInfo setselectCarWithUnitPrice:carInfo.m_unitPrice dayPrice:carInfo.m_dayPrice carModel:carInfo.m_model carSerie:carInfo.m_carseries carPlate:carInfo.m_plateNum discount:carInfo.m_discount imageUrl:carInfo.m_carFile];
    [m_carInfo setNeedsDisplay];
}
/**
 *方法描述：解析初始化从服务器获取到的车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initCarInfo:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    [[CarDataManager shareInstance] setSelCar:[dic objectForKey:@"cars"]];
    [self updateCarInfo];
}

/**
 *方法描述：当前订单信息返回
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initMyOrderWithNetworkRequest:(FMNetworkRequest *)fmRequest
{
    if ([NO_ORDER_CURRENTLY isEqualToString:fmRequest.responseData])
    {
        ConfirmOrderViewController *tmpCtrl = [[ConfirmOrderViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:tmpCtrl animated:YES];
    }
    else
    {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:STR_HAVE_RENTED delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
        [alert needDismisShow];
    }

}
#pragma mark--UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==TAG_ALERTVIEW)
    {
        if (buttonIndex==1)
        {
            IdentifyVerificationViewController *identify = [[IdentifyVerificationViewController alloc] init];
            [self.navigationController pushViewController:identify animated:YES];
        }
    }

}


#pragma mark --DataComeBack
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
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_selectOrderTimeByCarId])// 根据车辆获取订单时间
    {
        [self updateOrderTimeByCarId:fmNetworkRequest.responseData];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getBranchById])//根据网点id获取网点信息
    {
        [self initBranche:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])//获取当前订单信息
    {
        [self initMyOrderWithNetworkRequest:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:kRequest_getCarInfo]) //获取车辆信息
    {
        [self initCarInfo:fmNetworkRequest];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_UserInFo])// 获取用户相关信息
    {
        NSInteger status = [[User shareInstance].status intValue];
        [self gotUserInfo:status];
    }
    
    [[LoadingClass shared] hideLoadingForMoreRequest];
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
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if([fmNetworkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
    {
        [self initMyOrderWithNetworkRequest:fmNetworkRequest];
    }
}

@end
