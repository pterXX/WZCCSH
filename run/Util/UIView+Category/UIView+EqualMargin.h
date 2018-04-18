//
//  UIView+EqualMargin.h
//  proj
//
//  Created by asdasd on 2018/1/2.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EqualMargin)
- (void)distributeSpacingHorizontallyWith:(NSArray*)views
                         withFixedSpacing:(CGFloat)fixedSpacing
                              leadSpacing:(CGFloat)leadSpacing
                              tailSpacing:(CGFloat)tailSpacing;

- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
