//
//  AppDelegate.m
//  proj
//
//  Created by asdasd on 2017/9/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "AppDelegate+RootViewController.h"
#import "RumtimeLog.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   // 3d touch
    [self registerShortcutItem];

    //  升级弹窗
   [self showNewEditionTestManager];

    [self registerBaiDuMap];
    
    //  只有定位后才能获取定位信息
    [self locationService];

   //  某些页面禁用IQKeyboardManager
   [self disabledIQKeyboardManagerVc];
    
    //  某些页面禁用WRNavigationBar
    [self wRNavigationBarBacklist];

    [self setNavigationBarColor];
    
   //  即时通讯
   [self regiesterIM];

    // 极光
    [self regiesterJPUSH:launchOptions];

    //  分享
    [self regiesterShareSDK];

    // 友盟
    [self regiesterUM];

    //  跳转到主页,自动判断是否登录
    [self configWindowRootController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#ifdef EM_DEPRECATED_IOS
    [[EMClient sharedClient] applicationDidEnterBackground:application];
#elseif
    /// 处理运行时APNS
    /// 现在您不需要手动调用，IMSDK会自动截获
    /// [[SPKitExample sharedInstance] exampleHandleRunningAPNSWithUserInfo:userInfo];
#endif
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
#ifdef EM_DEPRECATED_IOS
    [[EMClient sharedClient] applicationWillEnterForeground:application];
#elseif 
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
#endif
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if ([XQLoginExample exampleIsLogined] == NO)
    {
        [XQLoginExample exampleLoginOuted];
    }
}


@end
