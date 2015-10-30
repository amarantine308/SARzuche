//
//  AboutUsViewController.m
//  SARzuche
//
//  Created by admin on 14-10-21.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "ConstDefine.h"
#import "ConstString.h"
#import "AboutUsViewController.h"
#import "ContactUsViewController.h"
#import "CompanyIntroductionViewController.h"

@implementation AboutUsViewController
{
    UITableView *pTableView;
    NSMutableArray *pDataSource;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
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
    
    pTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    pTableView.delegate = self;
    pTableView.dataSource = self;
    [self.view addSubview:pTableView];
    
    // 去掉多余的行
    UIView *foot = [[UIView alloc] init];
    [pTableView setTableFooterView:foot];
    
    pDataSource = [[NSMutableArray alloc] initWithObjects:@"公司介绍", @"联系我们", @"检查更新", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pDataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"AboutUsViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellid];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [pDataSource objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row)
    {
        case 0: // 公司介绍
        {
            CompanyIntroductionViewController *nextVC = [[CompanyIntroductionViewController alloc] init];
            [self.navigationController pushViewController:nextVC animated:YES];
            nextVC = nil;
        }
            break;
            
        case 1: // 联系方式
        {
            ContactUsViewController *nextVC = [[ContactUsViewController alloc] init];
            [self.navigationController pushViewController:nextVC animated:YES];
            nextVC = nil;
        }
            break;
            
        case 2:
        {
            [self checkVersion];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 检查更新
-(void)checkVersion
{
#if 0
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getVersion]];
#else
    NSString *curVer = [NSString stringWithFormat:@"%@", [self getBuildVersion]];
#endif
    FMNetworkRequest *tmpRequest = [[BLNetworkManager shareInstance]checkVersion_currentVersion:curVer type:@"ios" delegate:self ];
    tmpRequest=nil;
}


-(NSString *)getBuildVersion
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    
    // app build版本
    NSString *app_build = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleVersion"]];
    
    return app_build;
}


-(NSString *)getVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [NSString stringWithFormat:@"%@", [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    
    return app_Version;
}

-(void)newVersion:(FMNetworkRequest *)request
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:STR_FOND_NEW_VERSION delegate:self cancelButtonTitle:STR_JUST_A_MOMENT otherButtonTitles:STR_UPDATE_VERSION, nil];
    alertView.delegate = self;
    [alertView show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"ALERT BUTTON 0");
    }
    else
    {
        NSLog(@"ALERT BUTTON 1");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app"]];
    }
}

#pragma mark FMNetworkRequest delegate
-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_CheckVersion])
    {
        [self newVersion:fmNetworkRequest];
    }
}

-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测版本失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

@end
