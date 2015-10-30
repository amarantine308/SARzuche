//
//  SelectCarViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "SelectCarViewController.h"
#import "ConstDefine.h"
#import "constString.h"
#import "AllCarModelView.h"
#import "PreOderViewController.h"
#import "BLNetworkManager.h"
#import "PersonalCarInfoView.h"
#import "LoadingClass.h"
#import "CarDataManager.h"
#import "OrderManager.h"
#import "ConstImage.h"
#import "BranchesMapViewController.h"
#import "BranchDataManager.h"
#import "CustomAlertView.h"

#define TAG_SCROLLVIEW          10010

#define HEIGHT_ROW_LABEL    30

// scroll view
#define FRAME_SCROLL_VIEW       CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)
#define SIZE_SCROLL_VIEW            CGSizeMake(0, 500)
// use info
#define FRAME_SELECT_CAR_LABEL  CGRectMake(10, 5, 260, HEIGHT_ROW_LABEL)
#define FRAME_SHOW_CONDITION    CGRectMake(270, 5, 26, 26)
#define FRAME_USER_INFO_VIEW    CGRectMake(0, HEIGHT_ROW_LABEL, 320, 140)
#define FRAME_ORDER_INFO_VIEW    CGRectMake(0, 0, 320, 140)
// all car
#define FRAME_ALL_CAR_VIEW      CGRectMake(0, 240, 320, MainScreenHeight - 240)
#define FRAME_SELECT_CAR_MODEL  CGRectMake(10, 0, 260, HEIGHT_ROW_LABEL)
#define FRAME_NO_CAR            CGRectMake(10, 260, 300, 100)
#define FRAME_ALL_CAR_TABEL     CGRectMake(0, HEIGHT_ROW_LABEL, 320, MainScreenHeight - HEIGHT_ROW_LABEL * 2 - controllerViewStartY)

#define NUM_OF_PAGE             @"20"

@interface SelectCarViewController ()
{
    BOOL m_bExtended;
    UIScrollView *m_scrollView;
    UIView *m_userInfoView;
    UIView *m_allCarsView;
    
    UILabel *m_noCarInfo;
    UIButton *m_selectAgain;
    UILabel *m_selectCondition;
    UILabel *m_selectCarModel;
    UIButton *m_showSelConditionBtn;
    
    NSString *m_city;
    NSString *m_takeTime;
    NSString *m_giveBackTime;
    NSString *m_branche;
    NSString *m_brancheId;
    
    NSInteger m_curHeight;
    AllCarModelView *m_allCar;
    NSMutableArray *m_carsArray;
    
    NSInteger m_totalcarNum;
    NSInteger m_numPerPage;
    NSInteger m_curPage;
    
    // request
    FMNetworkRequest *m_carListReq;
}

@end

@implementation SelectCarViewController

