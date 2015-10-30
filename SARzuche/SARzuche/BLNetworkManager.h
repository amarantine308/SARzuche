//
//  SWNetworkManager.h
//  Shuiwu
//
//  Created by Leks on 13-12-20.
//  Copyright (c) 2013年 Shuiwu. All rights reserved.
//

#import "FMNetworkManager.h"
#import "SBJsonWriter.h"



#define EXTRANET        1// 使用外网改为 1，内网 0
//#define DEBUG  1

#if EXTRANET //外网
#define kProjectBaseUrl                   @"www.51sar.com:18778/"

#else
#if DEBUG // 开发调试
#define kProjectBaseUrl                   @"http://192.168.221.22:8080/sbdcar/"
//#define kProjectBaseUrl                   @"http://192.168.221.6:8080/sbdcar/"
#else // Release 发布
#define kProjectBaseUrl                   @"http://192.168.221.221:8091/sbdcar/"
#endif
#endif

#if EXTRANET //外网
#define kCarOperationBaseUrl                @"http://221.226.2.254:18081/sarmonitor/controlcmdAction.do"
#else
#if DEBUG// 开发调试
#define kCarOperationBaseUrl                @"http://192.168.221.221:8081/sarmonitor/controlcmdAction.do"
//#define kCarOperationBaseUrl                     @"http://221.226.2.254:28080/sarmonitor/controlcmdAction.do"
#else
#define kCarOperationBaseUrl                @"http://192.168.221.221:8091/sarmonitor/controlcmdAction.do"
#endif
#endif

#if EXTRANET//外网
#define kImageBaseUrl                   @"http://221.226.2.254:18091/sarcms"
#else
#if DEBUG// 开发调试
//#define kImageBaseUrl                   @"http://221.226.2.254:28080/sarcms"
#define kImageBaseUrl                   @"http://221.226.221.6:28080/sarcms"
#else// Release 发布
#define kImageBaseUrl                   @"http://192.168.221.221:8091/sarcms"
#endif
#endif
#define PAY_ALIPYBACK     @"http://221.226.2.254:18091/sbdcar/account/recharge2.do"
//#define PAY_ALIPYBACK     @"http://221.226.2.254:48080/sbdcar/account/recharge2.do"
//#define PAY_ALIPYBACK     @"http%3A%2F%2F221.226.2.254:48080/sbdcar/account/recharge2.do"//杨国玉



#define kRequest_CheckVersion             @"0 检测版本"
#define kRequest_UserLogin                @"1 用户-登录"
#define kRequest_Register                 @"2 新用户注册"
#define KRequest_RealName                 @"4 实名认证"
#define kRequest_getCode                  @"5 获取验证码"


#define kRequest_UserChangeInfo           @"6 用户资料修改"
#define kRequest_UserChangePassWord       @"7 修改密码"
#define kRequest_UserInFo                 @"9 用户资料"
#define kRequest_AccountCharge            @"10账户充值"
#define KRequest_AccountWithDraw          @"11账户提现"
#define KRequest_AccountMoneyDetail       @"12账户金额详情" 
#define kRequest_getOrdersList              @"13 我的订单列表"
#define kRequest_getCurrentOrderInfo        @"14 当前订单信息"
#define kRequest_getOrderInfo               @"15 查看订单信息"
#define kRequest_evaluateOrder              @"16 订单估价"
#define kRequest_submitOrder                @"17 提交订单"
#define kRequest_cancelOrder                @"18 取消订单"
#define kRequest_repeatOrderList            @"19 续订记录"
#define kRequest_renewOrder                 @"20 续订订单"
#define kRequest_MyTicket                   @"21 我的发票"
#define kRequest_AddTicket                  @"22 申请邮寄发票接口"

#define kRequest_getCommonBranchList        @"23 获取常用网点"
#define kRequest_getBranchListByPosition    @"24 据经纬度获取网点列表"

