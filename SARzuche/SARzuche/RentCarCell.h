//
//  RentCarCell.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RentCarCellDelegate <NSObject>

- (void)rentCarInfo:(NSInteger )index;

@end



@interface RentCarCell : UITableViewCell
{
    IBOutlet UILabel *lab_intentce; //意向一
    IBOutlet UILabel *lab_submit_time;//提交时间
    IBOutlet UILabel *lab_take_time;//提取时间
    IBOutlet UILabel *lab_car_brand;//品牌
    IBOutlet UILabel *lab_car_series;//车系
    IBOutlet UILabel *lab_cycle;//周期
    IBOutlet UILabel *lab_car_num;//车辆数
    IBOutlet UIButton *btn_showInfo;
    IBOutlet UIView *vi_rent;
}

@property (nonatomic,weak) id <RentCarCellDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *lab_intentce;
@property (nonatomic, retain) IBOutlet UILabel *lab_submit_time;
@property (nonatomic, retain) IBOutlet UILabel *lab_take_time;
@property (nonatomic, retain) IBOutlet UILabel *lab_car_brand;
@property (nonatomic, retain) IBOutlet UILabel *lab_car_series;
@property (nonatomic, retain) IBOutlet UILabel *lab_cycle;
@property (nonatomic, retain) IBOutlet UILabel *lab_car_num;
@property (nonatomic, retain) IBOutlet UIButton *btn_showInfo;

@end



