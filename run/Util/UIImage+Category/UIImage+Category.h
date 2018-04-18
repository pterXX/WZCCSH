//
//  UIImage+Category.h
//  running man
//
//  Created by asdasd on 2018/3/30.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
+(UIImage *)imageWithColor:(UIColor *)color;


+(UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张可以随意拉伸但不变形的图片
 */
+(UIImage *)resizedImage:(NSString *)name;

/**
 返回一张指定尺寸的图片
 */
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/**
 *  返回一张添加水印的图片
 */
+(instancetype)waterImageWithBackground:(NSString *)bg logo:(NSString *)logo;

/**
 *  返回一张带边框的圆形图
 */
+(instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  返回截屏后的图片
 */
+(instancetype)captureWithView:(UIView *)view;


/**
 图片设置圆角

 */
- (UIImage *)roundedCornerRadius:(CGFloat)cornerRadius;
@end
