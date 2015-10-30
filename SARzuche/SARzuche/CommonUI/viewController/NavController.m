//
//  NavController.m
//  Weibo
//
//  Created by sun sun on 12-11-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavController.h"
#import "constDefine.h"
#import "PublicFunction.h"

#define FRAME_SHORT_MENU                CGRectMake(0, 70, MainScreenWidth, MainScreenHeight - 70)

@implementation NavController

@synthesize customNavBarView;
//@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void) navLeftBtnPressed:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void) navRightBtnPressed:(id)sender
{
    
}


-(void)showShortMenuBtn:(BOOL)bShow
{
    if (m_shortMenuBtn)
    {
        [self addShortMenu];
    }
    
    if (bShow)
    {
        [customNavBarView addSubview:m_shortMenuBtn];
    }
    else
    {
        [m_shortMenuBtn removeFromSuperview];
    }
}


- (void)viewDidLoad
{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:@"changeSkin" object:nil];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
#if 0
        UIImage *image;

        UIImage *imgBack = [UIImage imageNamed:@"nav_tab.png"];
        if(!IOS_VERSION_ABOVE_7)
        {
            image = [imgBack stretchableImageWithLeftCapWidth:15.f topCapHeight:40.f];
        }
        else
        {
            image = imgBack;
        }
        
        [self.navigationController.navigationBar setBackgroundColor:kCommonViewBackgroundColor];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
#else
        [self.navigationController.navigationBar setBackgroundColor:kNavBackgroundColor];
#endif
    }
    
	UIButton *btn;
	UIImage *tmpimage;
	UIBarButtonItem *barItem;
	
	if (leftNavBtnName != nil)
	{
        NSLog(@"leftNavBtnName != nil");
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		tmpimage = [UIImage imageNamed:leftNavBtnName];
		[btn setBackgroundImage:tmpimage forState:UIControlStateNormal];
		btn.frame = CGRectMake(0, 0, tmpimage.size.width/2, tmpimage.size.height/2);
        [btn addTarget:self action:@selector(navLeftBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	}
	if (rightNavBtnName != nil)
	{
		btn = [UIButton buttonWithType:UIButtonTypeCustom];
		tmpimage = [UIImage imageNamed:rightNavBtnName];
		[btn setBackgroundImage:tmpimage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(navRightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
		btn.frame = CGRectMake(0, 0, tmpimage.size.width, tmpimage.size.height);
        NSLog(@"btn.frame.y %f",btn.frame.size.height);
        NSLog(@"btn.frame.x %f",btn.frame.size.width);
		barItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
		self.navigationItem.rightBarButtonItem = barItem;
	}
    
    self.view.backgroundColor = kCommonViewBackgroundColor;

    //添加自定义导航栏(默认为左侧添加一个返回按钮，右侧无按钮)
    float yPos = kStatusBarHeight;
    if(!IOS_VERSION_ABOVE_7)
    {
        yPos = 0;
    }
    customNavBarView = [[CustomNavBarView alloc]initWithFrame:CGRectMake(0, yPos, SCREEN_BOUNDS.size.width, kNavigationBarHeight) title:self.title];
    [customNavBarView setLeftButton:kBackButtonImgName target:self leftBtnAction:@selector(backClk:)];
    [self.view addSubview:customNavBarView];
    
    [self addShortMenu];
    
    [super viewDidLoad];
}

-(void)addShortMenu
{
    if (customNavBarView) {
        m_shortMenuBtn = [[UIButton alloc] initWithFrame:FRAME_RIGHT_BUTTON1];
        m_shortMenuBtn.backgroundColor = [UIColor greenColor];
        [m_shortMenuBtn setTitle:@"short" forState:UIControlStateNormal];
//        tmpimage = [UIImage imageNamed:rightNavBtnName];
//		[m_shortMenuBtn setBackgroundImage:tmpimage forState:UIControlStateNormal];
        [m_shortMenuBtn addTarget:self action:@selector(shortMenuPressed:) forControlEvents:UIControlEventTouchUpInside];
//		m_shortMenuBtn.frame = CGRectMake(0, 0, tmpimage.size.width, tmpimage.size.height);
//        [customNavBarView addSubview:m_shortMenuBtn];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    //隐藏系统导航栏
    [self.navigationController setNavigationBarHidden:YES];

//#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    
    if(IOS_VERSION_ABOVE_7)
    {
        //设置状态栏文字
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
        //添加状态栏底色
        UIView *viewStatus = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, kStatusBarHeight)];
        viewStatus.backgroundColor = kNavBackgroundColor;
        [self.view addSubview:viewStatus];
    }
    else
    {
        //设置状态栏文字
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    [super viewWillAppear:animated];
}

-(void)backClk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shortMenuPressed:(id)sender
{
    //默认不显示，在子类实现
    
    if (nil == m_shortMenu) {
        m_shortMenu = [[ShortMenuView alloc] initWithFrame:FRAME_SHORT_MENU];
        m_shortMenu.backgroundColor = [UIColor clearColor];
        m_shortMenu.delegate = self;
    }
    
    if (NO == m_bShowMenu) {
        [self.view addSubview:m_shortMenu];
    }
    else
    {
        [m_shortMenu removeFromSuperview];
    }
    m_bShowMenu = !m_bShowMenu;
}


- (BOOL) shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - short menu delegate
-(void)shortMenuExit
{
    m_bShowMenu = NO;
}

-(void)shortMenuSelect:(shortMenuEnum)index
{
    [[PublicFunction ShareInstance] jumpWithController:self toPage:index];
}

@end
