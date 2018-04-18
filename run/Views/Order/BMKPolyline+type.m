//
//  BMKPolyline+type.m
//  run
//
//  Created by asdasd on 2018/4/12.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "BMKPolyline+type.h"
#import <objc/runtime.h>
@implementation BMKPolyline (type)
- (NSInteger)type{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setType:(NSInteger)type{
    objc_setAssociatedObject(self, @selector(type), @(type), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
