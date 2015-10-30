//
//  CustomAlertView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-11-6.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView
{
    NSTimeInterval m_interval;
    NSTimer *m_timer;
}
#if 0
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION NS_EXTENSION_UNAVAILABLE_IOS("Use UIAlertController instead.");
{
    m_interval = 0;
    return [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}
#endif



- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles withDismissInterval:(NSInteger)interval
{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        m_interval = interval;
    }
    
    return self;
}

- (void)dismissAlertView:(NSTimer*)timer {
    NSLog(@"Dismiss alert view");
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
}


-(void)needDismisShow
{
    if (m_interval > 0) {
        m_timer = [NSTimer scheduledTimerWithTimeInterval:m_interval
                                     target:self
                                   selector:@selector(dismissAlertView:)
                                   userInfo:nil
                                    repeats:NO];
    }
    
    [self show];
}

-(void)dealloc
{
    NSLog(@"-- dealloc --");
    [m_timer invalidate];
    m_timer = nil;
}

@end
