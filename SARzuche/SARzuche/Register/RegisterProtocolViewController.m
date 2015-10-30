//
//  RegisterProtocolViewController.m
//  SARzuche
//
//  Created by liuwei on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "RegisterProtocolViewController.h"
#import "ConstDefine.h"

@interface RegisterProtocolViewController ()

@end

@implementation RegisterProtocolViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"注册协议";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    float originY = 65;
    if (IOS_VERSION_ABOVE_7)
        originY = 80;

    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, originY, self.view.bounds.size.width - 10 * 2, self.view.bounds.size.height - originY - 20)];
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.scalesPageToFit = YES;
    myWebView.multipleTouchEnabled = YES;
    myWebView.opaque = NO;
    [self.view addSubview:myWebView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [myWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
