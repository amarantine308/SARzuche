//
//  CustomDrawView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-14.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CustomDrawView.h"
#import "ConstDefine.h"

@implementation CustomDrawView
@synthesize m_style;

- (id)initWithFrame:(CGRect)frame withStyle:(customStyle)style fillColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_style = style;
        m_color = color;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withStyle:(customStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        m_style = style;
    }
    return self;
}

-(void)setFontSize:(CGFloat)fontSize
{
    m_fontSize = fontSize;
}

-(void)setLineWidth:(CGFloat)width
{
    m_lineWidth = width;
}


-(void)setCirRectangleColor:(UIColor *)color
{
    m_color = [UIColor colorWithCGColor:color.CGColor];// color;
}

-(void)setText:(NSString*)str
{
    m_string = [NSString stringWithFormat:@"%@", str];
    
//    [self setNeedsDisplay];
}

-(void)drawText:(NSString*)str
{
    if (m_fontSize < 0.00001) {
        m_fontSize = 13.0;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if (IS_IOS7) {
        NSAttributedString *attributedStr = [[NSAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:m_fontSize], NSForegroundColorAttributeName : [UIColor blackColor] }];
        
        [attributedStr drawAtPoint:CGPointMake(1, 1)];
        
        CGRect tmpRect = self.frame;
        tmpRect.size.width = attributedStr.size.width;
        tmpRect.size.height = attributedStr.size.height;
    }
    else
#endif
    {
//        [[UIColor blackColor] set];
        [str drawInRect:self.frame withFont:[UIFont systemFontOfSize:m_fontSize]];
//        NSLog(@"DRAW TEXT ---- %@: %f, %.f, %.f, %.f", str, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    }
//    self.frame = tmpRect;
//    [str drawInRect:CGRectMake(1, 1, self.frame.size.width - 1, self.frame.size.height-1) withAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

-(void)drawLine:(NSInteger)lineWidth
{
    m_path = [UIBezierPath bezierPath];
    m_path.lineWidth = lineWidth;
    CGPoint startPoint = CGPointMake(3, self.frame.size.height/2);
    CGPoint endPoint = CGPointMake(self.frame.size.width - 3, self.frame.size.height/2);

    [m_path moveToPoint:startPoint];
    [m_path addLineToPoint:endPoint];

    m_bVerLine = NO;
}


-(void)drawVerLine:(NSInteger)lineWidth withColor:(UIColor *)color
{
    [[UIColor whiteColor] set];
    m_path = [UIBezierPath bezierPath];
//    [[UIColor whiteColor] setStroke];
    m_path.lineWidth = lineWidth;
    CGPoint startPoint = CGPointMake(1, 2);
    CGPoint endPoint = CGPointMake(1, self.frame.size.height - 2);
    
    [m_path moveToPoint:startPoint];
    [m_path addLineToPoint:endPoint];
    
    m_bVerLine = YES;
}


-(void)drawRectangle:(NSInteger)lineWidth
{
    m_path = [UIBezierPath bezierPath];
    m_path.lineWidth = lineWidth;
    [m_path moveToPoint:CGPointMake(1, 1)];
    [m_path addLineToPoint:CGPointMake(1, self.frame.size.height-1)];
    [m_path addLineToPoint:CGPointMake(self.frame.size.width-1, self.frame.size.height-1)];
    [m_path addLineToPoint:CGPointMake(self.frame.size.width-1, 1)];

    [m_path closePath];
}

-(void)drawRectangleWithFrame:(CGRect)rect withColor:(UIColor*)color
{
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [color setFill];
    [path fill];
}

-(void)drawRectangleWithColor:(UIColor *)color
{
#if 1
    m_path = [UIBezierPath bezierPathWithOvalInRect:self.frame];
    [[UIColor blueColor] setFill];
    [m_path fill];
#else
    self.backgroundColor = color;
    m_path = [UIBezierPath bezierPath];
    [m_path moveToPoint:CGPointMake(1, 1)];
    [m_path addLineToPoint:CGPointMake(1, self.frame.size.height-1)];
    [m_path addLineToPoint:CGPointMake(self.frame.size.width-1, self.frame.size.height-1)];
    [m_path addLineToPoint:CGPointMake(self.frame.size.width-1, 1)];
    [m_path fill];
#endif
    [m_path closePath];
}

-(void)drawCirRectangle:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
    /*画圆角矩形*/
    UIColor * aColor = [UIColor greenColor];// colorWithRed:0 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    
    float rightX = rect.size.width; // self.frame.size.width;
    float rightY = rect.size.height;// self.frame.size.height;
    float leftX = 0;
    float leftY = 0;
    float cir = ((rightY - leftY) / 2);
    float half =  cir/2;
    
    CGContextMoveToPoint(context, rightX, rightY-cir);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, rightX, rightY, rightX-cir, rightY, half);  // 右下角角度
    CGContextAddArcToPoint(context, leftX, rightY, leftX, rightY-cir, half); // 左下角角度
    CGContextAddArcToPoint(context, leftX, leftY, rightX-cir, leftY, half); // 左上角
    CGContextAddArcToPoint(context, rightX, leftY, rightX, rightY-cir, half); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
//    UIGraphicsPopContext();
}


