//
//  LocationViewController.m
//  SARzuche
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "LocationViewController.h"
#import "ConstDefine.h"

#define Height_TextField        30.0
#define OriginX_TextField       OriginX_AddressImageView + Width_AddressImageView + 10

#define Width_AddressImageView      26.0 / 2.0
#define Height_AddressImageView     26.0 / 2.0
#define OriginX_AddressImageView    20.0
#define OriginY_AddressImageView    (Height_TextField - Height_AddressImageView) / 2.0

#define Width_SearchBtn             34.0  / 2.0
#define Height_SearchBtn            34.0  / 2.0

#define Width_PointsImgView         26.0 / 2.0
#define Height_PointsImgView        42.0 / 2.0

#define Width_ImageView             30.0 / 2.0
#define Height_ImageView            30.0 / 2.0
#define OriginX_ImageView           10
#define OriginY_ImageView           (40 - Height_ImageView) / 2.0

@interface LocationViewController ()

@end

@implementation LocationViewController
{
    NSMutableArray *historyArray;
    NSMutableArray *searchResultArray;
    NSMutableArray *pDataSource;
    UITableView *pTableView;
    
    UIButton *clearBtn;
    UITextField *searchTextField;
    
    BMKPoiSearch *poisearch;
    
    BOOL showHistory;
}
@synthesize myLocation, delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float originY = 44 + 20;
    if (IOS_VERSION_ABOVE_7)
        originY = 64 + 20;
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_AddressImageView, originY + OriginY_AddressImageView, Width_AddressImageView, Height_AddressImageView)];
    searchImageView.image = [UIImage imageNamed:@"输入终点.png"];
    [self.view addSubview:searchImageView];
    
    searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, 200, Height_TextField)];
    searchTextField.delegate = self;
    searchTextField.returnKeyType = UIReturnKeySearch;
    searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(self.view.bounds.size.width - 20 - Width_SearchBtn, searchImageView.frame.origin.y, Width_SearchBtn, Height_SearchBtn);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImageView *pointsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_AddressImageView, originY + Height_TextField, Width_PointsImgView, Height_PointsImgView)];
    pointsImgView.image = [UIImage imageNamed:@"点-.png"];
    [self.view addSubview:pointsImgView];
    
    originY += Height_TextField + Height_PointsImgView;
    UIImageView *myLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_AddressImageView, originY + OriginY_AddressImageView, Width_AddressImageView, Height_AddressImageView)];
    myLocationImageView.image = [UIImage imageNamed:@"我的位置.png"];
    [self.view addSubview:myLocationImageView];
    
    UITextField *myLocationTextField = [[UITextField alloc] initWithFrame:CGRectMake(OriginX_TextField, originY, 80, Height_TextField)];
    myLocationTextField.text = @"我的位置";
    myLocationTextField.enabled = NO;
    myLocationTextField.textColor = [UIColor blueColor];
    myLocationTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:myLocationTextField];
    
    UIButton *myLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myLocationBtn.frame = myLocationTextField.frame;
    [myLocationBtn setBackgroundColor:[UIColor clearColor]];
    [myLocationBtn addTarget:self action:@selector(myLocationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myLocationBtn];
    
    if ([self.title isEqualToString:@"起点"])
    {
        searchTextField.placeholder = @"输入起点";
    }
    else
    {
        searchTextField.placeholder = @"输入终点";
    }
    
    originY += 40;
    pTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, originY, self.view.bounds.size.width - 10 * 2, 40 * 6) style:UITableViewStylePlain];
    pTableView.delegate = self;
    pTableView.dataSource = self;
    pTableView.backgroundColor = [UIColor clearColor];
    pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:pTableView];
    pDataSource = [[NSMutableArray alloc] init];
    
    // 去掉多余的行
    UIView *foot = [[UIView alloc] init];
    [pTableView setTableFooterView:foot];

    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/baiduplist/%@", NSHomeDirectory(), @"locationHistory.plist"];
    historyArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    if (!historyArray)
    {
        historyArray = [[NSMutableArray alloc] init];
    }
    
    if ([historyArray count] > 0)
    {
        [pDataSource addObject:@"历史记录"];
        for (NSDictionary *dic in historyArray)
        {
            switch ([[dic objectForKey:@"type"] intValue])
            {
                case 1:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@(公交站)", [dic objectForKey:@"name"]]];
                    break;
                    
                case 3:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@(地铁站)", [dic objectForKey:@"name"]]];
                    break;
                    
                default:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]]];
                    break;
            }
        }
        
        originY += 40*6 + 10;
        clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(15, originY, self.view.bounds.size.width - 15 * 2, 40);
        [clearBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clearBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:clearBtn];
    }
    
    searchResultArray = [[NSMutableArray alloc] init];
    poisearch = [[BMKPoiSearch alloc]init];
    showHistory = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    poisearch.delegate = nil; // 不用时，置nil
}

