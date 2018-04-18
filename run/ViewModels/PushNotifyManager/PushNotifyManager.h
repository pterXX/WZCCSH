//
//  PushNotifyManager.h
//  cyb
//
//  Created by caoshichao on 15/10/14.
//  Copyright (c) 2015年 sjw-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PushNotifyManager : NSObject

+(void)processNotify:(NSDictionary *)data;
//  程序在进入前台和后台的操作
+(void)setPushNotifyRecv:(BOOL)isRecv;

@end
