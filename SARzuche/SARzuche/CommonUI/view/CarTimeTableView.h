//
//  CarTimeTableView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-23.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, rectColor)
{
    rectYellow,
    rectRed
};

@interface RectView : NSObject

@property(nonatomic)CGRect m_rect;
@property(nonatomic)rectColor m_clr;
@property(nonatomic)NSInteger m_days; // 今天 0； 明天：1， 后天： 2
@end


@interface StringView : NSObject
@property(nonatomic)CGRect m_strRect;
//@property(nonatomic)CGSize m_strDrawPos;
@property(nonatomic, strong)NSString *m_strDraw;
@end

@interface CarTimeTableView : UIView
{
    NSInteger m_todayStartY;
    NSInteger m_tomorrowStartY;
    NSInteger m_thirdDayStartY;
    
    CGRect m_frstStrTop;
    CGRect m_frstStrBottom;
    CGRect m_secStrTop;
    CGRect m_secStrBottm;
    CGRect m_thrdStrTop;
    CGRect m_thrdStrBottom;
    
    CGRect m_frstScale;
    CGRect m_secdScale;
    CGRect m_thrdScale;
    
    NSInteger m_viewHeight;
    
    NSMutableArray *m_rectArray; // rectView array
    NSMutableArray *m_strDrawArr1;
    NSMutableArray *m_strDrawArr2;
    NSMutableArray *m_strDrawArr3;
    NSMutableArray *m_strDrawArr4;
    NSMutableArray *m_strDrawArr5;
    NSMutableArray *m_strDrawArr6;
    
    NSMutableArray *m_strDrawScale;
    
    NSArray *m_checking1;
    NSArray *m_checking2;
    NSArray *m_checking3;
    NSArray *m_using1;
    NSArray *m_using2;
    NSArray *m_using3;
}



-(void)updateChecking:(NSArray *)chk1 check2:(NSArray *)chk2 check3:(NSArray *)chk3;
-(void)updateUsing:(NSArray *)using1 use2:(NSArray *)using2 check3:(NSArray *)using3;
@end
