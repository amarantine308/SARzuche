//
//  AllCarModelView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCarInfoView.h"
#import "CommonTableView.h"

@protocol AllCarModeViewDelegate <NSObject>

@optional
-(void)toOderCar:(NSInteger)index;

-(void)getMoreCar:(BOOL)bRefresh;
@end


@interface AllCarModelView : UIView<UITableViewDataSource, UITableViewDelegate, PersonalCarInfoViewDelegate, CommonTableViewDelegate>

@property(nonatomic, weak)id<AllCarModeViewDelegate> m_delegate;

-(void) updateCars:(NSMutableArray *)arr totalNum:(NSInteger)numbers;
-(void)viewFrameChanged;
@end
