//
//  HomeSubView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "HomeSubView.h"
#import "ConstDefine.h"

@implementation HomeSubView
#define COLOR_TITLE [UIColor blackColor]

// 初始化 首页 九宫格 对应View
- (id)initWithFrame:(CGRect)frame title:(NSString *)strTitle image:(NSString *)imageName withBgdImg:(NSString *)bgrndImg
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:imageName];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        imgView.frame = CGRectMake(10, 0, 80, 80);
        
        UIImage* back = [UIImage imageNamed:bgrndImg];
        UIImageView *backImgView = [[UIImageView alloc] initWithImage:back];
        backImgView.frame = CGRectMake(10, 0, 80, 80);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 100, 20)];
        label.text  = strTitle;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = FONT_HOME;
        label.textColor = COLOR_HOME;
        [self addSubview:label];
        [self addSubview:backImgView];
        [self addSubview:imgView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setSubViewTag:(NSInteger)tag
{
    self.tag = tag;
}



@end
