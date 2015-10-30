//
//  ConstString.h
//  SAR
//
//  Created by 徐守卫 on 14-9-9.
//  Copyright (c) 2014年 sibida. All rights reserved.
//

#ifndef SAR_ConstString_h
#define SAR_ConstString_h


#import "language.h"
// for test
#define STR_TEST                        [language getLocalString:@"test"]
#define STR_LABEL_STRING                [language getLocalString:@"labelString"]


// to add app's string
#define STR_PULLDOWN_RELOAD                  [language getLocalString:@"pulldownreload"]// = "下拉重新加载数据";
#define STR_RELEASE_RELOAD                   [language getLocalString:@"releasetoreload"]// = "释放重新加载数据";
#define STR_LOADING                          [language getLocalString:@"loading"]// = "加载中...";
#define STR_PULLUP_LOADMORE                  [language getLocalString:@"pulluploadmore"]// = "上拉加载更多数据";
#define STR_RELEASE_LOADMORE                 [language getLocalString:@"releaseloadmore"]// = "释放加载更多数据";
#define STR_REQUEST_FAILED                  [language getLocalString:@"requestFailed"]// = "获取数据失败";

// alert
#define STR_OK                  [language getLocalString:@"ok"]// = "确定";
#define STR_CANCEL                  [language getLocalString:@"cancel"]// = "取消";
#define STR_BACK                  [language getLocalString:@"back"]// = "返回";
#define STR_PLEASE_WAIT                 [language getLocalString:@"pleaseWait"] // "请稍等"
#define STR_NETWORK_ERROR               [language getLocalString:@"networkError"]// = "网络连接失败";
// 首页
#define STR_HOME_TITLE                  [language getLocalString:@"HomeTitle"]
#define STR_PERSONAL_RENTAL             [language getLocalString:@"PersonalRental"]
#define STR_COMPANY_RENTAL              [language getLocalString:@"CompanyRental"]
#define STR_BRANCHES                    [language getLocalString:@"branches"]
#define STR_MY_INFO                     [language getLocalString:@"MyInfo"]
#define STR_MY_CAR                      [language getLocalString:@"MyCar"]
#define STR_PERSON_TIP                  [language getLocalString:@"PersonTip"]
#define STR_MYCAR_TIP                   [language getLocalString:@"MyCarTip"]
#define STR_PUSH_NOTIFICATION           [language getLocalString:@"PushNotification"]
#define STR_NOTIFICATION_TIP            [language getLocalString:@"NotificationTip"]
#define STR_DONOT_ALLOW                 [language getLocalString:@"DonotAllow"]
#define STR_PREFERENTIAL                [language getLocalString:@"preferential"]
#define STR_ENTER_PREFERENTIAL          [language getLocalString:@"enterPreferential"]// = "输入兑换码，不区分大小写";
#define STR_EXCHANGE_CODE_PROMPT        [language getLocalString:@"exchangeCodeError"]// = "兑换码不存在，请检查";
#define STR_CONVERT                     [language getLocalString:@"convert"]// = "兑换";
#define STR_GET_PREFERENTIAL            [language getLocalString:@"getPreferential"]// = "恭喜您，获得\"%@\"一张";
#define STR_MY_PREFERENTIAL             [language getLocalString:@"myPreferential"]// = "我的优惠券";
#define STR_TO_KNOW_PREFERENTIAL        [language getLocalString:@"toKnowPreferential"]// = "了解优惠券";
#define STR_FOND_NEW_VERSION            [language getLocalString:@"fondNewVersion"]// = "发现新版本";
#define STR_JUST_A_MOMENT               [language getLocalString:@"justamoment"]// = "稍后再说";
#define STR_UPDATE_VERSION              [language getLocalString:@"updateNow"]// = "立即更新";
#define STR_VERSIONS                    [language getLocalString:@"versions"]// = "软件版本";
#define STR_SOFTWARE_SIZE               [language getLocalString:@"swSize"]// = "软件大小";
#define STR_UPDATE_CONTENT              [language getLocalString:@"updateContent"]// = "更新内容";
#define STR_NETWORK_DONOT_WORK          [language getLocalString:@"networkdonotwork"]// = "网络不给力点击重试";
#define STR_AD                          [language getLocalString:@"ad"]// = "活动";
#define STR_EMPTY_CODE                  [language getLocalString:@"convertCodeEmpty"]// = "兑换码不能为空";
//快捷菜单
#define STR_HOMEPAGE                    [language getLocalString:@"HomePage"]// = "首页";
//"" = "分时租车"; //PersonalRental
//"" = "企业租车"; //CompanyRental
//"" = "个人中心"; // myCenter
//"" = "我的订单"; // myOrder
#define STR_HELPER                      [language getLocalString:@"helper"]// = "帮助中心";
#define STR_SERVICE_TEL                 [language getLocalString:@"serviceTel"]// = "400-8288-517";
// 登录
#define STR_ACCOUNT                     [language getLocalString:@"account"]// = "账号";
#define STR_PASSWORD                    [language getLocalString:@"password"]// = "密码";
#define STR_ENTER_PASSWORD              [language getLocalString:@"enterPassword"]// = "请输入密码";
#define STR_ENTER_PHONE_NUM             [language getLocalString:@"enterPhoneNum"]// = "请输入手机号";
#define STR_FORGET_PASSWORD             [language getLocalString:@"forgetPassword"]// = "忘记密码";
#define STR_REGISTER                    [language getLocalString:@"register"]// = "注册";
#define STR_VIP_LOGIN                   [language getLocalString:@"VIPLogin"]// = "会员登录";
#define STR_LOGIN                       [language getLocalString:@"Login"]// = "登录";
#define STR_REALNAME_AUDIT              [language getLocalString:@"RealNameAudit"]// = "实名认证资料审核中";
#define STR_NO_CERTIFICATION            [language getLocalString:@"noCertification"]// = "您还未进行实名认证，请先完成实名认证。";
#define STR_TO_COMPELETE_REALNAME       [language getLocalString:@"toCompeleteRealName"]// = "进行实名认证";
#define STR_REAL_NAME_FAILED            [language getLocalString:@"realNameFailed"]// = "实名认证失败，请先完成实名认证。";
#define STR_HAVE_MORE_RESERVED          [language getLocalString:@"haveMoreReserved"]// = "您已预订车辆，无法再次预订";
#define STR_HAVE_RESERVED_PERIOD        [language getLocalString:@"haveReservedPeriod"]// = "当前时间段内有其他用户已预订";
#define STR_NEED_SELECTTIME_AGAIN       [language getLocalString:@"needSelectTimeAgain"]// = "还车时间需大于取车时间，请重新选择";
#define STR_LESS_THAN_1HOUR             [language getLocalString:@"lessThan1hour"]// = "租期不得小于1小时";
#define STR_CHECK_CURRENT_TIME          [language getLocalString:@"checkCurrentTime"]// = "请注意当前时间";
#define STR_CHECK_CUR_WITH_START_TIME            [language getLocalString:@"checkCurrentTimeWithStartTime"]//订单开始时间不能早于当前时间
// 优惠券
#define STR_SELECT_COUPON                   [language getLocalString:@"selectCoupon"] // "选择优惠券"
#define STR_DESCRIPTION                 [language getLocalString:@"description"] // "描述"
#define STR_COUPON_NAME                 [language getLocalString:@"couponName"]// = "优惠券名称:";
#define STR_COUPON_ID                 [language getLocalString:@"couponId"]// = "券号:";
#define STR_COUPON_TYPE                 [language getLocalString:@"couponType"]// = "优惠券类型:";
#define STR_COUPON_VALID                 [language getLocalString:@"validDate"]// = "使用有效期:";
#define STR_COUPON_SCOPE                 [language getLocalString:@"usingScope"]// = "使用范围":;
#define STR_COUPON_CARMODE                 [language getLocalString:@"usingCarMode"]// = "使用车型:";
#define STR_COUPON_LEFTNUM                 [language getLocalString:@"leftNum"]// = "剩余可用次数:";
// 分时租车
#define STR_NANJING                     [language getLocalString:@"Nanjing"]
#define STR_PERSONAL_INFO1              [language getLocalString:@"personalInfo1"]
#define STR_PERSONAL_INFO2              [language getLocalString:@"personalInfo2"]
#define STR_TAKE_INFO                   [language getLocalString:@"takeinfo"]
#define STR_GIVEBACK_INFO               [language getLocalString:@"giveBackInfo"]
#define STR_TO_SELECT_CAR               [language getLocalString:@"toSelectCare"]
#define STR_TAKE_CAR_TIME               [language getLocalString:@"takeCarTime"]
#define STR_GIVE_BACK_TIME              [language getLocalString:@"giveBackTime"]
#define STR_NETWORK                     [language getLocalString:@"network"]
#define STR_RENTED                     [language getLocalString:@"rented"]// = "已租";
#define STR_IDLE                        [language getLocalString:@"idle"]// = "未租";
#define STR_NEED_MORE_CASH              [language getLocalString:@"needMoreCash"]// = "当前账户可用余额不足,请先进行充值";
#define STR_YUAN_PERHOUER               [language getLocalString:@"yuanPerHour"]// = "元/时";
#define STR_YUAN_PERDAY                 [language getLocalString:@"yuanPerDay"]// = "元/天";
#define STR_PRICE_FORMAT                [language getLocalString:@"price"]// = "%@元";
#define STR_PER_HOUR                    [language getLocalString:@"perHour"]// = "/时";
#define STR_PER_DAY                     [language getLocalString:@"perDay"]// = "/天";
#define STR_WRITE_AGAIN                 [language getLocalString:@"writeagain"]// = "重新填写";
#define STR_NORESULT_FORSEARCHING       [language getLocalString:@"noResultsForSearching"]// = "未搜索到相关结果";
#define STR_HAVE_RENTED                 [language getLocalString:@"haveRented"]// = "您已预订车辆，无法再次预订";
#define STR_TAKE_GIVEBACK_CAR          [language getLocalString:@"takegivebackCar"]// = "取还车";
#define STR_NEED_SEL_TIME               [language getLocalString:@"needselTime"]// = "请选择取车/还车时间";
#define STR_TODAY                       [language getLocalString:@"today"]// = "今天";
#define STR_TOMMORROW                   [language getLocalString:@"tommorrow"]// = "明天";
#define STR_AFTER_TOMMORROW             [language getLocalString:@"TheDayAfterTomorrow"]// = "后天";
// 选择车型
#define STR_SELECT_BRANCHES             [language getLocalString:@"selectBranches"]
#define STR_NO_RESULT                   [language getLocalString:@"noResult"]
#define STR_SEL_CONDITION               [language getLocalString:@"selectCondition"]
#define STR_ALL_CAR_MODEL               [language getLocalString:@"allCarModel"]
#define STR_TO_RENT                     [language getLocalString:@"toRentCar"]
// 我的车辆
#define STR_HONKING                     [language getLocalString:@"honking"]
#define STR_OPEN_DOOR                   [language getLocalString:@"opendoor"]
#define STR_CLOSE_DOOR                  [language getLocalString:@"closedoor"]
#define STR_GIVEBACK_CAR                [language getLocalString:@"givebackcar"]
#define STR_NOCAR_FORSELECTING          [language getLocalString:@"noCarForSelecting"]
#define STR_SELECT_CAR                  [language getLocalString:@"selectcar"]
#define STR_TAKE_BRANCHES               [language getLocalString:@"takeBranches"]
#define STR_GIVEBACK_BRANCHES               [language getLocalString:@"givebackBranches"]
#define STR_NO_ORDER                    [language getLocalString:@"noOrder"]// = "您当前还没有即将开始的订单";
#define STR_CANNOT_GOT_POSITION         [language getLocalString:@"cannotGotPosition"]// = "无法定位当前位置";
#define STR_NOCAR_NOGIVEBACK            [language getLocalString:@"noCarNoGiveback"]// = "还车失败，您还未取车";
#define STR_DRIVING_OPENFAILED          [language getLocalString:@"drivingOpenFailed"]// = "车辆行驶中，开门失败";
#define STR_DRIVING_CLOSEFAILED         [language getLocalString:@"drivingCloseFailed"]// = "车辆行驶中，锁门失败";
#define STR_GIVEBACK_FAILED             [language getLocalString:@"givebackFailed"]// = "还车失败";
#define STR_GIVEBACK_SUCCESS            [language getLocalString:@"givebackSuccess"]// = "还车成功";
#define STR_NETWORK_DONOTWORK           [language getLocalString:@"networkDonotWork"]// = "网络异常，请稍后重试";
//#define STR_CACULATING                  [language getLocalString:@"caculting"]// = "亲，我们正在卖力的计算费用...";
#define STR_CONGRATULATION              [language getLocalString:@"congratulation"]// = "恭喜您，还车成功！";
#define STR_DROVE_TIME                  [language getLocalString:@"drovetime"]// = "行驶时长";
#define STR_DROVE_HHMM                  [language getLocalString:@"droveHHMM"]// = "%@小时%@分";
#define STR_DROVE_HH                    [language getLocalString:@"hour"]// = "%@ 小时";
#define STR_TIME_PRICE_FORMAT           [language getLocalString:@"timePrice"]// = "元/小时";
#define STR_KILO_PRICE_FROMAT           [language getLocalString:@"kiloPrice"]// = "元/公里";
#define STR_DROVE_KILO                  [language getLocalString:@"drovemileage"]// = "行驶里程";
#define STR_KILO_FORMAT                 [language getLocalString:@"kiloFomat"]// = "%@公里";
#define STR_SEVENTDAY_PROMPT            [language getLocalString:@"sevendayprompt"]// = "提示：7天内会结算代缴违章费及车损金（若有违章费未交或车辆维修费用）！";
#define STR_RENTAL_AGAIN                [language getLocalString:@"rentalagain"]// = "继续订车";
#define STR_TO_HOME                     [language getLocalString:@"tohome"]// = "回首页";
#define STR_BALANCE_FORPREPAY           [language getLocalString:@"balanceforprepay"]// = "预付款余额";
#define STR_NEED_RECHARGE               [language getLocalString:@"needrecharge"]// = "待支付";
// 网点
#define STR_NEAR_BRANCHES               [language getLocalString:@"nearBranches"]// = "附近网点";
#define STR_USED_BRANCHES               [language getLocalString:@"usedBranches"]// = "常用网点";
#define STR_MAP                 [language getLocalString:@"map"]// = "地图";
// 订单
#define STR_ORDER               [language getLocalString:@"order"]
#define STR_PRICE_DETAILS       [language getLocalString:@"priceDetails"]// = "价格详情";
#define STR_CAR_PRICE_DECLARE   [language getLocalString:@"carPriceDeclare"]// = "车辆价格说明";
#define STR_PREPAY_DETAILS      [language getLocalString:@"prePayDetails"]// = "预付款=时长费+里程费+调度费+押金";
#define STR_WORKINGDAY_PRICE    [language getLocalString:@"workingdayPrice"]// = "工作日   (%.2f元/天)";
#define STR_WEEKEND_PRICE       [language getLocalString:@"weekendPrice"]// = "双休日   (%.2f元/天)";
#define STR_HOLIDAY_PRICE       [language getLocalString:@"holidayPrice"]// = "节假日   (%@-%@)(%.2f元/天)";
#define STR_PERIOD_OF_TIME      [language getLocalString:@"PeriodOfTime"]// = "时段";
#define STR_ORIGINAL_PRICE      [language getLocalString:@"originalPrice"]// = "原价";
#define STR_PROMOTION_PRICE     [language getLocalString:@"promotionPrice"]// = "促销价";
#define STR_MILEAGE_PRICE       [language getLocalString:@"mileagePrice"]// = "里程费（含燃油费）";
#define STR_SCHEDULING_PRICE    [language getLocalString:@"schedulingPrice"]// = "调度费（异地还车）";
#define STR_DEPOSIT             [language getLocalString:@"deposit"]// = "押金（事故、违章）";

