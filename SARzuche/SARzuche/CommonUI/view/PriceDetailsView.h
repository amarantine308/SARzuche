//
//  PriceDetailsView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderManager.h"

@interface PriceDetailsView : UIView
{
    UIView *m_backgroundView;
    UIView *m_subView;
    UILabel *m_costDetail;
    UILabel *m_duration;
    UILabel *m_mileage;
    UILabel *m_scheduling;
    UILabel *m_deposit;
    UILabel *m_total;
    
    UILabel *m_couponDeduction;
    UILabel *m_delay;
    UILabel *m_damage;
    UILabel *m_illegal;
    UILabel *m_durationTotalHours;
    UILabel *m_kilometerTotal;
    UILabel *m_delayHour;
    BOOL m_bPrepay;
    
    NSInteger m_viewHeight;
}

- (id)initWithFrame:(CGRect)frame prepay:(BOOL)prepay;
-(void)setOrderData:(srvOrderData *)orderData;
@end
