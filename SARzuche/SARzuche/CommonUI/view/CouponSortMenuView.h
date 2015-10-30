//
//  CouponSortMenuView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-11-10.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CouponSortMenuViewDelegate <NSObject>

@required
-(void)MenuSelect:(NSString *)selStr;
@optional
-(void)MenuExit;

@end

@interface CouponSortMenuView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *m_menu;
    NSArray *m_nemuArray;
}

@property(nonatomic, weak)id<CouponSortMenuViewDelegate> delegate;

@end
