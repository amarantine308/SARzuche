//
//  BranchesTableView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BranchesTableCell.h"
#import "CommonTableView.h"


@protocol BranchesTableViewDelegate <NSObject>

-(void)selBranche:(NSDictionary *)brancheData;
-(void)selBlock:(NSString *)blockName;

@optional
-(void)getMoreDate:(branchesViewType)type;
-(void)regetData:(branchesViewType) type;

@end

@interface BranchesTableView : UIView<UITableViewDataSource, UITableViewDelegate, CommonTableViewDelegate>

@property(nonatomic)branchesViewType m_tableType;
@property(nonatomic, weak)id<BranchesTableViewDelegate> delegate;
@property(nonatomic)NSInteger m_totalsItem;

- (id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame forBlock:(branchesViewType)type;


-(void)searchTableData:(NSArray *)dataArray;// for search 
-(void)setTableData:(NSArray *)dataArray;
-(void)setTableData:(NSArray *)dataArray withBlock:(NSString *)blockName;
-(void)setPosition:(CLLocationDegrees)latitude withLon:(CLLocationDegrees)longitude;

-(void)getMoreRequestFailed;
@end
