//
//  MyAccountDetailViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyAccountDetailViewController.h"
#import "constString.h"
#import "MyAccountCellTableViewCell.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "ConstDefine.h"
#import "MyAccountFlow.h"
#import "FlowRecord.h"
#define TAG_LITTLETABLEVIEW  8
#define TAG_IMAGEVIEW        9
#define TAG_LABEL           10
#define TAG_IMAGEFLOW        11//流水按钮 小三角
#define TAG_FLOWSORT         12//流水分类

#define  PAGESIZE  10


@interface MyAccountDetailViewController ()

@end

@implementation MyAccountDetailViewController

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
    
    _isClose = YES;
    //流水 以及 小的下拉三角形
    UIView *titleView;
    if (IS_IOS7)
    {
       titleView = [[UIView alloc]initWithFrame:CGRectMake(100, 20, 220, 44)];
    }
    else
    {
        titleView = [[UIView alloc]initWithFrame:CGRectMake(100, 0, 220, 44)];
    }
    
    //流水
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 100, 30)];
    label.font = [UIFont systemFontOfSize:22.0f];
    label.tag  = TAG_FLOWSORT;
    label.text = STR_MYCENTER_DETAIL;
    label.textAlignment = NSTextAlignmentRight;
    label.textColor     = [UIColor whiteColor];
    label.backgroundColor = kNavBackgroundColor;
    [titleView addSubview:label];
    
    //流水按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(label.frame.size.width, 7, 30, 30);
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = TAG_IMAGEFLOW;
    [btn setImage:[UIImage imageNamed:@"myaccountflow_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showLittleTable:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    
    
    [self.view addSubview:titleView];
    
    
    //分类Table
    if (IOS_VERSION_ABOVE_7)
    {
        _littleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 200) style:UITableViewStylePlain];

    }
    else
    {
        _littleTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 200) style:UITableViewStylePlain];
    }
    _littleTable.hidden = YES;
    _littleTable.delegate = self;
    _littleTable.dataSource=self;
    _littleTable.backgroundColor = [UIColor whiteColor];
    _littleTable.scrollEnabled = NO;
    _littleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (IOS_VERSION_ABOVE_7)
    {
        pTableView = [[CommonTableView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStylePlain];
    }
    else
    {
        pTableView = [[CommonTableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44) style:UITableViewStylePlain];
    }
    
    pTableView.delegate = self;
    pTableView.dataSource = self;
    pTableView.m_delegate = self;
    pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:pTableView];
    
    pDataSource = [[NSMutableArray alloc] init];
    _type = @"1";//默认初始值
    [self getDatawithType:_type];
}
- (void)getDatawithType:(NSString *)type
{
    //“type”:流水类型 1全部 2充值 3提现 4消费
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getAccountDetailByUserId:[User shareInstance].id type:type
                                                                                      pageSize:[NSString stringWithFormat:@"%d", PAGE_COUNT]
                                                                                    pageNumber:@"1"
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
    NSString *totalNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"totalNumber2"];
    
    if (pDataSource.count >= totalNumber.intValue)
    {
        [pTableView finishReloadingDataWithMore:NO ];
    }
    else
    {
        [pTableView finishReloadingDataWithMore:YES  ];
    }
}


