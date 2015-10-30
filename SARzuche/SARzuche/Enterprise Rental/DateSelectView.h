//
//  TenancySelectView.h
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateSelectViewDelegate <NSObject>
-(void)selectString:(NSString *)str;
@end

@interface DateSelectView : UIView<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray *pDataSource;
@property(nonatomic, assign)id<DateSelectViewDelegate> delegate;

@end


@interface DateSelectView (UIUseDatePicker)

-(id)initWithFrame:(CGRect)frame StartDate:(NSDate *)startDate;
-(void)setTitle:(NSString*)strTitle;
@end