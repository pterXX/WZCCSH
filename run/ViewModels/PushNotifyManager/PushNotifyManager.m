//
//  PushNotifyManager.m
//  cyb
//
//  Created by caoshichao on 15/10/14.
//  Copyright (c) 2015年 sjw-mac. All rights reserved.
//

#import "PushNotifyManager.h"
#import "XQLoginExample.h"
#import "RunOrderViewController.h"
#import "WalletViewController.h"
#import "MessgaeDetailViewController.h"
@implementation PushNotifyManager


static BOOL IS_RECV;
static PushNotifyManager *SELF;
+(void)processNotify:(NSDictionary *)data
{
    if (data == nil) {
        return;
    }
//        NSString* flag = [data objectForKey:@"type_id"];
//        if ([@"1" isEqual:flag]) {
            UIViewController *vc = [PushNotifyManager getViewContoller:data];
            if (vc != nil) {
                [[self navigationController] pushViewController:vc animated:YES];
            }
//    }
}

#pragma mark - Private Methods
//  获取响应的导航栏
+ (UINavigationController *)navigationController{
    UIViewController *vc =  [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)vc;
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        for (UIViewController *subVc in vc.childViewControllers)
        {
            if ([subVc isKindOfClass:[UINavigationController class]])
            {
                return (UINavigationController *)subVc;
            }
        }
    }else{
        return vc.sideMenuViewController.contentViewController;
    }
    return nil;
}

+ (UITabBarController *)tabBarController{
    UIViewController *vc =  [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([vc isKindOfClass:[UINavigationController class]])
    {
        UIViewController *topVC = ((UINavigationController *)vc).topViewController;
        return [topVC isKindOfClass:[UITabBarController class]]?((UITabBarController *)topVC):nil;
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return ((UITabBarController *)vc);
    }
    return nil;
}


+ (void)selectedTabbarChildVC:(Class)vcClass {
    UINavigationController *nav = [self navigationController];
    UIViewController *top = nav.topViewController;
    UIViewController *visible = nav.visibleViewController;
    if ([top isKindOfClass:[UITabBarController class]]) {
        if (top == visible) {
            UITabBarController *tabVc = (UITabBarController *)top;
            for (UIViewController *vc in tabVc.childViewControllers) {
                if ([vc isKindOfClass:vcClass]) {
                    [tabVc setSelectedViewController:vc];
                    break;
                }
            }
        }
    }
}

+(UIViewController *)getViewContoller:(NSDictionary *)data
{
    if ([XQLoginExample exampleIsLogined] == NO) {
        return nil;
    }
    UIViewController *vc = nil;
    
    int type = [[data objectForKey:@"type"] intValue];
    switch (type) {
        case 1:
            [XQNotificationCenter postNotificationName:kPushOrderPageAndReloadUINotificationKey object:nil];
            break;
        case 2:
             return [self initMessageDetailVC:data];
            break;
        case 3:
            return [self initWalletVC:data];
            break;
        case 4:

            break;

        default:
            break;
    }
    return vc;
}

+ (RunOrderViewController *)initOrderVC:(NSDictionary *)data{
    RunOrderViewController *vc = [[RunOrderViewController alloc] init];
    vc.viewModel.isGrabSingle = YES;
    if (data[@"id"] == nil ) {
        vc.viewModel.aid = data[@"id"];
          return vc;
    }else{
        return nil;
    }
}

+ (MessgaeDetailViewController *)initMessageDetailVC:(NSDictionary *)data{
    MessgaeDetailViewController *vc = [[MessgaeDetailViewController alloc] init];
    if (data[@"id"] != nil ) {
        vc.aid = data[@"id"];
    }else{
        return nil;
    }
    vc.msg_type = data[@"msg_type"];
    return vc;
}

+ (WalletViewController *)initWalletVC:(NSDictionary *)data{
    WalletViewController *vc = [[WalletViewController alloc] init];
    return vc;
}





+(void)setPushNotifyRecv:(BOOL)isRecv
{
//    if (SELF == nil) {
//        SELF = [[PushNotifyManager alloc]init];
//    }
//    IS_RECV = isRecv;
//    if (!isRecv) {
//        //屏幕唤醒后
//        [NSTimer scheduledTimerWithTimeInterval:10.0 target:SELF selector:@selector(onSendNotifyTimer) userInfo:nil repeats:NO];
//    }else{
//        [SELF onSendNotifyTimer];
//    }
}

-(void)onSendNotifyTimer
{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *deviceToken = [defaults objectForKey:@"token_key"];
//
//    NSString *method = @"user/reNewDeviceToken";
//    NSString *imei = deviceToken;
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:imei,@"token_key", nil];

}
@end
