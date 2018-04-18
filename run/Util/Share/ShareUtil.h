//
//  ShareUtil.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

typedef void (^Callback)(void);
@interface ShareUtil : NSObject
/**
 *  构造分享
 *
 *  @param image    图片路径
 *  @param title        标题
 *  @param url          链接
 *  @param description  描述
 *  @param sharetypeNum 类型
 *  @param onSuccess    成功回调
 */
+(void)shareShowWithImage:(id )image title:(NSString *)title url:(NSString *)url description:(NSString *)description sharetypeNum:(SSDKPlatformType)sharetypeNum onSuccess:(Callback)onSuccess;

/**
 视频分享

 @param url 视频的本地链接
 @param title 标题
 @param text 描述
 @param sharetypeNum 分享的平台
 @param onSuccess 成功的回调
 */
+(void)shareShowWithVideoFileUrl:(id)url title:(NSString *)title text:(NSString *)text sharetypeNum:(NSInteger)sharetypeNum onSuccess:(Callback)onSuccess;

/**
 *  注册分享
 */
+ (void)resigterShareSDK;

+ (void)LoginExampleWithPlatform:(SSDKPlatformType)platform
                         success:(void(^)(SSDKUser *user))success
                            fail:(void(^)(NSError *error))fail;


/**
 全部取消授权，只用退出登录时使用
 */
+ (void)cancelAuthorize;
@end
