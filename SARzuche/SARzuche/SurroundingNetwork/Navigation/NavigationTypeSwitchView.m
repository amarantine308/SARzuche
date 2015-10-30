//
//  NavigationTypeSwitchView.m
//  SARzuche
//
//  Created by admin on 14-10-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavigationTypeSwitchView.h"
#import "ConstDefine.h"

#define CELL_HEIGHT         297.0 / 6.0
#define TABLEVIEW_WIDTH     475.0 / 2.0
#define TABLEVIEW_HEIGHT    CELL_HEIGHT * 3
#define TABLEVIEW_ORIGINX   (self.bounds.size.width - TABLEVIEW_WIDTH) / 2
#define TABLEVIEW_ORIGINY   (self.bounds.size.height - TABLEVIEW_HEIGHT) / 2 - 30
#define FRAME_TABLEVIEW     CGRectMake(TABLEVIEW_ORIGINX, TABLEVIEW_ORIGINY, TABLEVIEW_WIDTH, TABLEVIEW_HEIGHT)

#define BACKVIEW_WIDTH      505.0 / 2.0
#define BACKVIEW_HEIGHT     TABLEVIEW_HEIGHT + 5*2
#define BACKVIEW_ORIGINX    (self.bounds.size.width - BACKVIEW_WIDTH) / 2
#define BACKVIEW_ORIGINY    TABLEVIEW_ORIGINY - 5
#define FRAME_BACKVIEW      CGRectMake(BACKVIEW_ORIGINX, BACKVIEW_ORIGINY, BACKVIEW_WIDTH, BACKVIEW_HEIGHT)

#define PIC_SELECTED        @"checkbox_selected.png"
#define PIC_UNSELECTED      @"checkbox_normal.png"

@implementation NavigationTypeSwitchView
{
    UITableView *pTableView;
    NSMutableArray *pDataSource;
}
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 灰背景
        self.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:0.3];
        
        UIView *backView = [[UIView alloc] initWithFrame:FRAME_BACKVIEW];
        backView.backgroundColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        backView.layer.borderWidth = 0.5;
        backView.layer.cornerRadius = 8.0;
#endif
        [self addSubview:backView];
        
        pDataSource = [[NSMutableArray alloc] initWithObjects:@"公交", @"驾乘", @"步行", nil];
        
        pTableView = [[UITableView alloc] initWithFrame:FRAME_TABLEVIEW style:UITableViewStylePlain];
        pTableView.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:185.0/255.0 blue:236.0/255.0 alpha:1.0];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        pTableView.layer.borderColor = [UIColor grayColor].CGColor;
        pTableView.layer.borderWidth = 0.5;
        pTableView.layer.cornerRadius = 5.0;
#endif
        pTableView.dataSource = self;
        pTableView.delegate = self;
        [self addSubview: pTableView];
        
        if (IOS_VERSION_ABOVE_7)
        {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
            pTableView.separatorInset = UIEdgeInsetsZero;
#endif
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClicked)];
        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)tagClicked
{
    if (delegate && [delegate respondsToSelector:@selector(hideNavigationTypeSwitchView)])
    {
        [delegate hideNavigationTypeSwitchView];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"NavigationTypeSwitchViewCell";
    NavigationTypeViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[NavigationTypeViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.delegate = self;
    }
    cell.cellBtn.tag = indexPath.row;
    cell.titleLabel.text = [pDataSource objectAtIndex:indexPath.row];

//    if (0 == indexPath.row)
//        cell.selectedView.image = [UIImage imageNamed:PIC_SELECTED];
//    else
//        cell.selectedView.image = [UIImage imageNamed:PIC_UNSELECTED];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NavigationTypeViewCellDelegate
-(void)cellBtnClicked:(id)sender
{
    int type = 0;
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag)
    {
        case 0:
            type = TAG_NavigationTypeBtn_bus;
            break;
        
        case 1:
            type = TAG_NavigationTypeBtn_driving;
            break;
            
        case 2:
            type = TAG_NavigationTypeBtn_walking;
            break;
            
        default:
            break;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(navigationTypeSelected:)])
    {
        [delegate navigationTypeSelected:type];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        //放过button点击拦截
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
