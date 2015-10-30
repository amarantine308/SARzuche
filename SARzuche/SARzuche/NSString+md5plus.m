//
//  NSString(md5plus).m
//  iLike
//
//  Created by house365 on 12-1-3.
//  Copyright (c) 2012年 HOUSE365. All rights reserved.
//

#import "NSString+md5plus.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(md5plus)

+ (NSString *)md5Str:(NSString *)str {

    NSString *final_str = str;
    const char *cStr = [final_str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

@end
