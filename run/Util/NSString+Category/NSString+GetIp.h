//
//  NSString+GetIp.h
//  city
//
//  Created by 3158 on 2017/9/12.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetIp)
#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
