//
//  UIView+EqualMargin.m
//  proj
//
//  Created by asdasd on 2018/1/2.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "UIView+EqualMargin.h"
#import <Masonry/Masonry.h>

@implementation UIView (EqualMargin)

- (void)distributeSpacingHorizontallyWith:(NSArray*)views
                         withFixedSpacing:(CGFloat)fixedSpacing
                              leadSpacing:(CGFloat)leadSpacing
                              tailSpacing:(CGFloat)tailSpacing
{
    __weak __typeof(&*self)ws = self;
    [views.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).with.offset(leadSpacing);
//        make.centerY.equalTo(ws.mas_centerY);
    }];

    UIView *lastSpace = views.firstObject;
    for ( int i = 1 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
//        UIView *space = spaces[i];

        [obj mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right).with.offset(fixedSpacing);
        }];
        lastSpace = obj;
    }

    [views.lastObject mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).with.offset( - tailSpacing);
    }];
}
- (void) distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];

    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];

        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }


    UIView *v0 = spaces[0];

    __weak __typeof(&*self)ws = self;

    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];

    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];

        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];

        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];

        lastSpace = space;
    }

    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

@end
