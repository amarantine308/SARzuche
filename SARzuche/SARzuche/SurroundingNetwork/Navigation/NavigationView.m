//
//  NavigationView.m
//  SARzuche
//
//  Created by admin on 14-9-17.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavigationView.h"

#define TAG_BTN_START   201
#define TAG_BTN_END     202

#define FONT_OF_BTN     14

#define Height_LocationBtn          25

#define Width_AddressImageView      26.0 / 2.0
#define Height_AddressImageView     26.0 / 2.0
#define Space_AddressImageView      (Height_LocationBtn - Height_AddressImageView) / 2.0

#define Width_ChangeBtn             46.0 / 2.0
#define Height_ChangeBtn            46.0 / 2.0

#define Width_NavigationBtn         580.0 / 2.0
#define Height_NavigationBtn        88.0  / 2.0

#define Width_PointsImgView         26.0 / 2.0
#define Height_PointsImgView        42.0 / 2.0

@implementation NavigationView
{
    BOOL startIsMyLocation;
    int markWitchBtn;
    
    NSString *startAddress;
    NSString *endAddress;
    
    UILabel *startLocationLabel;
    UILabel *endLocationLabel;
    
    UIImageView *startImageView;
    UIImageView *endImageView;
    
    NavigationTypeSwitchView *switchView;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        startIsMyLocation = YES;
        startAddress = [[NSString alloc] init];
        endAddress = [[NSString alloc] init];
        startAddress = @"我的位置";
        endAddress = @"输入终点";
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 120)];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        float originX_imageView = 20;
        float originY_startLocationBtn = 15;
        startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX_imageView, originY_startLocationBtn+Space_AddressImageView, Width_AddressImageView, Height_AddressImageView)];
        startImageView.image = [UIImage imageNamed:@"我的位置.png"];
        [backView addSubview:startImageView];
        
        UIButton *startLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startLocationBtn.tag = TAG_BTN_START;
        startLocationBtn.frame = CGRectMake(originX_imageView + Width_AddressImageView + Space_AddressImageView, originY_startLocationBtn, 200, Height_LocationBtn);
        [startLocationBtn setBackgroundColor:[UIColor clearColor]];
        [startLocationBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        startLocationLabel = [[UILabel alloc] initWithFrame:startLocationBtn.frame];
        startLocationLabel.text = startAddress;
        startLocationLabel.textColor = [UIColor blueColor];
        [backView addSubview:startLocationLabel];
        [backView addSubview:startLocationBtn];
        
        UIImageView *pointsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(originX_imageView, originY_startLocationBtn + Height_LocationBtn, Width_PointsImgView, Height_PointsImgView)];
        pointsImgView.image = [UIImage imageNamed:@"点-.png"];
        [backView addSubview:pointsImgView];
        
        float originY_endLocationBtn = originY_startLocationBtn + Height_LocationBtn + Height_PointsImgView;
        endImageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX_imageView, originY_endLocationBtn+Space_AddressImageView, Width_AddressImageView, Height_AddressImageView)];
        endImageView.image = [UIImage imageNamed:@"输入终点.png"];
        [backView addSubview:endImageView];
        
        UIButton *endLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        endLocationBtn.tag = TAG_BTN_END;
        endLocationBtn.frame = CGRectMake(originX_imageView + Width_AddressImageView + Space_AddressImageView, originY_endLocationBtn, 200, Height_LocationBtn);
        [endLocationBtn setBackgroundColor:[UIColor clearColor]];
        [endLocationBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        endLocationLabel = [[UILabel alloc] initWithFrame:endLocationBtn.frame];
        endLocationLabel.text = endAddress;
        endLocationLabel.textColor = [UIColor blackColor];
        [backView addSubview:endLocationLabel];
        [backView addSubview:endLocationBtn];
        
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBtn.frame = CGRectMake(backView.bounds.size.width - 20 - 30, (110 - 30) / 2, Width_ChangeBtn, Height_ChangeBtn);
        [changeBtn setBackgroundImage:[UIImage imageNamed:@"icon-切换.png"] forState:UIControlStateNormal];
        [changeBtn addTarget:self action:@selector(changBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:changeBtn];
        
        float originY = backView.frame.origin.y + backView.bounds.size.height + 30;
        UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navigationBtn.frame = CGRectMake((self.bounds.size.width - Width_NavigationBtn) / 2.0, originY, Width_NavigationBtn, Height_NavigationBtn);
        [navigationBtn setTitle:@"开始导航" forState:UIControlStateNormal];
        [navigationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [navigationBtn setBackgroundImage:[UIImage imageNamed:@"下一步.png"] forState:UIControlStateNormal];
        [navigationBtn addTarget:self action:@selector(navigationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:navigationBtn];
        
//        float btnSpace = 40;
//        float btnWidth = 60;
//        float btnHeight = 30;
//        float btnOriginX = (self.bounds.size.width - btnWidth*3 - btnSpace*2) / 2;
//        
//        UIButton *busBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        busBtn.tag = TAG_NavigationTypeBtn_bus;
//        busBtn.frame = CGRectMake(btnOriginX, originY, btnWidth, btnHeight);
//        [busBtn setTitle:@"公交" forState:UIControlStateNormal];
//        [busBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [busBtn setBackgroundColor:[UIColor yellowColor]];
//        [busBtn addTarget:self action:@selector(navigationTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:busBtn];
//        
//        UIButton *driveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        driveBtn.tag = TAG_NavigationTypeBtn_driving;
//        driveBtn.frame = CGRectMake(btnOriginX + (btnWidth+btnSpace), originY, btnWidth, btnHeight);
//        [driveBtn setTitle:@"驾乘" forState:UIControlStateNormal];
//        [driveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [driveBtn setBackgroundColor:[UIColor yellowColor]];
//        [driveBtn addTarget:self action:@selector(navigationTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:driveBtn];
//        
//        UIButton *walkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        walkBtn.tag = TAG_NavigationTypeBtn_walking;
//        walkBtn.frame = CGRectMake(btnOriginX + (btnWidth+btnSpace)*2, originY, btnWidth, btnHeight);
//        [walkBtn setTitle:@"步行" forState:UIControlStateNormal];
//        [walkBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [walkBtn setBackgroundColor:[UIColor yellowColor]];
//        [walkBtn addTarget:self action:@selector(navigationTypeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:walkBtn];
    }
    return self;
}

#pragma mark - NavigationTypeSwitchViewDelegate
-(void)navigationTypeSelected:(int)type
{
    switchView.hidden = YES;
    
    if (delegate && [delegate respondsToSelector:@selector(enterStartNavigationView:)])
    {
        [delegate enterStartNavigationView:type];
    }
}

-(void)hideNavigationTypeSwitchView
{
    switchView.hidden = YES;
}

#pragma mark - 按钮点击事件
-(void)navigationBtnClicked
{
    if ([endAddress isEqualToString:@"输入起点"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入起点位置" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    if ([endAddress isEqualToString:@"输入终点"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入终点位置" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    if ([startAddress isEqualToString:endAddress])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起点位置与终点位置一样，请您重新选择！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    if (switchView)
    {
        switchView.hidden = NO;
    }
    else
    {
        switchView = [[NavigationTypeSwitchView alloc] initWithFrame:self.bounds];
        switchView.delegate = self;
        [self addSubview:switchView];
    }
}

-(void)changBtnClicked
{
    if (startIsMyLocation)
    {
        startIsMyLocation = NO;
        if ([endAddress isEqualToString:@"输入终点"])
        {
            endAddress = @"输入起点";
        }
        
        startLocationLabel.text = endAddress;
        startLocationLabel.textColor = [UIColor blackColor];
        
        endLocationLabel.text = startAddress;
        endLocationLabel.textColor = [UIColor blueColor];
        
        startImageView.image = [UIImage imageNamed:@"输入终点.png"];
        endImageView.image = [UIImage imageNamed:@"我的位置.png"];
    }
    else
    {
        startIsMyLocation = YES;
        if ([endAddress isEqualToString:@"输入起点"])
        {
            endAddress = @"输入终点";
        }
        
        startLocationLabel.text = startAddress;
        startLocationLabel.textColor = [UIColor blueColor];
        
        endLocationLabel.text = endAddress;
        endLocationLabel.textColor = [UIColor blackColor];
        
        startImageView.image = [UIImage imageNamed:@"我的位置.png"];
        endImageView.image = [UIImage imageNamed:@"输入终点.png"];
    }
    
    if (delegate && [delegate respondsToSelector:@selector(startEndLocationChanged)])
    {
        [delegate startEndLocationChanged];
    }
}

-(void)locationBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    markWitchBtn = btn.tag;
    switch (markWitchBtn)
    {
        case TAG_BTN_START:
        {
            if (startIsMyLocation)
            {
                if (delegate && [delegate respondsToSelector:@selector(enterLocationView:isMyLocation:)])
                {
                    [delegate enterLocationView:@"起点" isMyLocation:YES];
                }
            }
            else
            {
                if (delegate && [delegate respondsToSelector:@selector(enterLocationView:isMyLocation:)])
                {
                    [delegate enterLocationView:@"起点" isMyLocation:NO];
                }
            }
        }
            break;
            
        case TAG_BTN_END:
        {
            if (startIsMyLocation)
            {
                if (delegate && [delegate respondsToSelector:@selector(enterLocationView:isMyLocation:)])
                {
                    [delegate enterLocationView:@"终点" isMyLocation:NO];
                }
            }
            else
            {
                if (delegate && [delegate respondsToSelector:@selector(enterLocationView:isMyLocation:)])
                {
                    [delegate enterLocationView:@"终点" isMyLocation:YES];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 起点终点位置改变
-(void)getTextFieldStr:(NSString *)str
{
    switch (markWitchBtn)
    {
        case TAG_BTN_START:
        {
            if (startIsMyLocation)
            {
                startAddress = str;
            }
            else
            {
                endAddress = str;
            }
            startLocationLabel.text = str;
        }
            break;
            
        case TAG_BTN_END:
        {
            if (startIsMyLocation)
            {
                endAddress = str;
            }
            else
            {
                startAddress = str;
            }
            endLocationLabel.text = str;
        }
            break;
            
        default:
            break;
    }
}

-(void)setEndAddress:(NSString *)str
{
    endAddress = str;
    endLocationLabel.text = str;
}

@end
