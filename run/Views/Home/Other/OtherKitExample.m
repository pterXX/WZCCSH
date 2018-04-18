//
//  Other.m
//  city
//
//  Created by 3158 on 2018/2/1.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "OtherKitExample.h"

@interface OtherKitExample ()

@end

@implementation OtherKitExample

//  绘制水平线线
+ (CAShapeLayer *)createViewHorizontalShapeLayerWithView:(UIView *)view
                                              startPoint:(CGPoint)startPoint
                                                   width:(CGFloat)width
{
    return [self createViewShapeLayerWithView:view startPoint:startPoint endPoint:CGPointMake(startPoint.x + width, startPoint.y)  strokeColor:[UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f]];
}

//  绘制垂直线
+ (CAShapeLayer *)createViewVerticalShapeLayerWithView:(UIView *)view
                                            startPoint:(CGPoint)startPoint
                                                height:(CGFloat)height
{
    return [self createViewShapeLayerWithView:view startPoint:startPoint endPoint:CGPointMake(startPoint.x, startPoint.y + height)  strokeColor:[UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f]];
}

+ (CAShapeLayer *)createViewShapeLayerWithView:(UIView *)view
                                    startPoint:(CGPoint)startPoint
                                      endPoint:(CGPoint)endPoint
                                   strokeColor:(UIColor *)strokeColor
{
    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:startPoint];
    // 其他点
    [linePath addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = 0.5;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    [view.layer addSublayer:lineLayer];
    return lineLayer;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
