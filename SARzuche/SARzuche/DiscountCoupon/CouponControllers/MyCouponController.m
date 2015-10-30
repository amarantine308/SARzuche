//
//  MyCouponController.m
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyCouponController.h"
#import "MyCouponCell.h"
#import "CouponInfoController.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "PublicFunction.h"
#import "ConstDefine.h"

#define IMG_CHECKBOX_SEL            @"checkbox_sel.png"
#define IMG_CHECKBOX_UNSEL          @"checkbox_unsel.png"

@interface MyCouponController ()
{
    CouponSortMenuView *m_sortView;
    NSMutableArray *m_couponSelected; //选择框选择数据
    
    
    NSDictionary *m_delDic;
    BOOL m_bDelete;
    BOOL m_bEmpty;
    
    NSInteger m_curPage;
    NSInteger m_pageSize;
}

@end

@implementation MyCouponController
@synthesize delegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)sendMyCouponUrl:(NSInteger)couponType sortType:(NSInteger)sortType
{
    //couponType ＝＝ 0:有效 1:无效 2:全部
    //sortType == 1 默认排序 2 到期时间排序 3 分类排序
    NSString *userid = [User shareInstance].id;
    m_sortType = sortType;
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    //我的优惠卷
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getMyCouponWithUserId:userid
                                                                           takeTime:@""
                                                                       givebackTime:@""
                                                                               type:[NSString stringWithFormat:@"%d", couponType]
                                                                           sortType:[NSString stringWithFormat:@"%d",sortType]
                                                                         pageNumber:m_curPage
                                                                           pageSize:m_pageSize
                                                                           delegate:self];
    req = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"我的优惠劵"];
    }
    
    table_myCoupon.backgroundColor = [UIColor clearColor];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if(IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    [m_sortBtn setTitle:STR_SORT_BY_DEFAULT forState:UIControlStateNormal];
    //我的优惠劵接口
    m_curPage = 1;
    m_pageSize = 20;
    m_sortType = 1;
    [self sendMyCouponUrl:0 sortType:m_sortType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableviewDelegate协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_segmentSel == 0)
    {
        return [m_validCoupons count];
    }
    else if(m_segmentSel == 1)
    {
        return [m_invalidCoupons count];
    }
    else if(m_segmentSel == 2)
    {
        return [list_coupons count];
    }
    
    return 0;
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strIdentifier = @"MyCouponCellIdentifier";
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyCouponCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = nil;
    if (m_segmentSel == 0)
    {
        dic = [m_validCoupons objectAtIndex:indexPath.row];
    }else if(m_segmentSel == 1)
    {
        dic = [m_invalidCoupons objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [list_coupons objectAtIndex:indexPath.row];
    }
    cell.tag = indexPath.row;
    cell.m_couponName.text = [dic objectForKey:@"name"];
    cell.m_couponTime.text = [NSString stringWithFormat:@"%@ ~ %@", [dic objectForKey:@"startdate"], [dic objectForKey:@"enddate"]];
    cell.m_couponDesc.text = [[dic objectForKey:@"remarks"]stringByReplacingOccurrencesOfString:@"+" withString:@"" ];
    cell.m_couponDesc.numberOfLines = 2;
    //[cell.m_couponDesc sizeToFit];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *tmpImg = [UIImage imageNamed:IMG_CHECKBOX_SEL];
    [cell.m_checkboxBtn setBackgroundImage:tmpImg forState:UIControlStateSelected];
    [cell.m_checkboxBtn setBackgroundImage:[UIImage imageNamed:IMG_CHECKBOX_UNSEL] forState:UIControlStateNormal];
    cell.m_checkboxBtn.tag = indexPath.row;
    cell.m_checkboxBtn.backgroundColor = [UIColor lightGrayColor];
    [cell.m_checkboxBtn addTarget:self action:@selector(checkBoxPressed:) forControlEvents:UIControlEventTouchUpInside];
    if (NO == m_bDelete) {
        cell.m_checkboxBtn.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    if (m_segmentSel == 0)
    {
        dic = [m_validCoupons objectAtIndex:indexPath.row];
    }
    else if(m_segmentSel == 1)
    {
        dic = [m_invalidCoupons objectAtIndex:indexPath.row];
    }
    else
    {
        dic = [list_coupons objectAtIndex:indexPath.row];
    }
    
    
    CouponInfoController *couponInfo = [[CouponInfoController alloc] init];
    [self.navigationController pushViewController:couponInfo animated:YES];
    [couponInfo setCouponData:dic];
}


- (IBAction)segmentControlInMyCoupon:(id)sender
{
    m_segmentSel = 3;
    [table_myCoupon reloadData];
    
    NSInteger index = [sender selectedSegmentIndex];
    m_segmentSel = index;
    
    //选择框隐藏显示，yes隐藏，no显示
    m_bDelete = NO;
    
    //此处清空选中数组数据
    [m_couponSelected removeAllObjects];
    
    //0 可用  1 无效
    switch (index)
    {
        case 0:
        {
            [self sendMyCouponUrl:0 sortType:m_sortType];
            [m_giveupBtn setTitle:@"丢弃" forState:UIControlStateNormal];
//            [UIView animateWithDuration:0.5 animations:^{
//                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:table_myCoupon cache:YES];
//            } completion:^(BOOL finished) {
//            }];
            break;
        }
        case 1:
        {
            [self sendMyCouponUrl:1 sortType:1];
            [m_giveupBtn setTitle:@"清空" forState:UIControlStateNormal];
//            [UIView animateWithDuration:0.5 animations:^{
//                [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:table_myCoupon cache:YES];
//            } completion:^(BOOL finished) {
//            }];
            break;
        }
        default:
            break;
    }
}


-(void)showBottomButton:(BOOL)bShow
{
    BOOL bHidden = !bShow;
    m_sortBtn.hidden = bHidden;
    m_giveupBtn.hidden = bHidden;
}



- (void)showAlertViewWithStr:(NSString *)str
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}


-(void)gotCoupons:(FMNetworkRequest *)request
{
    NSDictionary *dic = request.responseData;
    if (m_segmentSel == 0) {
        m_validCoupons = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"coupon_enable"]];
        if ([m_validCoupons count] == 0)
        {
//            [self showAlertViewWithStr:@"您还没有兑换优惠劵哦"];
            [self showBottomButton:NO];
        }
        else
        {
            [self showBottomButton:YES];
        }
    }
    else if(m_segmentSel == 1)
    {
        m_invalidCoupons = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"coupon_disable"]];
        
        if ([m_invalidCoupons count] == 0)
        {
            [self showBottomButton:NO];
        }
        else
        {
            [self showBottomButton:YES];
        }
    }
    else
    {
        list_coupons = [dic objectForKey:@"couponByDate"];
    }
    
    [m_couponSelected removeAllObjects];
    [table_myCoupon reloadData];
}


