//
//  UIImageView+URL.h
//  SARzuche
//
//  Created by 徐守卫 on 14-11-28.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDImageCache.h"
//#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"


//@interface UIImageView (URL)
@interface CustomImageView : UIImageView
{
    NSString *m_defaultName;
    NSString *m_url;
}

- (instancetype)initWithImage:(NSString *)imageName withUrl:(NSString *)url;

@end
