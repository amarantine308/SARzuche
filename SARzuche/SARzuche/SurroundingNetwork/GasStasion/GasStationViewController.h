//
//  GasStationViewController.h
//  SARzuche
//
//  Created by admin on 14-9-26.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
#import "NavController.h"

@interface GasStationViewController : NavController<BMKMapViewDelegate, BMKPoiSearchDelegate, BMKLocationServiceDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@end