#define kRequest_selectBranchByCondition    @"26 条件获取网点列表"
#define kRequest_getBranchById              @"27 根据网点id获取网点信息"
#define kRequest_getAreaListByCity          @"28 获取城市区域列表"
#define kRequest_selectCarsByCondition      @"29 条件获取车辆列表"
#define kRequest_getCarPrice                @"30 获取车辆价格"
#define kRequest_selectOrderTimeByCarId     @"31 车辆时间轴"
#define kRequest_getCarInfo                 @"32 获取车辆信息"

#define kRequest_complain                   @"33 用户投诉"

#define kRequest_getImage                   @"获取图片"
#define kRequest_CompanyCarBrand            @"获取公司图标"


#define kGet_carAuthentication              @"get 车辆认证"
#define kGet_carOpenDoor                    @"get 开门"
#define kGet_carCloseDoor                   @"get 关门"
#define kGet_carHonking                     @"get 鸣笛"

#define kRequest_sendCompanyConsult         @"38 提交企业意向订单"

#define kRequest_getMyMessage                 @"41获取我的消息"
#define kRequest_MessageReaded                @"42我的消息-已读"
#define kRequest_deleteMyMessage              @"42我的消息-删除"


#define kRequest_getAdvertisement           @"43 广告图片列表"
#define kRequest_exchangeCoupon             @"44 兑换优惠券"
#define kRequest_getMyCoupon                @"45 我的优惠券"
#define kRequest_getCouponUseRecord         @"46 优惠券使用记录"
#define kRequest_getSuitableCoupon          @"47 获取适用订单优惠券"
#define KRequest_getCouponStatistic         @"47优惠劵使用统计"
#define KRequest_discardCoupon              @"48废弃优惠劵"

#define kRequest_updateOrder                @"50 预估修改订单"
#define kRequest_computeRenew               @"51 预估续订押金"
#define kRequest_getRenewFullInfo           @"52 获取可续订信息"
#define KRequest_getMyAccountMessage        @"53 获取我的账户信息"
#define kRequest_getCarStatus               @"54 获取车辆行驶状态"
#define kRequest_returnCar                  @"55 还车"
#define kRequest_findMyPassWordYZM          @"56 找回密码验证码"
#define kRequest_findMyPassWord             @"57 找回密码"

#define kRequest_createPayNum               @"58 获取订单流水号"
#define KRequest_getEnterpriseList          @"59 查询企业订单列表"
#define kRequest_getCompanyCarTypeList      @"60 根据品牌获取企业可租车系"


#define kRequest_getCompanyCarBrand         @"39 获取所有企业用车品牌"
#define kRequest_sendCompanyConsuit         @"38 提交企业意向订单"
#define kRequest_changeOrder                @"64 修改订单"

#define kRequest_UPPay     @"银联支付"
#define KRequest_checkCode  @"67 找回密码校验验证码"
#define KRequest_sendMyLocation @"71发送我的位置"


@interface BLNetworkManager : FMNetworkManager
{
    NSString *keyStr;
    NSString *TransID;

}
@property(nonatomic,copy)NSString *keyStr;
@property(nonatomic,copy)NSString *TransID;
//解密
- (NSString *)decryptDataWithString:(NSString *)dataStr;
//加密
- (NSString *)encryptDataWithDic:(id)obj;
//相同参数
- (NSMutableDictionary *)dictionaryWithPostParamsSvcCont:(NSString *)SvcCont MSGReq:(NSString *)MSGReq IsSec:(NSString *)IsSec IsZip:(NSString *)IsZip;

+(BOOL)needHeartBeatReq;
+ (BLNetworkManager *)shareInstance;
//版本检测
-(FMNetworkRequest*)checkVersion_currentVersion:(NSString *)version
                                           type:(NSString*)type
                                       delegate:(id)delegate;
//登陆
-(FMNetworkRequest*)loginAction_supervisionLogin:(NSString*)phone
                                        password:(NSString*)password
                                            type:(NSString*)type
                                        delegate:(id)delegate;
