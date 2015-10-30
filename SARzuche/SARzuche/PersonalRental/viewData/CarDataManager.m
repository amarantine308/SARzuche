//
//  CarDataManager.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CarDataManager.h"
#import "ConstDefine.h"

#pragma mark - SelectedCar
@implementation SelectedCar

@synthesize m_carId;
@synthesize m_carFile;
@synthesize m_carseries;
@synthesize m_dayPrice;
@synthesize m_discount;
@synthesize m_model;
@synthesize m_plateNum;
@synthesize m_unitPrice;
@synthesize m_branchid;

@end


#pragma mark - car Price
@implementation SrvCarPrice
@synthesize m_damagePrice;
@synthesize m_dayprice;
@synthesize m_delayfee;
@synthesize m_dispafee;
@synthesize m_enddate;
@synthesize m_id;
@synthesize m_lgaldesit;
@synthesize m_mileage;
@synthesize m_pricetype;
@synthesize m_startDate;
@synthesize m_timeList;
@end

#pragma mark - CarDataManager
@implementation CarDataManager


+(CarDataManager *)shareInstance
{
    static CarDataManager *handle;
    @synchronized(self)
    {
        if (nil == handle) {
            handle = [[CarDataManager alloc] init];
        }
        
        return handle;
    }
    
    return nil;
}


#pragma mark - car Info

/**
 *方法描述：设置选择车辆信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setSelCar:(NSDictionary *)carDic
{
    if (nil == carDic)
    {
        m_selCar = nil;
    }
    
    if (nil == m_selCar) {
        m_selCar = [[SelectedCar alloc] init];
    }
    m_selCar.m_unitPrice = [NSString stringWithFormat:@"%@", [carDic objectForKey:@"unitPrice"]];
    m_selCar.m_dayPrice = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"dayPrice"]];
    NSString *strModel = [[NSString alloc] initWithFormat:@"%@", [carDic objectForKey:@"model"]];
    NSString *resModel = [strModel stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    m_selCar.m_model = [NSString stringWithFormat:@"%@",resModel];
    m_selCar.m_carseries = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"carseries"]];
    NSString *strTmp = [[NSString alloc] initWithFormat:@"%@",[carDic objectForKey:@"plateNum"]];
    NSString *resPlate = [strTmp stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    m_selCar.m_plateNum = [NSString stringWithFormat:@"%@",resPlate];
    m_selCar.m_discount = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"activePrice"]];
    m_selCar.m_carFile = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"carFile"]];
    m_selCar.m_carId = [NSString stringWithFormat:@"%@", [carDic objectForKey:@"id"]];
    m_selCar.m_branchid = [NSString stringWithFormat:@"%@", GET([carDic objectForKey:@"branchid"])];
    
    if ([m_selCar.m_discount isEqualToString:@"(null)"])
    {
        m_selCar.m_discount = nil;
    }
}

// 当前选择的车辆
-(SelectedCar *)getSelCar
{
    return m_selCar;
}

#pragma mark - all history car
// 添加历史订单车辆
-(void)addHistoryCar:(NSDictionary *)carDic
{
    if (m_allHistoryCarDic == nil) {
        m_allHistoryCarDic = [[NSMutableDictionary alloc] init];
    }
    

    SelectedCar *tmpCar = [[SelectedCar alloc] init];

    tmpCar.m_unitPrice = [NSString stringWithFormat:@"%@", [carDic objectForKey:@"unitPrice"]];
    tmpCar.m_dayPrice = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"dayPrice"]];
    NSString *strModel = [[NSString alloc] initWithFormat:@"%@", [carDic objectForKey:@"model"]];
    NSString *resModel = [strModel stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    tmpCar.m_model = [NSString stringWithFormat:@"%@",resModel];
    tmpCar.m_carseries = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"carseries"]];
    NSString *strTmp = [[NSString alloc] initWithFormat:@"%@",[carDic objectForKey:@"plateNum"]];
    NSString *resPlate = [strTmp stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    tmpCar.m_plateNum = [NSString stringWithFormat:@"%@",resPlate];
    tmpCar.m_discount = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"activePrice"]];
    tmpCar.m_carFile = [NSString stringWithFormat:@"%@",[carDic objectForKey:@"carFile"]];
    tmpCar.m_carId = [NSString stringWithFormat:@"%@", [carDic objectForKey:@"id"]];
    tmpCar.m_branchid = [NSString stringWithFormat:@"%@", GET([carDic objectForKey:@"branchid"])];
    
    if ([tmpCar.m_discount isEqualToString:@"(null)"])
    {
        tmpCar.m_discount = nil;
    }
    
    [m_allHistoryCarDic setObject:tmpCar forKey:tmpCar.m_carId];
}

// 获取历史订单车辆
-(SelectedCar *)getHistoryCar:(NSString *)carId
{
    if (carId == nil || [carId length] == 0) {
        return nil;
    }
    
    return [m_allHistoryCarDic objectForKey:carId];
}

// 清除历史订单使用的车辆
-(void)clearAllHistoryCar
{
    [m_allHistoryCarDic removeAllObjects];
    m_allHistoryCarDic = nil;
}

#pragma mark - get car info
-(NSString *)GetUnitPriceWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"unitPrice"];
}

-(NSString *)GetDayPriceWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"dayPrice"];
}

-(NSString *)GetModelWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"model"];
}

-(NSString *)GetCarSeriesWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"carseries"];
}

-(NSString *)GetPlateNumWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"plateNum"];
}

-(NSString *)GetDiscountWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"activePrice"];
}

-(NSString *)GetCarFileWithCar:(NSDictionary *)carDic
{
    return [carDic objectForKey:@"carFile"];
}


#pragma mark - car price function
-(NSString *)getDateString:(NSDictionary *)timeDic
{
    /*
    startDate =         {
        date = 10;
        day = 5;
        hours = 0;
        minutes = 0;
        month = 9;
        seconds = 0;
        time = 1412870400000;
        timezoneOffset = "-480";
        year = 114;
    };*/
