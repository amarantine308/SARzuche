//
//  LocationViewController.h
//  SARzuche
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"

@protocol LocationViewControllerDelegate <NSObject>

-(void)getLocation:(NSDictionary *)dic startOrEnd:(NSString *)locationTitle;
@end

@interface LocationViewController : NavController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, BMKPoiSearchDelegate>

@property(nonatomic, assign)BOOL myLocation;
@property(nonatomic, assign)id<LocationViewControllerDelegate> delegate;

@end
