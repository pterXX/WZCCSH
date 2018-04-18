//
//  CustomNavigationViewController.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigationViewController : UINavigationController <UINavigationControllerDelegate>
///  当前页面是否需要透明导航栏
+ (BOOL)transparentVc:(__unsafe_unretained Class)vcClass;
///  设置当前显示VC导航栏标题的颜色，需要先调用setAppearanceTitleColor  或setTitleColor:forVcClass: 才会有效果
+ (void)setTitleColorVisibleVc:(__unsafe_unretained Class)vcClass;
///  设置当前显示VC导航栏为透明，需要先调用setTransparentVcClass
+ (void)setTransparentVisibleVc:(__unsafe_unretained Class)vcClass;
///  设置当前显示的页面的导航栏为不透明
+ (void)setNotTransparentVisibleVc:(__unsafe_unretained Class)vcClass;

///  设置需要显示透明色的 VC
+ (void)setTransparentVcClass:(NSArray *)transparentVcClass;
+ (NSArray *)transparentVcClass;

///  设置全局的NavigationBarColor
+ (void)setAppearanceNavigationBarColor:(UIColor *)color;
+ (UIColor *)appearanceNavigationBarColor;

///  设置全局的分割线颜色
+ (void)setAppearanceShadowImageColor:(UIColor *)color;
+ (UIColor *)appearanceShadowImageColor;

///  设置全局标题的颜色
+ (void)setAppearanceTitleColor:(UIColor *)color;
+ (UIColor *)appearanceTitleColor;

///  设置指定vc的NavigationBarColor
+ (UIColor *)getNavigationBarColorForVcClass:(Class)vcClass;
+ (void)setNavigationBarColor:(UIColor *)color forVcClass:(Class)vcClass;
+ (void)removeNavigationBarColorForVcClass:(Class)vcClass;

///  设置指定vc的分割线颜色
+ (UIColor *)getShadowImageColorForVcClass:(Class)vcClass;
+ (void)setShadowImageColor:(UIColor *)color forVcClass:(Class)vcClass;
+ (void)removeShadowImageColorForVcClass:(Class)vcClass;

///  设置指定VC的标题颜色
+ (UIColor *)getTitleColorForVcClass:(Class)vcClass;
+ (void)setTitleColor:(UIColor *)color forVcClass:(Class)vcClass;
+ (void)removeTitleColorForVcClass:(Class)vcClass;
@end
