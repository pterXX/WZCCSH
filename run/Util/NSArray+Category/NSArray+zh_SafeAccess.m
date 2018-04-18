//
//  NSArray+zh_SafeAccess.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "NSArray+zh_SafeAccess.h"

@implementation NSArray (zh_SafeAccess)

- (NSUInteger)zh_indexOfObject:(id)anObject {
    NSParameterAssert(self.count);
    if ([self containsObject:anObject]) {
        return [self indexOfObject:anObject];
    }
    return 0;
}

///  删除指定条件object
- (id)zh_removeOfObject:(BOOL(^)(id value))block
{
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj  in self) {
       BOOL  isremove = block(obj);
        if (isremove == NO) {
            [arr addObject:obj];
        }
    }
    return arr;
}

@end
