//
//  Other.h
//  city
//
//  Created by 3158 on 2018/2/1.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherKitExample:NSObject
//  绘制水平线线
+ (CAShapeLayer *)createViewHorizontalShapeLayerWithView:(UIView *)view
                                              startPoint:(CGPoint)startPoint
                                                   width:(CGFloat)width;
//  绘制垂直线
+ (CAShapeLayer *)createViewVerticalShapeLayerWithView:(UIView *)view
                                            startPoint:(CGPoint)startPoint
                                                height:(CGFloat)height;

+ (CAShapeLayer *)createViewShapeLayerWithView:(UIView *)view
                                    startPoint:(CGPoint)startPoint
                                      endPoint:(CGPoint)endPoint
                                   strokeColor:(UIColor *)strokeColor;
@end
