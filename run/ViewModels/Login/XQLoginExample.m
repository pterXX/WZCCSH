//
//  XQLoginExample.m
//  proj
//
//  Created by asdasd on 2018/1/11.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "XQLoginExample.h"
#import "XQSetupExample.h"
#import "ShareUtil.h"
#import "RootViewControllerUtil.h"
#import "LoginViewController.h"
#import "UMMobClick/MobClick.h"
#import "CodeModel.h"
#import "JPUSHService.h"


#define XQ_LOGIN_USER_INFO @"XQ_LOGIN_USER_INFO"
#define XQ_LOGIN_USET_PHONE @"XQ_LOGIN_USET_PHONE"
#define XQ_LOGIN_USET_PASSWORD @"XQ_LOGIN_USET_PASSWORD"
#define XQ_LOGIN_USER_CITY @"XQ_LOGIN_USER_CITY"
#define XQ_LOGIN_USER_LATIUDE_AND_LONGITUDE  @"XQ_LOGIN_USER_LATIUDE_AND_LONGITUDE"

#define XQ_LOGIN_USER_CITY_CODE @"XQ_LOGIN_USER_CITY_CODE"

#define XQ_LOGIN_USER_IS_RUN  @"XQ_LOGIN_USER_IS_RUN"
#define XQ_LOGIN_USER_RUN_STATUS  @"XQ_LOGIN_USER_RUN_STATUS"
#define XQ_LOGIN_USER_IS_WORKING  @"XQ_LOGIN_USER_IS_WORKING"

#define XQ_LOGIN_USET_INFO_TOKEN_KEY @"token_key"

@implementation XQLoginExample

static NSString *const CustomErrorDomain = @"cn.cssh.www.runing_man";

#pragma mark Public Methos
+ (instancetype)sharedInstance
{
    static XQLoginExample *loginExample = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginExample = [[XQLoginExample alloc] init];
    });
    return loginExample;
}



//  微信登录
+ (void)weChatLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                          fail:(void(^)(NSError *error))fail
{

    [ShareUtil LoginExampleWithPlatform:SSDKPlatformTypeWechat success:^(SSDKUser *user) {
        XQOauthReq *req = [[XQOauthReq alloc] init];
        req.type = @"2";
        req.openid =  user.uid;
        req.unionid =  user.rawData[@"unionid"];
        req.tx_pic = user.icon;
        req.nickname = user.nickname;
        req.province = user.rawData[@"province"];
        req.city = user.rawData[@"city"];
        req.country = user.rawData[@"country"];
        req.sex = user.rawData[@"sex"];
        [[XQLoginExample sharedInstance] _tryOauthWithReq:req success:success fail:fail];
    } fail:^(NSError *error) {
         fail? fail(error):nil;
    }];
}

//  QQ登录
+ (void)qqLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                      fail:(void(^)(NSError *error))fail
{
    [ShareUtil LoginExampleWithPlatform:SSDKPlatformTypeQQ success:^(SSDKUser *user) {
        XQOauthReq *req = [[XQOauthReq alloc] init];
        req.type = @"1";
        req.openid =  user.uid;
        req.unionid =  user.rawData[@"unionid"];
        req.tx_pic = user.icon;
        req.nickname = user.nickname;
        req.province = user.rawData[@"province"];
        req.city = user.rawData[@"city"];
        req.country = @"中国";
        req.sex = user.rawData[@"sex"];
        [[XQLoginExample sharedInstance] _tryOauthWithReq:req success:success fail:fail];
    }  fail:^(NSError *error) {
        fail? fail(error):nil;
    }];
}

//  新浪登录
+ (void)sinaLoginWithSuccess:(void(^)(NSInteger status, NSString *bind_id))success
                        fail:(void(^)(NSError *error))fail
{
    [ShareUtil LoginExampleWithPlatform:SSDKPlatformTypeSinaWeibo success:^(SSDKUser *user) {
        XQOauthReq *req = [[XQOauthReq alloc] init];
        req.type = @"3";
        req.openid =  user.uid;
        req.unionid =  user.rawData[@"unionid"];
        req.tx_pic = user.icon;
        req.nickname = user.nickname;
        req.province = user.rawData[@"province"];
        req.city = user.rawData[@"city"];
        req.country = @"中国";
        [[XQLoginExample sharedInstance] _tryOauthWithReq:req success:success fail:fail];
    }  fail:^(NSError *error) {
        fail? fail(error):nil;
    }];
}




