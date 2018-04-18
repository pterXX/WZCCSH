//
//  xq_CloseButton.m
//  proj
//
//  Created by asdasd on 2017/12/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "xq_CloseButton.h"

@implementation xq_CloseButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGFloat radius = w / 2.0;

    self.backgroundColor = [UIColor grayColor];
    self.layer.backgroundColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);

    CGFloat cw = 4;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    CGContextMoveToPoint(context, w / cw , h / cw);
    CGContextAddLineToPoint(context, w / cw * 3, h /cw * 3);
    CGContextMoveToPoint(context, w / cw, h / cw * 3);
    CGContextAddLineToPoint(context, w / cw * 3, h / cw);
    CGContextAddPath(context, bezierPath.CGPath);

    CGContextSetLineWidth(context, 0.75f);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}

@end
