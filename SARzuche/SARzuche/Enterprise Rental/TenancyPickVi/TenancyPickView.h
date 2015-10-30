//
//  TenancyPickView.h
//  SARzuche
//
//  Created by dyy on 14-10-29.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TenancyPickDelegate <NSObject>

- (void)clickSureBtnInTenancyPick:(NSString *)str;

@end

@interface TenancyPickView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *pick_tenancy; //租期选择器
    NSArray *list_tenancy;
}
@property (nonatomic, weak) id <TenancyPickDelegate> delegate;

@end
