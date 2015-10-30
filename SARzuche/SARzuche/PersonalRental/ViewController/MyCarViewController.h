//
//  MyCarViewController.h
//  SARzuche
//
//  Created by 徐守卫 on 14-9-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "NavController.h"
#import "PersonalCarInfoView.h"
#import "BMapKit.h"

@interface MyCarViewController : NavController<PersonalCarInfoViewDelegate,CLLocationManagerDelegate, BMKLocationServiceDelegate, BMKGeneralDelegate>
{
    int _type;//1鸣笛2开门3锁门
}
@end
