//
//  SWNetworkManager.m
//  Shuiwu
//
//  Created by Leks on 13-12-20.
//  Copyright (c) 2013年 Shuiwu. All rights reserved.
//

#import "BLNetworkManager.h"
#import "JSON.h"
#import "FBEncryptorDES.h"
#import "NSData+ExtendNSData.h"
#import "AllBeans.h"
#import "ConstDefine.h"
#import "User.h"


@implementation BLNetworkManager
@synthesize keyStr,TransID;

static NSInteger nCount = 0;
static BLNetworkManager *g_cNetworkManager = nil;
+ (BLNetworkManager *)shareInstance
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        g_cNetworkManager = [[BLNetworkManager alloc] init];
    });
    nCount = 0;
    return g_cNetworkManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (g_cNetworkManager)
    {
        NSLog(@"CNetworkManager object initialization error!");
        return g_cNetworkManager;
    }
    return [super allocWithZone:zone];
}

- (id)init
{
    if (self = [super init])
    {
        self.keyStr = @"f4b9ec30ad9f68f89b29639786cb62ef";
    }
    return self;
}

+(BOOL)needHeartBeatReq
{
    nCount ++;
    if (nCount > HEART_BEAT_INTERVAL)
    {
        return YES;
    }
    
    return NO;
}

//解密
- (NSString *)decryptDataWithString:(NSString *)dataStr
{
    //解析数据 base64 des 后用utf-8解码
    NSData * encode = [NSData dataWithBase64EncodedString:dataStr];
    NSData * secData = [FBEncryptorDES decryptData:encode key:self.keyStr];
    NSString *result = [[NSString alloc]initWithData:secData encoding:NSUTF8StringEncoding ];
    NSString *dataResult = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return dataResult;
}
//加密
- (NSString *)encryptDataWithDic:(id)obj
{
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *str2= [json stringWithObject:obj];
    //首先进行utf-8编码 然后des base64加密
    NSString *str = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *des = [FBEncryptorDES encryptData:str key:self.keyStr];
    NSString *result = [des base64Encoding];
    return result;
}
- (NSMutableDictionary *)dictionaryWithPostParamsSvcCont:(NSString *)SvcCont MSGReq:(NSString *)MSGReq IsSec:(NSString *)IsSec IsZip:(NSString *)IsZip
{
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    [postParams setObject:MSGReq forKey:@"MSGReq"];
    [postParams setObject:SvcCont forKey:@"SvcCont"];
    [postParams setObject:IsSec forKey:@"IsSec"];
    [postParams setObject:IsZip forKey:@"IsZip"];
    return postParams;

}


-(BOOL)filterCarResponse:(NSDictionary *)res withRequest:(FMNetworkRequest*)networkRequest
{
    /*get 车辆认证 返回数据:
     {"success":true,"code":100}
     */
    NSInteger code = [[res objectForKey:@"code"] integerValue];
    BOOL ret = NO;
    switch (code) {
        case 100:
            ret = YES;
            break;
        case 101:
            break;
        default:
            break;
    }
    
    return ret;
}
- (BOOL)filter:(FMNetworkRequest*)networkRequest
{
    if (networkRequest.isSkipFilterRequest)
    {
        return YES;
    }
    
    BOOL ret = NO;
    
    NSString *responseString = networkRequest.responseData;
    
    NSLog(@"\n\n%@ 返回数据:\n%@\n\n", networkRequest.requestName, responseString);
    
    if (!responseString || responseString.length == 0)
    {
        networkRequest.responseData = @"数据加载失败，请稍后再试~";
        return NO;
    }
    
    id retObj = [responseString JSONValue];
    if (!retObj)
    {
        networkRequest.responseData = @"数据解析错误";
        return NO;
    }
    NSDictionary *result = retObj;
    
    // 处理我的车辆页面相关请求
    if ([networkRequest.requestName isEqualToString:kGet_carAuthentication] ||
        [networkRequest.requestName isEqualToString:kGet_carCloseDoor]||
        [networkRequest.requestName isEqualToString:kGet_carHonking]||
        [networkRequest.requestName isEqualToString:kGet_carOpenDoor])
    {
        if ([self filterCarResponse:result withRequest:networkRequest]) {
            return YES;
        }
    }
    
    NSInteger code = [[result objectForKey:@"Code"] integerValue];
    //应答成功
    if (code == 100)
    {
        NSDictionary *dic = retObj;
        NSInteger IsZip = [[dic objectForKey:@"IsZip"] integerValue];
        NSInteger IsSec = [[dic objectForKey:@"IsSec"] integerValue];
        NSString *dataStr = [dic objectForKey:@"SvcCont"];
        //没有压缩 只加密的
        if ((IsZip==0)&&(IsSec==1))
        {
            NSDictionary *resultData = [[self decryptDataWithString:dataStr]JSONValue];
            NSLog(@"--------------------------------------------------------------------- \n %@",resultData);
            
            if ([networkRequest.requestName isEqualToString:kRequest_UserLogin])
            {
                NSDictionary *dic=[resultData objectForKey:@"user"];
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    //User *u = [FMBean objectWithDictionary:dic classType:[User class]];
                    User *u=[[User shareInstance] initWithDictionary:dic];
                    networkRequest.responseData = u;
                    return YES;
                }
            }
            else if([networkRequest.requestName isEqualToString:kRequest_AccountCharge])
            {
                NSString *message = [dic objectForKey:@"message"];
                networkRequest.responseData = message;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_AddTicket])
            {
                NSString *message = [dic objectForKey:@"message"];
                networkRequest.responseData = message;
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_UPPay])
            {
                FlowMessage *flow = [FMBean objectWithDictionary:resultData classType:[FlowMessage class]];
                networkRequest.responseData = flow;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_createPayNum])
            {
                networkRequest.responseData = [resultData objectForKey:@"flowId"];
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:KRequest_getMyAccountMessage])
            {
                NSDictionary *dic = [resultData objectForKey:@"account"];
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    MyAccount *account =[FMBean objectWithDictionary:dic classType:[MyAccount class]];
                    networkRequest.responseData = account;
                    return YES;
                }
               
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_UserChangeInfo])
            {
                networkRequest.responseData = [dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:KRequest_AccountWithDraw])
            {
                networkRequest.responseData = [dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_getCode])
            {
                networkRequest.responseData = [dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_UserChangePassWord])
            {
                networkRequest.responseData=[dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_UserInFo])
            {
                NSDictionary *dic=[resultData objectForKey:@"user"];
                if ([dic isKindOfClass:[NSDictionary class]])
                {
                    User *u=[[User shareInstance] initWithDictionary:dic];
                    networkRequest.responseData = u;
                    return YES;
                }
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_getOrdersList])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_getCurrentOrderInfo])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_getOrderInfo])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_submitOrder])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if ([networkRequest.requestName isEqualToString:kRequest_cancelOrder])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_repeatOrderList])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_renewOrder])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_MyTicket])
            {
               if( [[resultData objectForKey:@"invoices"] isKindOfClass:[NSArray class]])
               {
                   NSArray *array = [FMBean objectsWithArray:[resultData objectForKey:@"invoices"]  classType:[Invoice class]];
                   networkRequest.responseData=array;
                   NSString *totalNumber = [resultData objectForKey:@"totalNumber"];
                   [[NSUserDefaults standardUserDefaults] setObject:totalNumber forKey:@"totalNumber"];
                   return YES;
               }
            
            }
            else if([networkRequest.requestName isEqualToString:KRequest_AccountMoneyDetail])
            {
                NSArray *array = [FMBean objectsWithArray:[resultData objectForKey:@"flows"] classType:[FlowRecord class]];
                networkRequest.responseData = array;
                NSString *totalNumber = [resultData objectForKey:@"total"];
                [[NSUserDefaults standardUserDefaults] setObject:totalNumber forKey:@"totalNumber2"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_selectBranchByCondition])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_selectCarsByCondition])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_getCommonBranchList])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_getBranchListByPosition])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_selectOrderTimeByCarId])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_getAreaListByCity])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_evaluateOrder])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_CompanyCarBrand])
            {
                networkRequest.responseData = resultData;
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_findMyPassWord])
            {
                networkRequest.responseData = [dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:kRequest_findMyPassWordYZM])
            {
                networkRequest.responseData = [dic objectForKey:@"message"];
                return YES;
            }
            else if([networkRequest.requestName isEqualToString:KRequest_sendMyLocation])
            {
                networkRequest.responseData = [dic objectForKey:@"Code"];
                return YES;
            }
            else
            {
                networkRequest.responseData = resultData;
                return YES;
            }
         }
        else if((IsZip==0)&&(IsSec==0))
        {
            if ([networkRequest.requestName isEqualToString:kRequest_CheckVersion])
            {
                if (dic)
                {
                    self.keyStr = @"f4b9ec30ad9f68f89b29639786cb62ef";
                   // self.keyStr = [[dic objectForKey:@"SvcCont"] objectForKey:@"key"];
                    self.TransID=[dic objectForKey:@"TransID"];
                    return YES;
                }
            }
        }
        else
        {
        
        }
 
    }
    //code 不为100时候 返回的错误信息
    else
    {
        networkRequest.responseData = [result objectForKey:@"message"];
        if (!networkRequest.responseData)
        {
            networkRequest.responseData = @"亲~很抱歉您的操作失败";
        }
        return NO;
    }

    
    return ret;
}