-(void)selectDicSaveToHistoryList:(NSDictionary *)selectDic
{
    int i;  // 先看看搜索列表里选中的地址是否已存在历史记录中
    for (i = 0; i < [historyArray count]; i++)
    {
        NSDictionary *historyDic = [historyArray objectAtIndex:i];
        if ([[selectDic objectForKey:@"name"] isEqualToString:[historyDic objectForKey:@"name"]])
        {
            break;
        }
    }
    
    if (0 == i) // 如果选中的地址在历史记录中为第一条
    {
        return;
    }
    else
    {
        if (i < [historyArray count])  // 选中的地址在历史记录中，且不为第一条
        {
            [historyArray removeObjectAtIndex:i];
        }
        
        [self selectDicInsertToHistoryListAndSave:selectDic];
    }
}

-(void)selectDicInsertToHistoryListAndSave:(NSDictionary *)selectDic
{
    [historyArray insertObject:selectDic atIndex:0];
    [self saveHistoryList ];
}

-(void)saveHistoryList
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/baiduplist/%@", NSHomeDirectory(), @"locationHistory.plist"];
    [historyArray writeToFile:filePath atomically:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchBtnClicked];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectDic;
    if (showHistory)
    {
        if (0 == indexPath.row)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        else
        {
            selectDic = [historyArray objectAtIndex:indexPath.row - 1];
            [historyArray removeObjectAtIndex:indexPath.row-1];
            [self selectDicInsertToHistoryListAndSave:selectDic];
        }
    }
    else
    {
        selectDic = [searchResultArray objectAtIndex:indexPath.row];
        
        
        if (0 == [historyArray count])
            [self selectDicInsertToHistoryListAndSave:selectDic];
        else
            [self selectDicSaveToHistoryList:selectDic];
    }
    
    if (delegate && [delegate respondsToSelector:@selector(getLocation:startOrEnd:)])
        [delegate getLocation:selectDic startOrEnd:self.title];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"LocationViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    int row = indexPath.row;
    if (showHistory)
    {
        cell.textLabel.text = [pDataSource objectAtIndex:row];
        if (0 == row)
        {
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
    }
    else
    {
        cell.textLabel.text = @"";
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }

        if (0 == row)
        {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_ImageView, OriginY_ImageView, Width_ImageView, Height_ImageView)];
            img.image = [UIImage imageNamed:@"选项-已选.png"];
            [cell.contentView addSubview:img];
        }
        else
        {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(OriginX_ImageView, OriginY_ImageView, Width_ImageView, Height_ImageView)];
            img.image = [UIImage imageNamed:@"选项-未选.png"];
            [cell.contentView addSubview:img];
        }
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_ImageView*2 + Width_ImageView, 0, self.view.bounds.size.width, 40)];
        textLabel.text = [pDataSource objectAtIndex:row];
        textLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textLabel];
    }
    
    return cell;
}

#pragma mark - 按钮点击事件
-(void)myLocationBtnClicked
{
    if (delegate && [delegate respondsToSelector:@selector(getLocation:startOrEnd:)])
        [delegate getLocation:[NSDictionary dictionaryWithObjectsAndKeys:@"我的位置", @"name", nil] startOrEnd:self.title];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearBtnClicked
{
    [historyArray removeAllObjects];
    [self saveHistoryList];
    
    [pDataSource removeAllObjects];
    [pTableView reloadData];
    clearBtn.hidden = YES;
}

-(void)searchBtnClicked
{
    NSString *keyword = searchTextField.text;
    if (!keyword || [keyword isEqualToString:@""])
    {
        return;
    }
    [searchTextField endEditing:YES];
    clearBtn.hidden = YES;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 10;
    citySearchOption.city= @"南京";
    citySearchOption.keyword = keyword;
    BOOL flag = [poisearch poiSearchInCity:citySearchOption];
    if(flag)
    {
        NSLog(@"检索发送成功");
    }
    else
    {
        NSLog(@"检索发送失败");
    }
}

#pragma mark - BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [pDataSource removeAllObjects];
        [searchResultArray removeAllObjects];

        for (BMKPoiInfo *poiInfo in result.poiInfoList)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            // 0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路
            [dic setObject:[NSString stringWithFormat:@"%d", poiInfo.epoitype] forKey:@"type"];
            [dic setObject:poiInfo.city forKey:@"city"];
            [dic setObject:poiInfo.name forKey:@"name"];
            [dic setObject:poiInfo.address forKey:@"address"];
            [dic setObject:[NSString stringWithFormat:@"%lf", poiInfo.pt.latitude] forKey:@"latitude"];
            [dic setObject:[NSString stringWithFormat:@"%lf", poiInfo.pt.longitude] forKey:@"longitude"];
            [searchResultArray addObject:dic];
            
            switch (poiInfo.epoitype)
            {
                case 1:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@(公交站)", poiInfo.name]];
                    break;
                    
                case 3:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@(地铁站)", poiInfo.name]];
                    break;
                    
                default:
                    [pDataSource addObject:[NSString stringWithFormat:@"%@", poiInfo.name]];
                    break;
            }
        }
        showHistory = NO;
        [pTableView reloadData];
	}
    else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR)
    {
        NSLog(@"起始点有歧义");
    }
    else
    {
        // 各种情况的判断。。。
    }
}

@end
