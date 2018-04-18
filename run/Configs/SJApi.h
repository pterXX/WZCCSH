///
///  SJApi.h
///  proj
///
///  Created by asdasd on 2017/9/25.
///  Copyright © 2017年 asdasd. All rights reserved.
///

#ifndef SJApi_h
#define SJApi_h


///  友盟
#define UM_APPKEY          @"5abda5eeb27b0a309800005d"
///  环信
//#define EM_APPKEY          @"1130160929178154#jinancitylife"
//////  openInstall
///#define OPENINSTALL_APPKEY @"aofc0p"
///  极光
#define JG_APPKEY          @"03b4dbc26b394bf73b3feba7"

///  社会化分享组件appkey
#define ShareSDK_APPKEY    @"1612a7f28f0fb"
///  微信
#define WeChat_APPKEY      @"wxea4be5683b0db302"
#define WeChat_Secret      @"d45a7570b4e661f63b67c716464b44c8"

///  腾讯
#define Tencent_APPKEY     @"1106794946"
#define Tencent_Secret     @"FYL4Es8eZZlYjkvc"
///
//////  百度sdk
#define BaiDuMapAppKey     @"7OFzBHAQciYnqrDOjX0wfPhLGsGLzcXQ"

//////  支付宝
///#define AP_AppScheme       @"alisdkCity"
///#define AP_AppId           @"2017090708598230"

#define APP_URlSchema      @"runingMan"
#define APPStrore_ID       @""



//  1 代表线上 其他值表示线下
#define IS_Release 2
#if IS_Release == 1
#define POST_API   @"http://api.cssh.cn";  //  线上
#define H5_URL     @"http://h5.cssh.cn"      //线上的

#else

#define POST_API   @"http://cssh_api.yinkuan.net"  //  线下
#define H5_URL     @"http://test.yinkuan.net"      //线下的

#endif

/**
 CSSH 开头的接口为城市生活的过渡接口
 CDT 开头的接口为产地通的过渡接口
 RUN 开头的接口为同城跑腿的过渡接口
 */

#define CSSH_SERVER_PATH [NSString stringWithFormat:@"%@/1",POST_API]
#define CDT_SERVER_PATH [NSString stringWithFormat:@"%@/2",POST_API]
#define RUN_SERVER_PATH [NSString stringWithFormat:@"%@/3",POST_API]


#define CSSH_MLString(aPATH) [NSString stringWithFormat:@"%@/%@",CSSH_SERVER_PATH,aPATH]
#define CDT_MLString(aPATH) [NSString stringWithFormat:@"%@/%@",RUN_SERVER_PATH,aPATH]
#define RUN_MLString(aPATH) [NSString stringWithFormat:@"%@/%@",RUN_SERVER_PATH,aPATH]


///  合作协议
#define RUN_AGREEMENT [NSString stringWithFormat:@"%@/run/agreement-cssh_shop_title_color_e",H5_URL]
///  关于我们
#define RUN_ABOUDT [NSString stringWithFormat:@"%@/run/about",H5_URL]

///  跑腿-首页 001
#define RUN_MAIN_INDEX @"main/index"

/// 跑腿-注册跑腿员 002
#define RUN_MAIN_REGISTER @"main/register"

///  跑腿订单 003
#define RUN_ORDER_LIST @"order/OrderList"

///  订单详情页  004
#define RUN_ORDER_ORDER_INFO @"order/OrderInfo"

///  抢单详情页  005
#define RUN_ORDER_GRAB_ORDER @"order/GrabOrder"
///  修改订单状态     006
//#define RUN_ORDER_EDITSTATUS @"order/Editstatus" //   城市生活跑腿员的接口
#define RUN_ORDER_EDITSTATUS  @"runordermsg/Editstatus"

///  生成呼叫跑腿订单  007
#define RUN_ORDER_CREATE_ORDER @"order/creatorder"

///  确认发布页面    009
#define RUN_ORDER_SUREPUB @"order/surepub"

/// 添加地址        010
#define RUN_ORDER_ADDRESS @"order/Address"

/// 呼叫跑腿页面的数据 011
#define RUN_ORDEER_CALL_PAGE @"order/callpage"

/// 呼叫跑腿计算金钱 012
#define RUN_ORDER_CALL_GET_MONEY @"order/getmoney"

///  计算跑腿金钱基础配置 013
#define RUN_ORDER_CONFIG @"order/config"

///  三方登录
#define RUN_USER_OTHER_LOGIN @"users/otherLogin"

///  登录 019
#define CSSH_USER_LOGIN CSSH_MLString(@"user/login")

///  注册 020
#define CSSH_USER_REGISTER CSSH_MLString(@"user/register")

///  找回密码 021
#define CSSH_USER_CHECK_FIND_MOBLIE CSSH_MLString(@"user/checkFindMobile")
///  找回密码 022
#define CSSH_USER_FIND_PASSWORD CSSH_MLString(@"user/findPassword")

//修改密码
#define CSSH_CHANGE_PASSWORD  CSSH_MLString(@"user/editPassword")

///  发送验证码 024
#define CSSH_USER_SENDE_CODE CSSH_MLString(@"user/sendCode")

/// 跑腿员独立app首页
#define RUN_USER_MIAN_INDEX @"main/userindex"


///  获取已开通城市的app_id
#define CSSH_GET_CITY_APP CSSH_MLString(@"allcity/getuseapp")

///  城市生活合并--通过gps判断城市开通
#define CSSH_GET_LOC_CITY_APP CSSH_MLString(@"allcity/getlocalapp")

///  第三方登录-绑定
#define CSSH_OTHER_LOGIN_BIND_MOBILE CSSH_MLString(@"user/otherLoginBind")
///  获取用户信息
#define CSSH_GET_USER_INFO CSSH_MLString(@"user/getpersonal")

///  修改用户信息
#define CSSH_CHANGE_USER_INFO CSSH_MLString(@"user/editDetails")

///  上传图片
#define CSSH_UPLOAD_IMG CSSH_MLString(@"upload/image")

///  跑腿员-验证手机号
#define RUN_CHECK_MOBLILE @"user/checkFindMobile"

///  更换手机号码
#define RUN_CHANGE_MOBLILE @"user/changemobile"

///  提现首页
#define RUN_TIXIAN_INDEX @"withdraw/balance"

///  获取账户信息
#define CSSH_USER_ACCOUNT_INFO CSSH_MLString(@"user/getUserInfo")

///  微信绑定
#define RUN_BIND_WECHAT @"withdraw/binduseropenid"

///  申请提现
#define RUN_GET_APPLY_WITHDRAWALS @"withdraw/applycash"

///  绑定支付宝
#define CSSH_BIND_ALIPAY CSSH_MLString(@"user/editZfb")

///  产地通_提现首页
#define CDT_TIXIAN_INDEX CDT_MLString(@"withdraw/index")

///  跑腿员-订单消息列表
#define RUN_MSG_LIST @"msg/OrderMsgList"


///  跑腿员-跑腿员-订单消息详情
#define RUN_MSG_INFO @"msg/OrderMsgInfo"

///  跑腿员 开工收工
#define RUN_IS_WORK @"user/Work"

///  跑腿员-未读消息数量 
#define RUN_MESSAGE_COUNT @"msg/Msgcount"

///  跑腿员个人中心解绑与绑定
#define RUN_BANGDDING @"msg/bangorunbang"

#define RUN_TIXIAN_RECORD @"withdraw/UserIndex"
#endif /* SJApi_h */
