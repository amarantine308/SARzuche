//
//  HistoryOrdersView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrdersData.h"
#import "HistoryOrdersViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "CommonTableView.h"

@protocol HistoryOrdersViwDelegate <NSObject>

-(void)selectOrder:(NSInteger)index;
-(void)showPayInfo:(NSInteger)index;

@required
-(void)GetHistoryMoreData:(BOOL)bRemove;

@end

@interface HistoryOrdersView : UIView<UITableViewDataSource, UITableViewDelegate, HistoryOrdersViewCellDelegate,CommonTableViewDelegate>
{
    CommonTableView *m_historyTable;
    
    OrderListData *m_orderListData;
    NSInteger m_tablecount;
    NSInteger m_totalsItem;
}

@property(nonatomic, weak)id<HistoryOrdersViwDelegate> delegate;

-(void)updateOrderList:(OrderListData *)orderList;
@end
