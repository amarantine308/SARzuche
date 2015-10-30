//
//  NSData+ExtendNSData.h
//  MobileOA
//
//  Created by vincent on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ExtendNSData)
//base64编码
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
//base64解码
- (NSString *)base64Encoding;
//gzip压缩
+ (NSData *)gzipCompress:(NSData*)data;
//gzip解压缩
+ (NSData *)gzipUncompress:(NSData*)data;

@end
