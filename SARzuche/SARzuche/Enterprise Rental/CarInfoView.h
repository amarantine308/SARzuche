//
//  CarInfoView.h
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateSelectView.h"
#import "RBCustomDatePickerView.h"
#import "TenancyPickView.h"

@protocol CarInfoViewDelegate <NSObject>
-(void)enterEnterpriseInfoView:(NSMutableDictionary *)dic;
-(void)enterIntensionCarView;
-(void)enterAreaCityController;
@end

@interface CarInfoView : UIView<UITableViewDelegate, UITableViewDataSource, DateSelectViewDelegate,DatePickerViewDelegate,UITextFieldDelegate,TenancyPickDelegate>
{
    UILabel *cityLabel; //取车城市
    UILabel *dateLabel; //取车日期
    UILabel *cartypeLabel; //意向车型
    UILabel *tenancyLabel; //租期
    UITextField *numTextField; //车辆数
    UISwitch *drivingServiceSwitch;//是否代驾
    UILabel *drivingSerLab;
}

@property(nonatomic, assign)id<CarInfoViewDelegate> delegate;
@property(nonatomic, retain) UILabel *cartypeLabel; //意向车型
@property(nonatomic, retain) UILabel *cityLabel;    //取车城市
@property(nonatomic, retain) NSString *brand;       //意向汽车品牌
@property(nonatomic, retain) NSString *carType;

- (void)resignKeyBoard;
@end
