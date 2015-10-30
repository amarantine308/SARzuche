//
//  ShortMenuView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ShortMenuView.h"
#import "ConstDefine.h"
#import "ConstString.h"

#define FRAME_SHORT_MENU    CGRectMake(120, 0, 180, 240)

@implementation ShortMenuView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initShortMenu];
    }
    return self;
}


-(void)initShortMenu
{
    m_nemuArray = [[NSArray alloc] initWithObjects:STR_HOMEPAGE, STR_PERSONAL_RENTAL, STR_COMPANY_RENTAL, STR_MYCENTER, STR_MY_ORDER, STR_HELPER, nil];
    
    m_menu = [[UITableView alloc] initWithFrame:FRAME_SHORT_MENU];
    m_menu.backgroundColor = [UIColor grayColor];
    m_menu.delegate = self;
    m_menu.dataSource = self;
    
    [self addSubview:m_menu];
}


#pragma mark - tableveiw delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (delegate && [delegate respondsToSelector:@selector(shortMenuSelect:)]) {
        [delegate shortMenuSelect:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *shortMenuViewIdentify = @"shortMenuIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shortMenuViewIdentify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shortMenuViewIdentify];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 40, 30)];
    tmpImageView.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:tmpImageView];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 2, 80, 30)];
    tmpLabel.text = [m_nemuArray objectAtIndex:indexPath.row];
    tmpLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:tmpLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
    if (delegate && [delegate respondsToSelector:@selector(shortMenuExit)]) {
        [delegate shortMenuExit];
    }
}

@end