-(void)drawRectangle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
    /*画圆角矩形*/
    UIColor * aColor = m_color ? m_color : kNavBackgroundColor;//[UIColor greenColor];// colorWithRed:0 green:1 blue:1 alpha:1];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);
    float rightX = self.frame.size.width;
    float rightY = self.frame.size.height;
    float leftX = 0;
    float leftY = 0;
    float cir = ((rightY - leftY) / 2);
    float half =  cir/2;
    
    CGContextMoveToPoint(context, rightX, rightY-cir);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, rightX, rightY, rightX-cir, rightY, half);  // 右下角角度
    CGContextAddArcToPoint(context, leftX, rightY, leftX, rightY-cir, half); // 左下角角度
    CGContextAddArcToPoint(context, leftX, leftY, rightX-cir, leftY, half); // 左上角
    CGContextAddArcToPoint(context, rightX, leftY, rightX, rightY-cir, half); // 右上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径

//    UIGraphicsPopContext();

}


-(void)drawOrderScale
{
//    [self drawRectangle];
    CGFloat startX = 0;//self.frame.origin.x;
    CGFloat startY = 0;//self.frame.origin.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height / 6;
    
    for (NSInteger i = 0; i < 3; i++) {
        CGRect forRect = CGRectMake(startX, startY + height * i, width, ((int)height/2)*2);
        
        [self drawCirRectangle:forRect];
        
        CGRect tmpRect = forRect;
        CGRect yellowRect = CGRectMake(tmpRect.origin.x + tmpRect.size.width/5, tmpRect.origin.y, tmpRect.size.width/5, tmpRect.origin.y + tmpRect.size.height);
        CGRect redRect = CGRectMake(tmpRect.origin.x+tmpRect.size.width, tmpRect.origin.y, tmpRect.size.width *2, tmpRect.size.height);
        [self drawRectangleWithFrame:yellowRect withColor:[UIColor redColor]];
        [self drawRectangleWithFrame:redRect withColor:[UIColor redColor]];
    }
}
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
    
     switch (m_style) {
         case customLine:
         {
             if (m_bVerLine) {
                 [[UIColor whiteColor] setStroke];                 
             }
             else
             {
                 [[UIColor grayColor] setStroke];
             }
             [m_path stroke];
//             [self drawRectangleWithColor:[UIColor whiteColor]];
         }
             break;
         case customRect:
             [m_path stroke];
             break;
         case customText:
         {
             [self drawText:m_string];
         }
             break;
         case customCirRectangle:
             [self drawRectangle];
             break;
         case customFillRect:
             if (nil != m_color) {
                 [self drawRectangleWithColor:m_color];
             }
             else
             {
                 [self drawRectangleWithColor:[UIColor redColor]];
             }
             break;
         case customDrawOrderTime:
             [self drawOrderScale];
             break;
         default:
             break;
     }
    
//    UIGraphicsPopContext();
 }


@end
