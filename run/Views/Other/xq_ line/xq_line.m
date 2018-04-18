//
//  xq_ShareBottomView.m
//  proj
//
//  Created by asdasd on 2018/1/6.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "xq_line.h"
#import "UIButton+Layout.h"

@interface xq_line ()

@end
@implementation xq_line
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}


- (void)setupViews
{
    self.backgroundColor = COLOR_BACKGRORD;
    self.bounds = CGRectMake(0, 0, KWIDTH,1);
}

#pragma mark - Prvate Method
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
