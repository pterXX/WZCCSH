//
//  ShortcutItemManage.h
//  run
//
//  Created by asdasd on 2018/4/17.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShortcutItemManage : NSObject
+ (instancetype)shareManager;

/**
 添加Item
 */
- (void)addItem:(UIApplicationShortcutItem *)item;

/**
 删除指定item
 */
- (void)removeItemWithType:(NSString *)type;

/**
 删除所有Item
 */
- (void)removeAllItem;


/**
 修改Item
 */
- (void)updateItem:(UIApplicationShortcutItem *)newItem;
@end
