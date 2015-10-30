//
//  IntensionCarView.h
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntensionCarInfoView.h"

@interface IntensionCarView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *carTableView;
    NSMutableArray *carDataSource;
    
    IntensionCarInfoView *carInfoView;
    
    UIView *lettersBackView;
    NSMutableArray *lettersArray;
    NSMutableArray *m_lettersInSection;
    
    NSString *currentLetter;
    
    BOOL isload;
}

@property (nonatomic, retain) NSMutableArray *carDataSource;
@property (nonatomic, retain) UITableView *carTableView;

- (void)updateTableView:(NSDictionary *)dic;


@end
