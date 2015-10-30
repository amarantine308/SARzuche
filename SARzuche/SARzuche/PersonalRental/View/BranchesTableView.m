//
//  BranchesTableView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchesTableView.h"
#import "PublicFunction.h"
#import "EGORefreshTableHeaderView.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "BranchDataManager.h"

#define BRANCHES_CELL_HEIGHT      (45.0)
#define BRANCHES_HEADER_HEIGHT      (20.0)

#define FRAME_ZERO              CGRectMake(0, 0, m_table.frame.size.width, 0)

#define DEFAULT_AREA            @"浦口区"

// image
#define IMG_BRANCE_BACKGROUND       @"block_background.png"
#define IMG_CELL_BACKGROUND         @"block_selected.png"


@interface BranchesTableView()
{
    CommonTableView *m_table;
    
    NSString * m_lat;
    NSString * m_lon;
    NSMutableArray *m_dataArray;
    
    NSString *m_selBlock;
    NSString *m_oldSelBlock;
    
    NSInteger m_tablecount;
    NSInteger m_prevItemCount;
    NSInteger m_totals;
}

@end


@implementation BranchesTableView
@synthesize m_tableType;
@synthesize m_totalsItem;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame forBlock:(branchesViewType)type
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        m_tableType = type;
        [self initTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor clearColor];
        [self initTableView];
    }
    return self;
}


