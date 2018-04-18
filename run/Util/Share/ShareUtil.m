//
//  ShareUtil.m
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "ShareUtil.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"


@implementation ShareUtil
+ (SSDKPlatformType)sharePlatformType:(SSDKPlatformType)sharetypeNum {
    SSDKPlatformType shareTypef = 0 ;
    switch (sharetypeNum) {
        case 0:
            shareTypef = SSDKPlatformSubTypeWechatSession;
            break;
        case 1:
            shareTypef = SSDKPlatformSubTypeWechatTimeline;
            break;
        case 2:
            shareTypef = SSDKPlatformSubTypeQQFriend;
            break;
        case 3:
            shareTypef = SSDKPlatformSubTypeQZone;
            break;
        case 4:
            shareTypef = SSDKPlatformTypeSinaWeibo;
            break;
        default:
            break;
    }
    return shareTypef;
}

///  分享
+ (void)share:(Callback)onSuccess shareParams:(NSMutableDictionary *)shareParams shareTypef:(SSDKPlatformType)shareTypef {
    [ShareSDK share:shareTypef //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:{
                 [MessageToast showMessage:@"分享成功"];
                 onSuccess();
             }
                 break;
             case SSDKResponseStateFail:{
                 [MessageToast showMessage:@"分享失败"];
                 MLLog(@"sahre error:%@",error);
             }
                 break;
             default:
                 break;
         }

     }];
}

/**
  *  构造普通分享
  *
  *  @param image    图片路径
  *  @param title        标题
  *  @param url          链接
  *  @param description  描述
  *  @param sharetypeNum 类型
  *  @param onSuccess    成功回调
  */
+(void)shareShowWithImage:(id )image title:(NSString *)title  url:(NSString *)url description:(NSString *)description sharetypeNum:(SSDKPlatformType)sharetypeNum onSuccess:(Callback)onSuccess
{
    SSDKPlatformType shareTypef = [self sharePlatformType:sharetypeNum];
    

    id imgArr = [NSArray array];
    if (!image) {
        imgArr = nil;
    }else{
        if ([image isKindOfClass:[NSArray class]]) {
            imgArr = image;
        }else{
           imgArr = @[image];
        }
    }
    
    NSURL *SHAREURL = nil;
    if (url != nil) {
        SHAREURL =  [NSURL URLWithString:url];
    }
  
    SSDKContentType contentType = SSDKContentTypeAuto;
    
    if ((image)  && (title == nil || description == nil || url == nil) && shareTypef == SSDKPlatformSubTypeQZone) {
        //  防止SSDKContentTypeAuto QQ 空间不能支持纯图片分享
        contentType = SSDKContentTypeImage;
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];


        //创建分享参数
        [shareParams SSDKSetupShareParamsByText:description
                                         images:imgArr//传入要分享的图片
                                            url:SHAREURL
                                          title:title
                                           type:contentType];

    //进行分享
    [self share:onSuccess shareParams:shareParams shareTypef:shareTypef];
}



/**
 视频分享

 @param url 视频的本地链接
 @param title 标题
 @param text 描述
 @param sharetypeNum 分享的平台
 @param onSuccess 成功的回调
 */
+(void)shareShowWithVideoFileUrl:(id )url title:(NSString *)title text:(NSString *)text sharetypeNum:(NSInteger)sharetypeNum onSuccess:(Callback)onSuccess
{
    SSDKPlatformType shareTypef = [self sharePlatformType:sharetypeNum];

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    if (shareTypef == SSDKPlatformSubTypeWechatSession || shareTypef == SSDKPlatformSubTypeWechatTimeline) {
        [shareParams SSDKSetupWeChatParamsByText:text
                                           title:title
                                             url:nil
                                      thumbImage:[UIImage imageNamed:@"icon-40"]
                                           image:[UIImage imageNamed:@"icon-40"]
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                             sourceFileExtension:[url pathExtension]
                                  sourceFileData:url
                                            type:SSDKContentTypeFile
                              forPlatformSubType:shareTypef];

    }else{
        [shareParams SSDKSetupQQParamsByText:text
                                       title:title
                                         url:nil
                               audioFlashURL:nil
                               videoFlashURL:url
                                  thumbImage:[UIImage imageNamed:@"icon-40"] images:[UIImage imageNamed:@"icon-40"] type:SSDKContentTypeVideo forPlatformSubType:shareTypef];

        [shareParams SSDKSetupInstagramByVideo:url];
    }


    //进行分享
    [self share:onSuccess shareParams:shareParams shareTypef:shareTypef];
}


+ (void)resigterShareSDK {
    /**
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */

    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType){
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformSubTypeWechatTimeline:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }

    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType)
        {
            case SSDKPlatformTypeSinaWeibo:
                //                [appInfo SSDKSetupSinaWeiboByAppKey:@"1531116115"
                //                                          appSecret:@"1253f77cfa9c613c85961c325e857c93"
                //                                        redirectUri:@"http://www.cssh.cn/main/anli"
                //                                           authType:SSDKAuthTypeWeb];

                break;
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WeChat_APPKEY
                                      appSecret:WeChat_Secret];
                break;
            case SSDKPlatformSubTypeWechatTimeline:
                [appInfo SSDKSetupWeChatByAppId:WeChat_APPKEY
                                      appSecret:WeChat_Secret];
                break;

            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:Tencent_APPKEY
                                     appKey:Tencent_Secret
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}


+ (void)LoginExampleWithPlatform:(SSDKPlatformType)platform
                         success:(void(^)(SSDKUser *user))success
                            fail:(void(^)(NSError *error))fail{
    //  先取消授权
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    [ShareSDK getUserInfo:platform onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
         if (state == SSDKResponseStateSuccess)
         {
             success?success(user):nil;
         }else
         {
             if(fail){
                 fail(error);
             }
         }
     }];
}


/**
 全部取消授权，只用退出登录时使用
 */
+ (void)cancelAuthorize{
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
}


@end
