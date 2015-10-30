//
//  IntensionCarViewController.m
//  SARzuche
//
//  Created by admin on 14-9-16.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "IntensionCarViewController.h"
#import "BLNetworkManager.h"
#import "LoadingClass.h"
#import "ConstDefine.h"
#import "ConstString.h"

#define NOTIFICATION_CAR_GETTYPE    @"NOTIFICATION_CAR_GETTYPE"

@interface IntensionCarViewController ()

@end

@implementation IntensionCarViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
//        self.title = @"企业租车";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[LoadingClass shared] showLoadingForMoreRequest:STR_PLEASE_WAIT];
    //39 获取所有企业用车品牌
    FMNetworkRequest *req = [[BLNetworkManager shareInstance] getCompanyCarTypeListWithDelegate:self];
    req = nil;
    
    
    //38 提交企业意向订单
//    FMNetworkRequest *sonsuitReq = [[BLNetworkManager shareInstance] sendCompanyConsultWithUserID:@"2" PhoneNu:@"15852905378" Model:@"" CarNu:1 Time:@"" City:@"" UseTime:@"" Remark:@"" Company:@"" Linkman:@"" delegate:self];
//    sonsuitReq = nil;
    
    
    //29 根据城市/网点获取车辆列表接口
//    FMNetworkRequest *conditionReq = [[BLNetworkManager shareInstance] selectCarsByConditionWithCity:@"南京" BranchId:@"" Brand:@"" PageSize:0 PageNum:0 delegate:self];
//    conditionReq = nil;
    
    
   // 60 根据品牌获取企业可租车系
//    FMNetworkRequest *companyReq = [[BLNetworkManager shareInstance] getCompanyCarTypeListByBrand:@"本田" delegate:self];
//    companyReq = nil;
    //注册通知
    [self initNotify];
}

- (void)initNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotifyInIntension:)
                                                 name:NOTIFICATION_CAR_GETTYPE
                                               object:nil];
}

- (void)getNotifyInIntension:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float originY = 44;
    if (IOS_VERSION_ABOVE_7)
        originY = 64;
    
    _intensionCarView = [[IntensionCarView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height - originY)];
    [self.view addSubview:_intensionCarView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
    
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_getCompanyCarBrand]) {
       NSDictionary *dic = [fmNetworkRequest.responseData objectForKey:@"reslutMap"];
        [_intensionCarView updateTableView:dic];
    }
}


-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoadingForMoreRequest];
}


@end
