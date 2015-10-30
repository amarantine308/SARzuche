//
//  RentCarView.h
//  SARzuche
//
//  Created by dyy on 14-10-22.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RentCarViewDelegate <NSObject>

- (void)hidenRentCarView;//隐藏意向详情页面

@end

@interface RentCarView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table_rentCar;
    UILabel *lab_city; //取车城市
    UILabel *lab_takedate; //取车日期
    UILabel *lab_brand; //意向车型
    UILabel *lab_companyName; //企业名称
    UILabel *lab_tenancy; //租期
    UILabel *lab_carNum; //车辆数
    UILabel *lab_drivingService;//是否代驾
    UILabel *lab_contactMan;//联系人
    UILabel *lab_carseries; //车系
    NSArray *list_titles;
    NSMutableDictionary *dic_rent;
    NSArray *list_tenancy;
}

@property (nonatomic, weak) id <RentCarViewDelegate>delegate;
@property (nonatomic, retain) NSMutableDictionary *dic_rent;
@property (nonatomic, retain) UITableView *table_rentCar;


@end
