//
//  CommonTableView.h
//
//  Created by zhang xiang on 13-8-30.
//  Copyright (c) 2013年 zhang xiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

#define PAGE_FIRSTPAGE                          1           // 第一页页码
#define PAGE_COUNT                              10          // 单页个数
#define KEY_CURRENTPAGE                         @"currentPage"
#define KEY_COUNT                               @"count"

#define NOTIFICATION_FINISHREFRESHFAILD         @"finishRefreshFaild"

@protocol CommonTableViewDelegate <NSObject>
@optional
/******************************************************************************
 函数名称  :pullUpAndDownRefreshDataWithInfoDic:
 函数描述  :上拉/下拉刷新
 输入参数  :1.infoDic:信息字典
 输出参数  : N/A
 返回值    : N/A
 备注      :	N/A
 ******************************************************************************/
- (void)pullUpAndDownRefreshDataWithInfoDic:(NSDictionary *)infoDic;
@end

@interface CommonTableView : UITableView<EGORefreshTableDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    EGORefreshPos _currentRefreshPos;
    id<CommonTableViewDelegate> _m_delegate;
    BOOL _reloading;
    BOOL _more;
    int _nextPage;
}
@property(nonatomic,assign) id<CommonTableViewDelegate> m_delegate;
@property(nonatomic,assign) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic,assign) EGORefreshTableFooterView *refreshFooterView;
@property(nonatomic,assign) EGORefreshPos currentRefreshPos;
@property(nonatomic,assign) int nextPage;
- (void)createHeaderView;
- (void)createFooterView;
- (void)setFooterView;
- (void)finishReloadingDataWithMore:(BOOL)isMore;
- (void)removeHeaderView;
- (void)removeFooterView;
@end
