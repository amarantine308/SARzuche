//
//  Invoice.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-10-20.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "FMBean.h"
#import "DTApiBaseBean.h"


@interface Invoice : FMBean
/*
{
    invoices =     (
                    {
                        "apply_time" = "2014-10-20+16:50:45.0";
                        "express_co" = "";
                        "express_id" = "";
                        id = 4;
                        "invoice_title" = 123321;
                        "order_id" = njdd23201410000005;
                        price = "1000.00";
                        "recip_address" = "\U6c5f\U82cf\U7701\U5357\U4eac\U5e02\U8f6f\U4ef6\U5927\U9053170\U53f7";
                        "recip_name" = "\U51af\U6bc5\U6f47";
                        "recip_number" = 18066108998;
                        status = 0;
                        uid = 23;
                    }
                    );
}
 */
@property(nonatomic,copy) NSString  *apply_time ;//申请时间
@property(nonatomic,copy) NSString  *express_co ;
@property(nonatomic,copy) NSString  *express_id ;
@property(nonatomic,copy) NSString  *id ;
@property(nonatomic,copy) NSString  *invoice_title ;
@property(nonatomic,copy) NSString  *price ;//价格
@property(nonatomic,copy) NSString  *order_id ;//订单号
@property(nonatomic,copy) NSString  *recip_address ;//地址
@property(nonatomic,copy) NSString  *recip_name ;//名称
@property(nonatomic,copy) NSString  *recip_number ;//手机号
@property(nonatomic,copy) NSString  *status ;   //0 未发 1 已发
@property(nonatomic,copy) NSString  *uid ;




@end
