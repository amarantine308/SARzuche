//
//  NextHelpViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-24.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NextHelpViewController.h"

@interface NextHelpViewController ()

@end

@implementation NextHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (customNavBarView)
    {
        [customNavBarView setTitle:self.title];
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scalesPageToFit = YES;
    _webView.multipleTouchEnabled = YES;
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    
    
    _noDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 40)];
    _noDesc.backgroundColor = [UIColor clearColor];
    _noDesc.textAlignment = NSTextAlignmentCenter;
    _noDesc.text = @"使用帮助，待客户提供";
    [self.view addSubview:_noDesc];
    
    if (self.type == nil)
    {
        _noDesc.hidden = NO;
    }
    else
    {
        _noDesc.hidden = YES;
                NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:self.type ofType:@"html"]];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
