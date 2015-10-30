//
//  CarDataManager.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - select car
@interface SelectedCar : NSObject

@property(nonatomic, strong)NSString *m_carId;
@property(nonatomic, strong)NSString * m_unitPrice;
@property(nonatomic, strong)NSString * m_dayPrice;
@property(nonatomic, strong)NSString * m_model;
@property(nonatomic, strong)NSString * m_carseries;
@property(nonatomic, strong)NSString * m_plateNum;
@property(nonatomic, strong)NSString * m_discount;
@property(nonatomic, strong)NSString * m_carFile;
@property(nonatomic, strong)NSString * m_branchid;
@end


#pragma mark - car price
@interface SrvCarPrice : NSObject

@property(nonatomic, strong)NSString * m_damagePrice;
@property(nonatomic, strong)NSString *m_dayprice;
@property(nonatomic, strong)NSString *m_delayfee;
@property(nonatomic, strong)NSString *m_dispafee;
@property(nonatomic, strong)NSString *m_enddate;
@property(nonatomic, strong)NSString *m_id;
@property(nonatomic, strong)NSString *m_lgaldesit;
@property(nonatomic, strong)NSString *m_mileage;
@property(nonatomic, strong)NSString *m_pricetype;
@property(nonatomic, strong)NSString *m_startDate;
@property(nonatomic, strong)NSArray *m_timeList;
@end

#pragma mark - CarDataManager

typedef NS_ENUM(NSInteger, srvCarPriceType)
{
    price_holiday,
    price_workday,
    price_weekend
};

@interface CarDataManager : NSObject
{
    SelectedCar *m_selCar;
//    NSMutableArray *m_allHistoryCarArr;
    NSMutableDictionary *m_allHistoryCarDic;
    
    SrvCarPrice *m_holidayPrice;
    SrvCarPrice *m_workdayPrice;
    SrvCarPrice *m_weekendPrice;
}

+(CarDataManager *)shareInstance;

// car info
-(void)setSelCar:(NSDictionary *)carDic;
-(SelectedCar *)getSelCar;

// all history car
-(void)addHistoryCar:(NSDictionary *)carDic;
-(SelectedCar *)getHistoryCar:(NSString *)carId;
-(void)clearAllHistoryCar;

#pragma mark - get car info
-(NSString *)GetUnitPriceWithCar:(NSDictionary *)carDic;
-(NSString *)GetDayPriceWithCar:(NSDictionary *)carDic;
-(NSString *)GetModelWithCar:(NSDictionary *)carDic;
-(NSString *)GetCarSeriesWithCar:(NSDictionary *)carDic;
-(NSString *)GetPlateNumWithCar:(NSDictionary *)carDic;
-(NSString *)GetDiscountWithCar:(NSDictionary *)carDic;
-(NSString *)GetCarFileWithCar:(NSDictionary *)carDic;

#pragma mark - car price function
-(void)setCarPrice:(NSDictionary *)srvPrice withType:(srvCarPriceType)type;
-(SrvCarPrice *)getCarPrice:(srvCarPriceType)type;
-(NSArray *)getCarPriceArray:(srvCarPriceType)type;
-(NSString *)getHolidayDateString;
-(NSString *)getDayPriceWithType:(srvCarPriceType)type;

-(NSString *)getHourPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat;
-(NSString *)getDayPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat;
-(NSString *)getHourDiscountPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat;


-(NSString *)getMileage;
-(NSString *)getScheduling;
-(NSString *)getDeposit;

@end
