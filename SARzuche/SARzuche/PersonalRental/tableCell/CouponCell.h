//
//  CouponCell.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LABEL_H             20
#define COUPON_CELL_HIGHT    (LABEL_H * 4 + 10)   

@protocol CouponCellDelegate <NSObject>

@required
-(void)radioSel:(NSString *)sel;

@end

@interface CouponCell : UITableViewCell
{
    UILabel *m_name;
    UILabel *m_type;
    UILabel *m_time;
    UILabel *m_desc;
}


@property(nonatomic, strong)UIButton *m_checkboxBtn;
@property(nonatomic, weak)id<CouponCellDelegate> delegate;

-(void)setCouponCellData:(NSDictionary *)couponDic withTag:(NSInteger)tag;

@end
