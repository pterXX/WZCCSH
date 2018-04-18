//
//  VoiceManager.m
//  run
//
//  Created by asdasd on 2018/4/16.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "VoiceManager.h"
#import <AVFoundation/AVFoundation.h>

@interface VoiceManager()
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation VoiceManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)shareManager{
    static VoiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[VoiceManager alloc] init];
    });
    return manager;
}


- (void)syntheticVoice:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        //  语音合成
        self.synthesizer = [[AVSpeechSynthesizer alloc] init];
        AVSpeechUtterance *speechUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        //设置语言类别（不能被识别，返回值为nil）
        speechUtterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        //设置语速快慢
        speechUtterance.rate = 0.55;
        //语音合成器会生成音频
        [self.synthesizer speakUtterance:speechUtterance];
    });
}
@end
