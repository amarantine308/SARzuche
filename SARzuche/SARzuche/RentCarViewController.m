//
//  RentCarViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RentCarViewController.h"
#import "RentCarCell.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "RentCarView.h"
#import "ConstDefine.h"
#import "PublicFunction.h"

@interface RentCarViewController ()

@end

@implementation RentCarViewController

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
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"企业租车意向"];
    }
    
    _table = [[CommonTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.m_delegate = self;
    _table.backgroundColor = [UIColor clearColor];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    //添加意向详情
    [self loadRentCarInfoView ];
    
    list_tenancy = @[@"一周以内",@"一个月以内",@"三个月以内",@"半年以内",@"一年以内",@"一年以上"];
    [self sendRequest];
    list_intensionlist = [[NSMutableArray alloc] init];

}
-(void)sendRequest
{
    // 根据经纬度获取网点列表
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getCompanyListUserID:[User  shareInstance].id pageNumber:@"1" pageSize:@"5" delegate:self];
    tempRequest=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---UITableViewDataSource,UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 228;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list_intensionlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RentCarCell";
    RentCarCell * cell= [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RentCarCell"
                                                     owner:self
                                                   options:nil];
        for(id obj in nib)
        {
            if([obj isKindOfClass:[RentCarCell class]])
            {
                cell = (RentCarCell *)obj ;
                cell.delegate = self;
            }
        }
    }
    NSDictionary *dic = [list_intensionlist objectAtIndex:indexPath.row];
    
    cell.lab_intentce.text = [NSString stringWithFormat:@"意向%d",indexPath.row+1];
    cell.lab_car_brand.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"brand"]];
    cell.lab_car_series.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"carseries"]];
    cell.lab_car_num.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"carNum"]];
    NSInteger tenancyInt = [GET([dic objectForKey:@"tenancytime"]) integerValue];
    cell.lab_cycle.text = [list_tenancy objectAtIndex:tenancyInt];
    cell.lab_submit_time.text = [[PublicFunction ShareInstance] getYMDHMString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"createdate"]]];
//    cell.lab_take_time.text = [[PublicFunction ShareInstance] getYMDHMString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"getTime"]]];
    cell.lab_take_time.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"getTime"]];
    cell.btn_showInfo.tag = 101+indexPath.row;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
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
    if (_table.currentRefreshPos == EGORefreshHeader)
    {
        [list_intensionlist removeAllObjects];
    }
    
    [list_intensionlist addObjectsFromArray:data];
    if (list_intensionlist.count >= _totalCount.intValue)
    {
        [_table finishReloadingDataWithMore:NO ];
    }
    else
    {
        [_table finishReloadingDataWithMore:YES  ];
    }
}

#pragma  mark-dataComeBack
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
//    NSLog(@"fmNetworkRequest:%@",fmNetworkRequest.re);
    if ([fmNetworkRequest.requestName isEqualToString:KRequest_getEnterpriseList])
    {
        [self reloadViewWithData:[fmNetworkRequest.responseData objectForKey:@"cons"]];
    }
    _totalCount = [fmNetworkRequest.responseData objectForKey:@"totalNumber"];
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    
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
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getCompanyListUserID:[User  shareInstance].id
                                                                                pageNumber:[infoDic objectForKey:KEY_CURRENTPAGE] pageSize:[infoDic objectForKey:KEY_COUNT] delegate:self];
    
    tempRequest=nil;

}
#pragma mark -  UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_table.refreshHeaderView)
    {
        [_table.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (_table.refreshFooterView)
    {
        [_table.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_table.refreshHeaderView)
    {
        [_table.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (_table.refreshFooterView)
    {
        [_table.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark - 企业租车意向协议方法
//next方法协议
- (void)rentCarInfo:(NSInteger)index
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[list_intensionlist objectAtIndex:index-1]];
    [dic setObject:[NSNumber numberWithInteger:index] forKey:@"rentNumber"];
    vi_rentCar.dic_rent = dic;
    [vi_rentCar.table_rentCar reloadData];
    vi_rentCar.hidden = NO;
}

- (void)hidenRentCarView
{
    vi_rentCar.hidden = YES;
}

- (void)loadRentCarInfoView
{
    vi_rentCar = [[RentCarView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    vi_rentCar.delegate = self;
    vi_rentCar.hidden = YES;
    [self.view addSubview:vi_rentCar];
}

@end
