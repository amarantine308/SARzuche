//
//  HomeSubView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SUB_IMAGE_H         80
#define SUB_LABEL_H         20
#define SUB_GAP             5
#define SUB_VIEW_H               110

@protocol HomeSubViewDelegate <NSObject>

-(void)entryModel:(NSInteger)tag;

@end


@interface HomeSubView : UIButton


- (id)initWithFrame:(CGRect)frame title:(NSString *)strTitle image:(NSString *)imageName withBgdImg:(NSString *)bgrndImg;
-(void)setSubViewTag:(NSInteger)tag;
@end