//  是否已经登录成功
+ (BOOL)exampleIsLogined
{
    if ([self lastUserInfo] && [self login_token].length > 0) {
        return YES;
    }else{
        return NO;
    }
}

//  退出登录
+ (void)exampleLoginOuted
{
    //  清除登录id
    //    [XQLoginExample removelastPhone];
    //    //  清除登录密码
    //    [XQLoginExample removeLastPassword];
    //  清除登录信息
    [XQLoginExample removeLastUserInfo];


    [XQLoginExample removeIs_Run];
    [XQLoginExample removeRunStatus];

    //  取消三方登录的授权
    [ShareUtil cancelAuthorize];
    //  调用清除极光推送的tag值和别名
    [XQSetupExample setCanPush:NO];
    //  调用退出登录的接口
    [[XQLoginExample sharedInstance] _loginOut];
    //  跳转到登录页面
    [XQLoginExample pushMainController];
}


//  获取最后的登录信息
+ (NSDictionary *)lastUserInfo
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:XQ_LOGIN_USER_INFO];
}

//  设置最后登录后信息
+ (void)setLastUserInfo:(NSDictionary *)lastUserInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:lastUserInfo forKey:XQ_LOGIN_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  设置修改后的资料
+ (void)setModifiedUserInfo:(NSDictionary *)modifiedUserInfo
{
    NSMutableDictionary *dict = [self lastUserInfo].mutableCopy;
    if (dict && modifiedUserInfo) {
        for (NSString *key in [modifiedUserInfo allKeys]) {
            if ([dict objectForKey:key]) {
                [dict setObject:modifiedUserInfo[key] forKey:key];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:XQ_LOGIN_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLastUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 最后登录的id
+ (NSString *)lastPhone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:XQ_LOGIN_USET_PHONE];
}

+ (void)setlastPhone:(NSString *)lastPhone
{
    [[NSUserDefaults standardUserDefaults] setObject:lastPhone forKey:XQ_LOGIN_USET_PHONE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removelastPhone
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USET_PHONE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  最后登录的密码
+ (NSString *)lastPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:XQ_LOGIN_USET_PASSWORD];
}

+ (void)setLastPassword:(NSString *)lastPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:XQ_LOGIN_USET_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLastPassword
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USET_PASSWORD];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  最后登录的的城市
+ (NSString *)lastCity
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:XQ_LOGIN_USER_CITY];
}

+ (void)setLastCity:(NSString *)lastCity
{
    [[NSUserDefaults standardUserDefaults] setObject:lastCity forKey:XQ_LOGIN_USER_CITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLastCity
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_CITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  经纬度
+ (NSString *)lastLatitudeAndLongitude
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:XQ_LOGIN_USER_LATIUDE_AND_LONGITUDE];
}