#define STR_FORCAST_DURATION            [language getLocalString:@"forcastDurationCost"]// = "预估时长费";
#define STR_FORCAST_MILEAGE             [language getLocalString:@"forcastMileageCost"]// = "预估里程费";
#define STR_FORCAST_SCHEDULING          [language getLocalString:@"forcastSchedulingCost"]// = "异地调度费";
#define STR_SUBMIT_ORDER                [language getLocalString:@"submitOrder"]// = "提交订单";
#define STR_COST_DETAILS                [language getLocalString:@"costDetails"]// = "费用明细";
#define STR_SUBMIT_SUCCESS              [language getLocalString:@"submitSuccess"]// 提交成功
#define STR_NOT_GOT_ORDER               [language getLocalString:@"notGotOrder"]// = "您还没有订单";
#define STR_MORE_THAN_3DAYS               [language getLocalString:@"morethan3days"]// = "只可选择3天内的订单";
// 我的订单
#define STR_MY_ORDER            [language getLocalString:@"myOrder"]
#define STR_CURRENT_ORDER       [language getLocalString:@"currentOder"]
#define STR_MY_ORDERS           [language getLocalString:@"myOrders"]
#define STR_ORDER_ID            [language getLocalString:@"orderID"]
#define STR_ORDER_TIME          [language getLocalString:@"orderTime"]
#define STR_ORDER_STATUS        [language getLocalString:@"orderStatus"]
#define STR_ORDER_RENEW_TIME                    [language getLocalString:@"orderRenewTime"]
#define STR_ORDER_UNSUBSCRIBE_TIME              [language getLocalString:@"orderUnsubscribeTime"]
#define STR_ORDER_PAYED_TIME                    [language getLocalString:@"orderPayedTime"] // 结算时间
#define STR_ORDER_PREPAY        [language getLocalString:@"prePayed"]
#define STR_ORDER_CONSUME       [language getLocalString:@"consume"]
#define STR_ORDER_UNSUBSCRIBE       [language getLocalString:@"orderUnsubscribe"]// = "退订";
#define STR_CONFIRM_UNSUBSCRIBE       [language getLocalString:@"confirmUnsubscribe"]// = "确认退订";
#define STR_ORDER_MODIFY        [language getLocalString:@"orderModify"]// = "修改";
#define STR_ORDER_RENEW         [language getLocalString:@"orderRenew"]// = "续订";
#define STR_REQUEST_TICKET         [language getLocalString:@"requestTicket"]// = "申请开票";
#define STR_RENT_AGAIN          [language getLocalString:@"rentAgain"]// = "再订一次";
#define STR_CONFIRM_ORDER       [language getLocalString:@"confirmOrder"]// = "确认订单";
#define STR_ORDER_MODIFY_TITLE              [language getLocalString:@"orderModifyTitle"]// = "修改订单";
#define STR_ORDER_CONTINUE_TITLE            [language getLocalString:@"orderContinueTitle"]// = "续订订单";
#define STR_AHEAD_OF_TAKETIME               [language getLocalString:@"aheadOfTakeTime"]// = "取车时间只可提前";
#define STR_BEHIND_OF_GIVEBACK              [language getLocalString:@"behindOfGiveback"]// = "还车时间只可延后";
#define STR_GO_ON_MOST_TIME                 [language getLocalString:@"goonMostTime"]// = "最多可续订时间";
#define STR_GO_ON_TIME                      [language getLocalString:@"goonTime"]// = "续订时长";
#define STR_GO_ON_DEPOSIT                   [language getLocalString:@"goonDeposit"]// = "续订押金";
#define STR_AVAILABLE_BALANCE               [language getLocalString:@"availableBalance"]// = "可用金额";
#define STR_ORDER_GIVEBACK_TIME             [language getLocalString:@"orderGiveBackTime"]// = "订单还车时间";
#define STR_CONFIRM_MODIFY                  [language getLocalString:@"confirmModify"]// = "确认修改";
#define STR_CONFIRM_GO_ON                      [language getLocalString:@"confirmGoOn"]// = "确认续订";