-(id)initWithCondition:(NSString *)city Branche:(NSString *)branche Take:(NSString *)takeTime GiveBack:(NSString *)gviebackTime
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        m_city = city;
        m_branche = branche;
        m_takeTime = takeTime;
        m_giveBackTime = gviebackTime;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_SELECT_CAR];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self initSelectCarView];
    [self getCarList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    CANCEL_REQUEST(m_carListReq);
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)showNoCar:(BOOL)bShow
{
    m_noCarInfo.hidden = !bShow;
    m_selectAgain.hidden = !bShow;
    m_scrollView.hidden = bShow;
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
    UserSelectCarCondition *sel = [[OrderManager ShareInstance] getCurSelectCarConditon];
    m_branche = sel.m_takeBranche;
    m_takeTime = sel.m_takeTime;
    m_giveBackTime = sel.m_givebackTime;
    m_brancheId = sel.m_takeBrancheId;
    
    m_numPerPage = [NUM_OF_PAGE integerValue];
    m_curPage = 1;
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)initUserInfoView
{    
    m_userInfoView = [[UIView alloc] initWithFrame:FRAME_USER_INFO_VIEW];
    m_userInfoView.backgroundColor = [UIColor clearColor];
    //
    PersonalCarInfoView *userInfo = [[PersonalCarInfoView alloc] initWithFrame:FRAME_ORDER_INFO_VIEW forUsed:forUserInfo];
    [userInfo setSelectConditionWithBranche:m_branche takeTime:m_takeTime backBranche:m_branche backTime:m_giveBackTime];
    [m_userInfoView addSubview:userInfo];
    
    CGRect tmpRect = m_userInfoView.frame;
    m_userInfoView.frame = CGRectMake(tmpRect.origin.x, tmpRect.origin.y, tmpRect.size.width, userInfo.frame.size.height);
    [m_scrollView addSubview:m_userInfoView];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)initAllCarView
{
    m_allCarsView = [[UIView alloc] initWithFrame:FRAME_ALL_CAR_VIEW];
    
    m_selectCarModel = [[UILabel alloc] initWithFrame:FRAME_SELECT_CAR_MODEL];
    m_selectCarModel.textColor= [UIColor blackColor];
    m_selectCarModel.text = STR_ALL_CAR_MODEL;
    [m_allCarsView addSubview:m_selectCarModel];
    
    // car info
    m_allCar = [[AllCarModelView alloc] initWithFrame:FRAME_ALL_CAR_TABEL];
    m_allCar.m_delegate = self;
    m_allCar.userInteractionEnabled = YES;
    [m_allCarsView addSubview:m_allCar];
    
//    NSInteger height =MainScreenHeight - (m_allCarsView.frame.origin.y + m_selectCarModel.frame.size.height);
//    CGRect tmpRect = CGRectMake(m_allCar.frame.origin.x, m_allCar.frame.origin.y, m_allCar.frame.size.width, height);
//    m_allCar.frame = tmpRect;
    
    
    CGRect tmpRect = CGRectMake(m_userInfoView.frame.origin.x, m_userInfoView.frame.origin.y + m_userInfoView.frame.size.height, FRAME_ALL_CAR_VIEW.size.width, m_selectCarModel.frame.size.height + m_allCar.frame.size.height);
    m_allCarsView.frame = tmpRect;
    [m_scrollView addSubview:m_allCarsView];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)initScrollView
{
    m_bExtended = NO;
    // scroll view
    m_scrollView = [[UIScrollView alloc] initWithFrame:FRAME_SCROLL_VIEW];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.contentSize = SIZE_SCROLL_VIEW;
    m_scrollView.tag = TAG_SCROLLVIEW;
    m_scrollView.userInteractionEnabled= YES;
    m_scrollView.scrollEnabled = NO;//YES; //
//    m_scrollView.delegate = self;
    
    m_selectCondition = [[UILabel alloc] initWithFrame:FRAME_SELECT_CAR_LABEL];
    m_selectCondition.text = STR_SEL_CONDITION;
    m_selectCondition.textColor = [UIColor blackColor];
    [m_scrollView addSubview:m_selectCondition];
    
    m_showSelConditionBtn = [[UIButton alloc] initWithFrame:FRAME_SHOW_CONDITION];
//    [m_showSelConditionBtn setBackgroundImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
    [m_showSelConditionBtn setImage:[UIImage imageNamed:IMG_SEL_PROMPT] forState:UIControlStateNormal];
    [m_showSelConditionBtn addTarget:self action:@selector(showSelectCondition) forControlEvents:UIControlEventTouchUpInside];
    [m_scrollView addSubview:m_showSelConditionBtn];
    
    [self initUserInfoView];
    [self initAllCarView];
    
    [self.view addSubview:m_scrollView];
    
    [self showUserInfo:m_bExtended];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)initSelectCarView
{
    self.view.userInteractionEnabled = YES;
    // no Car
    m_noCarInfo = [[UILabel alloc] initWithFrame:FRAME_NO_CAR];
    m_noCarInfo.backgroundColor = [UIColor clearColor];
    [m_noCarInfo setText:STR_NOCAR_FORSELECTING];
    m_noCarInfo.textColor = [UIColor blackColor];
    m_noCarInfo.lineBreakMode = NSLineBreakByCharWrapping;
    m_noCarInfo.textAlignment = NSTextAlignmentCenter;
    m_noCarInfo.numberOfLines = 2;
    m_noCarInfo.hidden = YES;
    
    m_selectAgain = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight - bottomButtonHeight, MainScreenWidth, bottomButtonHeight)];
    [m_selectAgain setBackgroundImage:[UIImage imageNamed:IMG_BOTTOM_LONG_BTN] forState:UIControlStateNormal];
    [m_selectAgain setTitle:STR_WRITE_AGAIN forState:UIControlStateNormal];
    [m_selectAgain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [m_selectAgain addTarget:self action:@selector(selectAgain) forControlEvents:UIControlEventTouchUpInside];
    m_selectAgain.hidden = YES;
    
    [self.view addSubview:m_noCarInfo];
    [self.view addSubview:m_selectAgain];
    
    [self initScrollView];
    
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)showUserInfo:(BOOL)bShow
{
    if (NO == m_bExtended)
    {
        [m_userInfoView removeFromSuperview];
        CGRect tmpRect = m_allCarsView.frame;
        tmpRect.origin.y -= m_userInfoView.frame.size.height;
        tmpRect.size.height += m_userInfoView.frame.size.height;
        m_allCarsView.frame = tmpRect;
        
        tmpRect = FRAME_ALL_CAR_TABEL;
//        tmpRect.size.height += m_userInfoView.frame.size.height;
        m_allCar.frame = tmpRect;
        [m_allCar viewFrameChanged];
        
        m_scrollView.contentSize = CGSizeMake(0, m_allCarsView.frame.size.height + m_selectCondition.frame.size.height + 5);
    }
    else
    {
        [m_scrollView addSubview:m_userInfoView];
        CGRect tmpRect = m_allCarsView.frame;
        tmpRect.origin.y += m_userInfoView.frame.size.height;
        tmpRect.size.height -= m_userInfoView.frame.size.height;
        m_allCarsView.frame = tmpRect;

        tmpRect = FRAME_ALL_CAR_TABEL;
        tmpRect.size.height -= m_userInfoView.frame.size.height;
        m_allCar.frame = tmpRect;
        [m_allCar viewFrameChanged];
        
        m_scrollView.contentSize = CGSizeMake(0, m_userInfoView.frame.size.height + m_allCarsView.frame.size.height + m_selectCondition.frame.size.height + 5);
    }
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)showSelectCondition
{
    NSLog(@"extend btn");
    m_bExtended = !m_bExtended;
    
    [self showUserInfo:m_bExtended];
    
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)updateCarsList:(NSDictionary *)responseDate
{
    m_totalcarNum = [[responseDate objectForKey:@"totalnum"] integerValue];
    m_carsArray = [responseDate objectForKey:@"cars"];
    NSLog(@"update Cars List");
    if (0 == [m_carsArray count]) {
        [self showNoCar:YES];
        return;
    }
    else
    {
        [self showNoCar:NO];
    }
    [m_allCar updateCars:m_carsArray totalNum:m_totalcarNum];
    m_curPage ++;
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */

-(void)getCarList
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];

    NSString *braunchId = [NSString stringWithFormat:@"%@", m_brancheId];//[[OrderManager ShareInstance] getCurSelectCarConditon].m_takeBrancheId;
    NSString *takeTime = [NSString stringWithFormat:@"%@:00", m_takeTime];
    NSString *giveBackTime = [NSString stringWithFormat:@"%@:00", m_giveBackTime];

    if (m_takeTime && [m_takeTime length] == 0) {
        takeTime = @"";
    }
    
    if (m_giveBackTime && [m_giveBackTime length] == 0) {
        giveBackTime = @"";
    }
    
    m_carListReq = [[BLNetworkManager shareInstance] selectCarsByCondition:STR_NANJING takeTime:takeTime returnTime:giveBackTime branche:braunchId page:m_curPage pagesize:m_numPerPage delegate:self];

    NSLog(@"-------curPage = %d  %@  %@, %@", m_curPage, takeTime, giveBackTime, braunchId);
}

