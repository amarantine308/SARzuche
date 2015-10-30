//
//  BlockTableView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BlockTableView.h"
@interface BlockTableView()
{
    NSMutableArray *_blockArray;
}
@end

@implementation BlockTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

// 初始化网点界面城市区域内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *blockIdentifier = @"BlockTable";//自定义的标识符
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:blockIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: blockIdentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];

//    [cell.contentView addSubview:cv];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

@end
