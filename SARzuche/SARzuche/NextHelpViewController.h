//
//  NextHelpViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"

@interface NextHelpViewController : NavController<UIWebViewDelegate>
{
    UIWebView *_webView;
    
    UILabel *_noDesc;
}
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *title;

@end