-(FMNetworkRequest*)checkVersion_currentVersion:(NSString *)version
                                           type:(NSString*)type
                                       delegate:(id)delegate
{
    //第一次请求不需要加密
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:version forKey:@"ver"];
    [svcCont setObject:type forKey:@"appType"];
    
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *str2= [json stringWithObject:svcCont];
    //首先进行utf-8编码 然后des base64加密
    NSString *str = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:str
                                                                     MSGReq:@"0"
                                                                      IsSec:@"0"
                                                                      IsZip:@"0"];
    
    
    return [self addPostMethod:kRequest_CheckVersion
                       baseUrl:nil
                        action:@"client/upgrade.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

//4   ${basePath}/user/ confirm  上传
- (FMNetworkRequest *)upLoadIdentifyCardWithPhoneNum:(NSString *)phoneNum
                                              idCode:(NSString *)idCode
                                                pic1:(UIImage *)pic1
                                            pic1Type:(NSString *)pic1Type
                                                pic2:(UIImage *)pic2
                                            pic2Type:(NSString *)pic2Type
                                                pic3:(UIImage *)pic3
                                            pic3Type:(NSString *)pic3Type
                                            delegate:(id)delegate
{

    NSData *data1 = UIImageJPEGRepresentation(pic1, 1.0);
    NSData *data2 = UIImageJPEGRepresentation(pic2, 1.0);
    NSData *data3 = UIImageJPEGRepresentation(pic3, 1.0);
    NSLog(@"---------data1-----%@",data1);
    NSString *datastr1 = [data1 base64Encoding];
    NSString *datastr2 = [data2 base64Encoding];
    NSString *datastr3 = [data3 base64Encoding];
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:phoneNum forKey:@"phone"];
    [svcCont setObject:idCode   forKey:@"idcode"];
    [svcCont setObject:datastr1 forKey:@"pic1"];
    [svcCont setObject:datastr2 forKey:@"pic2"];
    [svcCont setObject:datastr3 forKey:@"pic3"];
    [svcCont setObject:pic1Type forKey:@"pic1Type"];
    [svcCont setObject:pic2Type forKey:@"pic2Type"];
    [svcCont setObject:pic3Type forKey:@"pic3Type"];
    
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *str2= [json stringWithObject:svcCont];
    NSString *str = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:str
                                                                     MSGReq:@"004"
                                                                      IsSec:@"0"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_RealName
                       baseUrl:nil
                        action:@"user/confirm.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

////Test
//-(FMNetworkRequest*)loginAction_supervisionLogin:(NSString*)phone
//                                        password:(NSString*)password
//                                            type:(NSString*)type
//                                           start:(NSString *)start
//                                             end:(NSString *)end
//                                        delegate:(id)delegate
//{
//    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
//    [svcCont setObject:phone forKey:@"id"];
//  //  [svcCont setObject:password forKey:@"couponno"];
//    
//    NSLog(@"-----%@",svcCont);
////    [svcCont setObject:type  forKey:@"returnBranch"];
////    [svcCont setObject:start  forKey:@"start"];
////    [svcCont setObject:end  forKey:@"end"];
//    
//    
//    //对内容进行加密
//    NSString *result = [self encryptDataWithDic:svcCont];
//    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
//                                                                     MSGReq:@"047"
//                                                                      IsSec:@"1"
//                                                                      IsZip:@"0"];
//    return [self addPostMethod:kRequest_UserLogin
//                       baseUrl:nil
//                        action:@"coupon/getStatistics.do"
//                        params:nil
//                     formDatas:postParams
//                      delegate:delegate];
//}

-(FMNetworkRequest*)loginAction_supervisionLogin:(NSString*)phone
                                        password:(NSString*)password
                                            type:(NSString*)type
                                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:phone forKey:@"account"];
    [svcCont setObject:password forKey:@"pwd"];
    [svcCont setObject:type  forKey:@"loginType"];

    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"001"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:kRequest_UserLogin
                       baseUrl:nil
                        action:@"user/login.do"
                        params:nil
                     formDatas:postParams
        
                      delegate:delegate];
}

#pragma mark -- 银联支付
- (FMNetworkRequest *)payWithUid:(NSString *)Uid
                           money:(NSString *)money
                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:Uid forKey:@"uid"];
    [svcCont setObject:money forKey:@"money"];
    NSLog(@"======%@",svcCont);
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"001"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    NSLog(@"=======银联支付   %@",svcCont);
    //@"http://192.168.221.6:8080"
    return [self addPostMethod:kRequest_UPPay
                       baseUrl:nil
                        action:@"account/upmpPayServer.do"
                        params:nil
                     formDatas:postParams
            
                      delegate:delegate];

}

-(FMNetworkRequest*)userRegister:(NSString *)phone
                        password:(NSString *)password
                  identifierCode:(NSString *)idCode
                   telephoneType:(NSString *)iosOrAndroid
                        delegate:(id)delegate
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:phone        forKey:@"account"];
    [dic setObject:password     forKey:@"pwd"];
    [dic setObject:idCode       forKey:@"sms"];
    [dic setObject:iosOrAndroid forKey:@"regWay"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:dic];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"002"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:kRequest_Register
                       baseUrl:nil
                        action:@"user/register.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark - 5 短信验证码
