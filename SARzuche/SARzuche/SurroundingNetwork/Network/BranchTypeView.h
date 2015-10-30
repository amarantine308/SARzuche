//
//  BranchTypeView.h
//  SARzuche
//
//  Created by admin on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BranchTypeView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *pDataSource;
@end