#define STR_RENEW_RECORD                            [language getLocalString:@"renewRecord"]// = "续订记录";
#define STR_RENEW_DATETIME                          [language getLocalString:@"renewDateTime"]// = "续订时间";
#define STR_UNSUB_PROMPT                [language getLocalString:@"unsubPrompt"]// = "订单开始前半小时内不可退订，若有特殊情况可电联客服400-8288-517。";
#define STR_CONFIRM_UNSUB_INFO          [language getLocalString:@"confirmUnsubInfo"]// = "是否确认退订该订单？";
#define STR_UNSUB_SUCCESS               [language getLocalString:@"unsubscribeSuccess"]// = "退订成功";

#define STR_TOTAL_COST                  [language getLocalString:@"totalCost"]// = "消费  %@元";
#define STR_COST_FORMAT                 [language getLocalString:@"costFormat"]// = "%@ 元";
#define STR_ORDER_DETAILS               [language getLocalString:@"orderDetails"]// = "订单详情";
#define STR_PREPAY_COST                 [language getLocalString:@"prepayCost"]// = "预付款  %@元";
// 修改订单
#define STR_MODIFY_PROMPT               [language getLocalString:@"modifyPrompt"]// = "订单开始前半小时内不可修改，若有特殊情况可电联客服400-8288-517。";
#define STR_TO_RECHARGE                 [language getLocalString:@"toRecharge"]// = "前往充值";
#define STR_RECHARGE_CONFIRM            [language getLocalString:@"rechargeConfirm"]// = "修改订单需额外支付预付款%.2f元，当前可用余额为%.2f元，请先前往充值";
#define STR_MODIFY_CONFIRM_INFO         [language getLocalString:@"modifyConfirm"]// = "修改订单需额外支付%.2f元，当前账户可用余额为%.2f元，是否确认修改？";
#define STR_MODIFY_SUCCESS              [language getLocalString:@"modifySuccess"]// = "修改成功";
// 续订
#define STR_RENEW_TO_RECHARGE_CONFIRM    [language getLocalString:@"renewToRechargeConfirm"]// = "当前可用余额:%.2f元，可用余额不足，请前往充值";
#define STR_RENEW_SUCCESS                [language getLocalString:@"renewSuccess"]// = "续订成功";
#define STR_RENEW_GIVEBACK_TIME          [language getLocalString:@"orderRenewGivebackTime"]// = "订单还车时间为:";
#define STR_RENEW_TIME_ZERO               [language getLocalString:@"renewTimeZero"]// = "续时为0";

