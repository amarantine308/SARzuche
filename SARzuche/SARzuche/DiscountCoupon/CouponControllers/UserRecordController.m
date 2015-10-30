//
//  UserRecordController.m
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "UserRecordController.h"
#import "UserRecordCell.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "PublicFunction.h"
#import "OrderManager.h"
#import "ViewSelectOrderViewController.h"

#define RGB(r,g,b,al) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]

@interface UserRecordController ()
{
    srvOrderData* m_orderData;
}

@end

@implementation UserRecordController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

- (void)sendUserRecordUrl
{
    NSString *userid = [User shareInstance].id;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    //并行执行一
    dispatch_group_async(group, queue, ^{
//        优惠卷使用统计
        FMNetworkRequest *userRecord_request = [[BLNetworkManager shareInstance] getCouponStatisticsWithUserId:userid delegate:self];
        userRecord_request = nil;
    });
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
//    并行执行二
    dispatch_group_async(group, queue, ^{
        //优惠卷使用记录
        FMNetworkRequest *request = [[BLNetworkManager shareInstance] getCouponUseRecordWithUserId:userid takeTime:@"" givebackTime:@"" delegate:self];
        request = nil;
    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"使用记录"];
    }
    //发送使用记录请求
    [self sendUserRecordUrl];
    
    vi_bottom.backgroundColor = RGB(43, 133, 208, 1);
}


#pragma mark - UItableviewDelegate协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list_coupons count];
}

- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 109;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserRecordCell *cell = nil;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserRecordCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *dic = [list_coupons objectAtIndex:indexPath.row];
    NSString *strCost = [[PublicFunction ShareInstance] checkAndFormatMoeny:GET([dic objectForKey:@"savemoney"])];
    cell.lab_savemoney.text = [NSString stringWithFormat:STR_COST_FORMAT, strCost];
    NSString *time = [[PublicFunction ShareInstance] getYMDHMString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"paytime"]]];
        cell.lab_paytime.text = [NSString stringWithFormat:@"结算时间: %@",time];
    cell.lab_orderNo.text = [NSString stringWithFormat:@"订单号: %@",GET([dic objectForKey:@"orderno"])];;
    cell.lab_couponName.text = GET([dic objectForKey:@"couponName"]);
    cell.btn_click.tag = indexPath.row;
    [cell.btn_click addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


-(void)reqOrderData:(NSString *)orderId
{
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getOrderInfo:orderId delegate:self];
    req = nil;
}

//前往我的订单页面
- (void)clickButtonAction:(UIButton *)sender
{
    NSInteger index = sender.tag;
    NSDictionary *coupondic = [list_coupons objectAtIndex:index];
//    NSLog(@"coupongdic:%@",coupondic);
    NSLog(@"%@",[coupondic objectForKey:@"orderId"]);
    [self reqOrderData:GET([coupondic objectForKey:@"orderId"])];
    
}


-(void)toOrderView
{
    ViewSelectOrderViewController *tmpController = [[ViewSelectOrderViewController alloc]initWithOrder:m_orderData];
    [self.navigationController pushViewController:tmpController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-fmNetworkFinished协议方法
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    /**/
    [[LoadingClass shared] hideLoadingForMoreRequest];
    if ([fmNetworkRequest.requestName isEqual:kRequest_getCouponUseRecord])
    {
        list_coupons = [fmNetworkRequest.responseData objectForKey:@"couponRecordLists"];
        [table_useRecord reloadData];
    }else if ([fmNetworkRequest.requestName isEqual:kRequest_getOrderInfo]){
        m_orderData = [[srvOrderData alloc] initWithOriginalData:fmNetworkRequest.responseData];
        [self toOrderView];
    }
    else
    {
        //优惠卷使用统计
        NSDictionary *dic = [fmNetworkRequest.responseData objectForKey:@"couponStatistics"];
        NSString *fee = GET([dic objectForKey:@"totalfee"]);
        if ([fee isEqualToString:@""]) {
            fee = @"0";
        }
        NSString *strFee = [[PublicFunction ShareInstance] checkAndFormatMoeny:[NSString stringWithFormat:@"%.2f",[fee doubleValue]]];
        lab_saveMoney.text = [NSString stringWithFormat:STR_COST_FORMAT,strFee];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
}

@end
