//
//  IntensionCarView.m
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "IntensionCarView.h"
#import "IntensionCarInfoView.h"
#import "FMNetworkManager.h"
#import "BLNetworkManager.h"

#define RGB(r,g,b,al) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]
#define CELL_HEIGHT 44
#define HEADER_HEIGHT 24

@implementation IntensionCarView
@synthesize carDataSource;
@synthesize carTableView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        isload = NO;
        
        self.backgroundColor = RGB(236, 234, 241, 1);
        
        carDataSource = [[NSMutableArray alloc] init];
        
        float lettersViewWidth = 20;
        carTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        carTableView.delegate = self;
        carTableView.dataSource = self;
        carTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:carTableView];
        
        // 去掉多余的行
        UIView *foot = [[UIView alloc] init];
        [carTableView setTableFooterView:foot];
        
        float carInfoViewWidth = 220;
        carInfoView = [[IntensionCarInfoView alloc] initWithFrame:CGRectMake(self.bounds.size.width - carInfoViewWidth, 0, carInfoViewWidth, self.bounds.size.height)];
        [self addSubview:carInfoView];
        carInfoView.hidden = YES;
        
        lettersBackView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - lettersViewWidth, 0, lettersViewWidth, self.bounds.size.height)];
        [self addSubview:lettersBackView];
        
        float btnWidth = 20;
        float btnHeight = 15;
        float originY = 25;
        lettersArray = [[NSMutableArray alloc] initWithObjects:@"★",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#",nil];
        
        int count = [lettersArray count];
        for (int i = 0; i < count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100 + i;
            btn.frame = CGRectMake(0, originY + btnHeight * i, btnWidth, btnHeight);
            [btn setTitle:[lettersArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(43, 133, 208, 1) forState:UIControlStateNormal];
            [btn setBackgroundColor:RGB(247, 247, 247, 0.8)];
            btn.titleLabel.font =[UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(letterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [lettersBackView addSubview:btn];
        }
        
        currentLetter = [lettersArray objectAtIndex:1];
    }
    return self;
}


//- (void)initAccess
-(void)addLetterView
{
    float btnWidth = 20;
    float btnHeight = 15;
    float originY = 25;
    int count = [lettersArray count];
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        btn.frame = CGRectMake(0, originY + btnHeight * i, btnWidth, btnHeight);
        [btn setTitle:[lettersArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(43, 133, 208, 1) forState:UIControlStateNormal];
        [btn setBackgroundColor:RGB(247, 247, 247, 0.8)];
        btn.titleLabel.font =[UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(letterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [lettersBackView addSubview:btn];
    }
}



#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_lettersInSection count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	return [m_lettersInSection objectAtIndex:section];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *vi_header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    vi_header.backgroundColor = RGB(236, 235, 241, 1);
    
    UILabel *letterLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, HEADER_HEIGHT)];
    letterLabel.text = [m_lettersInSection objectAtIndex:section];
    letterLabel.font = [UIFont systemFontOfSize:15];
    letterLabel.textColor = RGB(135.0, 135.0, 137.0, 1);
    [vi_header addSubview:letterLabel];
    
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, vi_header.frame.size.height-0.50, tableView.frame.size.width, 0.50)];
    spaceView.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:213.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
    [vi_header addSubview:spaceView];
    
    return vi_header;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isload)
    {
        NSDictionary *dic_cars = [carDataSource objectAtIndex:section];
        return [[dic_cars objectForKey:@"items"] count];
    }
    else
    {
        return [carDataSource count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"IntensionCarViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    for (UIView *subView in cell.contentView.subviews)
//    {
//        [subView removeFromSuperview];
//    }
    
    if (isload)
    {
        NSDictionary *dic_cars = [carDataSource objectAtIndex:indexPath.section];
        NSArray *list_cars = [dic_cars objectForKey:@"items"];
        cell.textLabel.text = [list_cars objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"helvetica" size:15];
    }
    else
    {
        cell.textLabel.text = [carDataSource objectAtIndex:indexPath.row];
    }
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-0.50, cell.bounds.size.width, 0.50)];
    spaceView.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:213.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
    [cell.contentView addSubview:spaceView];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect tablerect = CGRectMake(0, 0, 100, self.bounds.size.height);
    carTableView.frame = tablerect;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *brand = cell.textLabel.text;
    FMNetworkRequest *companyReq = [[BLNetworkManager shareInstance] getCompanyCarTypeListByBrand:brand delegate:self];
    companyReq = nil;
}

#pragma mark - 按钮点击事件
-(void)letterBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger nSel = btn.tag - 100;
    NSString *selStr = [lettersArray objectAtIndex:nSel];
    if ([currentLetter isEqualToString:selStr])
    {
        return;
    }

    NSInteger section = 0;//[m_lettersInSection ]
    for (NSInteger i = 0; i < [m_lettersInSection count]; i++)
    {
        NSString *tmpStr = [m_lettersInSection objectAtIndex:i];
        if ([selStr isEqualToString:tmpStr])
        {
            section = i;
            currentLetter = tmpStr;
            break;
        }
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    [carTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)updateTableView:(NSDictionary *)dic
{
    isload = YES;
    if (nil == m_lettersInSection)
    {
        m_lettersInSection = [[NSMutableArray alloc] init];
    }
    else
    {
        [m_lettersInSection removeAllObjects];
    }
//    [lettersArray removeAllObjects];
    [carDataSource removeAllObjects];
    NSArray *keys = [dic allKeys];
    //对keys按照字母顺序进行排序
    NSArray *resultArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //根据字典，刷新lettersArray and carDataSource 数据
    for (NSString *str in resultArray) {
        [m_lettersInSection addObject:[str uppercaseString]];
        NSArray *termplist = [dic objectForKey:str];
        NSMutableDictionary *dic_temp = [NSMutableDictionary dictionaryWithObjectsAndKeys:termplist,@"items", nil];
        [carDataSource addObject:dic_temp];
    }
    //刷新表哥
    [carTableView reloadData];
    
#if 0
    for (UIView *subview in lettersBackView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self addLetterView];
#endif
}

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    //根据汽车品牌选择车系
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCompanyCarTypeList])
    {
        NSArray *carseries = [fmNetworkRequest.responseData objectForKey:@"carseries"];
        [carInfoView reloadData:carseries];
        carInfoView.hidden = NO;
        lettersBackView.hidden = YES;
    }
}

@end