//-(FMNetworkRequest*)loginAction_supervisionLogin:(NSString*)phone
//                                        password:(NSString*)password
//                                            type:(NSString*)type
//                                           start:(NSString *)start
//                                             end:(NSString *)end
//                                        delegate:(id)delegate;


//注册
-(FMNetworkRequest*)userRegister:(NSString *)phone
                        password:(NSString *)password
                  identifierCode:(NSString *)idCode
                   telephoneType:(NSString *)iosOrAndroid
                        delegate:(id)delegate;

#pragma mark - 5 短信验证码
- (FMNetworkRequest *)getYZMWithAccount:(NSString *)account
                               delegate:(id)delegate;

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
                                      delegate:(id)delegate;
#pragma mark - 7 修改密码
- (FMNetworkRequest *)changePassWordWithuserId:(NSString *)userId
                                      passWord:(NSString*)passWord
                                   newPassWord:(NSString *)newPassWord
                                      delegate:(id)delegate;
#pragma mark - 9 获取用户资料

- (FMNetworkRequest *)getUserInfoWith:(NSString *)userId
                             delegate:(id)delegate;

//${basePath}/account/recharge
- (FMNetworkRequest *)rechargeWithUid:(NSString *)uid
                               payNum:(NSString *)payNum
                               amount:(NSString *)amount
                        chargeChannel:(NSString *)chargeChannel
                            cardStyle:(NSString *)cardStyle
                             bankName:(NSString *)bankName
                           cardNumber:(NSString *)cardNumber
                               flowId:(NSString *)flowId
                             delegate:(id)delegate;

#pragma mark- 33用户投诉
// ${basePath}/ client/complain
-(FMNetworkRequest *)complain:(NSString *)userName
                     phoneNum:(NSString *)telephone
                 complainType:(NSString *)type
                      content:(NSString *)content
                  contentType:(NSString *)contentType
                     delegate:(id)delegate;

#pragma  mark - 58 获取流水号
// ${basePath}/account/createPayNum
-(FMNetworkRequest *)createPayNum:(NSString *)uid
                            price:(NSString *)price
                          channel:(NSString *)channel
                         delegate:(id)delegate;

#pragma  mark-10账户充值
- (FMNetworkRequest *)getChargeWithAccount:(NSString *)account
                                 chargenum:(NSString *)chargenum
                                    payNum:(NSString *)payNum
                                  delegate:(id)delegate;
;
#pragma mark-11账户提现
- (FMNetworkRequest *)WithDrawByUserId:(NSString *)userId
                             chargenum:(NSString *)chargenum
                                   YZM:(NSString *)YZM
                              delegate:(id)delegate;

#pragma mark - 12 账户金额详情
- (FMNetworkRequest *)getAccountDetailByUserId:(NSString *)userId
                                          type:(NSString *)type
                                      pageSize:(NSString *)pageSize
                                    pageNumber:(NSString *)pageNumber
                                      delegate:(id)delegate;

#pragma mark - 21 我的发票（没有）
- (FMNetworkRequest *)getMyTicketByUserId:(NSString *)userId
                               pageNumber:(NSString *)pageNumber
                                pageSize :(NSString *)pageSize
                                 delegate:(id)delegate;
#pragma mark -22申请邮寄发票接口
- (FMNetworkRequest *)addTicketWithUserId:(NSString *)userId
                                 userName:(NSString *)userName
                                  address:(NSString *)address
                                    phone:(NSString *)phone
                                    title:(NSString *)title price:(NSString *)price
                                  orderId:(NSString *)orderId
                                 delegate:(id)delegate;


#pragma mark - 40获取我的消息
- (FMNetworkRequest *)getMyMessageByPhoneNum:(NSString *)phoneNum
                                        type:(NSString *)type
                                  pageNumber:(NSString *)pageNumber
                                   pageSize :(NSString *)pageSize
                                    delegate:(id)delegate;
//${basePath}/ client/getMyMessage
 //- (FMNetworkRequest *)getMyMessageByPhoneNum:(NSString *)phoneNum
 //                                   delegate:(id)delegate;