- (FMNetworkRequest *)getYZMWithAccount:(NSString *)account
                               delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:account forKey:@"account"];
    [svcCont setObject:@"1" forKey:@"type"];
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"001"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:kRequest_getCode
                       baseUrl:nil
                        action:@"user/sendCode.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark - 6 修改个人资料
- (FMNetworkRequest *)changeUserInfowithUserId:(NSString *)userId
                                          name:(NSString *)name
                                      nikeName:(NSString *)nikeName
                                           sex:(NSString *)sex
                                      birthday:(NSString *)birthday
                                        income:(NSString *)income
                                         email:(NSString *)email
                                       address:(NSString *)address
                                     headImage:(UIImage *)headImage
                                 headImageType:(NSString *)headImageType
                                      delegate:(id)delegate
{
    
    //转化图片为二进制流 之后用base64编码
    NSData *data = UIImageJPEGRepresentation(headImage, 1.0);
    NSString *dataStr=[data base64Encoding];
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(nikeName) forKey:@"nickname"];
    [svcCont setObject:GET(userId) forKey:@"ID"];
    [svcCont setObject:GET(name) forKey:@"name"];
    [svcCont setObject:GET(sex) forKey:@"sex"];
    [svcCont setObject:GET(birthday) forKey:@"birthday"];
    [svcCont setObject:GET(income )forKey:@"income"];
    [svcCont setObject:GET(email )forKey:@"email"];
    [svcCont setObject:GET(address) forKey:@"address"];
    [svcCont setObject:GET(dataStr) forKey:@"headImage"];
    [svcCont setObject:GET(headImageType) forKey:@"headImageType"];
    
    SBJsonWriter *json = [[SBJsonWriter alloc] init];
    NSString *str2= [json stringWithObject:svcCont];
    NSString *str = [str2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:str
                                                                     MSGReq:@"006"
                                                                      IsSec:@"0"
                                                                      IsZip:@"0"];
   
    return [self addPostMethod:kRequest_UserChangeInfo
                       baseUrl:nil
                        action:@"profile/edit.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
    
}

#pragma mark - 7 修改密码
- (FMNetworkRequest *)changePassWordWithuserId:(NSString *)userId
                                      passWord:(NSString*)passWord
                                   newPassWord:(NSString *)newPassWord
                                      delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"userId"];
    [svcCont setObject:passWord forKey:@"pwd"];
    [svcCont setObject:newPassWord forKey:@"newpwd"];
    
    NSLog(@"===svcCont===%@",svcCont);

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"007"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_UserChangePassWord
                       baseUrl:nil
                        action:@"profile/passwd.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];


}
#pragma mark - 9 获取用户资料

- (FMNetworkRequest *)getUserInfoWith:(NSString *)userId
                             delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"id"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"009"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_UserInFo
                       baseUrl:nil
                        action:@"profile/index.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
    
}

#pragma  mark-10账户充值
- (FMNetworkRequest *)rechargeWithUid:(NSString *)uid
                               payNum:(NSString *)payNum
                                 amount:(NSString *)amount
                        chargeChannel:(NSString *)chargeChannel
                            cardStyle:(NSString *)cardStyle
                             bankName:(NSString *)bankName
                            cardNumber:(NSString *)cardNumber
                               flowId:(NSString *)flowId
                                  delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(uid) forKey:@"uid"];
    [svcCont setObject:GET(payNum) forKey:@"payNum"]; //交易号
    [svcCont setObject:GET(amount) forKey:@"amount"];//”充值金额”
    [svcCont setObject:GET(chargeChannel) forKey:@"chargeChannel"];//交易方式（支付宝/银联）
    [svcCont setObject:GET(cardStyle) forKey:@"cardStyle"];//卡类型
    [svcCont setObject:GET(bankName) forKey:@"bankName"];//银行
    [svcCont setObject:GET(cardNumber) forKey:@"cardNumber"];//卡号
    [svcCont setObject:GET(flowId) forKey:@"flowId"];//我方交易流水号

    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0058"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_AccountCharge
                       baseUrl:nil
                        action:@"account/recharge.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark- 33用户投诉
// ${basePath}/ client/complain
-(FMNetworkRequest *)complain:(NSString *)userName
                     phoneNum:(NSString *)telephone
                 complainType:(NSString *)type
                      content:(NSString *)content
                  contentType:(NSString *)contentType
                     delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:type forKey:@"type"];
    [svcCont setObject:userName forKey:@"name"];
    [svcCont setObject:telephone forKey:@"telephone"];
    [svcCont setObject:content forKey:@"content"];
    [svcCont setObject:contentType forKey:@"contentType"];
    NSLog(@"======%@====",svcCont);
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0033"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_complain
                       baseUrl:nil
                        action:@"client/complain.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark- 58获取充值流水  支付宝 获取flowId
// ${basePath}/account/createPayNum
-(FMNetworkRequest *)createPayNum:(NSString *)uid
                            price:(NSString *)price
                          channel:(NSString *)channel
                         delegate:(id)delegate
{
    // channel  充值方式 0 支付宝 1 银联
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(uid) forKey:@"uid"];
    [svcCont setObject:GET(price) forKey:@"price"];
    [svcCont setObject:GET(channel) forKey:@"channel"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"058"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_createPayNum
                       baseUrl:nil
                        action:@"account/createPayNum.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}



#pragma  mark-10账户充值
- (FMNetworkRequest *)getChargeWithAccount:(NSString *)account
                                 chargenum:(NSString *)chargenum     //充值金额
                                    payNum:(NSString *)payNum        //交易号
                                  delegate:(id)delegate

//                             chargeChannel:(NSString *)chargeChannel //交易方式（支付宝0/银联1）
//                                 cardStyle:(NSString *)cardStyle     //卡类型
//                                  bankName:(NSString *)bankName      //银行
//                                cardNumber:(NSString *)cardNumber    //卡号
//                                    flowId:(NSString *)flowId        //我方交易流水号
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:account forKey:@"uid"];
    [svcCont setObject:chargenum forKey:@"amount"];
    [svcCont setObject:payNum forKey:@"flowId"];
    NSLog(@"---%@",svcCont);
//    [svcCont setObject:chargeChannel forKey:@"chargeChannel"];
//    [svcCont setObject:cardStyle forKey:@"cardStyle"];
//    [svcCont setObject:bankName forKey:@"bankName"];
//    [svcCont setObject:cardNumber forKey:@"cardNumber"];
//    [svcCont setObject:flowId forKey:@"flowId"];


    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"010"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_AccountCharge
                       baseUrl:nil
                        action:@"account/recharge.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}
