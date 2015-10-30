//
//  CompanyIntroductionViewController.m
//  SARzuche
//
//  Created by admin on 14-10-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CompanyIntroductionViewController.h"
#import "ConstDefine.h"

@implementation CompanyIntroductionViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"公司介绍";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, originY+10, self.view.bounds.size.width - 15*2, self.view.bounds.size.height - originY - 10*2)];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.editable = NO;
    contentTextView.text = @"        江苏思必达车业服务有限公司成立于2013年6月，由南京浦口国有资产投资经营集团发起组建并控股，公司自筹建伊始便创立了专业团队、优质服务、科技创新三大企业核心发展理念，致力于为企业和个人客户提供专业，周到，细致的用车整体解决方案。\n\n        思必达服务项目涵盖企业长租、商务短租、分时自助租赁、车联网管理服务。车辆涵盖高中低档各类品牌、车型。以专业的角度为客户选择满意的车型，搭配合理的租期，以高效的团队为客户提供优质的服务，完备的保障，解决客户用车问题，降低客户用车成本。\n\n        2014年，思必达继企业长租、商务短租服务之后适时推出分时自助租赁与车联网管理服务，依托强大的科技支持，再次扬帆起航。";
    [self.view addSubview:contentTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
