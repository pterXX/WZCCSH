//
//  NSArray+zh_SafeAccess.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/15.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (zh_SafeAccess)

- (NSUInteger)zh_indexOfObject:(id _Nullable )anObject;


///  删除指定条件object
- (id _Nullable )zh_removeOfObject:(BOOL(^_Nonnull)(id _Nonnull value))block;
@end