// 订单状态
#define STR_ORDER_STATUS_UNSUBSCRIBE       [language getLocalString:@"orderStatusUnsubscribe"]//"已退订";
#define STR_ORDER_STATUS_FINISHED           [language getLocalString:@"orderStatusFinished"]//"订金结算完成";
#define STR_ORDER_STATUS_NORMAL             [language getLocalString:@"orderStatusNormal"]// = "待结算";
#define STR_ORDER_STATUS_PAYED              [language getLocalString:@"orderStatusPayed"]// = "租金已结算";
#define STR_ORDER_STATUS_RENEW              [language getLocalString:@"orderStatusRenew"]// = "已续订";
#define STR_ORDER_STATUS_DELAY              [language getLocalString:@"orderStatusDelay"]// = "已延时";

#define STR_DURATION_CONSUMPTION                [language getLocalString:@"durationConsumption"]// = "时长费";
#define STR_MILEAGE_CONSUMPTION                 [language getLocalString:@"mileageConsumption"]// = "里程费";
#define STR_SCHEDULING_CONSUMPTION              [language getLocalString:@"schedulingConsumption"]// = "调度费";
#define STR_DELAY_CONSUMPTION               [language getLocalString:@"delayConsumption"]// = "延时费";
#define STR_DAMAGE_COST                     [language getLocalString:@"damageCost"]// = "车损金";
#define STR_ILLEGAL_COST                    [language getLocalString:@"illegalCost"]// = "违章金";
#define STR_COUPON_DEDUCTION                [language getLocalString:@"couponDeduction"]// = "优惠券抵扣";
#define STR_AMOUNT                          [language getLocalString:@"amount"]// = "共计消费";
#define STR_TOTAL_HOURS                     [language getLocalString:@"totalHours"]// = "共%d小时";
#define STR_TOTAL_MILOMETER                 [language getLocalString:@"totalKilometers"]// = "共%d公里";
// 申请开票
#define STR_TICKET_INFO              [language getLocalString:@"ticketInfo"]// = "发票信息";
#define STR_TICKET_HEAD              [language getLocalString:@"ticketHead"]// = "发票抬头";
#define STR_TICKET_ENTER_HEAD              [language getLocalString:@"enterTicketHead"]// = "请输入发票抬头";
#define STR_TICKET_ADDRESS                  [language getLocalString:@"ticketAdrdess"]// = "收票地址";
#define STR_TICKET_ENTER_ADDRESS              [language getLocalString:@"enterTicketAddress"]// = "请输入具体地址";
#define STR_ORDER_INFO                      [language getLocalString:@"oderInfo"]// = "订单信息";
#define STR_TICKET_NOTE                     [language getLocalString:@"ticketNote"]// = "开票须知：";
#define STR_TICKET_NOTE1              [language getLocalString:@"Note1"]// = "1.状态为“结算完成”的订单可申请开票；";
#define STR_TICKET_NOTE2              [language getLocalString:@"Note2"]// = "2.目前无法开具增值税发票；";
#define STR_TICKET_NOTE3              [language getLocalString:@"Note3"]// = "3.每张订单只能申请开票一次；（由于用户自身填写错误信息造成的发票无效，无法再次申请开票）";
#define STR_ORDER_COST                      [language getLocalString:@"cost"]// = "消费金额";
// 确认还车
#define STR_COUPON                          [language getLocalString:@"coupon"]// = "券";
#define STR_COMFIRM_GIVEBACK                [language getLocalString:@"confirmGiveBack"]// = "确认还车";
#define STR_SEL_AND_COMFIRM_GIVEBACK                [language getLocalString:@"selAndConfirmGiveBack"]// = "选择并确认还车";
#define STR_USE                             [language getLocalString:@"use"]// = "用";
#define STR_NOT_USE                         [language getLocalString:@"notuse"]// = "不用";
#define STR_GIVEBACK_PROMPT                 [language getLocalString:@"givebackPrompt"]// = "小提示:";
#define STR_GIVEBACK_PROMPT1              [language getLocalString:@"givebackPrompt1"]// = "1.还车至订单目的地网点";
#define STR_GIVEBACK_PROMPT2              [language getLocalString:@"givebackPrompt2"]// = "2.请拿好自己的行李物品，并熄火关好车门窗";
#define STR_GIVEBACK_PROMPT3              [language getLocalString:@"givebackPrompt3"]// = "3.还车后，系统会计算本次用车费用，7天后结算押金费用";
#define STR_GIVEBACK_PROMPT4              [language getLocalString:@"givebackPrompt4"]// = "4.发现您有可用的优惠券，是否使用?";

