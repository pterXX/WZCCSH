//
//  UIViewController+Public.m
//  proj
//
//  Created by asdasd on 2017/12/10.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIViewController+Public.h"
#import <objc/runtime.h>

@implementation UIViewController (Public)
//#pragma mark - ************* 通过运行时动态替换方法 ******************
//+ (void)load {
//
//    MethodSwizzle(self,@selector(viewDidLoad),@selector(override_viewDidLoad));
//}
//
//void MethodSwizzle(Class c,SEL origSEL,SEL overrideSEL)
//{
//    Method origMethod = class_getInstanceMethod(c, origSEL);
//    Method overrideMethod= class_getInstanceMethod(c, overrideSEL);
//
//    //运行时函数class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用:
//    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod)))
//    {
//        //如果添加成功(在父类中重写的方法)，再把目标类中的方法替换为旧有的实现:
//        class_replaceMethod(c,overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
//    }
//    else
//    {
//        //addMethod会让目标类的方法指向新的实现，使用replaceMethod再将新的方法指向原先的实现，这样就完成了交换操作。
//        method_exchangeImplementations(origMethod,overrideMethod);
//    }
//}
//
//- (void)override_viewDidLoad{
//    [self override_viewDidLoad];
//    self.view.backgroundColor = COLOR_BACKGRORD;
//}


- (UIActivityIndicatorView *)xq_activityIndicatorView
{
    if (objc_getAssociatedObject(self, _cmd) == nil)
    {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0)];
        [indicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
//        indicator.hidden = YES;
        objc_setAssociatedObject(self, _cmd, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:indicator];
    }
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)xq_isAnimating
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


- (void)xq_startAnimatingWithIsHideSubViews:(BOOL)isHideSubViews
{

    if (self.xq_activityIndicatorView.isAnimating == YES)
    {
        return;
    }
    [self.view bringSubviewToFront:self.xq_activityIndicatorView];
    objc_setAssociatedObject(self, @selector(xq_isAnimating), @(self.xq_activityIndicatorView.isAnimating), OBJC_ASSOCIATION_RETAIN);
    self.xq_activityIndicatorView.hidden = NO;
    [self.xq_activityIndicatorView startAnimating];
    if (isHideSubViews)
    {
        //  如果是第一次加载数据，那么就不隐藏子视图
        if ([objc_getAssociatedObject(self, @"isFisrt") boolValue] == YES)
        {
            return;
        }
        //  只有第一次加载的时候才会隐藏所有子视图
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             if ([obj isKindOfClass:[UIActivityIndicatorView class]] == NO)
             {
                 obj.hidden = YES;
                 obj.alpha = 0.0;
             }
         }];

        //  是否第一次加载
        objc_setAssociatedObject(self, @"isFisrt", @(YES), OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)xq_stopAnimating
{
    [self.xq_activityIndicatorView stopAnimating];
    objc_setAssociatedObject(self, @selector(xq_isAnimating), @(self.xq_activityIndicatorView.isAnimating), OBJC_ASSOCIATION_RETAIN);
    //  显示全部子视图
    [UIView animateWithDuration:0.2 animations:^{
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIActivityIndicatorView class]] == NO)
            {
                obj.hidden = NO;
                obj.alpha = 1.0;
            }
        }];
    } completion:^(BOOL finished) {
        self.xq_activityIndicatorView.hidden = YES;
    }];
}
@end
