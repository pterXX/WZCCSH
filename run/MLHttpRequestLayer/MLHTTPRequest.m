//
//  MLHTTPRequest.m
//  HuiBao
//
//  Created by 玛丽 on 2017/11/22.
//  Copyright © 2017年 玛丽. All rights reserved.
//

#import "MLHTTPRequest.h"
#import "OpenUDID.h"
#import "XQLoginExample.h"
#import "KeyChainStore.h"
@implementation MLHTTPRequestResult

- (id)initWithJSON:(id)json
{
    self = [super init];
    if (self) {
        NSDictionary *dicJson = [json isKindOfClass:[NSDictionary class]]?json:[self returnDictionaryWithData:json];
        self.errcode    = [[dicJson objectForKey:@"errcode"] integerValue];
        self.errmsg     = [dicJson objectForKey:@"errmsg"];
        self.data    = [dicJson objectForKey:@"data"];
        self.json    = dicJson;
        MLLog(@"json %@",dicJson);
    }
    return self;
}

- (id)objectForKey:(NSString *)key
{
    return [self.json objectForKey:key];
}


// NSData转dictonary
-(NSDictionary*)returnDictionaryWithData:(NSData*)data
{
    if (data == nil) {
        return @{};
    }
    NSDictionary* myDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return myDictionary;
}

@end

@implementation MLHTTPRequest
///** 登录*/
//+ (NSURLSessionTask *)getLoginWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
//{
//    return [self requestWithURL:MLString(@"smb/w_v_l_v2") parameters:parameters success:success failure:failure];
//}
///** 退出*/
//+ (NSURLSessionTask *)getExitWithParameters:(id)parameters success:(MLRequestSuccess)success failure:(MLRequestFailure)failure
//{
//    return [self requestWithURL:MLString(@"smb/w_g_v_c") parameters:parameters success:success failure:failure];
//}

#define KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
+(NSString *)getUUID
{
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];

    //首次执行该方法时，uuid为空

    if ([strUUID isEqualToString:@""] || !strUUID)
    {

        //生成一个uuid的方法

        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);

        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));

        //将该uuid保存到keychain

        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];

    }
    return strUUID;
}


+ (NSString *)dpi
{
    CGRect screen = [[UIScreen mainScreen]bounds];
    return [NSString stringWithFormat:@"%d*%d",(int)screen.size.width,(int)screen.size.height];
}

+ (NSString *)time
{
    return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSString *) getJoinRequestURL:(NSString *)requestURL param:(NSDictionary *)param
{
    NSMutableString *requestUrl = [[NSMutableString alloc] init];
    [requestUrl appendString:requestURL];
    if (param!=nil) {
        NSEnumerator * enumeratorKey = [param keyEnumerator];
        NSRange foundObj=[requestURL rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        BOOL isfirst = foundObj.length == 0;
        for (NSString *key in enumeratorKey) {
            NSString *value = [param objectForKey:key];
            if (isfirst) {
                [requestUrl appendFormat:@"?%@=%@", key, value, nil];
                isfirst = NO;
            }else{
                [requestUrl appendFormat:@"&%@=%@", key, value, nil];
            }
        }
    }
    return requestUrl;
}


#pragma mark - 请求的公共方法
+ (NSString *)setRequestHeader:(NSString *)url isReponseCache:(BOOL)isReponseCache{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[UIDevice appCurVersion] forKey:@"app_ver"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(KWIDTH)] forKey:@"screen_w"];
    [dict setObject:[NSString stringWithFormat:@"%@",@(KHEIGHT)] forKey:@"screen_h"];
    [dict setObject:@"ios" forKey:@"sys"];
    [dict setObject:[UIDevice phoneVersion] forKey:@"ver"];
    [dict setObject:@"appstore" forKey:@"expand"];
    [dict setObject:[self dpi] forKey:@"dpi"];
    [dict setObject:[OpenUDID value] forKey:@"imei"];
    [dict setObject:[MLNetWorkHelper isWiFiNetwork]?@"1":@"2" forKey:@"is_wifi"];
    if ([XQLoginExample lastCityCode]) {
        [dict setObject:[XQLoginExample lastCityCode] forKey:@"app_id"];
    }
    if ([XQLoginExample exampleIsLogined])
    {
        //  如果登录了就传登录信息
        [dict setObject:[XQLoginExample login_token] forKey:@"token_key"];
        [dict setObject:[XQLoginExample uid] forKey:@"uid"];
    }

    if ([XQLoginExample lastCityCode]) {
        // 存在位置信息
        [dict setObject:[NSString stringWithFormat:@"%@",[XQLoginExample lastCityCode]] forKey:@"app_id"];
    }

    NSString * uuid= [self getUUID];
    if (uuid && uuid.length > 0) {
        [dict setObject:uuid forKey:@"uuid"];
    }

    //  是否加载缓存,不加载缓存就使用经纬度
    if (isReponseCache == NO) {
        NSString *lastLatitudeAndLongitude = [XQLoginExample lastLatitudeAndLongitude];
        if (lastLatitudeAndLongitude)
        {
            NSArray *arr = [lastLatitudeAndLongitude componentsSeparatedByString:@","];
            [dict setObject:[NSString stringWithFormat:@"%@",arr.firstObject] forKey:@"latitude"];
            [dict setObject:[NSString stringWithFormat:@"%@",arr.lastObject] forKey:@"longitude"];
        }
    }


   return [self getJoinRequestURL:url param:dict];
}

