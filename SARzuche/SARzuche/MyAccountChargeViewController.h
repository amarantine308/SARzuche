//
//  MyAccountChargeViewController.h
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavController.h"
//#import "AlixLibService.h"
#import "UPPayPluginDelegate.h"
#import "FlowMessage.h"

#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"

@interface MyAccountChargeViewController : NavController<UPPayPluginDelegate>
{

    IBOutlet UITextField *_chargeAmount;//充值的金额
    int _payType;//（支付宝11   银联12 ）银联的以分为单位，支付宝以元为单位
    FlowMessage *_flowMessage;//银联 返回来的 tn, flowId
    
    NSString *_tn; //银联返回的交易流水号 tn
    NSString *_flowId;//支付宝 返回的交易流水号

    __weak IBOutlet UIImageView *uppayImage;
    __weak IBOutlet UIImageView *_alixpayImage;
    
    NSString *chargeAmount;
}
@property (nonatomic , copy) NSString *chargeAmount;
//确认充值
- (IBAction)sureAction:(id)sender;
//取消第一响应
- (IBAction)resignAction:(id)sender;
//查看银行限额
- (IBAction)bankAction:(id)sender;
- (IBAction)payAction:(id)sender;

@end
