//
//  RootViewControllerUtil.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RESideMenu/RESideMenu.h>

#import "SJAdapter.h"

#import "CustomNavigationViewController.h"
#import "CustomTabBarViewController.h"


@interface RootViewControllerUtil : NSObject
/**
 包含菜单栏的根视图
 */
+ (RESideMenu *)menuViewController;
+ (RESideMenu *)notTabbarMenuViewController;


/**
 只存在导航栏的根视图控制器
 */
+ (CustomNavigationViewController *)navigationController;


/**
 带导航栏的登录框

 */
+ (CustomNavigationViewController *)loginNavViewController;

/**
 申请注册跑腿员
 */
+ (CustomNavigationViewController *)applyController;

/**
 判断是否需要登录

 @return 登录 返回Menu  没有登录的返回登录视图
 */
+ (UIViewController *)isLoginViewController;

/**
  判断是否有权限

 @return 登录 返回Menu  没有登录的返回登录视图
 */
+ (UIViewController *)pushPermissionsViewController;
@end

@interface UIView (UIViewController)

- (UIViewController *)viewController;

- (UINavigationController *)navavigationController;
@end
