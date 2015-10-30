//
//  NetworkStatusView.h
//  SARzuche
//
//  Created by 徐守卫 on 14-11-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLNetworkManager.h"

@interface NetworkStatusView : UIView
{
    NSInteger m_nCount;
    NSTimer *m_autoRomveTimer;
    UILabel *m_prompt;
}


@property Reachability* m_hostReach;


-(id)initWithPromptString:(NSString *)promptStr;
@end