//    NSString *month = [timeDic objectForKey:@"month"];
//    NSString *day = [timeDic objectForKey:@"day"];
    
//    NSString *strRet;
    return nil;
}

/**
 *方法描述：设置日价格
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(void)setCarPrice:(NSDictionary *)srvPrice withType:(srvCarPriceType)type
{
    SrvCarPrice *tmpCarPrice = [[SrvCarPrice alloc] init];
 
    if (nil == srvPrice) {
        tmpCarPrice = nil;
    }
    else
    {
        tmpCarPrice.m_damagePrice = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"damagePrice"])];
        tmpCarPrice.m_dayprice = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"dayprice"])];
        tmpCarPrice.m_delayfee = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"delayfee"])];
        tmpCarPrice.m_dispafee = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"dispafee"])];
        tmpCarPrice.m_enddate = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"enddate"])];
        tmpCarPrice.m_id = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"id"])];
        tmpCarPrice.m_lgaldesit = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"lgaldesit"])];
        tmpCarPrice.m_mileage = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"mileage"])];
        tmpCarPrice.m_pricetype = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"pricetype"])];
        tmpCarPrice.m_startDate = [NSString stringWithFormat:@"%@", GET([srvPrice objectForKey:@"startDate"])];
        tmpCarPrice.m_timeList = [[NSArray alloc] initWithArray:[srvPrice objectForKey:@"timeList"]];
    }
    
    switch (type) {
        case price_holiday:
            m_holidayPrice = tmpCarPrice;
            break;
        case price_weekend:
            m_weekendPrice = tmpCarPrice;
            break;
        case price_workday:
            m_workdayPrice = tmpCarPrice;
            break;
        default:
            break;
    }
}

// 里程费
-(NSString *)getMileage
{
    return m_workdayPrice.m_mileage;
}
// 调度价格
-(NSString *)getScheduling
{
    return m_workdayPrice.m_dispafee;
}

// 获取车辆违章破损价格
-(NSString *)getDeposit
{
    NSInteger damage = [m_workdayPrice.m_damagePrice integerValue];
    NSInteger lgaldeit = [m_workdayPrice.m_lgaldesit integerValue];
    
    return [NSString stringWithFormat:@"%d", damage + lgaldeit];
}

/**
 *方法描述：获取工作日／节假日／休息日价格
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getDayPriceWithType:(srvCarPriceType)type
{
    switch (type)
    {
        case price_holiday:
            return m_holidayPrice.m_dayprice;
            break;
        case price_weekend:
            return m_weekendPrice.m_dayprice;
            break;
        case price_workday:
            return m_workdayPrice.m_dayprice;
            break;
        default:
            return nil;
            break;
    }
}

/**
 *方法描述：格式化节假日区间
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getHolidayDuration
{
    NSString *startDay = @"";
    NSString *endDay= @"";
    
    if (!(nil == startDay || 0 == [startDay length]) && !(nil == endDay || 0 == [endDay length]))
    {
        return nil;
    }
    
    NSString *strRet = [NSString stringWithFormat:@"%@-%@", startDay, endDay];
    
    return strRet;
}

/**
 *方法描述：获取指定工作日／休息日／节假日车辆价格
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(SrvCarPrice *)getCarPrice:(srvCarPriceType)type
{
    switch (type) {
        case price_holiday:
            return m_holidayPrice;
            break;
        case price_weekend:
            return m_weekendPrice;
            break;
        case price_workday:
            return m_workdayPrice;
            break;
        default:
            return nil;
            break;
    }
}



/**
 *方法描述：获取指定格式时间字串
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getHHMM:(NSString*)time
{
    NSArray *tmpArr = [time componentsSeparatedByString:@":"];
    NSString *hh = [tmpArr objectAtIndex:0];
    NSString *mm = [tmpArr objectAtIndex:1];
    
    NSString *resRet = [NSString stringWithFormat:@"%@:%@", hh, mm];

    return resRet;
}

/**
 *方法描述：解析车辆价格信息
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSArray *)getCarPriceArray:(srvCarPriceType)type
{
    SrvCarPrice *tmpPrice = [self getCarPrice:type];
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    NSString *durationTime = nil;
    NSString *price = nil;
    NSString *disPrice = nil;
    NSInteger nCount = [tmpPrice.m_timeList count];
    for (NSInteger i = 0; i < nCount; i++)
    {
        NSDictionary *tmpDic = [tmpPrice.m_timeList objectAtIndex:i];
        NSString *sTime = [tmpDic objectForKey:@"stime"];
        NSString *eTime = [tmpDic objectForKey:@"etime"];
        
        if ([sTime length] > 0 && [eTime length] > 0) {
            durationTime = [NSString stringWithFormat:@"%@-%@", [self getHHMM:sTime], [self getHHMM:eTime]];
            price = [NSString stringWithFormat:@"%@", GET([tmpDic objectForKey:@"price"])];
            disPrice = [NSString stringWithFormat:@"%@", GET([tmpDic objectForKey:@"disprice"])];
            NSLog(@"%@, %@, %@", durationTime, price, disPrice);
            NSDictionary *tmpDic = [[NSDictionary alloc] initWithObjectsAndKeys:durationTime, @"duration", price, @"price", disPrice, @"disPrice", nil];
            [retArr addObject:tmpDic];

        }
        else
        {
            break;
        }
        
    }

    return retArr;
}

/**
 *方法描述：转换时间显示格式
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)covertDateString:(NSString *)date
{
    // "2014-10-31" -> "10.31"
    NSArray *tmpArr = [date componentsSeparatedByString:@"-"];
    if ([tmpArr count] == 3) {
        NSString *month = [tmpArr objectAtIndex:1];
        NSString *day = [tmpArr objectAtIndex:2];
        NSString *resRet = [NSString stringWithFormat:@"%@.%@", month, day];

        return resRet;
    }
    
    return @"";
}

/**
 *方法描述：格式化节假日时间
 *创建人：
 *创建时间：
 *修改人：
 *修改原因：
 *修改时间：
 */
-(NSString *)getHolidayDateString
{
    NSString *start = [self covertDateString:m_holidayPrice.m_startDate];
    NSString *end = [self covertDateString:m_holidayPrice.m_enddate];
    
    if ((nil != start && [start length] > 0) && (nil != end && [end length] > 0)) {
        NSString *resRet = [NSString stringWithFormat:@"%@-%@", start, end];
        return resRet;
    }
    
    return @"";
}


-(NSString *)getHourPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat
{
    return @"";
}


-(NSString *)getDayPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat
{
    return @"";
}

-(NSString *)getHourDiscountPriceWithTime:(NSString *)strTime withTimeFormat:(NSString *)strFormat
{
    return @"";
}

@end