-(void)initTableView
{
    m_table = [[CommonTableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.m_delegate = self;
    [m_table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [m_table setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_BRANCE_BACKGROUND]]];
    [self addSubview:m_table];
    
}
/**
 *方法描述：设置gps位置
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setPosition:(CLLocationDegrees)latitude withLon:(CLLocationDegrees)longitude
{
    m_lat = [NSString stringWithFormat:@"%.6f",latitude];
    m_lon = [NSString stringWithFormat:@"%.6f",longitude];
    
    [m_table reloadData];
}
/**
 *方法描述：设置表数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)searchTableData:(NSArray *)dataArray
{
    if (nil == m_dataArray) {
        m_dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    }
    else
    {
        [m_dataArray removeAllObjects];
        [m_dataArray addObjectsFromArray:dataArray];
    }
    
    m_tablecount = [m_dataArray count];
    
    [m_table reloadData];
    
    if (m_tablecount >= m_totalsItem) {
        [m_table finishReloadingDataWithMore:NO];
    }
    else
    {
        [m_table finishReloadingDataWithMore:YES];
    }
}
/**
 *方法描述：设置表数据
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setTableData:(NSArray *)dataArray
{
    if (nil == m_dataArray) {
        m_dataArray = [[NSMutableArray alloc] initWithArray:dataArray];
    }
    else
    {
        if (m_tableType == tableBlock || m_table.currentRefreshPos == EGORefreshHeader) {
            [m_dataArray removeAllObjects];
        }
        [m_dataArray addObjectsFromArray:dataArray];
    }
    
    m_tablecount = [m_dataArray count];

    [m_table reloadData];
    
    if (m_tablecount >= m_totalsItem) {
        [m_table finishReloadingDataWithMore:NO];
    }
    else
    {
        [m_table finishReloadingDataWithMore:YES];
    }
}


-(void)getMoreRequestFailed
{
    if (m_tablecount >= m_totalsItem) {
        [m_table finishReloadingDataWithMore:NO];
    }
    else
    {
        [m_table finishReloadingDataWithMore:YES];
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
-(NSInteger)getHighlightIndex
{
    NSInteger nCount = [m_dataArray count];
    for (NSInteger i = 0; i < nCount; i++)
    {
        if ([STR_NEAR_BRANCHES isEqualToString:[m_dataArray objectAtIndex:i]])
        {
            return i;
        }
             
        if ([STR_USED_BRANCHES isEqualToString:[m_dataArray objectAtIndex:i]]) {
            return i;
        }
        
        if ([DEFAULT_AREA isEqualToString:[m_dataArray objectAtIndex:i]])
        {
            return i;
        }
    }
    
    return 0;
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setTableData:(NSArray *)dataArray withBlock:(NSString *)blockName
{
    NSLog(@"----------%@", GET(blockName));
    m_selBlock = blockName;
    
    [self setTableData:dataArray];
    
    if (m_tableType == tableBlock)
    {
        if (/*nil == blockName &&*/ ([dataArray count] > 0))
        {
            NSInteger nDefault = [self getHighlightIndex];
            NSIndexPath *index = [NSIndexPath indexPathForRow:nDefault inSection:0];
            [m_table selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
            m_selBlock = [dataArray objectAtIndex:nDefault];
            if (delegate && [delegate respondsToSelector:@selector(selBlock:)])
            {
                [delegate selBlock:m_selBlock];
            }
        }
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
-(void)setSelBlock:(NSString *)blockName
{
    m_selBlock = blockName;
    [m_table reloadData];
}
/**
 *方法描述：
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)selectBranche:(NSDictionary *)selBrancheData
{
    NSLog(@"select branche");
    if (delegate && [delegate respondsToSelector:@selector(selBranche:)])
    {
        [delegate selBranche:selBrancheData];
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
-(void)selBlock:(NSString *)selBlockName
{
    NSLog(@"sel block");
    if (delegate && [delegate respondsToSelector:@selector(selBlock:)])
    {
        [delegate selBlock:selBlockName];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [m_dataArray count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *branchesIdentify = @"branchesIdentify";
    BranchesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:branchesIdentify];

    if (nil == cell) {
        cell = [[BranchesTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:branchesIdentify];
    }
    
    [cell setCellForBlock:self.m_tableType];
    if (m_tableType == tableBlock) {
        [cell setBlockName:[m_dataArray objectAtIndex:indexPath.row]];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        UIImageView *tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_CELL_BACKGROUND]];
        [cell setSelectedBackgroundView:tmpView];
    }
    else
    {
        NSDictionary *tmpData = [m_dataArray objectAtIndex:indexPath.row];
        if (nil != tmpData) {
            [cell setBrancheName:[tmpData objectForKey:@"name"]];
            [cell setBrancheAddress:[tmpData objectForKey:@"address"]];
            NSString *tmpLon = [tmpData objectForKey:@"longitude"];
            NSString *tmpLat = [tmpData objectForKey:@"latitude"];
            if (m_lat && m_lat) {
                CLLocationDistance nDis = [[PublicFunction ShareInstance] getDistance:m_lon lat1:m_lat lon2:tmpLon lat2:tmpLat];
                NSString *dist = [NSString stringWithFormat:@"%.1f Km", nDis];
                [cell setDistance:dist];
//                NSLog(@"%@ / %@ / %@: %@ %@", [tmpData objectForKey:@"name"], [tmpData objectForKey:@"address"], dist, m_lon, m_lat);
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    
    if (m_tableType == tableSearch || m_tableType == tableBlock) {
        return nil;
    }

    return (m_selBlock == nil) ? @"" : m_selBlock;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BRANCHES_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
    if (m_tableType == tableSearch || m_tableType == tableBlock){
        return 0;
    }
    return BRANCHES_HEADER_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select ");
    
    if (m_tableType == tableBlock) {
        m_oldSelBlock = [NSString stringWithFormat:@"%@", m_selBlock];
        m_selBlock = [m_dataArray objectAtIndex:indexPath.row];
        if ([m_oldSelBlock isEqualToString:m_selBlock]) {
            return;
        }
       [self selBlock:m_selBlock];
    }
    else
    {
        [self selectBranche:[m_dataArray objectAtIndex:indexPath.row]];
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
-(void)GetMoreData
{
    m_prevItemCount = m_tablecount;
    
    if(m_table.currentRefreshPos == EGORefreshHeader)
    {
        if (delegate && [delegate respondsToSelector:@selector(regetData:)])
        {
            [delegate regetData:m_tableType];
        }
    }
    else
    {
        if (delegate && [delegate respondsToSelector:@selector(getMoreDate:)])
        {
            [delegate getMoreDate:m_tableType];
        }
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
-(void)FinishedLoadMoreData
{
    NSLog(@"get more data");
    [m_table reloadData];
    
    
    if (m_prevItemCount >= 1) {
        NSIndexPath* row = [NSIndexPath indexPathForRow:m_prevItemCount - 1 inSection:0];
        [m_table scrollToRowAtIndexPath:row atScrollPosition:UITableViewScrollPositionNone animated:NO];
        
    }
    
}

#pragma mark -  UIScrollViewDelegate Methods
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
	if (m_table.refreshHeaderView)
    {
        [m_table.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (m_table.refreshFooterView)
    {
        [m_table.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
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
    if (m_table.refreshHeaderView)
    {
        [m_table.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (m_table.refreshFooterView)
    {
        [m_table.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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
