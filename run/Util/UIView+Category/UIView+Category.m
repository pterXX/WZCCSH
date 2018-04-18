//
//  UIView+Category.m
//  proj
//
//  Created by asdasd on 2017/11/8.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIView+Category.h"
//#import "UIFont+runtime.h"
#import <objc/runtime.h>

@implementation UIView (Category)
- (void)adaptSizeSubViewsYouUIScreenWidth:(CGFloat)width{

//    //  只调用一次 防止重复调用导致视图错乱
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        NSArray<UIView *> *views = self.subviews;

        NSArray *classArray = @[@"UIImageView",@"UILabel",@"UITextField",@"UITextView",@"UIScrollView",@"UITableView",@"UITableView",@"UICollectionView",@"UIButton",@"UIView"];

        CGFloat bili = [UIScreen mainScreen].bounds.size.width  / (width + 0.0);
        for (UIView *subView in views) {
            BOOL ys = NO;
            for (NSString *clsStr in classArray) {
                if ([subView isKindOfClass:NSClassFromString(clsStr)]) {
                    ys = YES;
                    break;
                }
            }
            if (ys) {
                CGRect frame = subView.frame;
                CGFloat height = frame.size.height;
                if (frame.size.height <= 1.0) {
                }else{
                    height = frame.size.height * bili;
                }
                subView.frame = CGRectMake(frame.origin.x * bili, frame.origin.y * bili, frame.size.width * bili, height);
                //            subView.frame = CGRectMake(100, 100, 100, 100);
                CGFloat cornerRadius = subView.layer.cornerRadius;
                if (cornerRadius > 0) {
                    subView.layer.cornerRadius = bili * cornerRadius;
                }
                if (subView.subviews.count > 0) {
                    [subView adaptSizeSubViewsYouUIScreenWidth:width];
                }
            }

            NSArray *allProperties = [self allProperties:subView];

            //设置字体大小
            if ([allProperties containsObject:@"font"]) {
                UIFont *font = [subView valueForKey:@"font"];
                if (font) {
                    [subView setValue:[UIFont systemFontOfSize:bili * font.pointSize] forKey:@"font"];
                }

            }
            allProperties = nil;

            //        }else if([subView isKindOfClass:[UILabel class]]){
            //
            //        }else  if([subView isKindOfClass:[UITextField class]]){
            //
            //        }else  if([subView isKindOfClass:[UITextView class]]){
            //
            //        }else  if([subView isKindOfClass:[UIScrollView class]]){
            //
            //        }else  if([subView isKindOfClass:[UITableView class]]){
            //
            //        }else if([subView isKindOfClass:[UICollectionView class]]){
            //
            //        }else{
            //
            //        }
            
        }
//    });
}



- (NSArray *)allProperties:(UIView *)view{
    unsigned int count;

    // 获取类的所有属性
    // 如果没有属性，则count为0，properties为nil
    objc_property_t *properties = class_copyPropertyList([view class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];

    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        [propertiesArray addObject:name];
    }
    
    // 注意，这里properties是一个数组指针，是C的语法，
    // 我们需要使用free函数来释放内存，否则会造成内存泄露
    free(properties);
    
    return propertiesArray;
}


/**
 隐藏所有视图
 */
- (void)hideAllSubView{
    for (UIView *view in self.subviews) {
        view.alpha = 0.0;
    }
}

/**
 显示所有视图
 */
- (void)showAllSubView{
    CGFloat count = 1.0 / self.subviews.count;
    for (UIView *view in self.subviews) {
        [UIView animateWithDuration:count animations:^{
            view.alpha = 1.0;
        }];
    }
}


//  渐变色
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];

    return gradientLayer;
}

//  查找父视图 TableView
- (UITableView *)xq_parentTableView
{
    return [self xq_parentView:@"UITableView"];
}


/**
 查找父视图

 @param parentClassStr 父视图的类名
 @return 当前查找到的俯父视图
 */
- (id)xq_parentView:(NSString *)parentClassStr
{
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;

    do {
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:NSClassFromString(parentClassStr)]) {
            return next;
        }

        next = next.nextResponder;

    }while(next != nil);
    
    return nil;
}

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
                                    startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {


    // 线的路径
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    // 起点
    [linePath moveToPoint:startPoint];
    // 其他点
    [linePath addLineToPoint:CGPointMake(endPoint.x, endPoint.y)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineWidth = width;
    lineLayer.strokeColor = lineColor.CGColor;
    lineLayer.path = linePath.CGPath;
    [lineLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线宽度
    [lineLayer setLineWidth:width];
    [lineLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [lineLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
     lineLayer.path = linePath.CGPath;
    
    [self.layer addSublayer:lineLayer];
}


@end
