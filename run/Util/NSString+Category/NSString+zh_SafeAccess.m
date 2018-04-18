//
//  NSString+zh_SafeAccess.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSString+zh_SafeAccess.h"

@implementation NSString (zh_SafeAccess)

///  得到第一个字
- (NSString *)firstCharacter
{
    return [self substringToIndex:1];
}

/// 得到最后一个字
- (NSString *)lastCharacter
{
    return [self substringFromIndex:self.length - 1];
}

- (NSString *)substringToIndexSafe:(NSUInteger)to {
    if (self == nil || [self isEqualToString:@""]) {
        return @"";
    }
    if (to > self.length - 1) {
        return @"";
    }
    return  [self substringToIndex:to];
}

- (NSString *)substringFromIndexSafe:(NSInteger)from {
    if (self == nil || [self isEqualToString:@""]) {
        return @"";
    }
    if (from > self.length - 1) {
        return @"";
    }
    return  [self substringFromIndex:from];
}

- (NSString *)deleteFirstCharacter {
    return [self substringFromIndexSafe:1];
}

- (NSString *)deleteLastCharacter {
    return [self substringToIndexSafe:self.length - 1];
}

- (BOOL)isEmpty
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0;
}

- (NSString *)trim{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