#pragma mark-11账户提现
- (FMNetworkRequest *)WithDrawByUserId:(NSString *)userId
                             chargenum:(NSString *)chargenum
                                   YZM:(NSString *)YZM
                              delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"uid"];
    [svcCont setObject:chargenum forKey:@"refund"];
    [svcCont setObject:YZM forKey:@"sms"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"011"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_AccountWithDraw
                       baseUrl:nil
                        action:@"account/accountRefund.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}
#pragma mark - 12 账户金额详情
//“type”:流水类型 1全部 2充值 3提现 4消费
- (FMNetworkRequest *)getAccountDetailByUserId:(NSString *)userId
                                          type:(NSString *)type
                                      pageSize:(NSString *)pageSize
                                     pageNumber:(NSString *)pageNumber
                                      delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"uid"];
    [svcCont setObject:type forKey:@"type"];
    [svcCont setObject:pageSize forKey:@"pageSize"];
    [svcCont setObject:pageNumber forKey:@"pageNumber"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"012"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    NSLog(@"-------> %@",svcCont);
    
    return [self addPostMethod:KRequest_AccountMoneyDetail
                       baseUrl:nil
                        action:@"account/accountDetails.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}
#pragma mark - 21 我的发票（没有）
- (FMNetworkRequest *)getMyTicketByUserId:(NSString *)userId
                               pageNumber:(NSString *)pageNumber
                                pageSize :(NSString *)pageSize
                                 delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"uid"];
    [svcCont setObject:pageNumber forKey:@"pageNumber"];
    [svcCont setObject:pageSize forKey:@"pageSize"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"021"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_MyTicket
                       baseUrl:nil
                        action:@"account/myInvoice.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}
#pragma mark -22申请邮寄发票接口 orderId__订单号
- (FMNetworkRequest *)addTicketWithUserId:(NSString *)userId
                                 userName:(NSString *)userName
                                  address:(NSString *)address
                                    phone:(NSString *)phone
                                    title:(NSString *)title
                                    price:(NSString *)price
                                  orderId:(NSString *)orderId
                                 delegate:(id)delegate
{
    //njdd23201410000005
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userId) forKey:@"uid"];
    [svcCont setObject:GET(userName) forKey:@"userName"];
    [svcCont setObject:GET(address) forKey:@"address"];
    [svcCont setObject:GET(phone) forKey:@"phone"];
    [svcCont setObject:GET(title) forKey:@"title"];
    [svcCont setObject:GET(price) forKey:@"price"];
    [svcCont setObject:GET(orderId) forKey:@"orderId"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"022"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_AddTicket
                       baseUrl:nil
                        action:@"account/addInvoice.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
    

}
//59 查询企业订单列表
- (FMNetworkRequest *)getCompanyListUserID:(NSString *)userId
                                pageNumber:(NSString *)pageNumber                                  
                                 pageSize :(NSString *)pageSize
                                  delegate:( id )delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"uid"];
    [svcCont setObject:pageNumber forKey:@"pageNumber"];
    [svcCont setObject:pageSize forKey:@"pageSize"];


    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"059"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_getEnterpriseList
                       baseUrl:nil
                        action:@"order/selectCompanyConsult.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

    
}
#pragma mark - 40获取我的消息 
//${basePath}/ client/getMyMessage
- (FMNetworkRequest *)getMyMessageByPhoneNum:(NSString *)phoneNum
                                        type:(NSString *)type
                                  pageNumber:(NSString *)pageNumber
                                    pageSize:(NSString *)pageSize
                                    delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(phoneNum) forKey:@"phone"];
    [svcCont setObject:GET(type) forKey:@"type"];
    [svcCont setObject:GET(pageNumber) forKey:@"pageNumber"];
    [svcCont setObject:GET(pageSize) forKey:@"pageSize"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"040"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getMyMessage
                       baseUrl:nil
                        action:@"client/getMyMessage.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

//${basePath}/ client/setMessageReaded
#pragma mark - 41我的消息 已读/删除
- (FMNetworkRequest *)myMessageReadOrDeleteWithMsgId:(NSString*)msgId
                                           msgStatus:(NSString *)status
                                            delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(msgId) forKey:@"id"];
    [svcCont setObject:GET(status) forKey:@"status"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"041"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_MessageReaded
                       baseUrl:nil
                        action:@"client/setMessageReaded.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark-53 获取我的账户信息
- (FMNetworkRequest *)getMyAccountMessageWithUserId:(NSString *)userId delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userId) forKey:@"uid"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"053"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_getMyAccountMessage
                       baseUrl:nil
                        action:@"account/getAccount.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];


}

#pragma mark - 56找回密码验证码
//“type”: 1注册验证码 2找回密码验证码 3提现验证码
- (FMNetworkRequest *)getYZMfindMyPassWordWithPhoneNum:(NSString *)phone
                                                  type:(NSString *)type
                                              delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:phone forKey:@"account"];
    [svcCont setObject:type forKey:@"type"];
    
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"056"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_findMyPassWordYZM
                       baseUrl:nil
                        action:@"user/sendCode.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
    

}
#pragma mark - 57找回密码
- (FMNetworkRequest *)findMyPassWordWithPhoneNum:(NSString *)phone
                                             YZM:(NSString *)YZM
                                             pwd:(NSString *)pwd
                                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:phone forKey:@"account"];
    [svcCont setObject:YZM forKey:@"sms"];
    [svcCont setObject:pwd forKey:@"pwd"];


    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"057"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_findMyPassWord
                       baseUrl:nil
                        action:@"user/updatePwdByPhone.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];


}

//${basePath}/order/updateOrder
-(FMNetworkRequest *)updateOrder:(NSString *)orderId
                         backNet:(NSString *)backNet
                       startTime:(NSString *)startTime
                         endTime:(NSString *)endTime
                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [svcCont setObject:GET(orderId) forKey:@"orderId"];
    [svcCont setObject:GET(backNet) forKey:@"backNet"];
    [svcCont setObject:GET(startTime) forKey:@"startTime"];
    [svcCont setObject:GET(endTime) forKey:@"endTime"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0050"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_updateOrder
                       baseUrl:nil
                        action:@"order/updateOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}
#pragma mark-64修改订单
//修改订单
- (FMNetworkRequest *)modifyOrderWithOrderId:(NSString *)orderId
                                     backNet:(NSString *)backNet
                                   startTime:(NSString *)startTime
                                     endTime:(NSString *)endTime
                                     deposit:(NSString *)deposit
                                  addDeposit:(NSString *)addDeposit
                                 timeDeposit:(NSString *)timeDeposit
                              mileageDeposit:(NSString *)mileageDeposit
                             dispatchDeposit:(NSString *)dispatchDeposit
                                    delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [svcCont setObject:GET(orderId) forKey:@"orderId"];
    [svcCont setObject:GET(backNet) forKey:@"backNet"];
    [svcCont setObject:GET(startTime) forKey:@"startTime"];
    [svcCont setObject:GET(endTime) forKey:@"endTime"];
    [svcCont setObject:GET(deposit) forKey:@"deposit"];
    [svcCont setObject:GET(addDeposit) forKey:@"addDeposit"];
    [svcCont setObject:GET(timeDeposit) forKey:@"timeDeposit"];
    [svcCont setObject:GET(mileageDeposit) forKey:@"mileageDeposit"];
    [svcCont setObject:GET(dispatchDeposit) forKey:@"dispatchDeposit"];

    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0064"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_changeOrder
                       baseUrl:nil
                        action:@"order/realUpdateOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}
#pragma mark - 67找回密码 校验验证码
- (FMNetworkRequest *)findMyPasswordCheckCode:(NSString *)sms
                                     delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [svcCont setObject:GET(sms) forKey:@"sms"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0067"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_checkCode
                       baseUrl:nil
                        action:@"user/checkCode.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}
#pragma mark - 个人订单
// 当前订单信息 ${basePath}/ order / orderinfo
-(FMNetworkRequest *)getCurrentOrderInfo:(NSString *)userID delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [svcCont setObject:GET(userID) forKey:@"ID"];
    
    //对内容进行加密
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0014"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCurrentOrderInfo
                       baseUrl:nil
                        action:@"order/orderinfo.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//${basePath}/ order/ orderlist
-(FMNetworkRequest *)getOrdersList:(NSString *)userID
                              Page:(NSString *)page
                              Size:(NSString*)numOfperPage
                          delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userID) forKey:@"ID"];
    [svcCont setObject:GET(page) forKey:@"pageNumber"];
    [svcCont setObject:GET(numOfperPage) forKey:@"pageSize"];
    
    NSString *result = [self encryptDataWithDic:svcCont];

    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0013"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getOrdersList
                       baseUrl:nil
                        action:@"order/orderlist.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

