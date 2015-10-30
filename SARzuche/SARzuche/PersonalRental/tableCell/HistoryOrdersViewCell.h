//
//  HistoryOrdersViewCell.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCarInfoView.h"
#import "MyOrdersData.h"

@protocol HistoryOrdersViewCellDelegate <NSObject>

-(void)showPayInfo:(NSInteger)index;

@end

@interface HistoryOrdersViewCell : UITableViewCell
{
    UILabel *m_OrderIDTitle;
    UILabel *m_OrderID;
    UILabel *m_OrderTimeTitle;
    UILabel *m_OrderTime;
    UILabel *m_OrderStatusTitle;
    UILabel *m_OrderStatus;
#if 0
    UILabel *m_renewTimeTitle;
    UILabel *m_renewTime;
    UILabel *m_payTimeTitle;
    UILabel *m_payTime;
#else
    UILabel *m_magicTitle;
    UILabel *m_magic;
#endif
    UILabel *m_prepayCost;
    
    PersonalCarInfoView *m_carInfo;
    UIButton *m_payedBtn;
    
    srvOrderData *m_orderData;
    FMNetworkRequest *m_repeatList;
    FMNetworkRequest *m_reqCar;
    
    NSInteger m_nCellHeight;
}

@property(nonatomic, weak)id<HistoryOrdersViewCellDelegate> delegate;

-(void)removeAllSubView;
-(void)setOrderData:(srvOrderData *)data;
@end
