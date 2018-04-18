//
//  UIView+Category.h
//  proj
//
//  Created by asdasd on 2017/11/8.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+nib.h"
#import "UIView+EqualMargin.h"
//#import "UIFont+runtime.h"

@interface UIView (Category)

- (void)adaptSizeSubViewsYouUIScreenWidth:(CGFloat)width;
- (NSArray *)allProperties:(UIView *)view;


/**
 隐藏所有视图
 */
- (void)hideAllSubView;

/**
 显示所有视图
 */
- (void)showAllSubView;


+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint;



//  查找父视图 TableView
- (UITableView *)xq_parentTableView;

/**
 查找父视图

 @param parentClassStr 父视图的类名
 @return 当前查找到的俯父视图
 */
- (id)xq_parentView:(NSString *)parentClassStr;



/**
 通过 CAShapeLayer 方式绘制虚线

 @param lineLength 虚线的宽度
 @param lineSpacing  虚线的间距
 @param lineColor  虚线的颜色
 @param width 虚线的宽度
 @param startPoint 起点
 @param endPoint 终点
 */
- (void)drawLineOfDashByCAShapeLayerLineLength:(int)lineLength
                                   lineSpacing:(int)lineSpacing
                                     lineColor:(UIColor *)lineColor
                                         width:(CGFloat)width
                                    startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint ;
@end
