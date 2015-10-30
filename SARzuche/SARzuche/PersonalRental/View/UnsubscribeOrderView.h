//
//  UnsubscribeOrderView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrdersData.h"
#import "CurrentOrderView.h"

@protocol UnsubOrderViewDelegate <NSObject>

-(void)backToPrePage:(BOOL)bUpdateHistory;

@end

@interface UnsubscribeOrderView : UIView
{
    UILabel *m_OrderIDTitle;
    UILabel *m_OrderID;
    UILabel *m_OrderTimeTitle;
    UILabel *m_OrderTime;
    UILabel *m_OrderStatusTitle;
    UILabel *m_OrderStatus;
    UIButton *m_renewTime;
    UILabel *m_payTimeTitle;
    UILabel *m_payTime;
    UILabel *m_magicLabel;
    
    NSInteger m_curViewHeight;
    
    UIButton *m_unsubscribeBtn;
    UIButton *m_prePayedBtn;
    
    srvOrderData *m_orderData;
    
    // request
    FMNetworkRequest *m_cancelOrderReq;
}

@property(nonatomic, weak)id<UnsubOrderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder;

@end
