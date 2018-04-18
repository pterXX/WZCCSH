//
//  UIView+Loading.m
//  running man
//
//  Created by asdasd on 2018/3/30.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UIView+Loading.h"
#import <objc/runtime.h>
static NSString const *originalBGColorKey = @"originalBGColorKey";
@implementation UIView (Loading)

- (void)xq_startLoadingAnimation{
    UIImageView *imgView = [self xqLoadIngImgView];
    [self addSubview:imgView];

    //  保存原来的颜色
    objc_setAssociatedObject(self, &originalBGColorKey, self.backgroundColor, OBJC_ASSOCIATION_RETAIN);
    //  将背景设为白色
    self.backgroundColor = [UIColor whiteColor];

    __weak typeof(self) wkself = self;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.with.sizeOffset(CGSizeMake(SJAdapter(274), SJAdapter(274)));
        make.centerX.equalTo(wkself.mas_centerX);
        make.top.equalTo(wkself.mas_top).with.offset(SJAdapter(100));
    }];

    NSMutableArray *array = [NSMutableArray array];
    for (UIView *subView in self.subviews) {
        if (subView.isHidden == YES) {
            [array addObject:subView];
        }
        if (subView != imgView ) {
            subView.hidden = YES;
        }
    }
    //  保存本身已经隐藏的视图
    [self setXq_HiddenArr:array];
    [imgView setAnimationDuration:1.0];
    [imgView startAnimating];
}



- (void)xq_stopLoadingAnimation
{
   UIImageView *imgView = objc_getAssociatedObject(self, @selector(xqLoadIngImgView));
    if (imgView) {
        [imgView stopAnimating];
        //  获取在动画没有开始之前本身已经隐藏的视图
        NSArray *array  = [self xq_HiddenArr];
        for (UIView *subView in self.subviews) {
            if (array && [array containsObject:subView]) {
                subView.hidden = YES; //   本身已经隐藏的就不需要再加载
            }else{
                subView.hidden = NO;
            }
        }

        //  清空
        [imgView removeFromSuperview];
        imgView = nil;
        objc_setAssociatedObject(self, @selector(xqLoadIngImgView), nil, OBJC_ASSOCIATION_RETAIN);

        UIColor *color = objc_getAssociatedObject(self, &originalBGColorKey);
        if (color) {
            //  还原原来背景色的颜色
            self.backgroundColor = color;
        }
    }
}

//  用于保存本身已隐藏的视图
- (void)setXq_HiddenArr:(NSArray *)arr{
    objc_setAssociatedObject(self, @selector(xq_HiddenArr), arr, OBJC_ASSOCIATION_RETAIN);
}
- (NSArray *)xq_HiddenArr{
    return objc_getAssociatedObject(self, _cmd);
}

- (UIImageView *)xqLoadIngImgView{
    UIImageView *imgView = [[UIImageView alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1; i < 9; i ++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loading%@",@(i)]];
        if (img) {
            [array addObject:img];
        }
    }
    imgView.animationImages = array;
    objc_setAssociatedObject(self, @selector(xqLoadIngImgView), imgView, OBJC_ASSOCIATION_RETAIN);
    return imgView;
}
@end
