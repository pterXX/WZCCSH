//
//  UIColor+UIImage.h
//  city
//
//  Created by asdasd on 2017/9/26.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(UIImage)
#pragma mark - 根据图片获取图片的主色调
+(UIColor*)mostColor:(UIImage*)image;

@end