#pragma mark - 41我的消息 已读
//- (FMNetworkRequest *)myMessageHasBeenReadWithUserId:(NSString*)userId
//                                            delegate:(id)delegate;
#pragma mark - 42我的消息 删除
- (FMNetworkRequest *)myMessageReadOrDeleteWithMsgId:(NSString*)msgId
                                           msgStatus:(NSString *)status
                                            delegate:(id)delegate ;
#pragma mark-53 获取我的账户信息
- (FMNetworkRequest *)getMyAccountMessageWithUserId:(NSString *)userId delegate:(id)delegate;
#pragma mark - 56找回密码验证码
- (FMNetworkRequest *)getYZMfindMyPassWordWithPhoneNum:(NSString *)phone
                                                  type:(NSString *)type
                                              delegate:(id)delegate;

#pragma mark - 57找回密码
- (FMNetworkRequest *)findMyPassWordWithPhoneNum:(NSString *)phone
                                             YZM:(NSString *)YZM
                                             pwd:(NSString *)pwd
                                        delegate:(id)delegate;
#pragma mark - 67找回密码 校验验证码
- (FMNetworkRequest *)findMyPasswordCheckCode:(NSString *)sms
                                     delegate:(id)delegate;

#pragma mark - 银联
- (FMNetworkRequest *)payWithUid:(NSString *)Uid
                                             money:(NSString *)money
                                        delegate:(id)delegate;

#pragma mark - 个人订单
// 当前订单信息 ${basePath}/ order / orderinfo
-(FMNetworkRequest *)getCurrentOrderInfo:(NSString *)userID
                                delegate:(id)delegate;

// 订单列表  ${basePath}/ order/ orderlist
-(FMNetworkRequest *)getOrdersList:(NSString *)userID
                              Page:(NSString *)page
                              Size:(NSString*)numOfperPage
                          delegate:(id)delegate;

//订单信息 ${basePath}/ order /getOrderInfo
-(FMNetworkRequest *)getOrderInfo:(NSString *)orderID
                         delegate:(id)delegate;


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
                        delegate:(id)delegate;

// 取消订单 ${basePath}/ order /cancelOrder
-(FMNetworkRequest *)cancelOrder:(NSString *)orderID
                         delegate:(id)delegate;

// 续订记录 ${basePath}/ order /repeatOrderList
-(FMNetworkRequest *)repeatOrderList:(NSString *)orderID
                            delegate:(id)delegate;

//续订订单 ${basePath}/ order /renewOrder
-(FMNetworkRequest *)renewOrder:(NSString *)userID
                        orderId:(NSString *)orderID
                      renewTime:(NSString *)renewTime
                      startTime:(NSString *)startTime
                        endTime:(NSString *)endTime
                 mileageDeposit:(NSString *)mileageDeposit
                    timeDeposit:(NSString *)timeDeposit
                        Deposit:(NSString *)deposit
                       delegate:(id)delegate;


// ${basePath}/order/ computeRenew
-(FMNetworkRequest *)computeRenewWithUid:(NSString *)uid
                                   carId:(NSString *)carId
                                duration:(NSString *)duration
                                delegate:(id)delegate;

//${basePath}/order/ getRenewFullInfo
-(FMNetworkRequest *)getRenewFullInfoWithUid:(NSString *)uid
                                       carId:(NSString *)carId
                                    delegate:(id)delegate;

#pragma mark - 分时租车
// ${basePath}/ client/getBranchById
-(FMNetworkRequest *)getBranchById:(NSString *)branchId
                          delegate:(id)delegate;

// 条件选择网点 ${basePath}/ client/selectBranchByCondition
-(FMNetworkRequest *)selectBranchByCondition:(NSString*)brancheName
                                        city:(NSString*)city
                                        area:(NSString*)area
                                  pageNumber:(NSInteger)pageNumber
                                    pageSize:(NSInteger)pageSize
                                    delegate:(id)delegate;

// ${basePath}/client/ getCompanyCarTypeList
-(FMNetworkRequest *)getCompanyCarTypeListWithBrand:(NSString *)brand
                                           delegate:(id)delegate;

