//
//  VoiceManager.h
//  run
//
//  Created by asdasd on 2018/4/16.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 场景：有新订单进来的时候
 语音：新的订单来了
 场景：点击开工按钮，成功
 语音：你已开工，上班路上注意安全
 场景：点击收工按钮，成功
 语音：你已收工，下班路上注意安全
 */

#define NEW_ORDER @"新的订单来了"
#define WORK_TITLE @"你已开工，上班路上注意安全"
#define NOT_WORK_TITLE @"你已收工，下班路上注意安全"

@interface VoiceManager : NSObject
- (void)syntheticVoice:(NSString *)string;

+ (instancetype)shareManager;
@end
