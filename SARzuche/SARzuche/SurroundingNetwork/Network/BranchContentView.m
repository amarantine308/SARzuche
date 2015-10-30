//
//  BranchContentView.m
//  SARzuche
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchContentView.h"

@implementation BranchContentView
{
    UITableView *pTableView;
}
@synthesize title, pDataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        pTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        pTableView.delegate = self;
        pTableView.dataSource = self;
        [self addSubview:pTableView];
        
        pDataSource = [[NSMutableArray alloc] init];
        title = [[NSString alloc] init];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"BranchContentViewCell";
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
    NSDictionary *dic = [pDataSource objectAtIndex:indexPath.row];
    UILabel *branchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, self.bounds.size.width - 50 - originX * 2, 24)];
    branchNameLabel.text = [dic objectForKey:@"branchName"];
    branchNameLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 50 - originX, 0, 50, 24)];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.text = [dic objectForKey:@"distance"];
    distanceLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 24, self.bounds.size.width - originX * 2, 20)];
    addressLabel.text = [dic objectForKey:@"address"];
    addressLabel.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:branchNameLabel];
    [cell.contentView addSubview:distanceLabel];
    [cell.contentView addSubview:addressLabel];
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