//${basePath}/ order /getOrderInfo
-(FMNetworkRequest *)getOrderInfo:(NSString *)orderID
                         delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(orderID) forKey:@"orderId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0015"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getOrderInfo
                       baseUrl:nil
                        action:@"order/getOrderInfo.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// 提交订单接口 ${basePath}/ order /submitOrder
-(FMNetworkRequest *)submitOrder:(NSString *)userID
                             car:(NSString *)carID
                       getBranchId:(NSString *)getBranchId
                    returnBranchId:(NSString *)returnBranchId
                           start:(NSString *)startTime
                             end:(NSString *)endTime
                  mileageDeposit:(NSString *)mileageDeposit
                     timeDeposit:(NSString *)timeDeposit
                   damageDeposit:(NSString *)damageDeposit
                 peccancyDeposit:(NSString *)peccancyDeposit
                 dispatchDeposit:(NSString *)dispatchDeposit
                         deposit:(NSString *)deposit
                     mileageunit:(NSString *)mileageunit
                        lateunit:(NSString *)lateunit
                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userID) forKey:@"uid"];
    [svcCont setObject:GET(carID) forKey:@"carId"];
    [svcCont setObject:GET(getBranchId) forKey:@"getBranch"];
    [svcCont setObject:GET(returnBranchId) forKey:@"returnBranch"];
    [svcCont setObject:GET(startTime) forKey:@"start"];
    [svcCont setObject:GET(endTime) forKey:@"end"];
    [svcCont setObject:GET(mileageDeposit) forKey:@"mileageDeposit"];
    [svcCont setObject:GET(timeDeposit) forKey:@"timeDeposit"];
    [svcCont setObject:GET(damageDeposit) forKey:@"damageDeposit"];
    [svcCont setObject:GET(peccancyDeposit) forKey:@"peccancyDeposit"];
    [svcCont setObject:GET(dispatchDeposit) forKey:@"dispatchDeposit"];
    [svcCont setObject:GET(deposit) forKey:@"deposit"];
    [svcCont setObject:GET(mileageunit) forKey:@"mileageunit"];
    [svcCont setObject:GET(lateunit) forKey:@"lateunit"];
    
    NSLog(@"=========%@",svcCont);
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0017"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_submitOrder
                       baseUrl:nil
                        action:@"order/submitOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//${basePath}/ order /cancelOrder
-(FMNetworkRequest *)cancelOrder:(NSString *)orderID
                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(orderID) forKey:@"orderId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0018"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_cancelOrder
                       baseUrl:nil
                        action:@"order/cancelOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/ order /repeatOrderList
-(FMNetworkRequest *)repeatOrderList:(NSString *)orderID
                        delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(orderID) forKey:@"orderId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0019"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_repeatOrderList
                       baseUrl:nil
                        action:@"order/repeatOrderList.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/ order /renewOrder
