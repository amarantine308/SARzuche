//
//  AllCarModelView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "AllCarModelView.h"
#import "PersonalCarInfoView.h"
#import "constString.h"
#import "ConstDefine.h"
#import "UIColor+Helper.h"

#define TAG_TABLEVIEW           10011

#define TAG_BASE_BUTTON                 100
#define FRAME_CAR_RENT_BTN              CGRectMake(230, 75, 60, 25)

#define FRAME_ZERO              CGRectMake(0, 0, m_allCarTable.frame.size.width, 0)
#define EGO_REFRESH_HEIGHT      40

@interface AllCarModelView()
{
    CommonTableView *m_allCarTable;
    
    NSInteger m_totalCars;
    NSMutableArray *m_carsArr;
    
    CGFloat m_cellWidth;
    CGFloat m_cellHeight;
    
    NSInteger m_prevItemCount;
    NSInteger m_tablecount;
}

@end

@implementation AllCarModelView
@synthesize m_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // Initialization code
        [self initCarModelView:frame];
    }
    return self;
}

-(void)initCarModelView:(CGRect)frame
{
    if (nil != m_allCarTable)
    {
        [m_allCarTable removeFromSuperview];
        m_allCarTable = nil;
    }
    
    // cell size
    m_cellWidth = frame.size.width;
    PersonalCarInfoView *tmpView = [[PersonalCarInfoView alloc] initWithFrame:CGRectMake(0, 0, m_cellWidth, 100)];
    m_cellHeight = tmpView.frame.size.height;
    tmpView = nil;
    
    m_allCarTable = [[CommonTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [m_allCarTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    m_allCarTable.delegate = self;
    m_allCarTable.dataSource = self;
    m_allCarTable.m_delegate = self;
    m_allCarTable.tag = TAG_TABLEVIEW;
    [self addSubview:m_allCarTable];
    
}

-(void)viewFrameChanged
{
    m_allCarTable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [m_allCarTable reloadData];
}


-(void)updateCars:(NSMutableArray *)arr totalNum:(NSInteger)numbers
{
    m_totalCars = numbers;
    if (nil == m_carsArr) {
        m_carsArr = [[NSMutableArray alloc] initWithArray:arr];
    }
    else
    {
        if (m_allCarTable.currentRefreshPos == EGORefreshHeader) {
            [m_carsArr removeAllObjects];
        }
        [m_carsArr addObjectsFromArray:arr];
    }
    
    m_tablecount = [m_carsArr count];
    
    if (m_tablecount >= m_totalCars)
    {
        [m_allCarTable finishReloadingDataWithMore:NO ];
    }
    else
    {
        [m_allCarTable finishReloadingDataWithMore:YES  ];
    }
    
    [m_allCarTable reloadData];
}

-(void)GetMoreData
{
    if (m_allCarTable.currentRefreshPos == EGORefreshHeader)
    {
        m_prevItemCount = 0;
        
        if (m_delegate && [m_delegate respondsToSelector:@selector(getMoreCar:)]) {
            [m_delegate getMoreCar:YES];
        }
        return;
    }
    NSLog(@"get more data");
    m_prevItemCount = m_tablecount;
    
    if (m_delegate && [m_delegate respondsToSelector:@selector(getMoreCar:)]) {
        [m_delegate getMoreCar:NO];
    }
//    [self performSelectorOnMainThread:@selector(FinishedLoadMoreData) withObject:nil waitUntilDone:YES];
}

-(void)toRentCar
{
    NSLog(@"TO RENT CAR");
}



#pragma mark - UIScrollViewDelegate Methods

//滚动响应，当用户在滚动视图中拉动的时候就会被触发（这里是指table中拉动）

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (m_allCarTable.refreshHeaderView)
    {
        [m_allCarTable.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    if (m_allCarTable.refreshFooterView)
    {
        [m_allCarTable.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (m_allCarTable.refreshHeaderView)
    {
        [m_allCarTable.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    if (m_allCarTable.refreshFooterView)
    {
        [m_allCarTable.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_carsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *allCarModeIdentify = @"allCarModeIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allCarModeIdentify];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:allCarModeIdentify];
    }
    
    for(UIView * subView in [cell.contentView subviews])
    {
        [subView removeFromSuperview];
    }
    
    PersonalCarInfoView *tmpView = [[PersonalCarInfoView alloc] initWithFrame:CGRectMake(0, 0, m_cellWidth, m_cellHeight)];
    if (m_carsArr && ([m_carsArr count] >= indexPath.row)) {
        NSDictionary *tmpCar = [m_carsArr objectAtIndex:indexPath.row];
        NSString *strModel = [[NSString alloc] initWithFormat:@"%@", [tmpCar objectForKey:@"model"]];
        NSString *resModel = [strModel stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        
        NSString *strTmp = [[NSString alloc] initWithFormat:@"%@",[tmpCar objectForKey:@"plateNum"]];
        NSString *resPlateNum = [strTmp stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        [tmpView setselectCarWithUnitPrice:GET([tmpCar objectForKey:@"unitPrice"])
                     dayPrice:GET([tmpCar objectForKey:@"dayPrice"])
                     carModel:GET(resModel)
                     carSerie:GET([tmpCar objectForKey:@"carseries"])
                     carPlate:GET(resPlateNum)
                     discount:GET([tmpCar objectForKey:@"activePrice"])
                     imageUrl:GET([tmpCar objectForKey:@"carFile"])];
    }
    cell.userInteractionEnabled = YES;
    
    UIButton *toRentCar = [[UIButton alloc] initWithFrame:FRAME_CAR_RENT_BTN];
    [toRentCar setTitle:STR_TO_RENT forState:UIControlStateNormal];
    toRentCar.backgroundColor = COLOR_LABEL_BLUE;//[UIColor grayColor];
    toRentCar.tag = indexPath.row + TAG_BASE_BUTTON;
    toRentCar.userInteractionEnabled = YES;
    [toRentCar addTarget:self action:@selector(toOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:tmpView];
    [cell.contentView addSubview:toRentCar];
    cell.backgroundColor = COLOR_BACKGROUND;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return (self.frame.size.height / 3);
    return m_cellHeight+ 5;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row");
}
#pragma mark - PersonalCarInfoDelegate
-(void)toOrder:(id)sender
{
    UIButton *btn = sender;
    
    if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(toOderCar:)]) {
        [self.m_delegate toOderCar:(btn.tag - TAG_BASE_BUTTON)];
    }
}

- (void)pullUpAndDownRefreshDataWithInfoDic:(NSDictionary *)infoDic
{
    [self GetMoreData];
}

@end
