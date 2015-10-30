//
//  HistoryOrdersView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HistoryOrdersView.h"


#define FRAME_ZERO              CGRectMake(0, 0, m_historyTable.frame.size.width, 0)
#define EGO_REFRESH_HEIGHT      40

@implementation HistoryOrdersView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHistoryView];
        self.userInteractionEnabled = YES;
    }
    return self;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)initHistoryView
{
    m_historyTable = [[CommonTableView alloc] initWithFrame:self.frame];
    m_historyTable.delegate = self;
    m_historyTable.dataSource = self;
    m_historyTable.m_delegate = self;
    m_historyTable.userInteractionEnabled = YES;
    m_historyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:m_historyTable];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectOrderWithIndex:(NSInteger)index
{
    NSLog(@" select order %d", index);
    if (delegate && [delegate respondsToSelector:@selector(selectOrder:)]) {
        [delegate selectOrder:index];
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
-(void)showPayInfo:(NSInteger)index
{
    if (delegate && [delegate respondsToSelector:@selector(showPayInfo:)]) {
        [delegate showPayInfo:index];
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
-(void)updateOrderList:(OrderListData *)orderList
{
//    if (m_tableType == tableBlock || m_historyTable.currentRefreshPos == EGORefreshHeader) {
//        [m_dataArray removeAllObjects];
//    }
    if (nil == orderList) {
        m_historyTable.hidden = YES;
        NSLog(@"history order list is nil");
        return;
    }
    
    m_orderListData = orderList;
    
    m_tablecount = [m_orderListData getOrderListDataNum];
    m_totalsItem = [m_orderListData getOrderListTotalNum];
    
    if (m_tablecount >= m_totalsItem) {
        [m_historyTable finishReloadingDataWithMore:NO];
    }
    else
    {
        [m_historyTable finishReloadingDataWithMore:YES];
    }
    
    if(m_tablecount == 0)
    {
        m_historyTable.hidden = YES;
    }
    else
    {
        m_historyTable.hidden = NO;
    }
}
#pragma mark - tableview delegate
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{// 1生效 2取消 3租金结算 4全部结算 5续订 6延时
    srvOrderData *data = [m_orderListData orderDataAtIndex:indexPath.row];
    NSInteger nStatus = [data.m_status integerValue];
    CGFloat fCellHeight = 235.0;
    switch (nStatus) {
        case 5:
            fCellHeight = 260.0;
            break;
            
        default:
            fCellHeight = 235.0;
            break;
    }
    
    return fCellHeight;
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [m_orderListData getOrderListDataNum];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectOrderWithIndex:indexPath.row];
}

/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *historyOrderCellIdentify = @"historyOrdersCell";
    HistoryOrdersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyOrderCellIdentify];
    if (nil == cell)
    {
        cell = [[HistoryOrdersViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:historyOrderCellIdentify];
    }
    else
    {
        [cell removeAllSubView];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    [cell setOrderData:[m_orderListData orderDataAtIndex:indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - EGORefreshTableHeaderView


/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)GetMoreData
{
    if (m_tablecount >= [m_orderListData getOrderListTotalNum])
    {
        [m_historyTable finishReloadingDataWithMore:NO];
        return;
    }
    
    
    if (delegate && [delegate respondsToSelector:@selector(GetHistoryMoreData:)])
    {
        if (m_historyTable.currentRefreshPos == EGORefreshHeader)
        {
                [m_orderListData removeAll];
                [delegate GetHistoryMoreData:YES];
            
            return;
            }
        else
        {
            [delegate GetHistoryMoreData:NO];
        }
    }
}


#pragma mark - UIScrollViewDelegate Methods
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (m_historyTable.refreshHeaderView)
    {
        [m_historyTable.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (m_historyTable.refreshFooterView)
    {
        [m_historyTable.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
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
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (m_historyTable.refreshHeaderView)
    {
        [m_historyTable.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (m_historyTable.refreshFooterView)
    {
        [m_historyTable.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
    [self GetMoreData];
}


@end
