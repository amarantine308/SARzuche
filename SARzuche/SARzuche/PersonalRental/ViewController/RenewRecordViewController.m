//
//  RenewRecordViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RenewRecordViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "RenewRecordCell.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"

#define FRAME_RECORD_TABLE      CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight -controllerViewStartY)

@interface RenewRecordViewController ()
{
    UITableView *m_recordsTable;
    
    srvOrderData *m_orderData;
    NSArray *m_renewList;
    BOOL m_bFromHistory;
    
    FMNetworkRequest *m_renewReq;
}

@end

@implementation RenewRecordViewController

-(id)initForHistoryRecord:(srvOrderData *)orderData
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        m_bFromHistory = YES;
        m_orderData = orderData;
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
    [self initRenewRecordsView];
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
    if (m_bFromHistory) {
        [self getRenewList];
    }
    else
    {
        m_orderData = [[OrderManager ShareInstance] getCurrentOrderData];
        m_renewList = [[OrderManager ShareInstance] getOrderRenewList];
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
-(void)getRenewList
{
    if (nil == m_orderData) {
        NSLog(@"no order data");
        return;
    }
    
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    
    m_renewReq = [[BLNetworkManager shareInstance] repeatOrderList:m_orderData.m_orderId  delegate:self];
}


-(void)dealloc
{
    CANCEL_REQUEST(m_renewReq);
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
        [customNavBarView setTitle:STR_RENEW_RECORD];
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
-(void)initRenewRecordsView
{
    m_recordsTable = [[UITableView alloc] initWithFrame:FRAME_RECORD_TABLE];
    m_recordsTable.delegate = self;
    m_recordsTable.dataSource = self;
    m_recordsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_recordsTable];
}


/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void) initRenewOrderInfo:(FMNetworkRequest *)fmNetworkRequest
{
    NSDictionary *dic = fmNetworkRequest.responseData;
    
    NSArray *data = [dic objectForKey:@"renewOrderList"];
    if (data == nil || [data count] == 0) {
        return;
    }
    
    NSMutableArray *tmpRenewArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [data count]; i++) {
        srvRenewData *tmpRnewData = [[srvRenewData alloc] init];
        [tmpRnewData setRenewData:[data objectAtIndex:i]];
        [tmpRenewArr addObject:tmpRnewData];
    }
    
    m_renewList = [[NSArray alloc] initWithArray:tmpRenewArr];
    
    [m_recordsTable reloadData];
    NSDictionary *renewDic = [data objectAtIndex:[data count]-1];
    NSString * renewTime = [renewDic objectForKey:@"newtime"];
    
    NSLog(@"%@", renewTime);
}
#pragma mark - table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [m_renewList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *renewRecordIdentify = @"renewRecordIdentify";
    RenewRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:renewRecordIdentify];
    if (nil == cell) {
        cell = [[RenewRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:renewRecordIdentify];
    }
    [cell setRnewRecordCellData:[m_renewList objectAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -FMNetworkRequest delegate
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_repeatOrderList])
    {
        [self initRenewOrderInfo:fmNetworkRequest];
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
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
}

@end
