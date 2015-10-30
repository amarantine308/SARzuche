//
//  MyAccountChargeViewController.m
//  SARzuche
//
//  Created by 冯毅潇 on 14-9-19.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#import "MyAccountChargeViewController.h"
#import "constString.h"
#import "BLNetworkManager.h"
#import "User.h"
#import "UPPayPlugin.h"
#import "LoadingClass.h"
#import "CustomAlertView.h"
#define kMode_Development             @"01"//            //@"00":代表接入生产环境(正式版 本需要); @"01":代表接入开发测试环境(测 试版本需要);
#define  PAY_ALIXPY 11 //支付宝
#define  PAY_UPPAY  12 //银联

#define ALERT_SUCCEED 13

@interface MyAccountChargeViewController ()
{
    NSMutableData* _responseData;
}
@property(nonatomic, copy)NSString *tnMode;
@end

@implementation MyAccountChargeViewController
@synthesize chargeAmount ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _payType = PAY_UPPAY;
    
    // Do any additional setup after loading the view from its nib.
    if (customNavBarView)
    {
        [customNavBarView setTitle:STR_MYCENTER_CHARGE];
    }
    _chargeAmount.text = self.chargeAmount;
    
}
#pragma mark- - aboutAlixpay
//支付宝获取订单信息并支付
- (void)getOrderInfoAndPay
{
    NSString *partner = @"2088511535165420";
    NSString *seller  = @"2088511535165420";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOZhAaj3+Z4D1SJNKO+dGVL4Pap1DHBohsH+l7/iGZoIrI5T05OTpviHk5j8fP/i+lvD+uAOpgAgz9OMhWY6PSi60ZogzO4KYTCmOJa5uDuCLTKlUanr7er4vskQtBdTi7ry4taQTp7ks1g2TOSqN/AWwlrgDHu7XaJQ7CFwJKodAgMBAAECgYEA1YX3ieo7+07GDkLBvEQ5IoNedEyEOPNIYyla8MfYvsFnXYsoQFHLofHWxSbPnEN9k+vy7BPnm5rNxN8rDPLRltns/AnaiXjEtrPzkSagtMCkRowtKMjA4WsFlhAlN+LEs5PxxlbQnRf6ZnSdGIL2wpgNXuwpcWGYxRAFhtRN3cECQQD9UvsCRrguz9QVjhXJBibBS+w4LnS9ZqCJg6yC7ca7PFIygWfA369HFWySDJteLR5HGJffreDmHuV5E6A3L5J1AkEA6M/6tMuz4k1IMpZ4tESfm9Abw8gLBREyzLsJCqVzHLZAR9sQQA8SgngJzhhT4jwj20dQcY/zXih/upgi+j30CQJAGPdjq67CmkJ7WYB+XyiPCz/rUQIrGTuTGNp0VxcOHgfs5fNhAV5KTQwsfhxl95skv8cJuM7POn7TCOLJSIcUvQJAevyrx2i4/XqwAjFlUG3UF17H3BRIZgPg3zCLJTmj5u4MZSk/m2ea8ptxKpPFdIUquAMjZuqRuRMR7sPB7opd6QJAP3h08pwimnzmPbXq8eHR8rkgZ/rg0V2RmukXhxarBFo+koYsJo8MbUwkyqciEg3EuTGGkfIltauIJ20WaB5l8w==";
    /*
	 *生成订单信息及签名
	 */
	//将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
	order.partner = partner;
	order.seller = seller;
    order.tradeNO = _flowId; //订单ID（由商家自行制定）
	order.productName = @"思必达账户充值"; //商品标题
	order.productDescription = @"思必达账户充值"; //商品描述
    CGFloat _price = _chargeAmount.text.floatValue;
	order.amount = [NSString stringWithFormat:@"%.2f",_price]; //商品价格
    order.notifyURL = PAY_ALIPYBACK;
	//order.notifyURL =  @"http%3A%2F%2F  192.1 account/recharge2.do"; //回调URL 需修改
    //order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types
	NSString *appScheme = @"SARzhuche";                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(privateKey);
	NSString *signedString = [signer signString:orderSpec];

	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            //验证签名成功，交易结果无篡改
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            if (resultStatus.intValue == 9000)
            {

                [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
                FMNetworkRequest *temp = [[BLNetworkManager shareInstance] getChargeWithAccount:[User shareInstance].id
                                                                                      chargenum:_chargeAmount.text
                                                                                         payNum:_flowId
                                                                                       delegate:self];
                temp  = nil;

            }
        }];
    }
}


