//
//  BusLineDetailViewController.m
//  SARzuche
//
//  Created by admin on 14-10-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BusLineDetailViewController.h"
#import "ConstDefine.h"

@implementation BusLineDetailViewController
{
    UITableView *pTableView;
}
@synthesize pDataSource, startLocation, endLocation, busLine;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"公交";
        pDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, self.view.bounds.size.width-10 * 2, 20)];
    startLabel.font = [UIFont systemFontOfSize:14];
    startLabel.text = [NSString stringWithFormat:@"出发地：%@", startLocation];
    startLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:startLabel];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65+20, self.view.bounds.size.width - 10*2, 20)];
    endLabel.font = [UIFont systemFontOfSize:14];
    endLabel.text = [NSString stringWithFormat:@"目的地：%@", endLocation];
    endLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:endLabel];
    
    UILabel *busLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65+40, self.view.bounds.size.width - 10*2, 20)];
    busLineLabel.font = [UIFont systemFontOfSize:14];
    busLineLabel.text = [NSString stringWithFormat:@"乘车方案：%@", busLine];
    busLineLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:busLineLabel];
    
    pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65+60, self.view.bounds.size.width, self.view.bounds.size.height - (65+60)) style:UITableViewStylePlain];
    pTableView.delegate = self;
    pTableView.dataSource = self;
    [self.view addSubview:pTableView];
    
    // 去掉多余的行
    UIView *foot = [[UIView alloc] init];
    [pTableView setTableFooterView:foot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"BusLineDetailViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [pDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

@end
