//
//  PageScrollerView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "PageScrollerView.h"

@interface PageScrollerView()
{
    UIScrollView *_scrollView;
    NSMutableArray *_images; // (UIImageView *) array
    NSInteger _pageCount;
    CGRect _imageSize;
    NSInteger _currentPageIndex;
    
    UIPageControl *_pageControl;
    NSTimer *_timer;
    
    BOOL _bNeedCircle;
}

@end


@implementation PageScrollerView
@synthesize delegate = _delegate;

-(void)autoScrollEnalbed:(BOOL)bAutoScroll
{
    if (bAutoScroll) {
        [self startAutoTurnPage];
        _bNeedCircle = YES;
    }
    else
    {
        _bNeedCircle = NO;
    }
}

-(void)startAutoTurnPage
{
    if(_pageCount <= 1)
    {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}

-(void)stopAutoTurnPage
{
    [_timer invalidate];
    _timer = nil;
}


-(NSInteger)getImages
{
    return [_images count];
}

-(void)deleteImages
{
    _pageCount = 0;
    [_images removeAllObjects];
}

-(void)ReplaceImage:(UIImageView *)newImage atIndex:(NSInteger)index
{
    if (index >= 0 && index < _pageCount) {
        [_images replaceObjectAtIndex:index withObject:newImage];
    }
    else
    {
        [_images addObject:newImage];
        _pageCount++;
        _pageControl.numberOfPages = _pageCount;
    }
    
    [self updateImage];
}


-(void)updateImage
{
    [self stopAutoTurnPage];
    
    for (UIView * subView in [_scrollView subviews])
    {
        [subView removeFromSuperview];
    }
    
    [self createScrollView];
    
    [self startAutoTurnPage];
}

- (id)initWithFrame:(CGRect)frame withImages:(NSArray *)imageViewArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _images = [NSMutableArray arrayWithArray:imageViewArray];
        _pageCount = [_images count];
        _imageSize = frame;
        // Initialization code
        [self createScrollView];
    }
    return self;
}


-(void)createScrollView
{
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    UIScrollView * tmpScrollView = [[UIScrollView alloc] initWithFrame:_imageSize];
    tmpScrollView.contentSize = CGSizeMake(_imageSize.size.width * _pageCount, 0);
    tmpScrollView.showsHorizontalScrollIndicator = NO;
    tmpScrollView.showsVerticalScrollIndicator = NO;
    tmpScrollView.pagingEnabled = YES;
    tmpScrollView.delegate = self;
    
    for (NSInteger i = 0; i < _pageCount; i++)
    {
        UIImageView *tmpImageView = [_images objectAtIndex:i];
        tmpImageView.frame = CGRectMake(_imageSize.size.width * i, 0, _imageSize.size.width, _imageSize.size.height);
        tmpImageView.userInteractionEnabled = YES;
        tmpImageView.tag = i;
        
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        [tmpImageView addGestureRecognizer:Tap];
        
        tmpImageView.contentMode = UIViewContentModeScaleToFill;
        [tmpScrollView addSubview:tmpImageView];
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _imageSize.size.height - 40, _imageSize.size.width, 20)];
    _pageControl.numberOfPages = _pageCount;
    
    _scrollView = tmpScrollView;
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    tmpScrollView = nil;
}

-(void)resetScrollOffset
{
    _currentPageIndex = 0;
    _pageControl.currentPage = _currentPageIndex;
    [_scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)nextPage
{
    int page = _currentPageIndex;
    page++;

    if (page == _pageCount) {
        [self resetScrollOffset];
        return;
    }
    
    _currentPageIndex = page;
    _pageControl.currentPage = _currentPageIndex;
    CGPoint point = CGPointMake(_imageSize.size.width *_currentPageIndex, 0);
//    [_scrollView scrollRectToVisible:CGRectMake(_imageSize.size.width * _currentPageIndex, 0,_imageSize.size.width,_imageSize.size.height) animated:YES];
    [_scrollView setContentOffset:point animated:YES];
}




#pragma mark - scroll delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger nPage = (NSInteger)(_scrollView.contentOffset.x/_imageSize.size.width);

    if (_currentPageIndex == 0 && (nPage == (_pageCount - 1)))
    {
        _currentPageIndex = 0;
        _pageControl.currentPage = 0;
        [_scrollView setContentOffset:CGPointMake(0, 0)];

        [_timer invalidate];
        _timer = nil;
        if (_bNeedCircle) {
            [self startAutoTurnPage];
        }
        return;
    }

    _currentPageIndex = _scrollView.contentOffset.x/_imageSize.size.width;
    _pageControl.currentPage = _currentPageIndex;
    
    [_timer invalidate];
    _timer = nil;
    if (_bNeedCircle) {
        [self startAutoTurnPage];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"DID SCROLL :%f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x > (_imageSize.size.width * (_pageCount - 1))) {
        if (NO == _bNeedCircle)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(scrollerViewExit)]) {
                [_delegate scrollerViewExit];
            }
        }
        else
        {
//            [self resetScrollOffset];
//            [self nextPage];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}


- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    NSLog(@"image pressed %d", sender.view.tag);
    NSInteger index = sender.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(enterContentWithUrl:)])
    {
        [self.delegate enterContentWithUrl:index];
    }
    
    if (2 == sender.view.tag && self.delegate && [self.delegate respondsToSelector:@selector(scrollerViewExit)]) {
        [self.delegate scrollerViewExit];
    }
}


-(void)setPageControllerHidden
{
    _pageControl.hidden = YES;
}
@end
