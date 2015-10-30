//
//  PersonalCarInfoView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@protocol PersonalCarInfoViewDelegate <NSObject>

@optional
-(void)toOrder;
-(void)jumpToMapWithBranche:(BOOL)bTakeBrance;
@end

typedef NS_ENUM(NSInteger, useType)
{
    forDefault,
    forMyCar,
    forSelectCar,
    forUserInfo,
    forCarInfoNoPrice,
    forCurOrder
};

@interface PersonalCarInfoView : UIView

@property(nonatomic, weak)id<PersonalCarInfoViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame forUsed:(useType)type;

// Order info
-(void)setSelectConditionWithBranche:(NSString *)tBhranche
                            takeTime:(NSString *)tTime
                         backBranche:(NSString *)bBranche
                            backTime:(NSString *)bTime;

-(void)setselectCarWithUnitPrice:(NSString *)unitPrice
           dayPrice:(NSString *)dPrice
           carModel:(NSString *)model
           carSerie:(NSString *)serie
           carPlate:(NSString *)plate
           discount:(NSString *)discount
           imageUrl:(NSString *)url;
@end
