//
//  AdContentViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-10-11.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "AdContentViewController.h"
#import "ConstDefine.h"
#import "ConstString.h"


#define FRAME_VIEW          CGRectMake(0, controllerViewStartY, MainScreenWidth, MainScreenHeight - controllerViewStartY)


@interface AdContentViewController ()
{
    NSString *m_contentUrl;
}

@end

@implementation AdContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        m_contentUrl = [NSString stringWithFormat:@"%@", url];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initContentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (customNavBarView) {
        [customNavBarView setTitle:STR_AD];
    }
}


-(void)initContentView
{
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:FRAME_VIEW];
    myWebView.backgroundColor = [UIColor clearColor];
    myWebView.scalesPageToFit = YES;
    myWebView.multipleTouchEnabled = YES;
    myWebView.opaque = NO;
    [self.view addSubview:myWebView];
    
    NSURL *url = [[NSURL alloc]initWithString:m_contentUrl];
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}

@end
