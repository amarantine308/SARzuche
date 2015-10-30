//
//  CommonTableView.m
//
//  Created by zhang xiang on 13-8-30.
//  Copyright (c) 2013年 zhang xiang. All rights reserved.
//

#import "CommonTableView.h"

@interface CommonTableView(private)
- (void)initHeaderAndFooter;
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos;
@end

@implementation CommonTableView
@synthesize m_delegate = _m_delegate;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshFooterView = _refreshFooterView;
@synthesize currentRefreshPos = _currentRefreshPos;
@synthesize nextPage = _nextPage;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_FINISHREFRESHFAILD object:nil];
    [_refreshHeaderView release];
    [_refreshFooterView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self initHeaderAndFooter];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        [self initHeaderAndFooter];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self)
    {
        [self initHeaderAndFooter];
    }
    return self;
}

- (void)initHeaderAndFooter
{
    _currentRefreshPos = EGORefreshHeader;
    _reloading = NO;
    _more = NO;
    _nextPage = PAGE_FIRSTPAGE;
    [self createHeaderView];
    [self createFooterView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishReFreshFaildNotification:) name:NOTIFICATION_FINISHREFRESHFAILD object:nil];
}

//设置headerView
- (void)createHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height,self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}


- (void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview])
    {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}


//设置footerView
- (void)setFooterView
{
    if (_more)
    {
        [self createFooterView];
    }else
    {
        [self removeFooterView];
    }
}


- (void)createFooterView
{
    //    UIEdgeInsets test = self.tableView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,height,self.frame.size.width,self.bounds.size.height);
    }
    else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, height,self.frame.size.width, self.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


- (void)removeFooterView
 {
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

//刷新
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
	
	//  should be calling your tableviews data source model to reload
	_reloading = YES;
    _currentRefreshPos = aRefreshPos;
    if (aRefreshPos == EGORefreshHeader)
    {
        //下拉刷新时重置为请求第一页
        _nextPage = PAGE_FIRSTPAGE;
        // pull down to refresh data
        
    }
    else if (aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        
    }
    if (_m_delegate && [_m_delegate respondsToSelector:@selector(pullUpAndDownRefreshDataWithInfoDic:)])
    {
        [_m_delegate pullUpAndDownRefreshDataWithInfoDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", _nextPage], KEY_CURRENTPAGE, [NSString stringWithFormat:@"%d", PAGE_COUNT], KEY_COUNT, nil]];
    }
    
	// overide, the actual loading data operation is done in the subclass
}

//刷新失败恢复状态
- (void)finishReFreshFaildNotification:(NSNotification *)noti
{
    [self finishReloadingDataWithMore:_more];
}

//刷新结束
- (void)finishReloadingDataWithMore:(BOOL)isMore
{
    //刷新tableView
    [self reloadData];
    //主线程立刻执行
    [self performSelectorOnMainThread:@selector(didFinishedLoading:) withObject:[NSNumber numberWithBool:isMore] waitUntilDone:NO];
}

- (void)didFinishedLoading:(NSNumber *)isMore
{
	//  model should call this when its done loading
	_reloading = NO;
    _more = [isMore boolValue];
    
	if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    
    if (_more)
    {
        _nextPage ++;
    }
    [self setFooterView];
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}
@end