#pragma mark -IBAction
- (IBAction)sureAction:(id)sender
{
    if (_chargeAmount.text.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"金额不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if([_chargeAmount.text isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"金额不能小于等于0" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        

    }
    else
    {
        if (_payType == PAY_ALIXPY)//支付宝支付
        {
            
            //先获取流水号 之后再跳支付宝 回调成功调支付接口  0支付宝  1银联
            //支付宝支付获取流水号
            [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
            FMNetworkRequest *req = [[BLNetworkManager shareInstance] createPayNum:[User shareInstance].id
                                                                             price:_chargeAmount.text
                                                                           channel:@"0"
                                                                          delegate:self];
            req = nil;
            /*
            //充值接口
            FMNetworkRequest *tempRequest= [[BLNetworkManager shareInstance] getChargeWithAccount:[User shareInstance].id
                                                                                        chargenum:@"1000"
                                                                                           payNum:@""
                                                                                         delegate:self];
            tempRequest = nil;
            
           
            
    */
        }
        else//银联支付
        {
            NSString *money = _chargeAmount.text;
            float price = money.floatValue*100;
            NSString *priceStr = [NSString stringWithFormat:@"%.0f",price];
            [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
            //银联支付 获取Tn  传money以分为单位 *100
            FMNetworkRequest *req =[[BLNetworkManager shareInstance] payWithUid:[User shareInstance].id
                                                                          money:priceStr
                                                                       delegate:self];
            req = nil;
            self.tnMode = kMode_Development;
        }
    }
}
#pragma mark UPPayPluginResult-银联支付成功回调
//银联支付成功回调 result  sucess
- (void)UPPayPluginResult:(NSString *)result
{
    //  调取系统的充值接口
    NSString* msg = [NSString stringWithFormat:@"%@", result];
    NSLog(@"======%@ ",msg);
    if ([result isEqualToString:@"success"])
    {
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"\n\n充值成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil, nil];
        [alert show];
        */
        
        float price = _chargeAmount.text.floatValue;
        NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
        [[LoadingClass shared] showLoading:STR_PLEASE_WAIT];
        FMNetworkRequest *temp = [[BLNetworkManager shareInstance] getChargeWithAccount:[User shareInstance].id
                                                                              chargenum:priceStr
                                                                                 payNum:_flowMessage.flowId //传flowID
                                                                               delegate:self];
        temp  = nil;
        


    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_SUCCEED)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - IBAction
- (IBAction)resignAction:(id)sender
{
    [_chargeAmount resignFirstResponder];
}
//查看银行限额
- (IBAction)bankAction:(id)sender
{
}

//选择支付方式（支付宝11   银联12 ）
- (IBAction)payAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag==PAY_ALIXPY)
    {
        _payType = PAY_ALIXPY;
        uppayImage.hidden = YES;
        _alixpayImage.hidden = NO;
    }
    if (btn.tag == PAY_UPPAY)
    {
        _payType = PAY_UPPAY;
        _alixpayImage.hidden = YES;
        uppayImage.hidden = NO;

    }
}
#pragma mark - dataComeBack

-(void)fmNetworkFinished:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    //银联获取Tn返回数据
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_UPPay])
    {
        if(_payType == PAY_UPPAY)
        {
            _flowMessage = fmNetworkRequest.responseData;
            //流水号 回来  跳转银联
            //_tn =fmNetworkRequest.responseData;
            [UPPayPlugin startPay:_flowMessage.tn
                             mode:self.tnMode
                   viewController:self
                         delegate:self];
        }
    }
    //支付宝获取流水号 返回数据
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_createPayNum])
    {
        if (_payType == PAY_ALIXPY)
        {
            //流水号 回来  跳转支付宝
            _flowId = fmNetworkRequest.responseData;
            [self getOrderInfoAndPay];
            //存下 _flowId  和金额
            float price = _chargeAmount.text.floatValue;
            NSString *priceStr = [NSString stringWithFormat:@"%.2f",price];
            [[NSUserDefaults standardUserDefaults] setObject:_flowId forKey:@"flowId"];
            [[NSUserDefaults standardUserDefaults] setObject:priceStr forKey:@"payMoney"];
        }
    }
    //账户充值数据回来
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_AccountCharge])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:fmNetworkRequest.responseData
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil , nil];
        alert.tag = ALERT_SUCCEED;
        [alert show];
    }
}
-(void)fmNetworkFailed:(FMNetworkRequest*)fmNetworkRequest
{
    [[LoadingClass shared] hideLoading];
    if ([fmNetworkRequest.requestName isEqualToString:kRequest_AccountCharge])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:fmNetworkRequest.responseData
                                                       delegate:self
                                              cancelButtonTitle:@"好的"
                                              otherButtonTitles:nil , nil];
        alert.tag = ALERT_SUCCEED;
        [alert show];

    }
    else
    {
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil message:fmNetworkRequest.responseData delegate:self cancelButtonTitle:STR_BACK otherButtonTitles:nil withDismissInterval:2];
    [alert needDismisShow];
    }
}


@end
