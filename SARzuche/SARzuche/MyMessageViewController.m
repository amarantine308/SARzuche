//
//  MyMessageViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyMessageViewController.h"
#import "BLNetworkManager.h"
#import "PublicFunction.h"
#import "LoadingClass.h"
#import "ConstString.h"
#import "ConstDefine.h"
#import "MessageCell.h"
#import "User.h"

#define Type_Message_NotRead    @"1"
#define Type_Message_Readed     @"2"
#define Type_Message_Delete     @"3"

#define Width_ImageView         94.0 / 2.0
#define Height_ImageView        94.0 / 2.0

#define Tag_AlertViewDeleteMsg  101
#define Tag_AlertViewReadMsg    102
#define Tag_AlertViewDeleteAll  103

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController
{
    CommonTableView *pTableView;
    NSMutableArray *pDataSource;
    
    UIView *noMessageBackView;
    int markIndex;
}

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
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"我的消息"];
    }
//    [customNavBarView setRightButtonWithTitle:@"全部删除" target:self rightBtnAction:@selector(deleteAllBtnClicked)];
    [customNavBarView setRightButtonFrame:CGRectMake(self.view.bounds.size.width - 80, 0, 70, 44)];

    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    pTableView = [[CommonTableView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY) style:UITableViewStylePlain];
    pTableView.m_delegate = self;
    pTableView.delegate = self;
    pTableView.dataSource = self;
    pTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:pTableView];
    pTableView.hidden = YES;
    
    pDataSource = [[NSMutableArray alloc] init];
    
    noMessageBackView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    noMessageBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:noMessageBackView];
    noMessageBackView.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((noMessageBackView.bounds.size.width - Width_ImageView) / 2.0, (noMessageBackView.bounds.size.height - Height_ImageView) / 2.0 - 50, Width_ImageView, Height_ImageView)];
    imageView.image = [UIImage imageNamed:@"默认图.png"];
    [noMessageBackView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.bounds.size.height, noMessageBackView.bounds.size.width, 20)];
    label.text = @"亲~暂时还没有您的消息哦~";
    label.textAlignment = NSTextAlignmentCenter;
    [noMessageBackView addSubview:label];
    
    [self getMessageList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadViewWithData:(id)data
{
    NSArray *array = (NSArray *)data;
    if (pTableView.currentRefreshPos == EGORefreshHeader)
    {
        [pDataSource removeAllObjects];
        
        if (0 == [array count])
        {
            noMessageBackView.hidden = NO;
            pTableView.hidden = YES;
            
            return;
        }
    }
    
    [pDataSource addObjectsFromArray:array];
    noMessageBackView.hidden = YES;
    pTableView.hidden = NO;
    [pTableView reloadData];
    
    if ([array count] == PAGE_COUNT)
    {
        [pTableView finishReloadingDataWithMore:YES];   // 有更多
    }
    else
    {
        [pTableView finishReloadingDataWithMore:NO];    // 没有更多
    }
}

#pragma mark - 按钮点击事件
-(void)deleteAllBtnClicked
{
    if ([pDataSource count] == 0)
    {
        [[LoadingClass shared] showContent:@"已经没有可删除的消息了哦～" andCustomImage:nil];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删掉所有消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = Tag_AlertViewDeleteAll;
    [alertView show];
}

#pragma mark - 请求
-(void)getMessageList
{
    pTableView.nextPage = 1;
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getMyMessageByPhoneNum:[User shareInstance].phone type:@"" pageNumber:@"1" pageSize:[NSString stringWithFormat:@"%d", PAGE_COUNT] delegate:self];
    request = nil;
}

-(void)deleteMessage:(NSDictionary *)dic
{
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] myMessageReadOrDeleteWithMsgId:[dic objectForKey:@"id"] msgStatus:Type_Message_Delete delegate:self];
    request = nil;
}

-(void)readMessage:(NSDictionary *)dic
{
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] myMessageReadOrDeleteWithMsgId:[dic objectForKey:@"id"] msgStatus:Type_Message_Readed delegate:self];
    request = nil;
}

