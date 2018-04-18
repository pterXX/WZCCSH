//
//  UIColor+hex.h
//  city
//
//  Created by 3158 on 2017/9/19.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hex)
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) hexString: (NSString *)color;


+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
@end

