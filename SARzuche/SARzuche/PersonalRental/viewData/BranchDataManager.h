//
//  BranchDataManager.h
//  SARzuche
//
//  Created by 徐守卫 on 14-10-8.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrancheData : NSObject

@property(nonatomic, strong)NSString *m_addTime;
@property(nonatomic, strong)NSString *m_address;
@property(nonatomic, strong)NSString *m_area;
@property(nonatomic)NSInteger m_carNumber;
@property(nonatomic, strong)NSString *m_city;
@property(nonatomic, strong)NSString *m_contacts;
@property(nonatomic, strong)NSString *m_id;
@property(nonatomic, strong)NSString *m_ifEnable;
@property(nonatomic, strong)NSString *m_latitude;
@property(nonatomic, strong)NSString *m_longitude;
@property(nonatomic, strong)NSString *m_name;
@property(nonatomic, strong)NSString *m_phone;
@property(nonatomic, strong)NSString *m_telphone;

-(void)setBranchData:(NSDictionary *)dic;
@end

@interface BranchDataManager : NSObject
{
    BrancheData *m_takeBranche;// 根据网点id获取到的网点数据， 与选择网点获取到的数据结构有别
    BrancheData *m_givebackBranche;// 根据网点id获取到的网点数据， 与选择网点获取到的数据结构有别
    
    // for map
//    NSDictionary *m_takeBranchDic;// 未下单前选择的网点
//    NSDictionary *m_givebackBranchDic;// 未下单前选择的网点
    NSMutableArray *m_takeBranchesArr;
    NSMutableArray *m_givebackBranchesArr;
}

+(BranchDataManager *)shareInstance;

#pragma mark - 根据网点ID获取到的网点数据
-(BrancheData *)getBranchDataWithType:(BOOL)bTake;
-(void)setBranchData:(NSDictionary *)dic withType:(BOOL)bTake;

// branche dic for map
#pragma mark - 从网点列表选择的网点
-(void)setSelBranchDic:(NSDictionary *)dic isSelTake:(BOOL)bTake;
-(NSMutableArray *)getSelBranchWithType:(BOOL)bTake;
@end
