//
//  ShortcutItemManage.m
//  run
//
//  Created by asdasd on 2018/4/17.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ShortcutItemManage.h"

@implementation ShortcutItemManage
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (instancetype)shareManager{
    static ShortcutItemManage *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ShortcutItemManage alloc] init];
        [manager removeAllItem];
    });
    return manager;
}


/**
 添加Item
 */
- (void)addItem:(UIApplicationShortcutItem *)item {
    NSMutableArray *arr = [UIApplication sharedApplication].shortcutItems.mutableCopy;
    [arr addObject:item];
    [UIApplication sharedApplication].shortcutItems = arr;
}

/**
 删除指定item
 */
- (void)removeItemWithType:(NSString *)type{
    NSMutableArray *arr = [UIApplication sharedApplication].shortcutItems.mutableCopy;
    for (UIApplicationShortcutItem *item in arr) {
        if ([item.type isEqualToString:type]) {
            [arr removeObject:item];
        }
    }
    [UIApplication sharedApplication].shortcutItems = arr;
}


/**
 删除所有Item
 */
- (void)removeAllItem{
    [UIApplication sharedApplication].shortcutItems = [NSArray array];
}

/**
 修改Item
 */
- (void)updateItem:(UIApplicationShortcutItem *)newItem{
    NSMutableArray *arr = [UIApplication sharedApplication].shortcutItems.mutableCopy;
    NSArray *array = [UIApplication sharedApplication].shortcutItems;
    BOOL isExsits = NO;
    for (UIApplicationShortcutItem *item in array) {
        if ([item.type isEqualToString:newItem.type]) {
            [arr replaceObjectAtIndex:[arr indexOfObject:item] withObject:newItem];
            isExsits = YES;
        }
    }
    if (isExsits == NO) {
        [arr addObject:newItem];
    }


    [UIApplication sharedApplication].shortcutItems = arr;
}

@end
