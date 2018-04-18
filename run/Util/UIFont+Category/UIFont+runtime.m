//
//  UIFont+runtime.m
//  字体大小适配-runtime
//
//  Created by 刘龙 on 2017/3/23.
//  Copyright © 2017年 xixhome. All rights reserved.
//

#import "UIFont+runtime.h"
#import <objc/runtime.h>
@implementation UIFont (runtime)
//+(void)load{
//    //获取替换后的类方法
//    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
//    //获取替换前的类方法
//    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
//    //然后交换类方法
//    method_exchangeImplementations(newMethod, method);
//}
//
//
//+(UIFont *)adjustFont:(CGFloat)fontSize{
//    UIFont *newFont=nil;
//    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/YourUIScreen];
//    return newFont;
//}

//  适配字体
+(UIFont *)adjustFont:(CGFloat)fontSize{
    UIFont *newFont=nil;
    objc_setAssociatedObject(self, _cmd, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    newFont = [UIFont systemFontOfSize:fontSize * [UIScreen mainScreen].bounds.size.width/YourUIScreen];
    return newFont;
}


//  指定的视图下子视图适配字体
+ (void)adjusFontWithSubViews:( NSArray<UIView *> * _Nonnull )subViews uiScreen:(CGFloat)youUIScreen
{
    [subViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self adjusAllSubViewsFontWithUIScreen:youUIScreen youView:obj];
    }];

}


//  适配一个视图下所有子视图的字体
+ (void)adjusAllSubViewsFontWithUIScreen:(CGFloat)youUIScreen youView:(UIView *)youView
{
    [UIFont adjusAllSubViewsFontWithUIScreen:youUIScreen youView:youView reulOutViews:nil];
}

//  除了排除的视图，其他的子视图都自动适应字体大小
+ (void)adjusAllSubViewsFontWithUIScreen:(CGFloat)youUIScreen
                                 youView:(UIView *)youView
                            reulOutViews:(NSArray <UIView *>*)reulOutViews
{
    CGFloat bili = [UIScreen mainScreen].bounds.size.width/youUIScreen;
    for (UIView *subView in youView.subviews)
    {
        if (reulOutViews && [reulOutViews containsObject:subView])
        {
            continue;
        }

        if ([subView isKindOfClass:[UIButton class]] == NO)
        {
            if ([subView isKindOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel *)subView;
                UIFont *font  = label.font;
                label.font = [UIFont systemFontOfSize:font.pointSize * bili];
            }else if([subView isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)subView;
                UIFont *font  = textField.font;
                textField.font = [UIFont systemFontOfSize:font.pointSize * bili];
                if (textField.leftView)
                {
                    [self adjusAllSubViewsFontWithUIScreen:youUIScreen youView:textField.leftView reulOutViews:reulOutViews];
                }
                else if (textField.rightView)
                {
                    [self adjusAllSubViewsFontWithUIScreen:youUIScreen youView:textField.rightView reulOutViews:reulOutViews];
                }
            }else if([subView isKindOfClass:[UITextView class]])
            {
                UITextView *text = (UITextView *)subView;
                UIFont *font  = text.font;
                text.font = [UIFont systemFontOfSize:font.pointSize * bili];
            }else{
                [self adjusAllSubViewsFontWithUIScreen:youUIScreen youView:subView reulOutViews:reulOutViews];
            }
        }else{
            UIButton *button = (UIButton *)subView;
            UIFont *font  = button.titleLabel.font;
            button.titleLabel.font = [UIFont systemFontOfSize:font.pointSize * bili];
        }
    }
}



@end
