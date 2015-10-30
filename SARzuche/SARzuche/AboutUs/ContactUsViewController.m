//
//  ContactUsViewController.m
//  SARzuche
//
//  Created by admin on 14-10-30.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ConstDefine.h"

#define OriginX_Label       15
#define Width_Label         self.view.bounds.size.width - OriginX_Label*2
#define Height_Label        45

#define Height_SepratorView 1.0 / 2.0

#define Width_ImageView     580.0 / 2.0

#define FontSize_Label      14

@implementation ContactUsViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"联系我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_Label, originY, Width_Label, Height_Label)];
    telLabel.text = @"TEL    400-8288-517";
    telLabel.font = [UIFont systemFontOfSize:FontSize_Label];
    telLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:telLabel];
    
    originY += Height_Label;
    UIImageView *sepratorView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SepratorView)];
    sepratorView1.image = [UIImage imageNamed:@"分割线.png"];
    [self.view addSubview:sepratorView1];
    
    originY += Height_SepratorView;
    UILabel *FAXLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_Label, originY, Width_Label, Height_Label)];
    FAXLabel.text = @"传真    025-56675618";
    FAXLabel.font = [UIFont systemFontOfSize:FontSize_Label];
    FAXLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:FAXLabel];
    
    originY += Height_Label;
    UIImageView *sepratorView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SepratorView)];
    sepratorView2.image = [UIImage imageNamed:@"分割线.png"];
    [self.view addSubview:sepratorView2];
    
    originY += Height_SepratorView;
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_Label, originY, Width_Label, Height_Label)];
    emailLabel.text = @"邮箱    sibida@51sar.com";
    emailLabel.font = [UIFont systemFontOfSize:FontSize_Label];
    emailLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emailLabel];
    
    originY += Height_Label;
    UIImageView *sepratorView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SepratorView)];
    sepratorView3.image = [UIImage imageNamed:@"分割线.png"];
    [self.view addSubview:sepratorView3];
    
    float height_addressLabel = Height_Label;
    originY += Height_SepratorView;
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(OriginX_Label, originY, Width_Label, height_addressLabel)];
    addressLabel.text = @"地址    南京市浦口区天浦路28号浦江财智中心\n           2号楼7楼";
    addressLabel.font = [UIFont systemFontOfSize:FontSize_Label];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
    addressLabel.numberOfLines = 0;
    [self.view addSubview:addressLabel];
    
    originY += height_addressLabel;
    UIImageView *sepratorView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, Height_SepratorView)];
    sepratorView4.image = [UIImage imageNamed:@"分割线.png"];
    [self.view addSubview:sepratorView4];
    
    UIImageView *mapImageView;
    float imageViewHeight;
    
    float boundsHeight = self.view.bounds.size.height;
    if (boundsHeight < 500)
    {
        imageViewHeight = 344.0 / 2.0;
        mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - Width_ImageView) / 2.0, originY + 10, Width_ImageView, imageViewHeight)];
        mapImageView.image = [UIImage imageNamed:@"4-地图.png"];
    }
    else
    {
        imageViewHeight = 480.0 / 2.0;
        mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - Width_ImageView) / 2.0, originY + 10, Width_ImageView, imageViewHeight)];
        mapImageView.image = [UIImage imageNamed:@"2个人中心-联系我们-map.png"];
    }
    [self.view addSubview:mapImageView];
    
    originY += imageViewHeight + 10*2;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
//    bottomView.backgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:242.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    bottomView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    [self.view addSubview:bottomView];
}

@end
