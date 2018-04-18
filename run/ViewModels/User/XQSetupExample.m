//
//  XQSetupExample.m
//  run
//
//  Created by asdasd on 2018/4/11.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQSetupExample.h"
#import "XQLoginExample.h"
#import "JPUSHService.h"

#define XQ_SETUP_USER_PUSH_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_USER_PUSH_SETUP_%@",uid]
#define XQ_SETUP_VIBRATION_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_VIBRATION_SETUP_%@",uid]
#define XQ_SETUP_SOUND_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_SOUND_SETUP_%@",uid]
//#define <#macro#>
//#define XQ_SETUP_PUSH_SETUP @"XQ_SETUP_PUSH_SETUP"
@implementation XQSetupExample

+ (BOOL)canPush{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *setup = [us objectForKey:XQ_SETUP_USER_PUSH_SETUP([XQLoginExample uid])];
    if (setup) {
        return [setup boolValue];
    }else{
        [us setObject:@"1" forKey:XQ_SETUP_USER_PUSH_SETUP([XQLoginExample uid])];
        [us synchronize];
        return YES;
    }
}

+(void)setCanPush:(BOOL)isCanPush{
    //  针对不同的用户设置id推送
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us setObject:isCanPush?@"1":@"0" forKey:XQ_SETUP_USER_PUSH_SETUP([XQLoginExample uid])];
    [us synchronize];

    if (isCanPush) {
        [self JPUSHServiceSetTagAndAlias];
    }else{
        [self JPUSHServiceRemoveTagAndAlias];
    }
}

+ (BOOL)canSound{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *setup = [us objectForKey:XQ_SETUP_SOUND_SETUP([XQLoginExample uid])];
    if (setup) {
        return [setup boolValue];
    }else{
        [self setCanSound:YES];
        return YES;
    }
}


+(void)setCanSound:(BOOL)isCanSound{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us setObject:isCanSound?@"1":@"0" forKey:XQ_SETUP_SOUND_SETUP([XQLoginExample uid])];
    [us synchronize];

    [self setMultipleTarget:[XQLoginExample uid] key:@"uid"];
    [self setMultipleTarget:isCanSound?@"1":@"0" key:XQ_SETUP_SOUND_SETUP([XQLoginExample uid])];
}

+ (BOOL)canCibration{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    NSString *setup = [us objectForKey:XQ_SETUP_VIBRATION_SETUP([XQLoginExample uid])];
    if (setup) {
        return [setup boolValue];
    }else{
        [us setObject:@"1" forKey:XQ_SETUP_VIBRATION_SETUP([XQLoginExample uid])];
        [us synchronize];
        return YES;
    }
}

+(void)setcanCibration:(BOOL)isCanCibration{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    [us setObject:isCanCibration?@"1":@"0" forKey:XQ_SETUP_VIBRATION_SETUP([XQLoginExample uid])];
    [us synchronize];
}


+(NSString *)ver
{
    return [UIDevice appCurVersion];
}

/**
 设置极光推送的tag 和 别名
 */
+ (void)JPUSHServiceSetTagAndAlias{
    NSString *app_id = [XQLoginExample lastCityCode];
    if (app_id) {

        [JPUSHService setTags:[NSSet setWithObject:app_id] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {

        } seq:1];
    }

    NSString *uid = [XQLoginExample uid];
    if (uid) {
        [JPUSHService setAlias:uid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

        } seq:2];
    };
}


/**
 极光推送清除tag值和别名
 */
+ (void)JPUSHServiceRemoveTagAndAlias
{
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {

    } seq:1];

    [JPUSHService deleteTags:[NSSet set] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {

    } seq:2];
}

//  设置多target 数据共享
+ (void)setMultipleTarget:(NSString *)obj key:(NSString *)key{
    //  多target 数据共享
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    NSUserDefaults *us = [[NSUserDefaults alloc] initWithSuiteName:appDomain];
    if (key) {
        [us setObject:obj?:@"" forKey:key];
    }
    [us synchronize];
}

+ (id)multipleTargetWithKey:(NSString *)key{
    //  多target 数据共享
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    NSUserDefaults *us = [[NSUserDefaults alloc] initWithSuiteName:appDomain];
    return [us objectForKey:key];
}

@end
