//
//  UIImageView+URL.m
//  SARzuche
//
//  Created by 徐守卫 on 14-11-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "UIImageView+URL.h"

@implementation CustomImageView//UIImageView(URL)


- (instancetype)initWithImage:(NSString *)imageName withUrl:(NSString *)url
{
    self = [super initWithImage:[UIImage imageNamed:imageName]];
    if (self) {
        m_defaultName = [NSString stringWithFormat:@"%@", imageName];
        self.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeScaleToFill //
        [self getImageWithUrl:url];
    }
    
    return self;
}


-(void)getImageWithUrl:(NSString *)url
{
    UIImage *tmpImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    
    if (tmpImg == nil) {
        self.image = [UIImage imageNamed:m_defaultName];
    }
    else
    {
        self.image = tmpImg;
        return;
    }
    
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])
    {
        __weak UIImageView *weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:data];
            if (image)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakself.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:url toDisk:NO];
                });
            }
        });
    }
}

@end
