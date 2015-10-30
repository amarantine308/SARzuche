//
//  FMUMath.h
//  FMLibrary
//
//  Created by leks on 13-3-22.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import <Foundation/Foundation.h>


CG_INLINE CGRect
FMURectSetX(CGRect r, CGFloat x)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectSetY(CGRect r, CGFloat y)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectSetOrigin(CGRect r, CGPoint origin)
{
    CGRect rect;
    rect.origin.x = origin.x;
    rect.origin.y = origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectSetWidth(CGRect r, CGFloat width)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectSetHeight(CGRect r, CGFloat height)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
FMURectSetSize(CGRect r, CGSize size)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = size.width;
    rect.size.height = size.height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetX(CGRect r, CGFloat x)
{
    CGRect rect;
    rect.origin.x = r.origin.x + x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetY(CGRect r, CGFloat y)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y + y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetOrigin(CGRect r, CGPoint offset)
{
    CGRect rect;
    rect.origin.x = r.origin.x + offset.x;
    rect.origin.y = r.origin.y + offset.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetWidth(CGRect r, CGFloat width)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width + width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetHeight(CGRect r, CGFloat height)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height + height;
    return rect;
}

CG_INLINE CGRect
FMURectOffsetSize(CGRect r, CGSize size)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width + size.width;
    rect.size.height = r.size.height + size.height;
    return rect;
}

@interface FMUMath : NSObject

/*
 判断某个点是否在矩形内
 */
+(BOOL)isPoint:(CGPoint)p inRect:(CGRect)rect;

/*
 判断两个矩形是否有交集
 */
+(BOOL)isRect:(CGRect)r1 intersectRect:(CGRect)r2;

/*
 计算文件大小，格式化显示
 */
+(NSString*)formattedTextForFileSize:(NSNumber*)fileSize;
@end