#define STR_CACULATING                      [language getLocalString:@"caculting"]// = "亲，我们正在卖力的计算费用...";
#define STR_TOTAL_PREPAY                      [language getLocalString:@"totalprepay"]// = "总预付款";
#define STR_TOTAL_COSTS                      [language getLocalString:@"totalcosts"]// = "总消费";
#define STR_ORDER_DURATION                      [language getLocalString:@"orderduration"]// = "订单时长";
#define STR_DELAY_TIME                      [language getLocalString:@"delayTime"]// = "延时";
#define STR_LAST_PAYED                      [language getLocalString:@"lastPayed"]// = "最终扣款";
#define STR_CANNOT_TAKECAR                      [language getLocalString:@"cannottakecar"]// = "订单开始前5分钟可使用车辆";
#define STR_NETWORK_RETRY                      [language getLocalString:@"pleaseRetry"]// = "网络异常，请重试";

// 企业租车
#define STR_ENTERPRISE_SUBMITSUCCESS        [language getLocalString:@"enterpriseSubmitSuccess"]// = "意向提交成功";
#define STR_ENTERPRISE_CONTACT              [language getLocalString:@"enterpriseContact"]// = "客户经理会在1天内联系您";
#define STR_ENTERPRISE_RENTMORE              [language getLocalString:@"enterpriseRentMore"]// = "继续选车";
#define STR_ENTERPRISE_TOHOME              [language getLocalString:@"enterpriseToHome"]// = "返回首页";
#define STR_BISNESS_INTRODUCTION              [language getLocalString:@"businessIntroduction"]// = "业务介绍";
#define STR_MORE_CAR_PROMPT              [language getLocalString:@"moreCarPrompt"]// = "没有您满意或者喜欢的车型? 马上联系客服400-8288-517, 重新选定心仪车型哦!";