+ (void)setLatitudeAndLongitude:(NSString *)latitudeAndLongitude
{
    [[NSUserDefaults standardUserDefaults] setObject:latitudeAndLongitude forKey:XQ_LOGIN_USER_LATIUDE_AND_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLatitudeAndLongitude
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_LATIUDE_AND_LONGITUDE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  是否是跑腿员
+ (BOOL)lastIs_Run{
    return [[NSUserDefaults standardUserDefaults] stringForKey:XQ_LOGIN_USER_IS_RUN].boolValue;
}

+ (void)setIs_Run:(NSString *)is_RUN
{
    [[NSUserDefaults standardUserDefaults] setObject:is_RUN forKey:XQ_LOGIN_USER_IS_RUN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeIs_Run
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_IS_RUN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//  是否开工状态
+ (BOOL)lastIs_Working{
    return [[NSUserDefaults standardUserDefaults] stringForKey:XQ_LOGIN_USER_IS_WORKING].boolValue;
}

+ (void)setIs_Working:(NSString *)Is_Working
{
    [[NSUserDefaults standardUserDefaults] setObject:Is_Working forKey:XQ_LOGIN_USER_IS_WORKING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeIs_Working{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_IS_WORKING];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  跑腿员审核状态 审核状态 1待审核 2 审核不通过 3 审核通过
+ (NSInteger)lastRunStatus{
    return [[[NSUserDefaults standardUserDefaults] stringForKey:XQ_LOGIN_USER_RUN_STATUS] integerValue];
}

+ (void)setRunStatus:(NSString *)runStatus{
    [[NSUserDefaults standardUserDefaults] setObject:runStatus forKey:XQ_LOGIN_USER_RUN_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeRunStatus{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_RUN_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//  城市编码
+ (NSString *)lastCityCode{
    return [[NSUserDefaults standardUserDefaults] objectForKey:XQ_LOGIN_USER_CITY_CODE];
}

+ (void)setLastCityCode:(NSString *)lastCityCode{
    [[NSUserDefaults standardUserDefaults] setObject:lastCityCode forKey:XQ_LOGIN_USER_CITY_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeLastCityCode{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_LOGIN_USER_CITY_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 登录令牌
+ (NSString *)login_token{
    return [[self lastUserInfo] objectForKey:XQ_LOGIN_USET_INFO_TOKEN_KEY];
}

// 用户ID
+ (NSString *)uid
{
    return [[self lastUserInfo] objectForKey:@"uid"];
}

// 昵称
+ (NSString *)nickname
{
    return [[self lastUserInfo] objectForKey:@"nickname"];
}


+ (void)getlastPhone:(NSString *__autoreleasing *)aUserID lastPassword:(NSString *__autoreleasing *)aPassword
{
    if (aUserID) {
        *aUserID = [self lastPhone];
    }

    if (aPassword) {
        *aPassword = [self lastPassword];
    }
}

+ (void)getLastPosition:(NSString *__autoreleasing *)city latitudeAndlongitude:(NSString *__autoreleasing *)latitudeAndlongitude
{
    if (city)
    {
        *city = [self lastCity];
    }

    if (latitudeAndlongitude) {
        *latitudeAndlongitude =  [self lastLatitudeAndLongitude];
    }
}

#pragma mark - UI Actions

/**
 跳转到指定的根视图

 @param IsFirstLogin 主要用于三方登录后判断是否第一次登录，第一次登录就跳转到完善资料的页面
 */
+ (void)pushMainControllerWithIsFirstLogin:(BOOL)IsFirstLogin
{
    //{
    //    if (IsFirstLogin)
    //    {
    //        PerfectInfoViewController *vc = [PerfectInfoViewController viewControllerWithStoryBoardName:KSMain];
    //        vc.isRegistered = NO;
    //        CustomNavigationViewController *nav = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
    //        [kWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    //    }else{
    //        [self pushMainController];
    //    }
}



/**
 跳转到主页
 */
+ (void)pushMainController
{
    CATransition *tr = [CATransition animation];
    tr.duration = 0.5;
    tr.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    tr.type = kCATransitionFade;
    kWindow.rootViewController = [RootViewControllerUtil isLoginViewController];
    [kWindow.layer addAnimation:tr forKey:@"animation"];
}


+ (RACSignal *)loginServer:(NSString *)phone password:(NSString *)password
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self loginWithPhone:phone password:password].mutableCopy;
        [MLHTTPRequest POSTWithURL:CSSH_USER_LOGIN parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                if (result.errmsg) {
                    [dc setObject:result.errmsg forKey:@"msg"];
                }
                if (result.errcode == 0) {
                    //  保存登录信息
                    [XQLoginExample setLastUserInfo:result.data];
                    [XQLoginExample setlastPhone:phone];
                    [XQLoginExample setLastPassword:password];
                    //  设置极光推送的别名和tag
                    [XQSetupExample setCanPush:YES];;

                    //  跳转到主页
                    [subscriber sendNext:result];
                }else{
                    [subscriber sendNext:result];
                }
                  [subscriber sendCompleted];
            }else{
                [subscriber sendError:[self unknownError:dc]];
            };
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


+ (NSURLSessionTask *)postRunIndex:(MLRequestFailure)failure latitude:(NSString *)latitude longitude:(NSString *)longitude success:(void (^)(void))success {
    return [MLHTTPRequest POSTWithURL:RUN_USER_MIAN_INDEX parameters:@{@"latitude":latitude,@"longitude":longitude} success:^(MLHTTPRequestResult *result) {
        if (result.data) {
            if ([[result.data allKeys] containsObject:@"is_run"]) {
                [XQLoginExample setIs_Run:result.data[@"is_run"]];
                [XQLoginExample setRunStatus:result.data[@"status"]];
                success?success():nil;
            }
        }else{
        }
    } failure:failure isResponseCache:YES];
}

+(void)runMainIndexServerSuccess:(void(^)(void))success failure:(MLRequestFailure)failure{

    NSArray *info = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
    MLLog(@"info %@",info);
    if (info.count == 2) {
        NSString * latitude = info.firstObject;
        NSString * longitude = info.lastObject;
        [self postRunIndex:failure latitude:latitude longitude:longitude success:success];
    }else{
        ///  直到存在经纬度的时候才能获取数据
        [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSArray *info = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
            MLLog(@"info %@",info);
            if (info.count == 2) {
                [subscriber sendNext:info];
                //            [subscriber sendCompleted];
            }else{
                NSLog(@"没有定位经纬度");
                [subscriber sendError:nil];
            }
            return nil;
        }] throttle:2] retry] subscribeNext:^(NSArray *x) {
            NSString * latitude = x.firstObject;
            NSString * longitude = x.lastObject;
            [self postRunIndex:failure latitude:latitude longitude:longitude success:success];
        } error:failure];
    }

}

+ (NSError *)loginError:(NSMutableDictionary *)dc{
    [dc setObject:@"login error" forKey:@"info"];
    NSError *loginError = [NSError errorWithDomain:CustomErrorDomain code:XQRequestErrorCode_LoginError userInfo:dc];
    return loginError;
}

+ (NSError *)unknownError:(NSMutableDictionary *)dc{
    [dc setObject:@"unknown error" forKey:@"info"];
    NSError *unknownError = [NSError errorWithDomain:CustomErrorDomain code:XQRequestErrorCode_UnknownError userInfo:dc];
    return unknownError;
}

+ (NSDictionary *)loginWithPhone:(NSString *)phone password:(NSString *)password
{
    return @{@"mobile":[phone stringByReplacingOccurrencesOfString:@" " withString:@""]?:@"",@"password":[password trim]?:@""};
}

+ (RACSignal *)bindPhoneServerWithPhone:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name bind_id:(NSString *)bind_id{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self checkPasswordWithPhone:phone code:code code_name:code_name].mutableCopy;
        [dc setObject:bind_id?:@"" forKey:@"bind_id"];
        [MLHTTPRequest GETWithURL:CSSH_OTHER_LOGIN_BIND_MOBILE parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
            };
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal *)registerSmsSendServerWithMobile:(NSString *)mobile
{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if ([mobile stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = @"请输入手机号";
            [subscriber sendNext:code];
            [subscriber sendCompleted];
            return nil;
        }
        [self trySmsSendServerWithMobile:mobile from:@"1" success:^(MLHTTPRequestResult *result) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = result.errmsg;
            code.code_name = result.data[@"code_name"];
            if (result.errcode == 0) {
                [subscriber sendNext:code];
            }else if (result.errcode == 4) {
                code.msg = @"当前手机号已注册,请直接登录";
                [subscriber sendNext:code];
            }else{
                [subscriber sendNext:code];
            }
            [subscriber sendCompleted];

        } fail:^(NSError * error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//  绑定手机号
+ (RACSubject *)bindPhoneSmsSendServerWithMoble:(NSString *)mobile{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if ([mobile stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = @"请输入手机号";
            [subscriber sendNext:code];
            [subscriber sendCompleted];
            return nil;
        }

        //  form 4  为绑定手机号
        [self trySmsSendServerWithMobile:mobile from:@"4" success:^(MLHTTPRequestResult *result) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = result.errmsg;
            code.code_name = result.data[@"code_name"];
            if (result.errcode == 0) {
                [subscriber sendNext:code];
            }else if (result.errcode == 4) {
                [subscriber sendNext:code];
            }else{
                [subscriber sendNext:code];
            }
            [subscriber sendCompleted];
        } fail:^(NSError * error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//  忘记密码
+ (RACSubject *)forgotPasswordSmsSendServerWithMoble:(NSString *)mobile{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if ([mobile stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = @"请输入手机号";
            [subscriber sendNext:code];
            [subscriber sendCompleted];
            return nil;
        }

        //  form 3  忘记密码
        [self trySmsSendServerWithMobile:mobile from:@"3" success:^(MLHTTPRequestResult *result) {
            CodeModel *code = [[CodeModel alloc] init];
            code.msg = result.errmsg;
            code.code_name = result.data[@"code_name"];
            if (result.errcode == 0) {
                [subscriber sendNext:code];
            }else if (result.errcode == 4) {
                [subscriber sendNext:code];
            }else{
                [subscriber sendNext:code];
            }
            [subscriber sendCompleted];
        } fail:^(NSError * error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

/**
 发送验证码

 @param mobile 手机号
 @param from 来源（1：注册，9：跑腿员 ），各个用途的验证码都需要传递，如果此文档没有，请联系相关人员添加
 @param success 成功后的回调
 */
+ (void)trySmsSendServerWithMobile:(NSString *)mobile
                              from:(NSString *)from
                           success:(void(^)(MLHTTPRequestResult *result))success
                              fail:(void(^)(NSError *))fail
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dic = @{@"mobile":mobile?:@"",@"type":from?:@"1"};
    [MLHTTPRequest GETWithURL:CSSH_USER_SENDE_CODE parameters:dic success:success failure:fail];
}


/**
 注册

 @param phone 手机号
 @param password 密码
 @param nickname 昵称
 @param code 验证码
 @param code_name 验证码秘钥
 @return 信号量
 */
+ (RACSignal *)registerServer:(NSString *)phone password:(NSString *)password nickname:(NSString *)nickname code:(NSString *)code code_name:(NSString *)code_name{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [XQLoginExample registerWithPhone:phone password:password nickname:nickname code:code code_name:code_name].mutableCopy;
        [MLHTTPRequest GETWithURL:CSSH_USER_REGISTER parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                if (result.errcode == 0) {
                    //  保存登录信息
                    [XQLoginExample setLastUserInfo:result.data];
                    [XQLoginExample setlastPhone:phone];
                    [XQLoginExample setLastPassword:password];
                    //  跳转到主页
                    [subscriber sendNext:@{@"status":@(YES)}];
                }else{
                    [subscriber sendNext:@{@"status":@(NO),@"msg":result.errmsg}];
                }
            }else{
                [subscriber sendNext:nil];
            };
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (NSDictionary *)registerWithPhone:(NSString *)phone password:(NSString *)password nickname:(NSString *)nickname code:(NSString *)code code_name:(NSString *)code_name
{
    return @{@"mobile":[phone stringByReplacingOccurrencesOfString:@" " withString:@""]?:@"",
             @"password":[password trim]?:@"",
             @"nick_name":nickname?:@"",
             @"code_name":code_name?:@"",
             @"code":code?:@""};
}


+ (RACSignal *)checkPasswordServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self checkPasswordWithPhone:phone code:code code_name:code_name].mutableCopy;
        [MLHTTPRequest GETWithURL:CSSH_USER_CHECK_FIND_MOBLIE parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                 [subscriber sendNext:result];
            }else{
                [subscriber sendNext:nil];
            };

            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (NSDictionary *)checkPasswordWithPhone:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name
{
    return @{@"mobile":[phone stringByReplacingOccurrencesOfString:@" " withString:@""]?:@"",
             @"code_name":code_name?:@"",
             @"code":code?:@""};
}

+ (RACSignal *)changePasswordServer:(NSString *)oPass nPass:(NSString *)nPass {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self changePasswordWithOPass:oPass nPass:nPass].mutableCopy;
        [MLHTTPRequest GETWithURL:CSSH_CHANGE_PASSWORD parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[self unknownError:dc]];
            };
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



+ (NSDictionary *)changePasswordWithOPass:(NSString *)oPass nPass:(NSString *)nPass
{
    return @{@"old_password":[oPass stringByReplacingOccurrencesOfString:@" " withString:@""]?:@"",
             @"new_password":[nPass stringByReplacingOccurrencesOfString:@" " withString:@""]?:@""};
}


+ (RACSignal *)findChangePasswordServer:(NSString *)token_key nPass:(NSString *)nPass {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self findPasswordWithToken_key:token_key nPass:nPass].mutableCopy;
        [MLHTTPRequest GETWithURL:CSSH_USER_FIND_PASSWORD parameters:dc success:^(MLHTTPRequestResult *result) {
            if (result) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }else{
                [subscriber sendError:[self unknownError:dc]];
            };
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


+ (NSDictionary *)findPasswordWithToken_key:(NSString *)token_key nPass:(NSString *)nPass
{
    return @{@"token_key":[token_key stringByReplacingOccurrencesOfString:@" " withString:@""]?:@"",
             @"password":[nPass stringByReplacingOccurrencesOfString:@" " withString:@""]?:@""};
}

+ (RACSignal *)checkPhoneServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self checkPasswordWithPhone:phone code:code code_name:code_name].mutableCopy;
        [MLHTTPRequest GETWithURL:RUN_CHECK_MOBLILE parameters:dc success:^(MLHTTPRequestResult *result) {
             [subscriber sendNext:result];
             [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

///  更换手机号
+ (RACSignal *)changePhoneServer:(NSString *)phone code:(NSString *)code code_name:(NSString *)code_name{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSMutableDictionary *dc = [self checkPasswordWithPhone:phone code:code code_name:code_name].mutableCopy;
        [MLHTTPRequest GETWithURL:RUN_CHANGE_MOBLILE parameters:dc success:^(MLHTTPRequestResult *result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}


///  更换手机号
+ (RACSignal *)isWokringServer:(BOOL)is_work{
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MLHTTPRequest GETWithURL:RUN_IS_WORK parameters:@{@"is_work":is_work?@"1":@"0"} success:^(MLHTTPRequestResult *result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}





#pragma mark Private Method

/**
 退出登录
 */
- (void)_loginOut{
    //    [MLHTTPRequest POSTWithURL:ZY_LOGIN_LOGOUT parameters:nil success:^(MLHTTPRequestResult *result) {
    //    } failure:^(NSError *error) {
    //
    //    }];
}

/**
 三方登录

 @param req 发起请求的参数
 @param success 成功后的回调
 @param fail 失败后的回调
 */
- (void)_tryOauthWithReq:(XQOauthReq *)req
                 success:(void(^)(NSInteger status,NSString *bind_id))success
                    fail:(void(^)(NSError *error))fail
{
    [MLNetWorkHelper openLog];
    MLLog(@"[req properties_aps]  %@",[req properties_aps]);
    [MLHTTPRequest POSTWithURL:RUN_USER_OTHER_LOGIN parameters:[req properties_aps] success:^(MLHTTPRequestResult *result) {
        NSString *status = [result.data objectForKey:@"status"];
        //        NSString *token_key = [result.data objectForKey:@"token_key"];
        NSString *bind_id = [result.data objectForKey:@"bind_id"];
        if (status.intValue == 2) {
            success(status.intValue,bind_id);
        }
        else if (status.intValue == 1){

            //NOTE:  统计不同城市app的活跃度,登录情况传用户昵称或账号
            [MobClick profileSignInWithPUID:[XQLoginExample lastCityCode] provider:result.data[@"uid"]];
            //NOTE:  保存用户id 用户tokenkey
            NSMutableDictionary *params = ((NSDictionary *)result.data).mutableCopy;
            [params setObject:[XQLoginExample lastCityCode]?:@"" forKey:@"app_id"];
            [XQLoginExample setLastUserInfo:params];
            success(status.intValue,bind_id);
        }

    } failure:^(NSError *error) {
        fail? fail(error): nil;
    }];
}



//   这里设置的随机账号，到时候需要改成正式账号
- (void)_getVisitorUserID:(NSString *__autoreleasing *)aGetUserID password:(NSString *__autoreleasing *)aGetPassword
{
    if (aGetUserID) {
        *aGetUserID = [NSString stringWithFormat:@"visitor%d", arc4random()%1000+1];
    }

    if (aGetPassword) {
        *aGetPassword = [NSString stringWithFormat:@"taobao1234"];
    }
}
@end


@implementation XQReq
//获取对象的所有属性
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

//Model 到字典
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    NSArray *properties = [self getAllProperties];
    for (NSString *propertyName in properties)
    {
        id propertyValue = [self valueForKey:propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    return props;
}


//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        NSArray *properties = [self getAllProperties];
        for (NSString *strName in properties)
        {
            //进行解档取值
            id value = [decoder decodeObjectForKey:strName];
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *properties = [self getAllProperties];
    for (NSString *strName in properties)
    {
        //利用KVC取值
        id value = [self valueForKey:strName];
        [encoder encodeObject:value forKey:strName];
    }
}


- (NSString *)description
{
    NSString *str =  [NSString string];
    NSArray *properties = [self getAllProperties];
    for (NSString *strName in properties)
    {
        //利用KVC取值
        id value = [self valueForKey:strName];
        str = [NSString stringWithFormat:@"%@\n%@ -- %@",str,strName,value];
    }
    return str;
}

@end

@implementation XQOauthReq




//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

- (NSString *)description
{
    return [super description];
}

@end


@implementation XQProfileReq
//解档
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}

- (NSString *)description
{
    return [super description];
}

@end

