//
//  AppDelegate+RootViewController.m
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "AppDelegate+RootViewController.h"
#import "XQLoginExample.h"
#import "HomeViewController.h"
#import "RootViewControllerUtil.h"
#import "XQLoginExample.h"
#import "LaunchView.h"

@implementation AppDelegate (RootViewController)


/**
 配置根视图控制器
 */
- (void)configWindowRootController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [RootViewControllerUtil pushPermissionsViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    //  引导页
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LaunchView2"] == nil) {
        LaunchView *lv = [[LaunchView alloc] initWithFrame:self.window.bounds];
        [lv setViewWillHide:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LaunchView2"];
        }];
        [self.window addSubview:lv];
    }
}

/**
 WRNavigationBar 黑名单，不会影响这几个ViewController
 */
- (void)wRNavigationBarBacklist
{

}

- (void)setNavigationBarColor{
    [CustomNavigationViewController setAppearanceNavigationBarColor:COLOR_EEEEEE];
    [CustomNavigationViewController setAppearanceTitleColor:COLOR_IMPORTANT];
}



/**
 禁用IQKeyboardManager
 */
- (void)disabledIQKeyboardManagerVc
{
//    [[IQKeyboardManager sharedManager].enabledToolbarClasses addObjectsFromArray:array];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObjectsFromArray:array];
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;

}



@end
