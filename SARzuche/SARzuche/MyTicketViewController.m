//
//  MyTicketViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyTicketViewController.h"
#import "MyTicketTableViewCell.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "Invoice.h"

#define  PAGESIZE  5



@implementation MyTicketViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"我的发票"];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    pTableView = [[CommonTableView alloc]initWithFrame:CGRectMake(0, 64,320,self.view.frame.size.height-64
                                                                  ) style:UITableViewStylePlain];
    
    pTableView.delegate = self;
    pTableView.dataSource = self;
    pTableView.m_delegate = self;
    pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:pTableView];
    
    pDataSource = [[NSMutableArray alloc] init];
    [self sendRequestToGetBranches];
}

// 根据经纬度,发送请求,获取网点列表
-(void)sendRequestToGetBranches
{
    // 根据经纬度获取网点列表
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getMyTicketByUserId:[User shareInstance].id
                                                                               pageNumber:@"1"
                                                                                 pageSize:@"5"
                                                                                 delegate:self];
    
    tempRequest = nil;
}

-(void)reloadViewWithData:(id)data
{
    //NSDictionary *dic = (NSDictionary *)data;
    //下拉刷新，请求第一页，先清空原数据
    //    if (_tableList.currentRefreshPos == EGORefreshHeader)
    //    {
    //        [_dataArr removeAllObjects];
    //    }
    //    [_dataArr addObjectsFromArray:[dic objectForKey:KEY_DATAARR]];
    //    //是否有更多
    //    [_tableList finishReloadingDataWithMore:[[dic objectForKey:KEY_ISMORE] boolValue]];
    if (pTableView.currentRefreshPos == EGORefreshHeader)
    {
        [pDataSource removeAllObjects];
    }
    
    [pDataSource addObjectsFromArray:data];
    NSString *totalNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalNumber"];

    if (pDataSource.count >= totalNumber.intValue)
    {
        [pTableView finishReloadingDataWithMore:NO ];
    }
    else
    {
        [pTableView finishReloadingDataWithMore:YES  ];
    }
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    MyTicketTableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTicketTableViewCell"
                                                     owner:self
                                                   options:nil];
        for(id obj in nib)
        {
            if([obj isKindOfClass:[MyTicketTableViewCell class]])
            {
                cell = (MyTicketTableViewCell *)obj ;
            }
        }
    }
    
    
    Invoice *aInvoice = [pDataSource  objectAtIndex:indexPath.row];
    //cell._name.text =aInvoice.recip_name;
    cell._name.text =aInvoice.invoice_title;

    cell._price.text = [NSString stringWithFormat:@"%@元",aInvoice.price];
    //地址
    NSString *location = [aInvoice.recip_address stringByReplacingOccurrencesOfString:@"+" withString:@""];
    cell._location.text = location;
    //时间
    NSString *time = aInvoice.apply_time;
    NSString *realTime = [[time stringByReplacingOccurrencesOfString:@"+" withString:@" "] substringToIndex:time.length-2];
    cell._time.text = realTime;
    //发票状态
    NSString *statuOfInvoice;
    if ([aInvoice.status isEqualToString:@"0"])
    {
        statuOfInvoice = @"待开票";
    }
    else
    {
        statuOfInvoice = @"已邮寄";
    }
    cell._state.text=statuOfInvoice;
    
    cell._orderID.text = aInvoice.order_id;
    NSString *postID;
    if (aInvoice.express_id.length == 0)
    {
    postID = [NSString stringWithFormat:@"%@",aInvoice.express_co];
    }
    else
    {
    postID = [NSString stringWithFormat:@"%@(%@)",aInvoice.express_co,aInvoice.express_id];
    }
    cell.postID.text = postID;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}
#pragma mark - CommonTableViewDelegate

/******************************************************************************
 函数名称  :pullUpAndDownRefreshDataWithInfoDic:
 函数描述  :上拉/下拉刷新
 输入参数  :1.infoDic:信息字典
 输出参数  : N/A
 返回值    : N/A
 备注      :	N/A
 ******************************************************************************/
- (void)pullUpAndDownRefreshDataWithInfoDic:(NSDictionary *)infoDic
{
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getMyTicketByUserId:[User shareInstance].id
                                                                               pageNumber:[infoDic objectForKey:KEY_CURRENTPAGE]
                                                                                 pageSize:[infoDic objectForKey:KEY_COUNT]
                                                                                 delegate:self];
    
    tempRequest = nil;
    
    //    // 根据经纬度获取网点列表
    //    FMNetworkRequest *reqBranches = [[BLNetworkManager shareInstance] getBranchListByPosition:@"31.980802" latitude:@"118.763257" pageNumber:[infoDic objectForKey:KEY_CURRENTPAGE] pagesize:[infoDic objectForKey:KEY_COUNT] delegate:self];
    //    reqBranches = nil;
}
#pragma mark -  UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (pTableView.refreshHeaderView)
    {
        [pTableView.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (pTableView.refreshFooterView)
    {
        [pTableView.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (pTableView.refreshHeaderView)
    {
        [pTableView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (pTableView.refreshFooterView)
    {
        [pTableView.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark - FMNetworkDelegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_MyTicket])
    {
        [self reloadViewWithData:fmNetworkRequest.responseData];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    NSLog(@" fm net work failed");
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_MyTicket])
    {
    }
}




@end
