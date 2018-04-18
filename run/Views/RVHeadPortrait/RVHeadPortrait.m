//
//  RVHeadPortrait.m
//  proj
//
//  Created by asdasd on 2017/10/10.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "RVHeadPortrait.h"

@implementation RVHeadPortrait
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 40, 40);

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headPortraitTap)];
        [self addGestureRecognizer:tap];

        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
         _headImgView.image = DEFAULT_HEAD_ICON;
        _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImgView.layer.borderWidth = 2;
        _headImgView.layer.cornerRadius = self.width / 2;
        _headImgView.layer.masksToBounds = YES;
        _headImgView.backgroundColor = [UIColor purpleColor];
        [self addSubview:_headImgView];
    }
    return self;
}

+ (RVHeadPortrait *)defaultHeadPortraitForBlock:(HeadTap)headTap{
    static RVHeadPortrait *head = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        head = [[RVHeadPortrait alloc] init];
    });
    head.headTap = headTap;
    return head;
}


/**
 头像点击
 */
- (void)headPortraitTap{
    if (self.headTap) {
        self.headTap();
    }
}

@end
