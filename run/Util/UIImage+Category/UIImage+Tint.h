//
//  UIImage+Tint.h
//  UIImageDemo
//
//  Created by asdasd on 2017/9/26.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)
//  改变图片的的色调

/**
 改变图片的色调
 */
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

/**
 将图片按灰度信息改变颜色

 @param tintColor 当前需要将图片改为指定的颜色
 @return 返回一张图片
 */
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

/**
 图片去色处理

 @return 一张只有灰色的图片
 */
-(UIImage *)grayImage;



/**
 根据颜色生成图片

 @param color 颜色
 @return 有颜色的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color  withSize:(CGSize)size;
@end
