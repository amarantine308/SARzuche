//
//  AreaCitySelectController.h
//  TYZX
//
//  Created by 丁鹏飞 on 14-10-9.
//  Copyright (c) 2014年 th-apple01. All rights reserved.
///Users/fengyixiao/Desktop/iphone官网报价.xlsx

#import <UIKit/UIKit.h>
#import "NavController.h"


typedef NS_ENUM(NSInteger, AreaCityType){
    Select_Plate=0,
    Select_Area,
    Select_City
};

/*
 省份城市选择页面
 */

@interface AreaCitySelectController : NavController<UITableViewDataSource,UITableViewDelegate>
{
//    NSMutableArray *content_list; //查询城市明
    UITableView *table_AreaCity;
}
@property (nonatomic, retain) NSMutableArray *area_list;//查询数据
@property (nonatomic, assign) AreaCityType areaCityType;//页面类型选择

@end
