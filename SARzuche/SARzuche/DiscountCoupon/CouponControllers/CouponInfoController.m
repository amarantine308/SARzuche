//
//  CouponInfoController.m
//  SARzuche
//
//  Created by dyy on 14-10-15.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "CouponInfoController.h"
#import "ConstString.h"

@interface CouponInfoController ()
{
    NSDictionary *m_couponDic;
}
@end

@implementation CouponInfoController
@synthesize m_carMode;
@synthesize m_id;
@synthesize m_scope;
@synthesize m_type;
@synthesize m_validTime;
@synthesize m_desc;
@synthesize m_leftNum;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:@"优惠劵详情"];
    }
    
    [self initLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*area = "";
 branch = "";
 enddate = "2014-12-01";
 iscountinue = 1;
 leftnum = 0;
 name = "\U65e0\U654c\U73b0\U91d1\U52382";
 no = 20141030170000111;
 remarks = "\U65e0\U654c\U73b0\U91d1\U52382";
 startdate = "2014-11-01";
 type = 4;*/

-(void)initLabel
{
    if (m_couponDic == nil) {
        return;
    }
    NSString *strModel = [m_couponDic objectForKey:@"model"];
    NSString *strType = [m_couponDic objectForKey:@"type"];
    _m_name.text =  [m_couponDic objectForKey:@"name"];
    m_leftNum.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"leftnum"]];
    m_carMode.text = [NSString stringWithFormat:@"%@", strModel ? strModel : @"所有车型"];
    m_id.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"no"]];
    m_scope.text = [NSString stringWithFormat:@"%@", [m_couponDic objectForKey:@"area"]];
    m_type.text = [self getTypeString:strType];
    m_validTime.text = [NSString stringWithFormat:@"%@ ~ %@", [m_couponDic objectForKey:@"startdate"], [m_couponDic objectForKey:@"enddate"]];
    NSString *descript = [[m_couponDic objectForKey:@"remarks"] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    m_desc.text = [NSString stringWithFormat:@"%@",descript];
    
}

-(void)setCouponData:(NSDictionary *)dic
{
    m_couponDic = [[NSDictionary alloc] initWithDictionary:dic];
}


-(NSString *)getTypeString:(NSString *)type
{
    NSInteger nInter = [type integerValue];
    switch (nInter) {
        case 1:
            return STR_DURATION_CONSUMPTION;
            break;
        case 2:
            return STR_MILEAGE_CONSUMPTION;
            break;
        case 3:
            return STR_ALL_COUPON;
            break;
        case 4:
            return STR_CASH_COUPON;
            break;
        default:
            return @"";
            break;
    }
}

@end
