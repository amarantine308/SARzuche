//
//  MyCouponController.h
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
#import "CouponSortMenuView.h"

@protocol MyCouponControllerDelegate <NSObject>

-(void)neeUpdateCouponData;

@end

/*
    我的优惠卷Controller
 */

@interface MyCouponController : NavController<CouponSortMenuViewDelegate>
{
    NSArray *list_coupons; //我的优惠卷数据
    NSMutableArray *m_validCoupons;
    NSMutableArray *m_invalidCoupons;
    
    NSInteger m_sortType;
    NSInteger m_segmentSel;
    IBOutlet UISegmentedControl *segment;//可用无效分割控制
    IBOutlet UITableView *table_myCoupon;//优惠劵列表
    IBOutlet UIButton *m_giveupBtn;
    IBOutlet UIButton *m_sortBtn;
}
@property(nonatomic, weak)id<MyCouponControllerDelegate> delegate;

- (IBAction)giveupBtnPressed:(id)sender;

- (IBAction)sortBtnPressed:(id)sender;
@end
