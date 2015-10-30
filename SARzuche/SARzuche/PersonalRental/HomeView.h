//
//  HomeView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-13.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeSubView.h"
#import "PageScrollerView.h"


// tag
#define TAG_PERSONAL_RENTAL         10001
#define TAG_COMPANY_RENTAL          10002
#define TAG_BRANCHES                10003
#define TAG_MYINFO                  10004

@protocol HomeViewDelegate <NSObject>

-(void)enterPersonalRental;

-(void)enterCompanyRental;

-(void)enterBranches;

-(void)enterMyInfo;

-(void)enterMyCar;

-(void)enterPreferential;

-(void)enterAd:(NSString *)url;
@end


@interface HomeView : UIView<HomeSubViewDelegate, PageScrollerViewDelegate>
{
}

@property(nonatomic, weak)id<HomeViewDelegate> delegate;


-(void)setImageArr:(NSArray *)imgArr;
@end
