//
//  CurrentOrderView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrdersData.h"
#import "OrderManager.h"
#import "PersonalCarInfoView.h"
#import "CarDataManager.h"

@protocol CurrentOrderViewDelegate <NSObject>

-(void)gotoRenewRecord;
@optional
-(void)gotoRenewOrder;
-(void)gotoUnSubscribeOrder;
-(void)gotoModifyOrder;
-(void)payedInfo;
-(void)prepayBtnPressed;
@required
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance;
@end

@interface CurrentOrderView : UIView<PersonalCarInfoViewDelegate>
{
    UILabel *m_OrderIDTitle;
    UILabel *m_OrderID;
    UILabel *m_OrderTimeTitle;
    UILabel *m_OrderTime;
    UILabel *m_OrderStatusTitle;
    UILabel *m_OrderStatus;
//    UILabel *m_renewTimeTitle;
//    UILabel *m_renewTime;
    UIButton *m_renewTime;
    UILabel *m_payTimeTitle;
    UILabel *m_payTime;
    UILabel *m_magicLabel;
    
    orderStatus m_currentStatus;//0预定 1生效 2取消 3租金结算 4全部结算
    NSInteger m_curViewHeight;
    
    // normal
    UIButton *m_prePayed;
    UIButton *m_unsubBtn;
    UIButton *m_modifyBtn;
    // renew
    UIButton *m_renewBtn;
    // payed
    UIButton *m_payedBtn;
    
    srvOrderData *m_orderData;
    
    PersonalCarInfoView *m_CarView;
    
    // 续订记录
    NSArray *m_renewList;
    //
    UIScrollView *m_scrollView;
}

@property(nonatomic, weak)id<CurrentOrderViewDelegate> delegate;
@property(nonatomic)BOOL m_bHistoryOrder;

-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder formHist:(BOOL)bHistory;
-(id)initWithFrame:(CGRect)frame withData:(srvOrderData *)curOrder;
-(void)setOrderData:(srvOrderData *)data;
-(void)setCarInfo:(SelectedCar *)car;

-(void)setRenewList:(NSArray *)renewList;
@end