-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqual:kRequest_getMyCoupon]) {//我的优惠卷
        [self gotCoupons:fmNetworkRequest];
    }
    else if([fmNetworkRequest.requestName isEqualToString:KRequest_discardCoupon])
    {
        [self sendMyCouponUrl:m_segmentSel sortType:1];
        [m_giveupBtn setTitle:@"丢弃" forState:UIControlStateNormal];
        
        if (delegate && [delegate respondsToSelector:@selector(neeUpdateCouponData)])
        {
            [delegate neeUpdateCouponData];
        }
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if([fmNetworkRequest.requestName isEqualToString:KRequest_discardCoupon])
    {
        NSLog(@"----- delete failed ------");
    }
    else if ([fmNetworkRequest.requestName isEqual:kRequest_getMyCoupon])
    {
        [[PublicFunction ShareInstance] showRequestFailed];
        
        [self showBottomButton:YES];
    }
}

-(void)MenuSelect:(NSString *)selStr
{
    [m_sortBtn setTitle:selStr forState:UIControlStateNormal];
    
    [self MenuExit];
    
    if ([STR_SORT_BY_DEFAULT isEqualToString:selStr])
    {
        m_sortType = 1;
    }
    else if([STR_SORT_BY_TIMEOVER isEqualToString:selStr])
    {
        m_sortType = 2;
    }
    else if([STR_SORT_BY_STYLE isEqualToString:selStr])
    {
        m_sortType = 3;
    }
    
    m_curPage = 1;
    [self sendMyCouponUrl:m_segmentSel sortType:m_sortType];
}

