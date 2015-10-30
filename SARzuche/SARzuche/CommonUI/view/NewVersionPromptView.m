//
//  NewVersionPromptView.m
//  SARzuche
//
//  Created by 徐守卫 on 14-9-27.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NewVersionPromptView.h"
#import "ConstDefine.h"
#import "ConstString.h"
#import "PublicFunction.h"

#define HEIGHT_BUTTON           50
#define WIDTH_PROMPT            220
#define HEIGHT_PROMPT           160
#define HEIGHT_LABEL            20

#define FRAME_BACKGROUND            CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)
#define FRAME_PROMPT_VIEW       CGRectMake(50, 190, WIDTH_PROMPT, HEIGHT_PROMPT)
#define FRAME_TITLE_VIEW        CGRectMake(0, 0, WIDTH_PROMPT, HEIGHT_BUTTON)
#define FRAME_VERSION           CGRectMake(10, HEIGHT_BUTTON + 20, WIDTH_PROMPT, HEIGHT_LABEL)
#define FRAME_SIZE              CGRectMake(10, HEIGHT_BUTTON + 10 + HEIGHT_LABEL, WIDTH_PROMPT-20, HEIGHT_LABEL)
#define FRAME_UPDATE_CONTENT    CGRectMake(10, HEIGHT_BUTTON + 10 + HEIGHT_LABEL * 2, WIDTH_PROMPT-20, HEIGHT_LABEL)
#define FRAME_TEXT_VIEW         CGRectMake(10, HEIGHT_BUTTON + 10 + HEIGHT_LABEL * 3, WIDTH_PROMPT-20, 150)

#define FRAME_BTN_LEFT          CGRectMake(0, HEIGHT_PROMPT - HEIGHT_BUTTON, WIDTH_PROMPT/2, HEIGHT_BUTTON)
#define FRAME_BTN_RIGHT          CGRectMake(WIDTH_PROMPT/2, HEIGHT_PROMPT - HEIGHT_BUTTON, WIDTH_PROMPT/2, HEIGHT_BUTTON)

#define IMG_UPDATE                     @"modify.png"
#define IMG_IGNORE                     @"unsubscribe.png"

@implementation NewVersionPromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initNewViersionPromptView];
    }
    return self;
}


-(void)initNewViersionPromptView
{
#if 0
    #define STR_FOND_NEW_VERSION            [language getLocalString:@"fondNewVersion"]// = "发现新版本";
    #define STR_JUST_A_MOMENT               [language getLocalString:@"justamoment"]// = "稍后再说";
    #define STR_UPDATE_VERSION              [language getLocalString:@"updateNow"]// = "立即更新";
    #define STR_VERSIONS                    [language getLocalString:@"versions"]// = "软件版本";
    #define STR_SOFTWARE_SIZE               [language getLocalString:@"swSize"]// = "软件大小";
    #define STR_UPDATE_CONTENT
#endif
    UIView *backGroundView = [[UIView alloc] initWithFrame:FRAME_BACKGROUND];
    backGroundView.backgroundColor = COLOR_TRANCLUCENT_BACKGROUND;
    
    
    UIView *tmpView = [[UIView alloc] initWithFrame:FRAME_PROMPT_VIEW];
    tmpView.backgroundColor = [UIColor whiteColor];
    
    UILabel *newVerson = [[UILabel alloc] initWithFrame:FRAME_TITLE_VIEW];
    newVerson.text = STR_FOND_NEW_VERSION;
    newVerson.textAlignment = NSTextAlignmentCenter;
    newVerson.backgroundColor= COLOR_LABEL_BLUE;
    [tmpView addSubview:newVerson];
    
    m_version = [[UILabel alloc] initWithFrame:FRAME_VERSION];
    m_version.text = STR_VERSIONS;
    [tmpView addSubview:m_version];
#if 0
    m_size = [[UILabel alloc] initWithFrame:FRAME_SIZE];
    m_size.text = STR_SOFTWARE_SIZE;
    [tmpView addSubview:m_size];

    UILabel* content = [[UILabel alloc] initWithFrame:FRAME_UPDATE_CONTENT];
    content.text = STR_UPDATE_CONTENT;
    [tmpView addSubview:content];
#endif
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:FRAME_BTN_LEFT];
    [leftBtn setTitle:STR_JUST_A_MOMENT forState:UIControlStateNormal];
 //   leftBtn.backgroundColor = [UIColor redColor];
    [leftBtn setBackgroundImage:[UIImage imageNamed:IMG_IGNORE] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(waitamoment) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:FRAME_BTN_RIGHT];
    [rightBtn setTitle:STR_UPDATE_VERSION forState:UIControlStateNormal];
//    rightBtn.backgroundColor = [UIColor greenColor];
    [rightBtn setBackgroundImage:[UIImage imageNamed:IMG_UPDATE] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(updateNow) forControlEvents:UIControlEventTouchUpInside];
    [tmpView addSubview:rightBtn];
#if 0
    m_textView  = [[UITextView alloc] initWithFrame:FRAME_TEXT_VIEW];
    m_textView.text = @"sdfasdfsdfasdfasdfsdfasdfsdafsdfsdfsadfasdfasdfasdfasdfasdfsadfadfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadfasdfasdfasfasdfasdfasdfUIButton *rightBtn = [[UIButton alloc] initWithFrame:FRAME_BTN_RIGHT];[rightBtn setTitle:STR_UPDATE_VERSION forState:UIControlStateNormal];    rightBtn.backgroundColor = [UIColor redColor];    [rightBtn addTarget:self action:@selector";
    m_textView.editable =  NO;
    m_textView.textColor = [UIColor blackColor];
    [tmpView addSubview:m_textView];
#endif
    [backGroundView addSubview:tmpView];
    [self addSubview:backGroundView];
}

-(void)setNewVersionValue:(NSString *)ver size:(NSString *)size content:(NSString *)strContent
{
    m_strVersion = [NSString stringWithFormat:@"%@", ver];
    m_version.text = [NSString stringWithFormat:@"%@:     %@", STR_VERSIONS, ver];
    m_size.text = [NSString stringWithFormat:@"%@:     %@", STR_SOFTWARE_SIZE, size];
    m_textView.text = strContent;
}

-(void) show
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
//    NSArray* windows = [UIApplication sharedApplication].windows;
//    window = [windows objectAtIndex:0]; // ios 5
    NSArray* windowViews = [window subviews];
    if(windowViews && [windowViews count]>0){
        UIView* subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView* aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
            
            
        }
        [subView addSubview:self];
    }
    
}

-(void)ignoreTheVersion
{
    NSString *str = [[PublicFunction ShareInstance] lastVersion:nil];
    if (nil == str) {
        [[PublicFunction ShareInstance] lastVersion:m_strVersion];
    }
    else
    {
        NSLog(@"last version :%@", str);
        [[PublicFunction ShareInstance] lastVersion:GET(m_strVersion)];
    }
}

-(void)waitamoment
{
    [self ignoreTheVersion];
    [self removeFromSuperview];
}

-(void)updateNow
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/wan-zhuan-quan-cheng/id692579125?mt=8"]];
    [self removeFromSuperview];
}

@end