// 根据城市/网点获取车辆列表 ${basePath}/ client/selectCarsByCondition
-(FMNetworkRequest *)selectCarsByCondition:(NSString *)city
                                  takeTime:(NSString *)startTime
                                returnTime:(NSString *)endTime
                                     branche:(NSString*)branche
                                      page:(NSInteger)pagenumber
                                  pagesize:(NSInteger)pagesize
                                  delegate:(id)delegate;

// 获取常用网点 ${basePath}/ client/getCommonBranchList
-(FMNetworkRequest *)getCommonBranchList:(NSString*)userID
                              pageNumber:(NSString*)pageNumber
                                pageSize:(NSString*)pageSize
                             brancheType:(NSString*)type
                                delegate:(id)delegate;

// 据经纬度获取网点列表 ${basePath}/ client/getBranchListByPosition
-(FMNetworkRequest *)getBranchListByPosition:(NSString *)longtitude
                                    latitude:(NSString *)latitude
                                  pageNumber:(NSString *)pagenumber
                                    pagesize:(NSString *)pagesize
                                    delegate:(id)delegate;

// 车辆时间轴 ${basePath}/ client/selectOrderTimeByCarId
-(FMNetworkRequest *)selectOrderTimeByCarId:(NSString *)carId
                        delegate:(id)delegate;

//城市区 ${basePath}/ client/getAreaListByCity
-(FMNetworkRequest *)getAreaListByCity:(NSString *)city
                              delegate:(id)delegate;


// 订单估价接口 ${basePath}/ order /evaluateOrder
-(FMNetworkRequest *)evaluateOrderWithCarId:(NSString*)carId
                                  getBranch:(NSString*)getBranch
                               returnBranch:(NSString*)returnBranch
                                      start:(NSString*)startTime
                                         end:(NSString *)endTime
                                   delegate:(id)delegate;


//4  ${basePath}/user/ confirm  上传 实名认证
- (FMNetworkRequest *)upLoadIdentifyCardWithPhoneNum:(NSString *)phoneNum
                                              idCode:(NSString *)idCode
                                                pic1:(UIImage *)pic1
                                            pic1Type:(NSString *)pic1Type
                                                pic2:(UIImage *)pic2
                                            pic2Type:(NSString *)pic2Type
                                                pic3:(UIImage *)pic3
                                            pic3Type:(NSString *)pic3Type
                                            delegate:(id)delegate;
//${basePath}/order/updateOrder
-(FMNetworkRequest *)updateOrder:(NSString *)orderId
                         backNet:(NSString *)backNet
                       startTime:(NSString *)startTime
                         endTime:(NSString *)endtime
                        delegate:(id)delegate;

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
                                    delegate:(id)delegate;

#pragma mark - image
-(FMNetworkRequest *)getImageWithUrl:(NSString *)city
                            delegate:(id)delegate;

#pragma mark - car
// ${basePath}/ client/getCarPrice
-(FMNetworkRequest *)getCarPriceWithCarId:(NSString *)carId
                                     startTime:(NSString *)startTime
                                    delegate:(id)delegate;

// ${basePath}/ client/getCarInfo
-(FMNetworkRequest *)getCarInfo:(NSString *)carId
                       delegate:(id)delegate;

// ${basePath}/car/getCarStatus
-(FMNetworkRequest *)getCarStatus:(NSString *)carId
                          deleage:(id)delegate;

#pragma mark - my car
-(FMNetworkRequest *)getCarAuthenticationWithCarId:(NSString *)carId
                                           orderId:(NSString *)orderId
                                          delegate:(id)delegate;

-(FMNetworkRequest *)openDoorWithCarId:(NSString *)carId
                               orderId:(NSString *)orderId
                              delegate:(id)delegate;

-(FMNetworkRequest *)closeDoorWithCarId:(NSString *)carId
                               orderId:(NSString *)orderId
                              delegate:(id)delegate;

