//
//  JMCircleAnimationView.m
//  AnimationButton
//
//  Created by Jimmy on 16/6/15.
//  Copyright © 2016年 Jimmy. All rights reserved.
//

#import "JMCircleAnimationView.h"

@interface JMCircleAnimationView ()

@property (nonatomic, assign) CGFloat timeFlag;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, nonnull ,  strong) CAShapeLayer *progressLayer;
@end
@implementation JMCircleAnimationView

+(instancetype)viewWithButton:(UIButton *)button{
    JMCircleAnimationView* animationView = [[JMCircleAnimationView alloc] init];
    
    animationView.frame = CGRectMake(8, 8, button.frame.size.width - 16, button.frame.size.height - 16);
    animationView.backgroundColor = [UIColor clearColor];
    animationView.borderColor = button.titleLabel.textColor;
    animationView.timeFlag = 0;
    return animationView;
}

#define ANIMATION 2
#if ANIMATION == 1
-(void)removeFromSuperview{
    [self.progressLayer removeAllAnimations];
    [self.progressLayer removeFromSuperlayer];
    [super removeFromSuperview];
}
-(void)startAnimation{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.autoreverses = YES;
    pathAnimation.duration = 1;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = CGFLOAT_MAX;
    pathAnimation.fillMode = kCAFillModeForwards;
    [self.progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

- (CAShapeLayer *)progressLayer
{
    if (_progressLayer == nil) {
        //2. 圆环
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.strokeColor = self.borderColor.CGColor;
        progressLayer.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0].CGColor;
        progressLayer.lineCap   = kCALineCapRound;
        progressLayer.lineJoin  = kCALineJoinBevel;
        progressLayer.lineWidth = 2.0;
        progressLayer.strokeEnd = 0.0;

        CGPoint _viewCenter = (CGPoint){self.bounds.size.width/2, self.bounds.size.height/2};
        UIBezierPath *progressCircle = [UIBezierPath bezierPath];
        [progressCircle addArcWithCenter:_viewCenter radius:self.bounds.size.height/2 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
        progressLayer.path = progressCircle.CGPath;
        [self.layer addSublayer:progressLayer];
        _progressLayer = progressLayer;
    }
    return _progressLayer;
}
#else
-(void)removeFromSuperview{
    [self.timer invalidate];
    self.timer = nil;
    self.timeFlag = 0;
    [super removeFromSuperview];
    [super removeFromSuperview];
}
-(void)startAnimation{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(continueAnimation) userInfo:nil repeats:YES];
        [self.timer fire];
}

-(void)continueAnimation{
    self.timeFlag += 0.02;
    [self setNeedsDisplay];
}

-(void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

-(void)drawRect:(CGRect)rect{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = rect.size.width / 2 - 2;
    CGFloat start = - M_PI_2 + self.timeFlag * 2*M_PI;
    CGFloat end = -M_PI_2 + 0.45 * 2 * M_PI  + self.timeFlag * 2 *M_PI;

    [path addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];

    [self.borderColor setStroke];
    path.lineWidth = 1.5;

    [path stroke];
}
#endif
@end
