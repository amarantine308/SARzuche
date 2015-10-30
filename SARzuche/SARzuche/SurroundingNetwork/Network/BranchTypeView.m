//
//  BranchTypeView.m
//  SARzuche
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchTypeView.h"

@implementation BranchTypeView
{
    UITableView *pTableView;
    int markRow;
}
@synthesize pDataSource;

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
        markRow = 0;
    }
    return self;
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"BranchTypeViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [pDataSource objectAtIndex:indexPath.row];
    if (markRow == indexPath.row)
    {
        cell.backgroundColor = [UIColor brownColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    markRow = indexPath.row;
    [pTableView reloadData];
}

@end