// 优惠券
#define STR_SORT_BY_DEFAULT              [language getLocalString:@"bydefaultSort"]// = "默认排序";
#define STR_SORT_BY_TIMEOVER             [language getLocalString:@"bytimeover"]// = "即将过期";
#define STR_SORT_BY_STYLE               [language getLocalString:@"byStyle"]// = "按类型";
#define STR_DURATION_COUPON               [language getLocalString:@"durationCoupon"]// = "时长费抵用券";//1 时长费抵用券
#define STR_MILEAGE_COUPON               [language getLocalString:@"mileageCoupon"]// = "里程费抵用券";//2 里程费抵用券
#define STR_ALL_COUPON               [language getLocalString:@"allCoupon"]// = "时长里程抵用券";//3 时长里程抵用券
#define STR_CASH_COUPON               [language getLocalString:@"cashCoupon"]// = "现金券";//4 现金券
#define STR_PLEASE_SELECT_COUPON    [language getLocalString:@"pleaseSelectCoupon"]// = "请选择优惠券";
// 周边网点


// 个人中心
#define STR_MYCENTER                [language getLocalString:@"myCenter"]
#define STR_MYCENTER_INFO           [language getLocalString:@"myCenter_info"]
#define STR_MYCENTER_ACCOUNT        [language getLocalString:@"myCenter_account"]
#define STR_MYCENTER_CHARGE         [language getLocalString:@"myCenter_charge"]
#define STR_MYCENTER_WITHDRAW       [language getLocalString:@"myCenter_withdraw"]
#define STR_MYCENTER_DETAIL         [language getLocalString:@"myCenter_detail"]
#define STR_SETTLEMENT              [language getLocalString:@"settlement"]// = "费用结算";
#define STR_INSTRUCTIONS            [language getLocalString:@"instructionsForCar"]// = "车辆使用";

#endif