+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure isResponseCache:(BOOL)isResponseCache {

    // 发起请求
    return [self POSTWithURL:URL parameters:parameter responseCache:isResponseCache?success:nil success:success failure:failure];
}


/*
 配置好MLNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用MLNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 以下是无缓存的公共方法,可自己再定制有缓存的
 */
+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {
    // 发起请求
    return [self POSTWithURL:URL parameters:parameter responseCache:nil success:success failure:failure];
}

/*
 配置好MLNetworkHelper各项请求参数,封装成一个公共方法,给以上方法调用,
 相比在项目中单个分散的使用MLNetworkHelper/其他网络框架请求,可大大降低耦合度,方便维护
 在项目的后期, 你可以在公共请求方法内任意更换其他的网络请求工具,切换成本小
 以下是无缓存的公共方法,可自己再定制有缓存的
 */
+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {
    
    // 发起请求
    return [self GETWithURL:URL parameters:parameter responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)POSTWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(MLRequestSuccess)responseCache success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {

    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数
    [MLNetWorkHelper setRequestTimeoutInterval:8.0];
    [MLNetWorkHelper openNetworkActivityIndicator:YES];
    [MLNetWorkHelper setRequestSerializer:MLRequestSerializerHTTP];
    [MLNetWorkHelper setResponseSerializer:MLResponseSerializerHTTP];
    //  判断是否包含地址
    if ([URL containsString:@"http"])
    {
        
    }else{
        URL = [NSString stringWithFormat:@"%@",RUN_MLString(URL)];
    }
    URL = [self setRequestHeader:URL isReponseCache:responseCache != nil];

    // 发起请求
    return [MLNetWorkHelper POST:URL parameters:parameter responseCache:^(id responseObject) {
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        if ([XQLoginExample exampleIsLogined]){
            if (responseObject) {
                  responseCache ? responseCache([[MLHTTPRequestResult alloc] initWithJSON:responseObject]):nil;
            }
        }

    } success:^(id responseObject) {
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        MLHTTPRequestResult *result = [[MLHTTPRequestResult alloc] initWithJSON:responseObject];
//        if (result.code == 300) {
//            ML_SHOW_MESSAGE(result.msg);
//            ///  需要登录
//            [XQLoginExample exampleLoginOuted];
//        }else{
            success? success(result):nil;
//        }

    } failure:^(NSError *error) {
        [self parseError:error];
        // 同上
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        failure(error);
    }];
}

+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter success:(MLRequestSuccess)success failure:(MLRequestFailure)failure isResponseCache:(BOOL)isResponseCache {

    // 发起请求
    return [self GETWithURL:URL parameters:parameter responseCache:isResponseCache?success:nil success:success failure:failure];
}

+ (NSURLSessionTask *)GETWithURL:(NSString *)URL parameters:(NSDictionary *)parameter responseCache:(MLRequestSuccess)responseCache success:(MLRequestSuccess)success failure:(MLRequestFailure)failure {
    
    // 在请求之前你可以统一配置你请求的相关参数 ,设置请求头, 请求参数的格式, 返回数据的格式....这样你就不需要每次请求都要设置一遍相关参数


    [MLNetWorkHelper setRequestTimeoutInterval:8.0];
    [MLNetWorkHelper openNetworkActivityIndicator:YES];
    [MLNetWorkHelper setRequestSerializer:MLRequestSerializerHTTP];
    [MLNetWorkHelper setResponseSerializer:MLResponseSerializerHTTP];
    [MLNetWorkHelper openLog];
    //  判断是否包含地址
    if ([URL containsString:@"http"])
    {
        
    }else{
        URL = [NSString stringWithFormat:@"%@",RUN_MLString(URL)];
    }
    URL = [self setRequestHeader:URL isReponseCache:responseCache != nil];

    // 发起请求
    return [MLNetWorkHelper GET:URL parameters:parameter responseCache:^(id responseObject) {
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        if ([XQLoginExample exampleIsLogined]){
             if (responseObject) {
            responseCache ? responseCache([[MLHTTPRequestResult alloc] initWithJSON:responseObject]):nil;
             }
        }
    } success:^(id responseObject) {
        //请求的头部信息；（我们执行网络请求的时候给服务器发送的包头信息）
       
        // 在这里你可以根据项目自定义其他一些重复操作,比如加载页面时候的等待效果, 提醒弹窗....
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        MLHTTPRequestResult *result = [[MLHTTPRequestResult alloc] initWithJSON:responseObject];
//        if (result.code == 300) {
//            ML_SHOW_MESSAGE(result.msg);
//            ///  需要登录
//            [XQLoginExample exampleLoginOuted];
//        }else{
            success? success(result):nil;
//        }
    } failure:^(NSError *error) {
        // 同上
        [MLNetWorkHelper openNetworkActivityIndicator:NO];
        [self parseError:error];
        failure(error);
    }];
}

/**
 上传图片

 @param imageArray 图片数组
 @param progressBlock 加载进度的回调
 @param success 成功的回调
 @param failure 失败的回调
 */
+ (void )uploadImageArray:(NSArray<UIImage *> *)imageArray
                              progress:(void (^)(NSProgress *progress,UIImage *image))progressBlock
                               success:(void (^)(NSArray *urls,NSArray *imgs))success
                               failure:(MLRequestFailure)failure{
    [MLNetWorkHelper openNetworkActivityIndicator:YES];
//    [self setRequestHeader];

    NSMutableArray *temArray = [NSMutableArray array];
    NSMutableArray *temImgArray = [NSMutableArray array];
     for (NSInteger i = 0; i < imageArray.count; i ++) {
        [MLNetWorkHelper uploadImagesWithURL:CSSH_UPLOAD_IMG
                                  parameters:nil name:@"image"
                                      images:@[imageArray[i]]
                                   fileNames:nil
                                  imageScale:0.5
                                   imageType:@"png"
                                    progress:^(NSProgress *progress) {

                                    } success:^(id responseObject) {
                                        MLHTTPRequestResult *result = [[MLHTTPRequestResult alloc] initWithJSON:responseObject];
                                        if (result.errcode == 0) {
                                            ML_SHOW_MESSAGE(@"上传完成");
                                            NSString *url = result.data[@"src"];
                                            if (url) {
                                                [temArray addObject:url];
                                                [temImgArray addObject:imageArray[i]];
                                                //当所有图片上传成功后再将结果进行回调
                                                if (temArray.count == imageArray.count) {
                                                    success(temArray,temImgArray);
                                                    [MLNetWorkHelper openNetworkActivityIndicator:NO];
                                                }
                                            }else{
                                                //  预读
                                                success(temArray,temImgArray);
                                            }
                                        }
                                    } failure:^(NSError *error) {
                                        // 同上
                                        [MLNetWorkHelper openNetworkActivityIndicator:NO];
//                                        [self parseError:error];
                                        failure(error);
                                    }];
    }
}



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
                failure:(MLRequestFailure)failure{
    NSString *urlStr =  [url containsString:@"http"]?url:RUN_MLString(url);
    [MLNetWorkHelper downloadWithURL:urlStr fileDir:fileDir progress:progressBlock success:success failure:failure];
}

+ (void)parseError:(NSError *)error{
#ifdef DEBUG
    NSData * data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    if (data)
    {
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        TGWebViewController *web = [[TGWebViewController alloc] init];
        web.attributeStr = str;
        web.webTitle = @"服务器的错误原因";
        web.progressColor = COLOR_MAIN;
        [([UIApplication sharedApplication].keyWindow.rootViewController) showViewController:web sender:nil];
    }
#else
#endif
}



@end
