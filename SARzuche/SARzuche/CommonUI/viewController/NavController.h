//
//  NavController.h
//  Weibo
//
//  Created by sun sun on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomNavBarView.h"
#import "ShortMenuView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@interface NavController : UIViewController<ShortMenuViewDelegate>
{
    NSString *leftNavBtnName;
	NSString *rightNavBtnName;
    
    CustomNavBarView *customNavBarView;
    
    // for short menu
    BOOL m_bShowMenu;
    UIButton *m_shortMenuBtn;
    ShortMenuView *m_shortMenu;
}

@property(nonatomic,strong)CustomNavBarView *customNavBarView;

- (void) navLeftBtnPressed:(id)sender;
- (void) navRightBtnPressed:(id)sender;

-(void)showShortMenuBtn:(BOOL)bShow;
-(void)shortMenuPressed:(id)sender;
@end
