//
//  AppDelegate+RootViewController.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewControllerUtil.h"


@interface AppDelegate (RootViewController)
/**
 配置根视图控制器
 */
- (void)configWindowRootController;

/**
 禁用IQKeyboardManager
 */
- (void)disabledIQKeyboardManagerVc;

/**
 WRNavigationBar 黑名单，不会影响这几个ViewController
 */
- (void)wRNavigationBarBacklist;

/**
 设置自定义导航栏的颜色
 */
- (void)setNavigationBarColor;
@end
