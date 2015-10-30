//
//  ShortMenuView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-18.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, shortMenuEnum)
{
    menu_home,
    menu_personal,
    menu_enterprise,
    menu_usercenter,
    menu_myorder,
    menu_helper,
    menu_preRental,
};

@protocol ShortMenuViewDelegate <NSObject>

@required
-(void)shortMenuSelect:(shortMenuEnum)index;
@optional
-(void)shortMenuExit;

@end

@interface ShortMenuView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *m_menu;
    NSArray *m_nemuArray;
}

@property(nonatomic, weak)id<ShortMenuViewDelegate> delegate;
@end
