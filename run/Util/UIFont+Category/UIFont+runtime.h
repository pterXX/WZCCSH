//
//  UIFont+runtime.h
//  字体大小适配-runtime
//
//  Created by 刘龙 on 2017/3/23.
//  Copyright © 2017年 xixhome. All rights reserved.
//

#import <UIKit/UIKit.h>
#define YourUIScreen 375 //自己UI设计原型图的手机尺寸宽度(6)
NS_ASSUME_NONNULL_BEGIN
@interface UIFont (runtime)

//  适配字体
+(UIFont *)adjustFont:(CGFloat)fontSize;


//  指定的视图下子视图适配字体
+ (void)adjusFontWithSubViews:( NSArray<UIView *> * _Nonnull )subViews
                     uiScreen:(CGFloat)youUIScreen;

//  适配一个视图下所有子视图的字体
+ (void)adjusAllSubViewsFontWithUIScreen:(CGFloat)youUIScreen
                                 youView:(UIView *)youView;

//  除了排除的视图，其他的子视图都自动适应字体大小
+ (void)adjusAllSubViewsFontWithUIScreen:(CGFloat)youUIScreen
                                 youView:(UIView *)youView
                            reulOutViews:(NSArray <UIView *>*)reulOutViews;
@end
NS_ASSUME_NONNULL_END
