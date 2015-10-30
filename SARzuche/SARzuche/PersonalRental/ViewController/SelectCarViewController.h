//
//  SelectCarViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "AllCarModelView.h"

@interface SelectCarViewController : NavController<AllCarModeViewDelegate, UIScrollViewDelegate>

-(id)initWithCondition:(NSString *)city Branche:(NSString *)branche Take:(NSString *)takeTime GiveBack:(NSString *)gviebackTime;
@end
