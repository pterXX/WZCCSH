//
//  XQSetupExample.h
//  run
//
//  Created by asdasd on 2018/4/11.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQSetupExample : NSObject
//  是否可以推送
+ (BOOL)canPush;
+(void)setCanPush:(BOOL)isCanPush;

//  是否可以有声音
+ (BOOL)canSound;
+(void)setCanSound:(BOOL)isCanSound;

//  是否可以有震动
+ (BOOL)canCibration;
+(void)setcanCibration:(BOOL)isCanCibration;

//  app版本
+(NSString *)ver;
@end