#pragma mark - jump to map
/**
 *方法描述：地图按钮代理
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance
{
    NSLog(@"--- TO MAP ----");
    if (bTakeBrance)
    {
        BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:YES]];
        vc.enterType = MapViewFromSelBranch;
//        vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        BranchesMapViewController *vc = [[BranchesMapViewController alloc] initWithSeleBranch:[[BranchDataManager shareInstance] getSelBranchWithType:NO]];
        vc.enterType = MapViewFromSelBranch;
//        vc.branchesArray = [[BranchDataManager shareInstance] getSelBranchWithType:NO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - AllCarModelView delegate
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)toOderCar:(NSInteger)index
{
    NSLog(@"to order car %d", index);
    NSDictionary *carDic = [m_carsArray objectAtIndex:index];
    [[CarDataManager shareInstance] setSelCar:carDic];
    
    PreOderViewController *tmpCtrl = [[PreOderViewController alloc] initWithCarData:carDic];
    [self.navigationController pushViewController:tmpCtrl animated:YES];
}

-(void)getMoreCar:(BOOL)bRefresh
{
    if (bRefresh) {
        m_curPage = 1;
    }
    
    [self getCarList];
}

-(void)selectAgain
{
    NSLog(@"select again");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - network delegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [self updateCarsList:fmNetworkRequest.responseData];
    
    [[LoadingClass shared] hideLoadingForMoreRequest];
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:STR_REQUEST_FAILED delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:INTERVAL_FOR_DISMISS_ALERTVIEW];
    [alert needDismisShow];
}

@end
