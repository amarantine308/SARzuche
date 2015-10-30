//
//  GuideViewController.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "AppDelegate.h"
#import "GuideViewController.h"
#import "ConstDefine.h"
#import "PublicFunction.h"
#import "HomeViewController.h"
#import "constString.h"
#import "LeftViewController.h"

#define GUIDE_VIEW_FRAME CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)

#define IMAGE_GUIDE1_960    @"firstStart1_960"
#define IMAGE_GUIDE2_960    @"firstStart2_960"
#define IMAGE_GUIDE3_960    @"firstStart3_960"
#define IMAGE_GUIDE1_1136    @"firstStart1_1136"
#define IMAGE_GUIDE2_1136    @"firstStart2_1136"
#define IMAGE_GUIDE3_1136    @"firstStart3_1136"

@interface GuideViewController ()

@end

@implementation GuideViewController

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
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [self InitView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

-(void)InitView
{
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE1_960]];
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE2_960]];
    UIImageView *image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE3_960]];
    if (IS_IPHONE5) {
        image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE1_1136]];
        image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE2_1136]];
        image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMAGE_GUIDE3_1136]];
    }
    NSArray *imagesArray = [[NSArray alloc] initWithObjects:image1, image2, image3, nil];
    
    CGRect rect = GUIDE_VIEW_FRAME;
    if (IS_IOS7 == NO) {
        CGRect tmpRect = rect;
        tmpRect.size.height += kViewCaculateBarHeight;
        rect = tmpRect;
    }
    PageScrollerView *tmpView = [[PageScrollerView alloc] initWithFrame:rect withImages:imagesArray];
    [tmpView autoScrollEnalbed:NO];
    [tmpView setPageControllerHidden];
    tmpView.delegate = self;
    self.view = tmpView;
    tmpView = nil;
}

-(void)jumpToHomePage
{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    HomeViewController *tmpHomeController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:tmpHomeController];
    
    app.navigationController = naviController;
    [PublicFunction ShareInstance].rootNavigationConroller = naviController;
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:naviController];
    app.menuController = rootController;
    
    LeftViewController *tmpGuideController = [[LeftViewController alloc] initWithNibName:nil bundle:nil];
    rootController.leftViewController = tmpGuideController;
    rootController.rightViewController = nil;
    
    app.window.rootViewController = app.menuController;
}

#pragma mark - scroller view delegate
-(void)scrollerViewExit
{
    NSLog(@"startPage exit and jump to home page");
    [self jumpToHomePage];
}

@end
