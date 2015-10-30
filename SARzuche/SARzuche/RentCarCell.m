//
//  RentCarCell.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RentCarCell.h"
#define RGB(r,g,b,al) [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:al]
#define TEXTCOLOR RGB(136, 136, 136, 1)

@implementation RentCarCell
@synthesize delegate;
@synthesize lab_car_brand;
@synthesize lab_car_num;
@synthesize lab_car_series;
@synthesize lab_cycle;
@synthesize lab_intentce;
@synthesize lab_submit_time;
@synthesize lab_take_time;
@synthesize btn_showInfo;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    //[vi_rent setBackgroundColor:RGB(236, 234, 241, 1)];
    lab_car_brand.textColor = TEXTCOLOR;
    lab_car_num.textColor = TEXTCOLOR;
    lab_car_series.textColor = TEXTCOLOR;
    lab_cycle.textColor = TEXTCOLOR;
    lab_submit_time.textColor = TEXTCOLOR;
    lab_take_time.textColor = TEXTCOLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//企业租车next方法调用
- (IBAction)getRentCarInfo:(id)sender
{
    UIButton *btn = sender;
    NSInteger index = btn.tag-100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rentCarInfo:)]) {
        [self.delegate rentCarInfo:index];
    }
}

@end