- (void)showLittleTable:(id)sender
{
    _isClose = !_isClose;
    if (_isClose)
    {
        UIButton *btn = (UIButton*)[self.view viewWithTag:TAG_IMAGEFLOW];
        [btn setImage:[UIImage imageNamed:@"myaccountflow_close"] forState:UIControlStateNormal];
        _littleTable.hidden =  YES;

    }
    else
    {
        [self.view addSubview:_littleTable];
        _littleTable.hidden =  NO;
        UIButton *btn = (UIButton*)[self.view viewWithTag:TAG_IMAGEFLOW];
        [btn setImage:[UIImage imageNamed:@"myaccountflow_open"] forState:UIControlStateNormal];
    }
   
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---UITableViewDataSource,delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_littleTable)
    {
        return 4;
    }
    else
    {
        return pDataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_littleTable)
    {
        return 44;
    }
    else
    {
    return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _littleTable)
    {
        NSArray *titles = @[@"全部",@"充值",@"提现",@"消费"];
        NSArray *imageNames = @[@"myaccountflow_all.png",@"myaccountflow_out.png",@"myaccoountflow_in.png",@"myaccount_consume.png"];
        MyAccountFlow *cell = nil;
        if (!cell)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyAccountFlow"
                                                         owner:self
                                                       options:nil];
            for(id obj in nib)
            {
                if([obj isKindOfClass:[MyAccountFlow class]])
                {
                    cell = (MyAccountFlow *)obj ;
                }
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row == 0)
        {
            cell.isChoose.hidden = NO;
        }
        cell.sortName.text =[titles objectAtIndex:indexPath.row];
        cell.sortImage.image = [UIImage imageNamed:imageNames[indexPath.row]];
        return cell;
    }
    else
    {
    MyAccountCellTableViewCell * cell2= nil;
    if (cell2==nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyAccountCellTableViewCell"
                                                     owner:self
                                                   options:nil];
        for(id obj in nib)
        {
            if([obj isKindOfClass:[MyAccountCellTableViewCell class]])
            {
                cell2 = (MyAccountCellTableViewCell *)obj ;
            }
        }
        cell2.backgroundColor = [UIColor clearColor];
        cell2.selectionStyle= UITableViewCellSelectionStyleNone;
        }
        
        FlowRecord *flow  = [pDataSource objectAtIndex:indexPath.row];
        //时间截取并展示
        NSString *time = flow.time;
        NSString *realTime=@"";
        if (time.length!=0)
        {
            realTime = [[time stringByReplacingOccurrencesOfString:@"+" withString:@" "] substringToIndex:flow.time.length-2];
        }
        cell2.time.text = realTime;
        //可用余额
        cell2.balance.text=[NSString stringWithFormat:@"可用余额%@元",flow.avaliable_amount];
        //充值金额
        float avaliableMoney = flow.avaliable_change.floatValue;
        NSString *change = @"";
        if (avaliableMoney>0)
        {
            if(       [flow.flow_type isEqualToString:@"充值"]
                    ||[flow.flow_type isEqualToString:@"财务扣款"]
                    ||[flow.flow_type isEqualToString:@"提现"]
              )
            {
                change = flow.avaliable_change;
            }
            else
            {
                change = flow.advance_change;
            }
            cell2.charage.text=[NSString stringWithFormat:@"+%@",change];
        }
        else
        {
          if(       [flow.flow_type isEqualToString:@"充值"]
                    ||[flow.flow_type isEqualToString:@"财务扣款"]
                    ||[flow.flow_type isEqualToString:@"提现"]
            )
            {
                change = flow.avaliable_change;
            }
            else
            {
                change = flow.advance_change;
            }
            cell2.charage.text=[NSString stringWithFormat:@"%@",change];
            cell2.charage.textColor = [UIColor orangeColor];
        }
        //充值方式    //1提现中 2成功 3失败
        NSString *style;
        NSString *withdraw;
        cell2.chargeStyle.text = flow.flow_type;
        if ([flow.withdraw_status isEqualToString:@"1"])
        {
            withdraw=@"申请提现";
        }
        if ([flow.withdraw_status isEqualToString:@"2"])
        {
            withdraw=@"申请提现成功";

        }
        if ([flow.withdraw_status isEqualToString:@"3"])
        {
            withdraw=@"申请提现失败";
        }
        if ([flow.flow_type isEqualToString:@"提现"]&& (withdraw.length!=0))
        {
            
            style = [NSString stringWithFormat:@"%@(%@)",flow.flow_type,withdraw];
        }
        else
        {
            style = flow.flow_type;
        }
        cell2.chargeStyle.text = style;
        return cell2;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_littleTable)
    {
        //发请求  查询
        _type = [NSString stringWithFormat:@"%d",indexPath.row+1];
        [self getDatawithType:_type];
        
        _littleTable.hidden=YES;
        UIButton *btn = (UIButton*)[self.view viewWithTag:TAG_IMAGEFLOW];
        [btn setImage:[UIImage imageNamed:@"myaccountflow_close"] forState:UIControlStateNormal];
        
        NSArray *titles = @[@"全部流水",@"充值流水",@"提现流水",@"消费流水"];
        //NSArray *titles = @[@"流水",@"充值",@"提现",@"消费"];

        UILabel *title = (UILabel *)[self.view viewWithTag:TAG_FLOWSORT];
        title.text = [titles objectAtIndex:indexPath.row];
        
        for (int index=0;index < 4; index++)
        {
            if (indexPath.row==index)
            {
                MyAccountFlow *cell =(MyAccountFlow*) [_littleTable cellForRowAtIndexPath:indexPath];
                cell.isChoose.hidden = NO;

            }
            else
            {
                NSIndexPath *indexpath2=[NSIndexPath indexPathForRow:index inSection:0];
                MyAccountFlow *cell =(MyAccountFlow*) [_littleTable cellForRowAtIndexPath:indexpath2];
                cell.isChoose.hidden = YES;
            }
        }
    }
    else
    {
    
    }

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
   
    FMNetworkRequest *tempRequest = [[BLNetworkManager shareInstance] getAccountDetailByUserId:[User shareInstance].id
                                                                                          type:_type
                                                                                      pageSize:[infoDic objectForKey:KEY_COUNT]
                                                                                    pageNumber:[infoDic objectForKey:KEY_CURRENTPAGE]
                                                                                      delegate:self];
    tempRequest = nil;

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



#pragma mark-DataComeBack

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [self reloadViewWithData:fmNetworkRequest.responseData];
}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{

}

@end
