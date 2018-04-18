//
//  XQLoginExample.h
//  proj
//
//  Created by asdasd on 2018/1/11.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeModel.h"

#define XQ_COPY @property (nonatomic ,copy)

@interface XQReq : NSObject <NSCoding>
//Model 到字典
- (NSDictionary *)properties_aps;
@end

@interface XQOauthReq : XQReq <NSCoding>
//**************************同城跑腿页面必传 ******************************
XQ_COPY NSString * type;         //Y1、QQ  2、微信
XQ_COPY NSString * openid;       // Y        openid
XQ_COPY NSString * sex;         //  性别
XQ_COPY NSString * nickname;     //N        昵称
XQ_COPY NSString * tx_pic;   //N        头像地址
XQ_COPY NSString * unionid;      //N        unionid，微信必传
//**************************同城跑腿页面必传 ******************************


XQ_COPY NSString * access_token; //N        access_token
XQ_COPY NSString * country;      //N        国家
XQ_COPY NSString * province;     //N        省份
XQ_COPY NSString * city;         //  城市
@end

@interface XQProfileReq: XQReq <NSCoding>
XQ_COPY NSString * mobile;     //Y        手机号
XQ_COPY NSString * nickname;   //Y        昵称
XQ_COPY NSString * password;   //Y        密码
XQ_COPY NSString * code;       //Y        验证码
@end

@interface XQLoginExample : NSObject
///  获取最后的登录信息
+ (NSDictionary *)lastUserInfo;
+ (void)setLastUserInfo:(NSDictionary *)lastUserInfo;
+ (void)removeLastUserInfo;

//  设置修改后的资料
+ (void)setModifiedUserInfo:(NSDictionary *)modifiedUserInfo;

// 最后登录的id
+ (NSString *)lastPhone;
+ (void)setlastPhone:(NSString *)lastPhone;
+ (void)removelastPhone;

//  最后登录的密码
+ (NSString *)lastPassword;
+ (void)setLastPassword:(NSString *)lastPassword;
+ (void)removeLastPassword;

//  最后登录的的城市
+ (NSString *)lastCity;
+ (void)setLastCity:(NSString *)lastCity;
+ (void)removeLastCity;

//  经纬度
+ (NSString *)lastLatitudeAndLongitude;
+ (void)setLatitudeAndLongitude:(NSString *)latitudeAndLongitude;
+ (void)removeLatitudeAndLongitude;

//  城市编码
+ (NSString *)lastCityCode;
+ (void)setLastCityCode:(NSString *)lastCityCode;
+ (void)removeLastCityCode;

//  是否是跑腿员
+ (BOOL)lastIs_Run;
+ (void)setIs_Run:(NSString *)is_RUN;
+ (void)removeIs_Run;

//  跑腿员审核状态 审核状态 1待审核 2 审核不通过 3 审核通过
+ (NSInteger)lastRunStatus;
+ (void)setRunStatus:(NSString *)runStatus;
+ (void)removeRunStatus;

//  是否开工状态
+ (BOOL)lastIs_Working;
+ (void)setIs_Working:(NSString *)Is_Working;
+ (void)removeIs_Working;


// 登录令牌
+ (NSString *)login_token;

// 用户ID
+ (NSString *)uid;


+ (void)getlastPhone:(NSString *__autoreleasing *)aUserID lastPassword:(NSString *__autoreleasing *)aPassword;

+ (void)getLastPosition:(NSString *__autoreleasing *)city latitudeAndlongitude:(NSString *__autoreleasing *)latitudeAndlongitude;

+ (instancetype)sharedInstance;


/**  微信登录
 */
+ (void)weChatLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                          fail:(void(^)(NSError *error))fail;

/**  QQ登录
  */
+ (void)qqLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                      fail:(void(^)(NSError *error))fail;

/**  新浪登录
  */
+ (void)sinaLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                        fail:(void(^)(NSError *error))fail;