-(FMNetworkRequest *)honkingWithCarId:(NSString *)carId
                               orderId:(NSString *)orderId
                              delegate:(id)delegate;

//${basePath}/account/returnCar
-(FMNetworkRequest *)returnCarWithUid:(NSString *)uid
                              orderId:(NSString *)orderId
                            useCoupon:(BOOL)bUse
                             couponId:(NSString *)couponId
                             delegate:(id)delegate;

#pragma mark - company
// ${basePath}/ client/getCompanyCarBrand
-(FMNetworkRequest *)getCompanyCarBrandWithDelegate:(id)delegate;

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
                                         delegate:(id)delegate;

#pragma mark - coupon
//${basePath}/coupon/getMyCoupon
-(FMNetworkRequest *)getMyCouponWithUserId:(NSString *)userId
                              takeTime:(NSString *)takeTime
                          givebackTime:(NSString *)givebackTime
                                  type:(NSString *)type // 0可用/1无效/2全部
                                  sortType:(NSString *)sortType
                                pageNumber:(NSInteger)pageNumber
                                  pageSize:(NSInteger)pageSize
                              delegate:(id)delegate;

// ${basePath}/coupon/exchangeCoupon
-(FMNetworkRequest *)exchangeCouponWithUserId:(NSString *)userId
                              authcode:(NSString *)authcode
                              delegate:(id)delegate;

//${basePath}/coupon/getCouponUseRecord
-(FMNetworkRequest *)getCouponUseRecordWithUserId:(NSString *)userId
                                  takeTime:(NSString *)takeTime
                              givebackTime:(NSString *)givebackTime
                                  delegate:(id)delegate;

//${basePath}/coupon/getSuitableCoupon
-(FMNetworkRequest *)getSuitableCoupon:(NSString *)orderId
                              delegate:(id)delegate;

#pragma mark - 首页广告
// ${basePath}/ client/getAdvertisement
-(FMNetworkRequest *)getAdvertisement:(NSString *)num
                                type:(NSString *)type//1.pc端首页，2.手机端首页，3长租页，4.注册页
                            delegate:(id)delegate;


//47{basePath}/coupon/getStatistics
- (FMNetworkRequest *)getCouponStatisticsWithUserId:(NSString *)userId
                                           delegate:(id)delegate;
// 48${basePath}/coupon/discardCoupon
- (FMNetworkRequest *)disCardCouponWithUserID:(NSString *)userID
                                       cardNo:(NSString *)cardNo
                                     delegate:(id)delegate;


#pragma mark - 企业租车
//29 根据城市/网点获取车辆列表接口 ${basePath}/ client/selectCarsByCondition
- (FMNetworkRequest *)selectCarsByConditionWithCity:(NSString *)city
                                           BranchId:(NSString *)branchId
                                              Brand:(NSString *)barnd
                                           PageSize:(NSInteger)pagesize
                                            PageNum:(NSInteger)pageNum
                                           delegate:(id)delegate;


//38 提交企业意向订单 ${basePath}/ order /sendCompanyConsult
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
                                          delegate:(id)delegate;
//59 查询企业订单列表
- (FMNetworkRequest *)getCompanyListUserID:(NSString *)userId
                                pageNumber:(NSString *)pageNumber
                                 pageSize :(NSString *)pageSize
                                  delegate:( id )delegate;

//39 获取所有企业用车品牌   ${basePath}/ client/getCompanyCarBrand
- (FMNetworkRequest *)getCompanyCarTypeListWithDelegate:(id)delegate;


//60 根据品牌获取企业可租车系 ${basePath}/client/ getCompanyCarTypeList
- (FMNetworkRequest *)getCompanyCarTypeListByBrand:(NSString *)brand
                                          delegate:(id)delegate;
//71鸣笛 取车  开门前发送我的位置
- (FMNetworkRequest *)sendMyLocationWithLog:(NSString *)Logitute
                                        lat:(NSString *)latitude
                                     cardId:(NSString *)cardId
                                   delegate:(id)delegate;

@end
