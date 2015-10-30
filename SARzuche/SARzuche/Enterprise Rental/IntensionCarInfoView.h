//
//  IntensionCarInfoView.h
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntensionCarInfoView : UIView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *pDataSource;

- (void)reloadData:(id)data;
@end
