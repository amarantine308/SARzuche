//
//  BranchDataManager.m
//  SARzuche
//
//  Created by 徐守卫 on 14-10-8.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "BranchDataManager.h"

@implementation BrancheData

@synthesize m_address;
@synthesize m_addTime;
@synthesize m_area;
@synthesize m_carNumber;
@synthesize m_city;
@synthesize m_contacts;
@synthesize m_id;
@synthesize m_ifEnable;
@synthesize m_latitude;
@synthesize m_longitude;
@synthesize m_name;
@synthesize m_phone;
@synthesize m_telphone;
//  设置网点数据
-(void)setBranchData:(NSDictionary *)dic
{
    m_telphone = [NSString stringWithFormat:@"%@", [dic objectForKey:@"telphone"]];
    m_phone = [NSString stringWithFormat:@"%@", [dic objectForKey:@"phone"]];
    m_name = [NSString stringWithFormat:@"%@", [dic objectForKey:@"name"]];
    m_longitude = [NSString stringWithFormat:@"%@", [dic objectForKey:@"longitude"]];
    m_latitude = [NSString stringWithFormat:@"%@", [dic objectForKey:@"latitude"]];
    m_ifEnable = [NSString stringWithFormat:@"%@", [dic objectForKey:@"ifEnable"]];
    m_id = [NSString stringWithFormat:@"%@", [dic objectForKey:@"id"]];
    m_contacts = [NSString stringWithFormat:@"%@", [dic objectForKey:@"contacts"]];
    m_city = [NSString stringWithFormat:@"%@", [dic objectForKey:@"city"]];
    m_carNumber = [[dic objectForKey:@"carNumber"] integerValue];
    m_area = [NSString stringWithFormat:@"%@", [dic objectForKey:@"area"]];
    m_address = [NSString stringWithFormat:@"%@", [dic objectForKey:@"address"]];
    m_addTime = [NSString stringWithFormat:@"%@", [dic objectForKey:@"addTime"]];
}
@end


@implementation BranchDataManager

+(BranchDataManager *)shareInstance
{
    static BranchDataManager *handle;
    @synchronized(self)
    {
        if (nil == handle) {
            handle = [[BranchDataManager alloc] init];
        }
        
        return handle;
    }
    
    return nil;
}

// 设置网点信息
/*branches =     (
 {
 addTime = "2014-09-23";
 address = "\U4ed9\U6797\U5929\U6d66\U8def1\U53f7
 \n";
 area = "\U6d66\U53e3\U533a";
 carNumber = 1;
 city = "\U5357\U4eac";
 contacts = 1;
 id = 02e8b4afea184c6382640e9759e9ce30;
 ifEnable = 0;
 latitude = "31.975854";
 longitude = "118.956973";
 name = "\U4ed9\U6797\U5929\U6d66\U8def1\U53f7
 \n\U7f51\U70b9";
 phone = 13888888888;
 telphone = 13888888888;
 }
 );*/
-(void)setBranchData:(NSDictionary *)dic  withType:(BOOL)bTake
{
    if (bTake) {
        
        if (nil == m_takeBranche) {
            m_takeBranche = [[BrancheData alloc] init];
        }
        
        [m_takeBranche setBranchData:dic];
        
        return;
    }
    
    
    if (nil == m_givebackBranche) {
        m_givebackBranche = [[BrancheData alloc] init];
    }
    
    [m_givebackBranche setBranchData:dic];
}

// 获取网点数据
-(BrancheData *)getBranchDataWithType:(BOOL)bTake
{
    if (bTake) {
        return m_takeBranche;
    }
    
    return m_givebackBranche;
}


// branche dic for map
#pragma mark - 从网点列表选择的网点
-(void)setSelBranchDic:(NSDictionary *)dic isSelTake:(BOOL)bTake
{
    if (bTake)
    {
       NSDictionary *takeBranchDic = [[NSDictionary alloc] initWithDictionary:dic];
        m_takeBranchesArr = [[NSMutableArray alloc] init];
        [m_takeBranchesArr addObject:takeBranchDic];
    }
    else
    {
        NSDictionary *givebackBranchDic = [[NSDictionary alloc] initWithDictionary:dic];
        m_givebackBranchesArr = [[NSMutableArray alloc] init];
        [m_givebackBranchesArr addObject:givebackBranchDic];
    }
}

// 用于网点跳转到地图
-(NSMutableArray *)getSelBranchWithType:(BOOL)bTake
{
    if (bTake)
    {
        return m_takeBranchesArr;
    }
    else
    {
        return m_givebackBranchesArr;
    }
}

@end
