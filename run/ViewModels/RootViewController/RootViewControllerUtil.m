//
//  RootViewControllerUtil.m
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "RootViewControllerUtil.h"
#import "UserViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "CustomNavigationViewController.h"
#import "XQLoginExample.h"
#import "ApplyViewController.h"
#import "PermissionsViewController.h"
@implementation RootViewControllerUtil

/**
 包含菜单栏的根视图
 */
+ (RESideMenu *)menuViewController{
     RESideMenu *sideMenuViewController;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

        UserViewController *leftMenuViewController = [[UserViewController alloc] init];

        sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[self navigationController]
                                                            leftMenuViewController:leftMenuViewController
                                                           rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
        //    sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
        sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        sideMenuViewController.contentViewShadowOpacity = 0.6;
        sideMenuViewController.contentViewShadowRadius = 5;
        sideMenuViewController.contentViewScaleValue = 1.0f;
        sideMenuViewController.contentViewInPortraitOffsetCenterX = SJAdapter(250);
        sideMenuViewController.scaleContentView = NO;
        sideMenuViewController.scaleMenuView = NO;
        sideMenuViewController.contentViewShadowEnabled = YES;
        sideMenuViewController.bouncesHorizontally = NO;
//    });
    return sideMenuViewController;
}

/**
 包含菜单栏的根视图
 */
+ (RESideMenu *)notTabbarMenuViewController{
   RESideMenu *sideMenuViewController;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

        UserViewController *leftMenuViewController = [[UserViewController alloc] init];

        sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:[self notTabbarNavigationController]
                                                            leftMenuViewController:leftMenuViewController
                                                           rightMenuViewController:nil];
        sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
        sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
        //    sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
        sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
        sideMenuViewController.contentViewShadowOpacity = 0.6;
        sideMenuViewController.contentViewShadowRadius = 5;
        sideMenuViewController.contentViewScaleValue = 1.0f;
        sideMenuViewController.contentViewInPortraitOffsetCenterX = SJAdapter(250);
        sideMenuViewController.scaleContentView = NO;
        sideMenuViewController.scaleMenuView = NO;
        sideMenuViewController.contentViewShadowEnabled = YES;
        sideMenuViewController.bouncesHorizontally = NO;
//    });
    return sideMenuViewController;
}


/**
 只存在导航栏的根视图控制器
 */
+ (CustomNavigationViewController *)notTabbarNavigationController{
     CustomNavigationViewController *navigationController;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

        //首页
        HomeViewController *homeVc = [[HomeViewController alloc] init];
        navigationController = [[CustomNavigationViewController alloc] initWithRootViewController:homeVc];
//    });
//
    return navigationController;
}

/**
 只存在导航栏的根视图控制器
 */
+ (CustomNavigationViewController *)navigationController{
     CustomNavigationViewController *navigationController;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{

        //首页
        HomeViewController *homeVc = [CustomTabBarViewController tabbarItem:[UIImage imageNamed:@"chanditong_home"] selectImg:[UIImage imageNamed:@"chanditong_home_selected"] vcClass:[HomeViewController class] title:@"首页"];


        CustomTabBarViewController *tabBarController = [[ CustomTabBarViewController alloc] init];

        //        tabBarController.delegate = self;
        tabBarController.title = homeVc.title;
        tabBarController.tabBar.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        tabBarController.viewControllers = [NSArray arrayWithObjects:homeVc, nil];

        navigationController = [[CustomNavigationViewController alloc] initWithRootViewController:tabBarController];
//    });

    return navigationController;
}

/**
 带导航栏的登录框

 */
+ (CustomNavigationViewController *)loginNavViewController{
    CustomNavigationViewController *navigationController;
    navigationController = [[CustomNavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    return navigationController;
}


/**
 申请注册跑腿员
 */
+ (CustomNavigationViewController *)applyController{
    CustomNavigationViewController *navigationController;
    navigationController = [[CustomNavigationViewController alloc] initWithRootViewController:[[ApplyViewController alloc] init]];
    return navigationController;
}

/**
 判断是否需要登录

 @return 登录 返回Menu  没有登录的返回登录视图
 */
+ (UIViewController *)isLoginViewController{
    if ([XQLoginExample exampleIsLogined]){
        return [RootViewControllerUtil notTabbarMenuViewController];
    }else{
       return [RootViewControllerUtil loginNavViewController];
    }
}

/**
 判断是否有权限

 @return 登录 返回Menu  没有登录的返回登录视图
 */
+ (UIViewController *)pushPermissionsViewController{
     if ([PermissionManager locationPermission] && [PermissionManager networkPermission]){
        return [RootViewControllerUtil isLoginViewController];
    }else{
        return [[PermissionsViewController alloc] init];
    }
}


@end

@implementation UIView (UIViewController)

- (UIViewController *)viewController {

    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;

    do {

        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }

        next = next.nextResponder;

    }while(next != nil);

    return nil;
}


- (UINavigationController *)navavigationController
{
    if ([self.viewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.viewController;
    }

    return self.viewController.navigationController;
}
@end

