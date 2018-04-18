//
//  UIDevice+Category.m
//  proj
//
//  Created by asdasd on 2017/12/21.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIDevice+Category.h"

@implementation UIDevice (Category)

+ (NSString *)identifierNumber{
    //手机序列号
    NSString* identifierNumber = [NSString stringWithFormat:@"%ld",[[UIDevice currentDevice] userInterfaceIdiom]];
    NSLog(@"手机序列号: %@",identifierNumber);
    return identifierNumber;
}

+ (NSString *)userPhoneName{
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    return userPhoneName;
}

+ (NSString *)deviceName{
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    return deviceName;
}

+ (NSString *)phoneVersion
{
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    return phoneVersion;
}


+ (NSString *)phoneModel
{
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    return phoneModel;
}

+ (NSString *)localPhoneModel
{
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    return localPhoneModel;
}


+ (NSString *)appCurName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
//    NSLog(@"当前应用名称：%@",appCurName);
    return appCurName;
}


+ (NSString *)appCurVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
    return appCurVersion;
}


+ (NSString *)appCurVersionNum
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // 当前应用软件版本  比如：1.0.1
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    return appCurVersionNum;
}


@end
