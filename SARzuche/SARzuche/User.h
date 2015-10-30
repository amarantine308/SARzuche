//
//  User.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-25.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FMBean.h"
#import "DTApiBaseBean.h"

#import "BMapKit.h"
#import "BNCoreServices.h"
#import "BNaviSoundManager.h"
#import "BLNetworkManager.h"

//百度ID
#define BAIDUMAPID @"1Tw1jCVkKjnrkkwn9kB5pjXY"

@interface User : FMBean
/*
{
    user =     {
        1 QQ = "";
        1 address = "\U5357\U4eac\U5e02\U96e8\U82b1\U53f0\U533a\U8f6f\U4ef6\U5927\U90531722\U53f7";
        app = 1;
        1 birthday = "";
        1 cardno = A2F56E3C;
        1 "del_flag" = 0;
        driverIdImage = "";
        1 email = "";
        1 headImage = "upload/id_picture/13451893070Hd.jpg";
        1 id = 2;
        1 income = "";
        loginIp = "192.168.221.3";
        logindate = "2014-10-14+14:53:21";
        logintype = ios;
        1 name = Amarantine;
        1 nickName = "\U4e3d\U4e3d\U5a05";
        password = e10adc3949ba59abbe56e057f20f883e;
        personId = 12;
        personIdImage = "";
        1 phone = 13451893070;
        regDate = "2014-09-22+16:51:46.0";
        regway = "";
        1 sex = "";
        status = 2;
        weixin = "";
    };
}
 */

@property(nonatomic,copy) NSString  *QQ ;
@property(nonatomic,copy) NSString  *address ;
@property(nonatomic,copy) NSString  *birthday ;
@property(nonatomic,copy) NSString  *email  ;
@property(nonatomic,copy) NSString  *headImage ;
@property(nonatomic,copy) NSString  *name  ;
@property(nonatomic,copy) NSString  *nickName  ;
@property(nonatomic,copy) NSString  *phone  ;
@property(nonatomic,copy) NSString  *sex ;
@property(nonatomic,copy) NSString  *income ;
@property(nonatomic,copy) NSString  *id;
@property(nonatomic,copy) NSString  *cardno;
@property(nonatomic,copy) NSString *del_flag;
@property(nonatomic,copy) NSString *driverIdImage;
@property(nonatomic,copy) NSString *loginIp;
@property(nonatomic,copy) NSString *logindate;
@property(nonatomic,copy) NSString *logintype;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *personId;
@property(nonatomic,copy) NSString *personIdImage;
@property(nonatomic,copy) NSString *personIdImage2;
@property(nonatomic,copy) NSString *regDate;
@property(nonatomic,copy) NSString *regway;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,copy) NSString *weixin;
@property(nonatomic,copy) NSString *remark;
@property(nonatomic,strong)BMKMapManager *mapManager;
@property(nonatomic,strong)BMKMapView *mapView;

+(User *)shareInstance;

@end
