//
//  CustomDrawView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-14.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, customStyle)
{
    customNone,
    customLine,
    customRect,
    customCirRectangle,
    customFillRect,
    customText,
    customDrawOrderTime
};

@interface CustomDrawView : UIView
{
    CGFloat m_lineWidth;
    UIBezierPath *m_path;
    CGFloat m_fontSize;
    
    UIColor *m_color;
    BOOL m_bVerLine;
    
    NSString *m_string;
}

@property(nonatomic)NSInteger m_style;

- (id)initWithFrame:(CGRect)frame withStyle:(customStyle)style;


-(void)setLineWidth:(CGFloat)width;
-(void)setFontSize:(CGFloat)fontSize;

-(void)drawVerLine:(NSInteger)lineWidth withColor:(UIColor *)color;
-(void)drawLine:(NSInteger)lineWidth;
-(void)drawRectangle:(NSInteger)lineWidth;
-(void)drawText:(NSString*)str;

-(void)setText:(NSString*)str;

-(void)setCirRectangleColor:(UIColor *)color;
@end
