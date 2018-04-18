//
//  MessageToast.m
//  cyb
//
//  Created by sjw-mac on 15/4/21.
//  Copyright (c) 2015年 sjw-mac. All rights reserved.
//

#import "MessageToast.h"

@implementation MessageToast
{
    NSTimer *timer;
   BOOL _keyBoardlsVisible;
}

/*!
 *  @brief 初始化
 */
- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHue:0/255.0 saturation:0/255.0 brightness:0/255.0 alpha:1.0];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:14.0];
        self.alpha = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self setHidden:YES];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        CGRect rect = window.bounds;
        
        CGSize size = [self.text sizeWithAttributes:@{@"NSFontAttributeName":self.font}];
        CGRect frame = self.frame;
        frame.size.width  = size.width;
        frame.size.height = 44;
        frame.origin = CGPointMake((rect.size.width - size.width)/2, rect.size.height * 0.5);
        self.frame = frame;
    }
    return self;
}

/*!
 *  @brief 提示框单利方法
 */
+ (id)sharedToast
{
    static MessageToast *toast = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        toast = [[self alloc] init];
    });
    return toast;
}


#pragma mark - 使用方法
/*!
 *  @brief 显示提示信息的方法
 *  @param message  需要显示的信息
 */
+ (void)showMessage:(NSString *)message
{
    MessageToast *toast = [self sharedToast];
    toast.text = message;
    [toast show];
}

#pragma mark - 实现方法
/*!
 *  @brief 显示提示框的方法
 */
- (void)show
{

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = window.bounds;

    CGSize size = [self.text sizeWithAttributes:@{@"NSFontAttributeName":self.font}];
    CGRect frame = self.frame;
    frame.size.width = size.width + 50;

    UIView *first = [MessageToast firstResponder];
    //  防止键盘遮挡
    if ([first isKindOfClass:[UITextField class]] || [first isKindOfClass:[UITextView class]]){
         frame.origin = CGPointMake((rect.size.width - frame.size.width)/2, rect.size.height * 0.4);
    }else{
         frame.origin = CGPointMake((rect.size.width - frame.size.width)/2, rect.size.height * 0.5);
    }
    self.frame = frame;

    if (self.isHidden) {
        [self setHidden:NO];
        [UIView animateWithDuration:(NSTimeInterval)0.25 animations:^{
            self.alpha = 0.9;
        }];
    }else
    {
        //  如果没有隐藏就证明已经显示在视图上了
        return;
    }

    [self performSelector:@selector(hide) withObject:nil afterDelay:2];
}

/*!
 *  @brief 隐藏提示框
 */
- (void)hide
{
    [UIView animateWithDuration:(NSTimeInterval)0.25 animations:^{
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}


+ (UIView *)firstResponder{
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    return firstResponder;
}

@end

@implementation AlertMessage
+ (void)showMessage:(NSString *)msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
@end
