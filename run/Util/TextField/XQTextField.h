//
//  XQTextField.h
//  proj
//
//  Created by asdasd on 2017/12/13.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

// 样式
typedef enum : NSUInteger {
    XQStyleNone = 0, //  无样式
    XQStylePhone, //  手机号
    XQStylePassword, //  密码
    XQStyleCode, //  验证码
    XQStyleEmail, //  邮箱
    XQStyleURL //  邮箱
} XQStyle;

@interface XQTextField : UITextField

//   左侧label
@property (nonatomic ,strong) UILabel * textFieldLeftLabel;
@property (nonatomic ,strong) UIButton * textFieldLeftBtn;

 //  输入框样式
@property (nonatomic ,assign) XQStyle styleType;

//  这个设置会影响 leftViewMode ，
@property (nonatomic ,assign) UITextFieldViewMode leftModel;
//  是否是图片, YES  leftViewModel 就会是图片，否者是label
@property (nonatomic ,assign) BOOL isLeftImg;

// 限制长度  密码模式,默认16位  ,手机和验证码，邮箱模式无法使用该属性
@property (nonatomic ,assign) NSInteger limitLength;

//   只有 styleType  等于 XQStylePassword 才会生效
@property (nonatomic ,strong) UIButton *passwordButton;

//   取值的时候用这个属性，使用text 取值可能会有其他字符
@property (nonatomic ,strong) NSString *realText;

- (instancetype)initWithPlaceholder:(NSString *)placeholder style:(XQStyle)style;

+ (instancetype)textWithPlaceholder:(NSString *)placeholder;

+ (instancetype)textWithStyle:(XQStyle)style;


/**
 开始计时，只有在验证码模式的时候才生效
 */
- (void)codeBtnBeginKeepTime;

/**
 设置验证码按钮点击的回调，只有在验证码模式的时候才生效

 @param time 验证码按钮持续禁用的时间
 @param block 点击后的回调
 @param cancelBlock 取消后的回调
 */
- (void)codeButtonTime:(NSTimeInterval)time touchUpInsidBlock:(void(^)(void))block cancelBlock:(void(^)(void))cancelBlock ;

/**
 判断是否是邮箱地址,只有在邮箱模式的时候才能正常使用
 */
-(BOOL)isValidateEmail;

/**
 建议使用这种方法赋值838
 */
- (void)setXqText:(NSString *)setXqText;
@end
