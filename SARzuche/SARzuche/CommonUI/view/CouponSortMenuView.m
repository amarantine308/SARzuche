//
//  CouponSortMenuView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-11-10.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CouponSortMenuView.h"

#import "ShortMenuView.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "PublicFunction.h"


#define VIEW_WIDTH          180
#define FRAME_SHORT_MENU    CGRectMake(120, 0, VIEW_WIDTH, 240)

@implementation CouponSortMenuView
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
    CGRect rect = self.frame;
    self.frame = CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    m_nemuArray = [[NSArray alloc] initWithObjects:STR_SORT_BY_DEFAULT, STR_SORT_BY_TIMEOVER, STR_SORT_BY_STYLE, nil];
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)];
    tmpView.backgroundColor = [UIColor clearColor];//COLOR_TRANCLUCENT_BACKGROUND;
    [self addSubview:tmpView];
    
    m_menu = [[UITableView alloc] initWithFrame:rect];
    m_menu.backgroundColor = [UIColor whiteColor];
    m_menu.delegate = self;
    m_menu.dataSource = self;
    m_menu.userInteractionEnabled = YES;
    m_menu.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:m_menu];
}


#pragma mark - tableveiw delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"sort select");
    if (delegate && [delegate respondsToSelector:@selector(shortMenuSelect:)]) {
        [delegate MenuSelect:[m_nemuArray objectAtIndex:indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_nemuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *shortMenuViewIdentify = @"SORTIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shortMenuViewIdentify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shortMenuViewIdentify];
    }
    cell.backgroundColor = [UIColor whiteColor];
#if 0
    UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 40, 30)];
    tmpImageView.backgroundColor = [UIColor greenColor];
    [cell.contentView addSubview:tmpImageView];
#endif
    CGRect tmpRect = CGRectMake(0, 0, m_menu.frame.size.width, 5);
    UIView *space = [[PublicFunction ShareInstance] spaceViewWithRect:tmpRect withColor:COLOR_BACKGROUND];
    [cell.contentView addSubview:space];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, m_menu.frame.size.width, 35)];
    tmpLabel.text = [m_nemuArray objectAtIndex:indexPath.row];
    tmpLabel.textColor = COLOR_LABEL_GRAY;
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:tmpLabel];
#if 0
    tmpRect = CGRectMake(0, 35, m_menu.frame.size.width, 5);
    UIView *space2 = [[PublicFunction ShareInstance] spaceViewWithRect:tmpRect withColor:COLOR_BACKGROUND];
    [cell.contentView addSubview:space2];
#endif
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSEnumerator *enumurator = [touches objectEnumerator];
    
    id touch;
    while (touch = [enumurator nextObject])
    {
        if ([touch isKindOfClass:[UITouch class]])
        {
            UITouch *tmpTouch = touch;
            if ([NSStringFromClass([tmpTouch.view class]) isEqualToString:@"UITableViewCellContentView"])
            {
                [[self nextResponder] touchesBegan:touches withEvent:event];
                [super touchesBegan:touches withEvent:event];
                return;
            }
        }
    }
    [self removeFromSuperview];
    if (delegate && [delegate respondsToSelector:@selector(MenuExit)]) {
        [delegate MenuExit];
    }
}


@end
