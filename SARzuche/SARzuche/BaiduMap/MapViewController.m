//
//  MapViewController.m
//  sarzuche
//
//  Created by 徐守卫 on 14-9-12.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController ()
{
    BMKMapManager* _mapManager;
    BMKMapView *_mapView;
}
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initMapManager];
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        self.view = _mapView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    self.view = _mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMapManager
{
    if (nil == _mapManager) {
        _mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [_mapManager start:@"T9R6n33WZQwacumHSnmqLDPt"  generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"GetNetworkState :%d", iError);
}

/**
 *返回授权验证错误
 *@param iError 错误号 : BMKErrorPermissionCheckFailure 验证失败
 */
- (void)onGetPermissionState:(int)iError
{
    NSLog(@"GetPermissionState :%d", iError);
}


@end