//  是否已经登录成功
+ (BOOL)exampleIsLogined;

//  退出登录
+ (void)exampleLoginOuted;


/**
 跳转到指定的根视图

 @param IsFirstLogin 主要用于三方登录后判断是否第一次登录，第一次登录就跳转到完善资料的页面
 */
+ (void)pushMainControllerWithIsFirstLogin:(BOOL)IsFirstLogin;


/**
 跳转到主页
 */
+ (void)pushMainController;


/**
 登录

 @param phone 手机号
 @param password 密码
 @return 信号量
 */
+ (RACSignal *)loginServer:(NSString *)phone password:(NSString *)password;


/**
 判断是否是跑腿员

 @param success 成功的回调
 @param failure 失败的回调
 */
+(void)runMainIndexServerSuccess:(void(^)(void))success failure:(MLRequestFailure)failure;
/**
 注册

 @param phone 手机号
 @param password 密码
 @param nickname 昵称
 @param code 验证码
 @param code_name 验证码秘钥
 @return 信号量
 */
+ (RACSignal *)registerServer:(NSString *)phone password:(NSString *)password nickname:(NSString *)nickname code:(NSString *)code code_name:(NSString *)code_name;

/**
 Rac  获取注册的验证码

 @param mobile 手机号
 @return 信号量
 */
+ (RACSignal *)registerSmsSendServerWithMobile:(NSString *)mobile;


/**
 Rac  获取绑定的验证码

 @param mobile 手机号
 @return 信号量
 */
+ (RACSubject *)bindPhoneSmsSendServerWithMoble:(NSString *)mobile;

/**
 Rac  获取忘记密码的手机号

 @param mobile 手机号
 @return 信号量
 */
+ (RACSubject *)forgotPasswordSmsSendServerWithMoble:(NSString *)mobile;

/**
 找回密码1

 @param phone 当前的手机号
 @param code 验证码
 @param code_name 验证码秘钥
 @return 信号量
 */
+ (RACSignal *)checkPasswordServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name;


/**
 更换密码

 @param oPass 旧密码
 @param nPass 新密码
 @return 信号量
 */
+ (RACSignal *)changePasswordServer:(NSString *)oPass nPass:(NSString *)nPass;



/**
 忘记密码后修改密码

 @param token_key 修改后的调用凭证
 @param nPass 新密码
 @return 信号量
 */
+ (RACSignal *)findChangePasswordServer:(NSString *)token_key nPass:(NSString *)nPass;


/**
 验证手机号是否注册

 @param phone 手机号
 @param code  验证码
 @param code_name 验证码秘钥
 @return 信号量
 */
+ (RACSignal *)checkPhoneServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name;

/**
 更换手机号

 @param phone 手机号
 @param code  验证码
 @param code_name 验证码秘钥
 @return 信号量
 */
+ (RACSignal *)changePhoneServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name;


/**
 绑定手机号

 @param phone 手机号
 @param code  验证码
 @param code_name 验证码秘钥
 @param bind_id 绑定id
 @return 信号量
 */
+ (RACSignal *)bindPhoneServerWithPhone:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name bind_id:(NSString *)bind_id;

/**
 发送验证码

 @param mobile 手机号
 @param from 来源（1：注册，9：跑腿员 ），各个用途的验证码都需要传递，如果此文档没有，请联系相关人员添加
 @param success 成功后的回调
 */
+ (void)trySmsSendServerWithMobile:(NSString *)mobile
                              from:(NSString *)from
                           success:(void(^)(MLHTTPRequestResult *result))success
                              fail:(void(^)(NSError *))fail;


/**
 开工收工

 @param is_work 1 开工 0 收工
 @return 信号量
 */
+ (RACSignal *)isWokringServer:(BOOL)is_work;

+ (NSError *)loginError:(NSMutableDictionary *)dc;

+ (NSError *)unknownError:(NSMutableDictionary *)dc;
@end


