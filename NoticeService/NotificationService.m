//
//  NotificationService.m
//  NoticeService
//
//  Created by asdasd on 2018/4/13.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFoundation.h>


#define XQ_SETUP_USER_PUSH_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_USER_PUSH_SETUP_%@",uid]
#define XQ_SETUP_VIBRATION_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_VIBRATION_SETUP_%@",uid]
#define XQ_SETUP_SOUND_SETUP(uid) [NSString stringWithFormat:@"XQ_SETUP_SOUND_SETUP_%@",uid]

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    

    void(^block)(void) = ^(void){
        NSString *type = self.bestAttemptContent.userInfo[@"type"];
        if (type.integerValue == 1) {
            //  语音合成
            [self syntheticVoice:self.bestAttemptContent.body];
        }
    };


    NSString *uid = [self multipleTargetWithKey:@"uid"];
    //  判断是否设置推送设置
    if (uid) {
      NSString *canSound =  [self multipleTargetWithKey:XQ_SETUP_SOUND_SETUP(uid)];
        if (canSound ) {
            if ([canSound boolValue]) {
                block();
            }
        }else{
            [self setMultipleTarget:@"1" key:XQ_SETUP_SOUND_SETUP(uid)];

        }
    }else{
        block();
    }

    self.contentHandler(self.bestAttemptContent);
}


- (void)syntheticVoice:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        //  语音合成
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        //设置语言类别（不能被识别，返回值为nil）
        speechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        //设置语速快慢
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate;
        //语音合成器会生成音频
        [self.synthesizer speakUtterance:speechUtterance];
    });
}


//  设置多target 数据共享
- (void)setMultipleTarget:(NSString *)obj key:(NSString *)key{
    //  多target 数据共享
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    NSUserDefaults *us = [[NSUserDefaults alloc] initWithSuiteName:appDomain];
    if (key) {
        [us setObject:obj?:@"" forKey:key];
    }
    [us synchronize];
}


- (id)multipleTargetWithKey:(NSString *)key{
    //  多target 数据共享
    NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
    NSUserDefaults *us = [[NSUserDefaults alloc] initWithSuiteName:appDomain];
    return [us objectForKey:key];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
