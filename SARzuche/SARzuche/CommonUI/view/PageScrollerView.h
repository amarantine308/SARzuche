//
//  PageScrollerView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageScrollerViewDelegate <NSObject>

@optional
-(void)scrollerViewExit;
-(void)enterContentWithUrl:(NSInteger)Url;

@end

@interface PageScrollerView : UIView<UIScrollViewDelegate>
{
}

@property(nonatomic, weak)id<PageScrollerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withImages:(NSArray *)imageViewArray;

-(void)autoScrollEnalbed:(BOOL)bAutoScroll;

-(void)ReplaceImage:(UIImageView *)newImage atIndex:(NSInteger)index;
-(void)deleteImages;
-(NSInteger)getImages;

-(void)setPageControllerHidden;
@end
