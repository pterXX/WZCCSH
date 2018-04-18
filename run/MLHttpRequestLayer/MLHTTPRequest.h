//
//  MLHTTPRequest.h
//  HuiBao
//
//  Created by 玛丽 on 2017/11/22.
//  Copyright © 2017年 玛丽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLNetWorkHelper.h"
@class MLHTTPRequestResult;
/**
 请求成功的block
 */
typedef void(^MLRequestSuccess)(MLHTTPRequestResult *result);
/**
 请求失败的block
 */
typedef void(^MLRequestFailure)(NSError *error);


@interface MLHTTPRequestResult : NSObject
@property (assign, nonatomic) NSInteger errcode;
@property (assign, nonatomic) NSString  *errmsg;
@property (assign, nonatomic) id        data;
@property (assign, nonatomic) id        json;
- (id)objectForKey:(NSString *)key;
- (id)initWithJSON:(id)json;
@end


@interface MLHTTPRequest : NSObject

+(NSString *)getUUID;
#pragma mark - 登陆退出
/** 登录*/
/*
+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
 */
/** 退出*/
/*
 + (NSURLSessionTask *)getExitWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
 */



/*
 配置好MLNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用MLNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 以下是无缓存的公共方法,可自己再定制有缓存的
 */
+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure isResponseCache:(BOOL)isResponseCache;
+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure isResponseCache:(BOOL)isResponseCache;

+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(MLRequestSuccess)responseCache success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(MLRequestSuccess)responseCache success:(MLRequestSuccess)success failure:(MLRequestFailure)failure;

/**
 上传图片

 @param imageArray 图片数组
 @param progress 加载进度的回调
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void )uploadImageArray:(NSArray<UIImage *> *)imageArray
                 progress:(void (^)(NSProgress *progress,UIImage *image))progress
                  success:(void (^)(NSArray *urls,NSArray *imgs))success
                  failure:(MLRequestFailure)failure;

/**
 下载文件
 
 @param url 下载链接
 @param fileDir 保存在缓存目录下
 @param progressBlock 下载进度
 @param success 成功后的回调
 @param failure 失败的回调
 */
+ (void)downFileWithUrl:(NSString *)url
                filrDir:(NSString *)fileDir
               progress:(void (^)(NSProgress *progress))progressBlock
                success:(void (^)(NSString *filePath))success
                failure:(MLRequestFailure)failure;
@end
