//
//  IntensionCarInfoView.m
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "IntensionCarInfoView.h"
#import "BLNetworkManager.h"
#import "ConstDefine.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Helper.h"
#import "UIImageView+URL.h"

#define NOTIFICATION_CAR_GETTYPE @"NOTIFICATION_CAR_GETTYPE"

#define CELL_HEIGHT 75

@implementation IntensionCarInfoView
{
    UITableView *pTableView;
}
@synthesize pDataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        pDataSource = [[NSMutableArray alloc] init];
        
        pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        pTableView.delegate = self;
        pTableView.dataSource = self;
        pTableView.backgroundColor = [UIColor clearColor];
        pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:pTableView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.50, frame.size.height)];
        line.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:213.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
        [self addSubview:line];
    }
    return self;
}

- (void)reloadData:(id)data
{
    [pDataSource removeAllObjects];
    [pDataSource addObjectsFromArray:(NSArray *)data];
    [pTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"IntensionCarInfoViewCell";
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
    
    NSDictionary *dic = [pDataSource objectAtIndex:indexPath.row];
    
//     NSString *imgURL= [NSString stringWithFormat:@"%@%@", kImageBaseUrl, [dic objectForKey:@"carFile"]];
    NSString *imgURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"carFile"]];
#if 0
    UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 7, 82, 60)];
    carImgView.backgroundColor = [UIColor blackColor];
    if ([imgURL hasPrefix:@"http://"] || [imgURL hasPrefix:@"https://"])
    {
        NSLog(@"intension :%@", imgURL);
        [carImgView setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"defaultcarimage.png"]];
    }

    [cell.contentView addSubview:carImgView];
#else
    CustomImageView *carImgView = [[CustomImageView alloc] initWithImage:@"defaultcarimage.png" withUrl:imgURL];
    carImgView.frame = CGRectMake(13, 7, 82, 60);
    
    [cell.contentView addSubview:carImgView];
#endif
    
    UILabel *carNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.frame.origin.x+82+10, 7, 110, 20)];
    carNameLabel.tag = 1001;
    NSString *strTmp = [NSString stringWithFormat:@"%@", GET([dic objectForKey:@"model"])];
    NSString *str = [strTmp stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    carNameLabel.text = [NSString stringWithFormat:@"%@ %@", str, GET([dic objectForKey:@"carseries"])];
    carNameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:carNameLabel];
    
    UILabel *monthpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.frame.origin.x+82+10, 27, 100, 20)];
    monthpriceLabel.tag = 1002;
    monthpriceLabel.text = [NSString stringWithFormat:@"%@元/月",[dic objectForKey:@"monthPrice"]];
    monthpriceLabel.font = [UIFont systemFontOfSize:13];
    monthpriceLabel.textColor = [UIColor colorWithRed:42.0 / 255.0 green:131.0 / 255.0 blue:210.0 / 255.0 alpha:1.0];
    [cell.contentView addSubview:monthpriceLabel];
    
    
    UILabel *yearpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(carImgView.frame.origin.x+82+10, 47, 100, 20)];
    yearpriceLabel.tag = 1003;
    yearpriceLabel.text = [NSString stringWithFormat:@"%@元/年",[dic objectForKey:@"frisyePrice"]];
    yearpriceLabel.font = [UIFont systemFontOfSize:13];
    yearpriceLabel.textColor = [UIColor colorWithRed:42.0 / 255.0 green:131.0 / 255.0 blue:210.0 / 255.0 alpha:1.0];
    [cell.contentView addSubview:yearpriceLabel];
    
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT-1, cell.bounds.size.width, 0.50)];
    spaceView.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:213.0 / 255.0 blue:220.0 / 255.0 alpha:1.0];
    [cell.contentView addSubview:spaceView];
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [pDataSource objectAtIndex:indexPath.row];
//    NSString *carname = [dic objectForKey:@"brand"];
//    NSLog(@"carname:%@",carname);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CAR_GETTYPE object:dic];
}

@end
