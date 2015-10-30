//
//  FMUMath.m
//  FMLibrary
//
//  Created by leks on 13-3-22.
//  Copyright (c) 2013年 House365. All rights reserved.
//

#import "FMUMath.h"

@implementation FMUMath

/*
 判断某个点是否在矩形内
 */
+(BOOL)isPoint:(CGPoint)p inRect:(CGRect)rect
{
    if (p.x < rect.origin.x || p.y < rect.origin.y
		|| p.x > rect.origin.x + rect.size.width
		|| p.y > rect.origin.y + rect.size.height)
	{
		return NO;
	}
	return YES;
}

/*
 判断两个矩形是否有交集
 */
+(BOOL)isRect:(CGRect)r1 intersectRect:(CGRect)r2
{
    if (r1.origin.x + r1.size.width < r2.origin.x ||
        r2.origin.x + r2.size.width < r1.origin.x ||
        r1.origin.y + r1.size.height < r2.origin.y ||
        r2.origin.y + r2.size.height < r1.origin.y) {
        return NO;
    }
    return YES;
}

/*
 计算文件大小，格式化显示
 */
+(NSString*)formattedTextForFileSize:(NSNumber*)fileSize
{
    NSString *ret = nil;
    NSNumber *tmp = nil;
    if (fileSize.unsignedLongLongValue < 1024) {
        ret = [NSString stringWithFormat:@"%@ 字节", fileSize];
    }
    else if (fileSize.unsignedLongLongValue < 1024*1024)
    {
        tmp = [NSNumber numberWithLongLong: fileSize.doubleValue /1024.0];
        ret = [NSString stringWithFormat:@"%.1lf KB", tmp.doubleValue];
    }
    else if (fileSize.unsignedLongLongValue < 1024*1024*1024)
    {
        tmp = [NSNumber numberWithLongLong: fileSize.doubleValue /1024.0/1024.0];
        ret = [NSString stringWithFormat:@"%.2lf MB", tmp.doubleValue];
    }
    else if (fileSize.unsignedLongLongValue/(1024*1024*1024) < 1024)
    {
        tmp = [NSNumber numberWithLongLong: fileSize.doubleValue /1024.0/1024.0/1024.0];
        ret = [NSString stringWithFormat:@"%.2lf GB", tmp.doubleValue];
    }
    
    return ret;
}
@end
