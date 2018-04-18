//
//  xq_KeyboardView.h
//  zhPopupController
//
//  Created by zhanghao on 2017/9/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xqUnderlineTextField : UITextField

@property (nonatomic, strong) UIColor *underlineColor;

@end

@interface xq_KeyboardView : UIView

@property (nonatomic, copy) void (^nextClickedBlock)(xq_KeyboardView *keyboardView, UIButton *button);
@property (nonatomic, copy) void (^loginClickedBlock)(xq_KeyboardView *keyboardView);

@property (nonatomic, strong) xqUnderlineTextField *numberField;
@property (nonatomic, strong) xqUnderlineTextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) NSArray<UIButton *> *buttons;

@end

@interface xq_KeyboardView2 : UIView

@property (nonatomic, copy) void (^gobackClickedBlock)(xq_KeyboardView2 *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) xqUnderlineTextField *numberField;
@property (nonatomic, strong) xqUnderlineTextField *codeField;
@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *gobackButton;

@end

@interface xq_KeyboardView3 : UIView

@property (nonatomic, copy) void (^senderClickedBlock)(xq_KeyboardView3 *keyboardView, UIButton *button);

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *senderButton;


//  显示输入框
+ (void)showKeyboardView:(NSString *)text
             placeholder:(NSString *)placeholder
            keyboardType:(UIKeyboardType)kbType
      senderClickedBlock:(void(^)(NSString *textStr))block;
@end
