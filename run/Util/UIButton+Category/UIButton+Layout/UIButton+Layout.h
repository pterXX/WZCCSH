//
//  UIButton+Layout.h
//  YLButton
//
//  Created by HelloYeah on 2016/12/5.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, UIButtonImagePosition) {
    UIButtonImagePositionLeft = 0,
    UIButtonImagePositionRight,
    UIButtonImagePositionTop,
    UIButtonImagePositionBottom
};

@interface UIButton (Layout)

@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;

//  布局后的宽高度
@property (nonatomic,assign) CGFloat layoutHeight;
@property (nonatomic,assign) CGFloat layoutWidth;

- (CGSize)titleSize;

- (void)setImgePosition:(UIButtonImagePosition)position  spacer:(CGFloat)spacer;
- (void)setImgePosition:(UIButtonImagePosition)position spacer:(CGFloat)spacer imageSize:(CGSize)size;

@end