#pragma mark - UITableViewDataSource,Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Height_Cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify = @"MyMessageView";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (nil == cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    NSDictionary *dic = [pDataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dic objectForKey:@"type"];
    cell.timeLabel.text = [[PublicFunction ShareInstance] getYMDHMString:[dic objectForKey:@"sendtime"]];

    NSMutableString *contentStr2 = [NSMutableString stringWithString:[dic objectForKey:@"content"]] ;
    NSMutableString *contentStr = (NSMutableString *)[contentStr2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    if (contentStr.length >= 36)
    {
        contentStr = [NSMutableString stringWithString:[contentStr substringToIndex:36]];
        [contentStr appendString:@"..."];
    }
    cell.contentLabel.text = contentStr;
    
    if ([[dic objectForKey:@"status"] isEqualToString:Type_Message_NotRead])
        [cell showNewMessageImageView:YES];
    else
        [cell showNewMessageImageView:NO];
    
    if ([pDataSource count]-1 == indexPath.row)
        [cell showSpaceView:NO];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    markIndex = indexPath.row;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示哦~亲~" message:@"您确定要删除这条消息吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = Tag_AlertViewDeleteMsg;
    [alertView show];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    markIndex = indexPath.row;
    NSDictionary *dic = [pDataSource objectAtIndex:markIndex];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"type"] message:[dic objectForKey:@"content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertView.tag = Tag_AlertViewReadMsg;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag)
    {
        case Tag_AlertViewReadMsg:
        {
            NSDictionary *dic = [pDataSource objectAtIndex:markIndex];
            if ([[dic objectForKey:@"status"] isEqualToString:Type_Message_NotRead])
            {
                [self readMessage:dic];
            }
        }
            break;
            
        case Tag_AlertViewDeleteMsg:
        {
            switch (buttonIndex)
            {
                case 0: // 取消
                    [pTableView reloadData];
                    break;
                    
                case 1: // 确定
                {
                    NSDictionary *dic = [pDataSource objectAtIndex:markIndex];
                    [self deleteMessage:dic];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case Tag_AlertViewDeleteAll:
        {
            switch (buttonIndex)
            {
                case 0: // 取消
                    break;
                    
                case 1: // 确定
                {
                    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
                    
                    NSMutableString *idList = [NSMutableString stringWithString:[NSMutableString stringWithString:[[pDataSource objectAtIndex:0] objectForKey:@"id"]]];
                    for (int i = 1; i < [pDataSource count]; i++)
                    {
                        NSString *idStr = [NSString stringWithFormat:@",%@", [[pDataSource objectAtIndex:i] objectForKey:@"id"]];
                        [idList appendString:idStr];
                    }
                    
                    FMNetworkRequest *request = [[BLNetworkManager shareInstance] myMessageReadOrDeleteWithMsgId:idList msgStatus:Type_Message_Delete delegate:self];
                    request = nil;
                }
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - FMNetworkManager delegate

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getMyMessage])// 获取我的消息列表
    {
        [self reloadViewWithData:[fmNetworkRequest.responseData objectForKey:@"mymess"]];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_MessageReaded])
    {
        [self getMessageList];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getMyMessage])// 获取我的消息列表
    {
        [pTableView finishReloadingDataWithMore:YES];    // 是否有更多
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取消息列表失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([fmNetworkRequest.requestName isEqualToString:kRequest_MessageReaded])
    {
        [[LoadingClass shared] showContent:@"网络异常，请稍候" andCustomImage:nil];
    }
}

#pragma mark - CommonTableViewDelegate
- (void)pullUpAndDownRefreshDataWithInfoDic:(NSDictionary *)infoDic
{
    [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
    FMNetworkRequest *request = [[BLNetworkManager shareInstance] getMyMessageByPhoneNum:[User shareInstance].phone type:@"" pageNumber:[infoDic objectForKey:KEY_CURRENTPAGE] pageSize:[infoDic objectForKey:KEY_COUNT] delegate:self];
    request = nil;
}

#pragma mark - UIScrollViewDelegate Methods

//滚动响应，当用户在滚动视图中拉动的时候就会被触发（这里是指table中拉动）

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (pTableView.refreshHeaderView)
    {
        [pTableView.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (pTableView.refreshFooterView)
    {
        [pTableView.refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (pTableView.refreshHeaderView)
    {
        [pTableView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (pTableView.refreshFooterView)
    {
        [pTableView.refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

@end