-(void)MenuExit
{
    [m_sortView removeFromSuperview];
    m_sortView = nil;
}

//废弃优惠劵
-(void)giveupCoupon:(NSString *)index
{
    NSString *userId = [User shareInstance].id;
    NSString *carlist = nil;
    // 0 可用  1无效
    if (m_segmentSel == 0) {
        //删除多个
        NSMutableArray *templist = [NSMutableArray arrayWithCapacity:10];
        for (NSString *tagindex in m_couponSelected) {
            NSDictionary *dic = [m_validCoupons objectAtIndex:[tagindex integerValue]];
            NSString *cardId = [NSString stringWithFormat:@"%@", [dic objectForKey:@"no"]];
            [templist addObject:cardId];
        }
        carlist = [templist componentsJoinedByString:@","];
        m_bEmpty = NO;
    }
    else if(1 == m_segmentSel)
    {
        //删除全部
        NSMutableArray *templist = [NSMutableArray arrayWithCapacity:10];
        for (NSDictionary *tempdic in m_invalidCoupons) {
            NSString *cardId = [NSString stringWithFormat:@"%@", [tempdic objectForKey:@"no"]];
            [templist addObject:cardId];
        }
        carlist = [templist componentsJoinedByString:@","];
        m_bDelete = NO;
    }
    
    //发送请求
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    [[BLNetworkManager shareInstance] disCardCouponWithUserID:userId cardNo:carlist delegate:self];
}

//丢弃清空功能点击
- (IBAction)giveupBtnPressed:(id)sender {
    // 0 可用  1 无效
    if (m_segmentSel == 0) {
        if (NO == m_bDelete) {
            m_bDelete = YES;
            [table_myCoupon reloadData];
        }
        else
        {
            //没有选中，无任何操作
            if (m_couponSelected.count == 0) {
                return;
            }
            [self giveupCoupon:nil];
        }

    }else{
        if (m_invalidCoupons.count == 0) {
            return;
        }
        if (NO == m_bEmpty) {
            m_bEmpty = YES;
            [m_giveupBtn setTitle:@"确认清空" forState:UIControlStateNormal];
            return;
        }
        [self giveupCoupon:nil];
        m_bEmpty = NO;
    }
}

- (IBAction)sortBtnPressed:(id)sender {
    NSLog(@"sort Btn Pressed");
    
    if (m_sortView) {
        [m_sortView removeFromSuperview];
        m_sortView = nil;
    }
    else
    {
        UIButton *btn = (UIButton *)sender;
        NSInteger startX = MainScreenWidth/2;
        NSInteger startY = MainScreenHeight - 120 - btn.frame.size.height;
        NSInteger width = MainScreenWidth/2;
        NSInteger height = 120;
        CGRect tmpRect = CGRectMake(startX, startY, width, height);
        m_sortView = [[CouponSortMenuView alloc] initWithFrame:tmpRect];
        m_sortView.delegate = self;
        [self.view addSubview:m_sortView];
        [self.view bringSubviewToFront:m_sortView];
    }
}

//列表选择框click
-(void)checkBoxPressed:(id)sender
{
    UIButton *btn = sender;
    BOOL bSelected = btn.selected;
    
    if (m_couponSelected == nil) {
        m_couponSelected = [[NSMutableArray alloc] init];
    }
    
    NSString *strTag = [NSString stringWithFormat:@"%d", btn.tag];
    
    //为选中
    if (bSelected) {
        btn.selected = NO;
        [m_couponSelected removeObject:strTag];

    }
    else  //选中
    {
        btn.selected = YES;
        [m_couponSelected addObject:strTag];
    }
    
    //0 可用 1无效
    if (m_segmentSel== 0) {
        if ([m_couponSelected count] == 0) {
            [m_giveupBtn setTitle:@"丢弃" forState:UIControlStateNormal];
            return;
        }
        [m_giveupBtn setTitle:[NSString stringWithFormat:@"丢弃 (%d)",[m_couponSelected count]] forState:UIControlStateNormal];
    }
}


@end
