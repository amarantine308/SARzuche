//
//  BranchListViewController.m
//  SARzuche
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchListViewController.h"

@interface BranchListViewController ()

@end

@implementation BranchListViewController
{
    UITableView *searchTableView;
    NSMutableArray *searchArray;
    
    UIView *backView;
    BranchTypeView *_branchTypeView;
    BranchContentView *_branchContentView;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"选择网点";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float originX = 20;
    float originY = 75;
    float btnWidth = 40;
    float btnHeight = 30;
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(originX, originY, self.view.bounds.size.width - originX * 3 - btnWidth, btnHeight)];
    searchTextField.placeholder = @"请输入目的地";
    [searchTextField setBackground:[UIImage imageNamed:@"registerTextFieldBackground.png"]];
    [self.view addSubview:searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(self.view.bounds.size.width - originX - btnWidth, originY, btnWidth, btnHeight);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor yellowColor]];
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    float tableViewOriginY = originY + btnHeight + originX;
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewOriginY, self.view.bounds.size.width, self.view.bounds.size.height - tableViewOriginY)];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    [self.view addSubview:searchTableView];
    searchTableView.hidden = YES;
    
    searchArray = [[NSMutableArray alloc] init];

    float branchTypeViewWidth = 100;
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@"附近网点", @"常用网点", @"鼓楼区", @"浦口区", @"江宁区", nil];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(10, tableViewOriginY, self.view.bounds.size.width - 10 * 2, self.view.bounds.size.height - tableViewOriginY - 30)];
    [self.view addSubview:backView];
    
    _branchTypeView = [[BranchTypeView alloc] initWithFrame:CGRectMake(0, 0, branchTypeViewWidth, backView.bounds.size.height)];
    _branchTypeView.pDataSource = tempArray;
    [backView addSubview:_branchTypeView];
    
    _branchContentView = [[BranchContentView alloc] initWithFrame:CGRectMake(branchTypeViewWidth, 0, backView.bounds.size.width - branchTypeViewWidth, backView.bounds.size.height)];
    _branchContentView.title = [tempArray objectAtIndex:0];
    _branchContentView.pDataSource = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"2.5km", @"distance", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"2.5km", @"distance", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"2.5km", @"distance", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"2.5km", @"distance", @"南京浦口区天浦路1号", @"address", nil], nil];
    [backView addSubview:_branchContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件
-(void)searchBtnClicked
{
    [searchArray removeAllObjects];
    searchArray = [NSMutableArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"仙林天浦路1号", @"branchName", @"南京浦口区天浦路1号", @"address", nil], nil];
    [searchTableView reloadData];
    backView.hidden = YES;
    searchTableView.hidden = NO;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"BranchListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    for (UIView *subView in cell.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    float originX = 10;
    NSDictionary *dic = [searchArray objectAtIndex:indexPath.row];
    UILabel *branchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, searchTableView.bounds.size.width - originX * 2, 24)];
    branchNameLabel.text = [dic objectForKey:@"branchName"];
    branchNameLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 24, searchTableView.bounds.size.width - originX * 2, 20)];
    addressLabel.text = [dic objectForKey:@"address"];
    addressLabel.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:branchNameLabel];
    [cell.contentView addSubview:addressLabel];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
