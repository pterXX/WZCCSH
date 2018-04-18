//
//  AppDelegate+AppService.h
//  proj
//
//  Created by asdasd on 2017/9/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "AppDelegate.h"
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import <AdSupport/AdSupport.h>


@interface AppDelegate (AppService)<JPUSHRegisterDelegate>

/**
 初始化话百度地图
 */
- (void)registerBaiDuMap;


/**
 3D touch列表
 */
- (void)registerShortcutItem;


/**
 升级弹窗
 */
- (void)showNewEditionTestManager;

/**
 注册及时通讯
 */
- (void)regiesterIM;


/**
 注册友盟
 */
- (void)regiesterUM;

/**
 注册极光
 */
- (void)regiesterJPUSH:(NSDictionary *)launchOptions;



/**
 注册分享
 */
- (void)regiesterShareSDK;


/**
 定位
 */
- (void)locationService;
@end