-(FMNetworkRequest *)renewOrder:(NSString *)userID
                        orderId:(NSString *)orderID
                      renewTime:(NSString *)renewTime
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTime
                 mileageDeposit:(NSString *)mileageDeposit
                    timeDeposit:(NSString *)timeDeposit
                        Deposit:(NSString *)deposit
                       delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userID) forKey:@"uid"];
    [svcCont setObject:GET(orderID) forKey:@"orderId"];
    [svcCont setObject:GET(renewTime) forKey:@"orderTime"];
    [svcCont setObject:GET(startTime) forKey:@"startTime"];
    [svcCont setObject:GET(endTime) forKey:@"endTime"];
    [svcCont setObject:GET(timeDeposit) forKey:@"timeDeposit"];
    [svcCont setObject:GET(mileageDeposit) forKey:@"mileageDeposit"];
    [svcCont setObject:GET(deposit) forKey:@"deposit"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0020"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_renewOrder
                       baseUrl:nil
                        action:@"order/renewOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark - 分时租车

// ${basePath}/ client/getBranchById
-(FMNetworkRequest *)getBranchById:(NSString *)branchId
                          delegate:(id)delegate
{
    if (nil == branchId) {
        return nil;
    }
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(branchId) forKey:@"branchId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0027"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getBranchById
                       baseUrl:nil
                        action:@"client/getBranchById.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// 分时租车 ${basePath}/ client/selectBranchByCondition
-(FMNetworkRequest *)selectBranchByCondition:(NSString*)brancheName
                                        city:(NSString*)city
                                        area:(NSString*)area
                                  pageNumber:(NSInteger)pageNumber
                                    pageSize:(NSInteger)pageSize
                                    delegate:(id)delegate
{
    NSString *strPageNumber;
    if (pageNumber==0)
    {
       strPageNumber = @"";
    }
    else
    {
       strPageNumber = [NSString stringWithFormat:@"%d", pageNumber];
    }
    NSString *strPageSize;
    if (pageSize==0)
    {
        strPageSize=@"";
    }
    else
    {
        strPageSize = [NSString stringWithFormat:@"%d", pageSize];
    }
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];

    [svcCont setObject:GET(brancheName) forKey:@"branchName"];
    [svcCont setObject:GET(city) forKey:@"city"];
    [svcCont setObject:GET(area) forKey:@"area"];
    [svcCont setObject:GET(strPageNumber) forKey:@"pageNumber"];
    [svcCont setObject:GET(strPageSize) forKey:@"pageSize"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0026"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_selectBranchByCondition
                       baseUrl:nil
                        action:@"client/selectBranchByCondition.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/client/ getCompanyCarTypeList
-(FMNetworkRequest *)getCompanyCarTypeListWithBrand:(NSString *)brand
                                           delegate:(id)delegate
{
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(brand) forKey:@"brand"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0060"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCompanyCarTypeList
                       baseUrl:nil
                        action:@"client/getCompanyCarTypeList.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// 根据城市/网点获取车辆列表 ${basePath}/ client/selectCarsByCondition
-(FMNetworkRequest *)selectCarsByCondition:(NSString *)city
                                  takeTime:(NSString *)startTime
                                returnTime:(NSString *)endTime
                                     branche:(NSString*)branche
                                      page:(NSInteger)pagenumber
                                      pagesize:(NSInteger)pagesize
                                  delegate:(id)delegate
{
    NSString *strPage = [NSString stringWithFormat:@"%d", pagenumber];
    NSString *strPageSize = [NSString stringWithFormat:@"%d", pagesize];
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(city) forKey:@"city"];
    [svcCont setObject:GET(branche) forKey:@"branchId"];
    [svcCont setObject:GET(strPage) forKey:@"pagenumber"];
    [svcCont setObject:GET(strPageSize) forKey:@"pageSize"];
    [svcCont setObject:GET(startTime) forKey:@"startTime"];
    [svcCont setObject:GET(endTime) forKey:@"endTime"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0029"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_selectCarsByCondition
                       baseUrl:nil
                        action:@"client/selectCarsByCondition.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// 获取常用网点 ${basePath}/ client/getCommonBranchList
-(FMNetworkRequest *)getCommonBranchList:(NSString*)userID
                              pageNumber:(NSString*)pageNumber
                                pageSize:(NSString*)pageSize
                             brancheType:(NSString*)type
                                delegate:(id)delegate
{
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userID) forKey:@"uid"];
    [svcCont setObject:GET(pageNumber) forKey:@"pageNumber"];
    [svcCont setObject:GET(pageSize) forKey:@"pageSize"];
    [svcCont setObject:GET(type) forKey:@"type"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0023"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCommonBranchList
                       baseUrl:nil
                        action:@"client/getCommonBranchList.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// 据经纬度获取网点列表 ${basePath}/ client/getBranchListByPosition
-(FMNetworkRequest *)getBranchListByPosition:(NSString *)longtitude
                                    latitude:(NSString *)latitude
                                  pageNumber:(NSString *)pagenumber
                                    pagesize:(NSString *)pagesize
                                    delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(longtitude) forKey:@"longtitude"];
    [svcCont setObject:GET(latitude) forKey:@"latitude"];
    [svcCont setObject:GET(pagenumber) forKey:@"pageNumber"];
    [svcCont setObject:GET(pagesize) forKey:@"pageSize"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0024"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getBranchListByPosition
                       baseUrl:nil
                        action:@"client/getBranchListByPosition.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// 车辆时间轴 ${basePath}/ client/selectOrderTimeByCarId
-(FMNetworkRequest *)selectOrderTimeByCarId:(NSString *)carId
                        delegate:(id)delegate
{
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0031"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_selectOrderTimeByCarId
                       baseUrl:nil
                        action:@"client/selectOrderTimeByCarId.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//城市区 ${basePath}/ client/getAreaListByCity
-(FMNetworkRequest *)getAreaListByCity:(NSString *)city
                              delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(city) forKey:@"city"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0028"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getAreaListByCity
                       baseUrl:nil
                        action:@"client/getAreaListByCity.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// 订单估价接口 ${basePath}/ order /evaluateOrder
-(FMNetworkRequest *)evaluateOrderWithCarId:(NSString*)carId
                                  getBranch:(NSString*)getBranch
                               returnBranch:(NSString*)returnBranch
                                      start:(NSString*)startTime
                                         end:(NSString *)endTime
                                   delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    [svcCont setObject:GET(getBranch) forKey:@"getBranch"];
    [svcCont setObject:GET(returnBranch) forKey:@"returnBranch"];
    [svcCont setObject:GET(startTime) forKey:@"start"];
    [svcCont setObject:GET(endTime) forKey:@"end"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0016"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_evaluateOrder
                       baseUrl:nil
                        action:@"order/evaluateOrder.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/order/ computeRenew
-(FMNetworkRequest *)computeRenewWithUid:(NSString *)uid
                                   carId:(NSString *)carId
                                duration:(NSString *)duration
                                delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(uid) forKey:@"uid"];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    [svcCont setObject:GET(duration) forKey:@"duration"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0051"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_computeRenew
                       baseUrl:nil
                        action:@"order/computeRenew.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

//${basePath}/order/ getRenewFullInfo
-(FMNetworkRequest *)getRenewFullInfoWithUid:(NSString *)uid
                                       carId:(NSString *)carId
                                    delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(uid) forKey:@"uid"];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0052"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getRenewFullInfo
                       baseUrl:nil
                        action:@"order/getRenewFullInfo.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

#pragma mark - image
-(FMNetworkRequest *)getImageWithUrl:(NSString *)imagUrl
                            delegate:(id)delegate
{
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:@""
                                                                     MSGReq:@"0028"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
#if 1
    return [self addPostMethod:kRequest_getImage
                       baseUrl:nil//kImageBaseUrl
                        action:imagUrl
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
#else
    return [self addGetMethod:kRequest_getImage
                 baseUrl:kImageBaseUrl
                  action:imagUrl
                  params:postParams
                delegate:delegate];
#endif
}

#pragma mark - Car

// ${basePath}/ client/getCarPrice
-(FMNetworkRequest *)getCarPriceWithCarId:(NSString *)carId
                                     startTime:(NSString *)startTime
                                      delegate:(id)delegate
{
    if (nil == carId) {
        NSLog(@"car id is nil");
        return nil;
    }
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    if (startTime && [startTime length] > 0) {
        [svcCont setObject:(startTime ? startTime : @"") forKey:@"time"];
    }
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0030"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCarPrice
                       baseUrl:nil
                        action:@"client/getCarPrice.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/ client/getCarInfo
-(FMNetworkRequest *)getCarInfo:(NSString *)carId
                       delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0032"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCarInfo
                       baseUrl:nil
                        action:@"client/getCarInfo.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

// ${basePath}/car/getCarStatus
-(FMNetworkRequest *)getCarStatus:(NSString *)carId
                          deleage:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(carId) forKey:@"carId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0054"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCarStatus
                       baseUrl:nil
                        action:@"car/getCarStatus.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


#pragma mark - My Car
//71鸣笛 取车  开门前发送我的位置
- (FMNetworkRequest *)sendMyLocationWithLog:(NSString *)Logitute
                                        lat:(NSString *)latitude
                                     cardId:(NSString *)cardId
                                   delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [svcCont setObject:GET(cardId) forKey:@"carId"];
    [svcCont setObject:GET(latitude) forKey:@"lat"];
    [svcCont setObject:GET(Logitute) forKey:@"lng"];
    NSLog(@"=====%@",svcCont);

    
    NSString *result = [self encryptDataWithDic:svcCont];
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0071"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:KRequest_sendMyLocation
                       baseUrl:nil
                        action:@"client/getCarCoordinate.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];


}

//http://192.168.221.40:8080/sarmonitor/controlcmdAction.do?method=ccpcmd&carid=09&type=10&orderid=xxxx
/* type
 1	认证	长连接建立之后，指令真正下发之前，终端必须向系统发送此指令进行认证。目前系统通过流程id进行简单认证，因此不需求携带data数据。
 10	鸣笛
 11	解锁
 12	锁车	
 */
-(FMNetworkRequest *)getCarAuthenticationWithCarId:(NSString *)carId
                                           orderId:(NSString *)orderId
                                          delegate:(id)delegate
{
    NSString *actionStr = [NSString stringWithFormat:@"?method=ccpcmd&carid=%@&type=%@&orderid=%@", carId, @"1", orderId];
    
    return [self addGetMethod:kGet_carAuthentication baseUrl:kCarOperationBaseUrl action:actionStr params:nil delegate:delegate];
}

-(FMNetworkRequest *)openDoorWithCarId:(NSString *)carId
                               orderId:(NSString *)orderId
                              delegate:(id)delegate
{
    NSString *actionStr = [NSString stringWithFormat:@"?method=ccpcmd&carid=%@&type=%@&orderid=%@", carId, @"11", orderId];
    
    return [self addGetMethod:kGet_carOpenDoor baseUrl:kCarOperationBaseUrl action:actionStr params:nil delegate:delegate];
}

-(FMNetworkRequest *)closeDoorWithCarId:(NSString *)carId
                                orderId:(NSString *)orderId
                               delegate:(id)delegate
{
    NSString *actionStr = [NSString stringWithFormat:@"?method=ccpcmd&carid=%@&type=%@&orderid=%@", carId, @"12", orderId];
    return [self addGetMethod:kGet_carCloseDoor baseUrl:kCarOperationBaseUrl action:actionStr params:nil delegate:delegate];
}

-(FMNetworkRequest *)honkingWithCarId:(NSString *)carId
                              orderId:(NSString *)orderId
                             delegate:(id)delegate
{
    NSString *actionStr = [NSString stringWithFormat:@"?method=ccpcmd&carid=%@&type=%@&orderid=%@", carId, @"10", orderId];
    
    return [self addGetMethod:kGet_carHonking baseUrl:kCarOperationBaseUrl action:actionStr params:nil delegate:delegate];
}


//${basePath}/account/returnCar

//${basePath}/account/returnCar
-(FMNetworkRequest *)returnCarWithUid:(NSString *)uid
                              orderId:(NSString *)orderId
                            useCoupon:(BOOL)bUse
                             couponId:(NSString *)couponId
                             delegate:(id)delegate
{
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(uid) forKey:@"uid"];
    [svcCont setObject:GET(orderId) forKey:@"orderId"];
    [svcCont setObject:(bUse ? @"1" : @"0") forKey:@"useCoupon"];
    [svcCont setObject:couponId forKey:@"couponId"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0055"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_returnCar
                       baseUrl:nil
                        action:@"account/returnCar.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}
#pragma mark - company
// ${basePath}/ client/getCompanyCarBrand
-(FMNetworkRequest *)getCompanyCarBrandWithDelegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:@"" forKey:@""];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0039"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_CompanyCarBrand
                       baseUrl:nil
                        action:@"client/getCompanyCarBrand.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// ${basePath}/ order /sendCompanyConsult
-(FMNetworkRequest *)sendCompanyConsultWithUserId:(NSString *)userID
                                            phone:(NSString *)phone
                                           carNum:(NSString *)carNum
                                             time:(NSString *)time
                                             city:(NSString *)city
                                          useTime:(NSString *)useTime
                                           remark:(NSString *)remark
                                          company:(NSString *)company
                                          linkman:(NSString *)linkman
                                        carseries:(NSString *)carseries
                                            brand:(NSString *)brand
                                designated_driver:(NSString *)designated_driver
                                         delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userID) forKey:@"userID"];
    [svcCont setObject:GET(phone) forKey:@"phone"];
    [svcCont setObject:GET(carNum) forKey:@"carNum"];
    [svcCont setObject:GET(time) forKey:@"time"];
    [svcCont setObject:GET(city) forKey:@"city"];
    [svcCont setObject:GET(useTime) forKey:@"useTime"];
    [svcCont setObject:GET(remark) forKey:@"remark"];
    [svcCont setObject:GET(company) forKey:@"company"];
    [svcCont setObject:GET(linkman) forKey:@"linkman"];
    [svcCont setObject:GET(carseries) forKey:@"carseries"];
    [svcCont setObject:GET(brand) forKey:@"brand"];
    [svcCont setObject:GET(designated_driver) forKey:@"designated_driver"];
    
    NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",userID,phone,carNum,time,city,useTime,remark,company,linkman,brand,carseries,designated_driver);
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0038"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_sendCompanyConsult
                       baseUrl:nil
                        action:@"order/sendCompanyConsult.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

#pragma mark - coupon
     //${basePath}/coupon/getMyCoupon
-(FMNetworkRequest *)getMyCouponWithUserId:(NSString *)userId
                              takeTime:(NSString *)takeTime
                          givebackTime:(NSString *)givebackTime
                                  type:(NSString *)type
                                  sortType:(NSString *)sortType
                                pageNumber:(NSInteger)pageNumber
                                  pageSize:(NSInteger)pageSize
                              delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"id"];
    [svcCont setObject:takeTime forKey:@"begindate"];
    [svcCont setObject:givebackTime forKey:@"enddate"];
    [svcCont setObject:type forKey:@"type"];
    [svcCont setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"pageNumber"];
    [svcCont setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [svcCont setObject:sortType forKey:@"sortType"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0044"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getMyCoupon
                       baseUrl:nil
                        action:@"coupon/getMyCoupon.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


// ${basePath}/coupon/exchangeCoupon
-(FMNetworkRequest *)exchangeCouponWithUserId:(NSString *)userId
                           authcode:(NSString *)authcode
                           delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"id"];
    [svcCont setObject:authcode forKey:@"authcode"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0044"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_exchangeCoupon
                       baseUrl:nil
                        action:@"coupon/exchangeCoupon.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


//${basePath}/coupon/getCouponUseRecord
-(FMNetworkRequest *)getCouponUseRecordWithUserId:(NSString *)userId
                                         takeTime:(NSString *)takeTime
                                     givebackTime:(NSString *)givebackTime
                                         delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"id"];
    [svcCont setObject:takeTime forKey:@"begindate"];
    [svcCont setObject:givebackTime forKey:@"enddate"];
    NSLog(@"---svcCont%@",svcCont);
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0046"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
   
    
    return [self addPostMethod:kRequest_getCouponUseRecord
                       baseUrl:nil
                        action:@"coupon/getCouponUseRecord.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


//${basePath}/coupon/getSuitableCoupon
-(FMNetworkRequest *)getSuitableCoupon:(NSString *)orderId
                              delegate:(id)delegate
{
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:orderId forKey:@"orderId"];
    NSLog(@"---svcCont%@",svcCont);
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0047"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    
    return [self addPostMethod:kRequest_getSuitableCoupon
                       baseUrl:nil
                        action:@"coupon/getSuitableCoupon.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//47  ${basePath}/coupon/getStatistics
- (FMNetworkRequest *)getCouponStatisticsWithUserId:(NSString *)userId
                                           delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userId forKey:@"id"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0047"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:KRequest_getCouponStatistic
                       baseUrl:nil
                        action:@"coupon/getStatistics.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

    
}


#pragma mark - 首页广告
//${basePath}/ client/getAdvertisement
-(FMNetworkRequest *)getAdvertisement:(NSString *)num
                                type:(NSString *)type//1.pc端首页，2.手机端首页，3长租页，4.注册页
                            delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:num forKey:@"num"];
//    [svcCont setObject:type forKey:@"type"];
    [svcCont setObject:@"2" forKey:@"type"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0043"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getAdvertisement
                       baseUrl:nil
                        action:@"client/getAdvertisement.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}

// 48${basePath}/coupon/discardCoupon
- (FMNetworkRequest *)disCardCouponWithUserID:(NSString *)userID
                                       cardNo:(NSString *)cardNo
                                     delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:userID forKey:@"id"];
    [svcCont setObject:cardNo forKey:@"couponno"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0048"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:KRequest_discardCoupon
                       baseUrl:nil
                        action:@"coupon/discardCoupon.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];


}


//29 根据城市/网点获取车辆列表接口 ${basePath}/ client/selectCarsByCondition
- (FMNetworkRequest *)selectCarsByConditionWithCity:(NSString *)city
                                           BranchId:(NSString *)branchId
                                              Brand:(NSString *)barnd
                                           PageSize:(NSInteger)pagesize
                                            PageNum:(NSInteger)pageNum
                                           delegate:(id)delegate
{
    NSString *strPage = [NSString stringWithFormat:@"%d", pageNum];
    NSString *strPageSize = [NSString stringWithFormat:@"%d", pagesize];
    
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(city) forKey:@"city"];
    [svcCont setObject:GET(branchId) forKey:@"branchId"];
    [svcCont setObject:GET(barnd) forKey:@"barnd"];
    [svcCont setObject:GET(strPageSize) forKey:@"pageSize"];
    [svcCont setObject:GET(strPage) forKey:@"pageNumber"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0029"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_selectCarsByCondition
                       baseUrl:nil
                        action:@"client/selectCarsByCondition.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];

}


//38 提交企业意向订单 ${basePath}/ client/getCompanyCarTypeList
- (FMNetworkRequest *)sendCompanyConsultWithUserID:(NSString *)userId
                                           PhoneNu:(NSString *)phoneNu
                                             Model:(NSString *)model
                                             CarNu:(NSInteger )carNu
                                              Time:(NSString *)time
                                              City:(NSString *)city
                                           UseTime:(NSString *)useTime
                                            Remark:(NSString *)remark
                                           Company:(NSString *)company
                                           Linkman:(NSString *)linkman
                                          delegate:(id)delegate
{
    NSString *carNum = [NSString stringWithFormat:@"%d",carNu];
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(userId) forKey:@"userID"];
    [svcCont setObject:GET(phoneNu) forKey:@"phone"];
    [svcCont setObject:GET(model) forKey:@"model"];
    [svcCont setObject:GET(carNum) forKey:@"carNum"];
    [svcCont setObject:GET(time) forKey:@"time"];
    [svcCont setObject:GET(city) forKey:@"city"];
    [svcCont setObject:GET(useTime) forKey:@"useTime"];
    [svcCont setObject:GET(remark) forKey:@"remark"];
    [svcCont setObject:GET(company) forKey:@"company"];
    [svcCont setObject:GET(linkman) forKey:@"linkman"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0038"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_sendCompanyConsuit
                       baseUrl:nil
                        action:@"order/sendCompanyConsult.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//39 获取所有企业用车品牌 ${basePath}/ client/getCompanyCarBrand
- (FMNetworkRequest *)getCompanyCarTypeListWithDelegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:@"" forKey:@""];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0039"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    
    return [self addPostMethod:kRequest_getCompanyCarBrand
                       baseUrl:nil
                        action:@"client/getCompanyCarBrand.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}

//60 根据品牌获取企业可租车系 ${basePath}/client/ getCompanyCarTypeList
- (FMNetworkRequest *)getCompanyCarTypeListByBrand:(NSString *)brand
                                          delegate:(id)delegate
{
    NSMutableDictionary *svcCont = [NSMutableDictionary dictionaryWithCapacity:10];
    [svcCont setObject:GET(brand) forKey:@"brand"];
    
    NSString *result = [self encryptDataWithDic:svcCont];
    
    NSMutableDictionary *postParams = [self dictionaryWithPostParamsSvcCont:result
                                                                     MSGReq:@"0060"
                                                                      IsSec:@"1"
                                                                      IsZip:@"0"];
    return [self addPostMethod:kRequest_getCompanyCarTypeList
                       baseUrl:nil
                        action:@"client/getCompanyCarTypeList.do"
                        params:nil
                     formDatas:postParams
                      delegate:delegate];
}


#pragma mark -
#pragma mark === 继承Get、Post方法 ===
#pragma mark -

-(FMNetworkRequest*)addGetMethod:(NSString*)requestName
                         baseUrl:(NSString*)baseUrl
                          action:(NSString*)action
                          params:(NSDictionary*)params
                        delegate:(id<FMNetworkProtocol>)networkDelegate
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (baseUrl)
    {
        [ms setString:baseUrl];
    }
    else
    {
        [ms setString:kProjectBaseUrl];
    }
    
    [ms appendString:action];
    
    [ms appendString:[self combineCommonGetParams:params]];
    
    NSLog(@"[GET][%@]:%@", requestName, ms);
    
    return [self addGetUrl:ms requestName:requestName delegate:networkDelegate];
}

-(FMNetworkRequest*)addPostMethod:(NSString*)requestName
                          baseUrl:(NSString*)baseUrl
                           action:(NSString*)action
                           params:(NSDictionary*)params
                        formDatas:(NSDictionary*)formDatas
                         delegate:(id<FMNetworkProtocol>)networkDelegate
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (baseUrl)
    {
        [ms setString:baseUrl];
    }
    else
    {
        [ms setString:kProjectBaseUrl];
    }
    
    [ms appendString:action];
    
    [ms appendString:[self combineCommonGetParams:params]];
    
    NSDictionary *datas = [self combineCommonPostDatas:formDatas];
    
    NSLog(@"[POST][%@]:%@", requestName, ms);
    NSLog(@"[POSTDATA][%@]:%@", requestName, datas);
    
    return [super addPostUrl:ms requestName:requestName formDatas:datas delegate:networkDelegate];
}

-(NSString*)combineCommonGetParams:(NSDictionary*)baseParams
{
    if (!baseParams)
    {
        return @"";
    }
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:10];
    [md setDictionary:baseParams];
    
    
    return [FMNetworkManager encodedUrlForUrlPrefix:@"" params:md];
}

-(NSDictionary*)combineCommonPostDatas:(NSDictionary*)baseParams
{
    if (!baseParams)
    {
        return [NSDictionary dictionary];
    }
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:10];
    [md setDictionary:baseParams];
    //公共参数
    if (self.TransID)
    {
        [md setObject:self.TransID forKey:@"TransID"];
    }
    else
    {
        [md setObject:@"" forKey:@"TransID"];
    }
    return md;
}

-(FMNetworkRequest*)addGetMethod:(NSString*)requestName
                         baseUrl:(NSString*)baseUrl
                          action:(NSString*)action
                          params:(NSDictionary*)params
                        delegate:(id<FMNetworkProtocol>)networkDelegate
                         session:(NSString*)session
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:100];
    if (baseUrl) {
        [ms setString:baseUrl];
    }
    else
    {
        [ms setString:kProjectBaseUrl];
    }
    
    [ms appendString:action];
    
    [ms appendString:[self combineCommonGetParams:params]];
    
    NSLog(@"[GET][%@]:%@", requestName, ms);
    
    return [self addGetUrl:ms requestName:requestName delegate:networkDelegate sessionid:session];
}

-(FMNetworkRequest*)addGetUrl:(NSString*)urlString
                  requestName:(NSString*)requestName
                     delegate:(id<FMNetworkProtocol>)networkDelegate
                    sessionid:(NSString*)sessionid
{
    FMNetworkRequest *fm_request = [[[FMNetworkRequest alloc] init] autorelease];
	fm_request.networkDelegate = networkDelegate;
    
    if (NO == [self checkNetwork:fm_request]) {
        return nil;
    }
    
    [self registNetwork:networkDelegate];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setDelegate:self];
	request.timeOutSeconds = 10;
    request.shouldAttemptPersistentConnection = NO;
    request.uploadProgressDelegate = self;
    request.downloadProgressDelegate = self;
    request.showAccurateProgress = YES;
    
//    if (sessionid) [request addRequestHeader:@"JSESSIONID" value:sessionid];
    
	fm_request.asiHttpRequest = request;
	fm_request.requestName = requestName;
    
    request.userInfo = [NSDictionary dictionaryWithObject:fm_request forKey:@"NetworkRequest"];
	[self addNetworkRequest:fm_request forInstance:networkDelegate];
    [fm_request start];
    
    [request release];
    
    return fm_request;
}
@end
