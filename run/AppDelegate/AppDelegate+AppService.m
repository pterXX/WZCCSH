//
//  AppDelegate+AppService.m
//  proj
//
//  Created by asdasd on 2017/9/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "xq_NewEditionTestManager.h"
#import "PushNotifyManager.h"
#import "UpgradeView.h"
#import "XQSetupExample.h"
#import "OnlyLocationManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ShortcutItemManage.h"
@implementation AppDelegate (AppService)


/**
 初始化话百度地图
 */
- (void)registerBaiDuMap{
    self.mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:BaiDuMapAppKey  generalDelegate:nil];
    if (!ret) {
        MLLog(@"manager start failed!");
    }
}

/**
 升级弹窗
 */
- (void)showNewEditionTestManager
{
//     [xq_NewEditionTestManager checkNewEditionWithAppID:APPStrore_ID ctrl:kWindow.rootViewController]; //1种用法，系统Alert
    [xq_NewEditionTestManager checkNewEditionWithAppID:APPStrore_ID CustomAlert:^(xq_AppStoreInfoModel *appInfo) {
        [UpgradeView show:appInfo.version info:appInfo.releaseNotes trackViewUrl:appInfo.trackViewUrl];
    }];
}
#ifdef EM_DEPRECATED_IOS
#else
//- (YWIMKit *)ywIMKit
//{
//
//}
#endif

- (void)regiesterIM{
#ifdef EM_DEPRECATED_IOS

#else

#endif
}



/**
 注册友盟
 */
- (void)regiesterUM
{
    UMConfigInstance.appKey = UM_APPKEY;
    UMConfigInstance.channelId = nil;
    UMConfigInstance.eSType = E_UM_NORMAL; //仅适用于游戏场景，应用统计不用设置
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}


/**
 注册极光
 */
- (void)regiesterJPUSH:(NSDictionary *)launchOptions{
    JPUSHRegisterEntity *entiy = [[JPUSHRegisterEntity alloc] init];
    entiy.types = JPAuthorizationOptionAlert |JPAuthorizationOptionBadge | JPAuthorizationOptionSound;

    [JPUSHService registerForRemoteNotificationConfig:entiy delegate:self];


    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    //Required
    // init Push(2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil  )
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JG_APPKEY  channel:@"App Store"
                 apsForProduction:IS_Release == 1
            advertisingIdentifier:advertisingId];



    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kJPFNetworkDidLoginNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
       ///  设置是否可以接收推送
        [XQSetupExample setCanPush:[XQSetupExample canPush]];
    }];
}


/**
 注册分享
 */
- (void)regiesterShareSDK{
    [ShareUtil resigterShareSDK];
}

/**
 定位
 */
- (void)locationService{

    [OnlyLocationManager shareManager:YES needVO:YES initCallBack:^(LocationInitType type, CLLocationManager *manager) {

    } resultCallBack:^(CLLocationCoordinate2D coordinate, CLLocation *location, OnlyLocationVO *locationVO) {
        NSNumber *la = @(coordinate.latitude);
        NSNumber *lo = @(coordinate.longitude);
        //  保存定位地址
        [XQLoginExample setLatitudeAndLongitude:[NSString stringWithFormat:@"%@,%@",la,lo]];
    }];
}


- (void)registerShortcutItem
{

    if (@available(iOS 9.1, *)) {
        UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:KWorkItemTypekey localizedTitle:@"开工" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite] userInfo:nil];
        [[ShortcutItemManage shareManager] addItem:shoreItem2];
    } else {
        // Fallback on earlier versions
    }

#ifdef DEBUG
    UIApplicationShortcutItem *shoreItem1 = [[UIApplicationShortcutItem alloc] initWithType:KShareItemTypekey localizedTitle:@"分享" localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare] userInfo:nil];
    [[ShortcutItemManage shareManager] addItem:shoreItem1];
#endif
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    // react to shortcut item selections
    NSLog(@"A shortcut item was pressed. It was %@.", shortcutItem.localizedTitle);
    // have we launched Deep Link Level 1
    if ([shortcutItem.type isEqualToString:KWorkItemTypekey]) {
        //  开工收工状态
        [MLHTTPRequest GETWithURL:RUN_IS_WORK parameters:@{@"is_work":[shortcutItem.localizedTitle isEqualToString:@"开工"]?@"1":@"0"} success:^(MLHTTPRequestResult *result) {
            ML_SHOW_MESSAGE(result.errmsg);
            if (result.errcode == 0) {
                [XQNotificationCenter postNotificationName:kWorkingStatuseNotificationKey object:nil];
            }
        } failure:^(NSError *error) {
            ML_MESSAGE_NETWORKING;
        }];
    }
}


///注册APNs成功并上报DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{

    /// Required 注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



///添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

    if([[userInfo allKeys] containsObject:@"type"] ){
        NSLog(@"userInfo %@",userInfo);
        [PushNotifyManager processNotify:@{@"type":[userInfo objectForKey:@"type"]}];
    }

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

    if([[userInfo allKeys] containsObject:@"type"]){
        NSLog(@"userInfo %@",userInfo);
        [PushNotifyManager processNotify:@{@"type":[userInfo objectForKey:@"type"]}];
    }

    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    //  iOS 10之前前台没有通知栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //  iOS 10以下 极光前台不展示消息栏，此处为自定义内容
//        [EBBannerView showWithContent:@"交易结果通知"];

        //  获取共享域的偏好设置（可百度“多target数据共享”）
//        NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.xxx"];
//        BOOL canSound = [userDefault boolForKey:@"voice"];
//        if (canSound) {
//            //  播放refund.wav或collection.wav固定音频文件
//            if ([refund condition]) {
//                [self playMusic:@"refund" type:@"wav"];
//            } else {
//                [self playMusic:@"collection" type:@"wav"];
//            }
//        }
    }
}

//  播放音频文件
- (void)playMusic:(NSString *)name type:(NSString *)type {
//    //得到音效文件的地址
//    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
//    //将地址字符串转换成url
//    NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
//    //生成系统音效id
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundFileObject);
//    //播放系统音效
//    AudioServicesPlaySystemSound(_soundFileObject);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

@end
