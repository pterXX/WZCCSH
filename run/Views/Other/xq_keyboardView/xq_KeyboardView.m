//
//  xq_KeyboardView.m
//  zhPopupController
//
//  Created by zhanghao on 2017/9/13.
//  Copyright © 2017年 snail-z. All rights reserved.
//

#import "xq_KeyboardView.h"
#import "zhPopupController.h"

@implementation xqUnderlineTextField

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = _underlineColor ?: [UIColor darkGrayColor];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGRect fillRect = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
    CGContextFillRect(context,fillRect);
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
    [self setNeedsDisplay];
}

@end


@implementation xq_KeyboardView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SJAdapter(16);
        
        _numberField = [[xqUnderlineTextField alloc] init];
        _numberField.font = [UIFont systemFontOfSize:17];
        _numberField.underlineColor = [UIColor grayColor];
        _numberField.placeholder = @" 请输入手机号";
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginuser"]];
        imgView.contentMode = UIViewContentModeCenter;
        _numberField.leftView = imgView;
        _numberField.leftViewMode = UITextFieldViewModeAlways;
        _numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _numberField.keyboardType = UIKeyboardTypeDefault;
        [_numberField becomeFirstResponder];
        [self addSubview:_numberField];
        
        _passwordField = [[xqUnderlineTextField alloc] init];
        _passwordField.font = [UIFont systemFontOfSize:17];
        _passwordField.underlineColor = [UIColor grayColor];
        _passwordField.placeholder = @" 输入密码";
        [_passwordField setSecureTextEntry:YES];
        UIImageView *imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginpswd"]];
        imgView2.contentMode = UIViewContentModeCenter;
        _passwordField.leftView = imgView2;
        _passwordField.leftViewMode = UITextFieldViewModeAlways;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberField.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:_passwordField];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = RGB(246, 246,246, 1.0);
        _loginButton.layer.borderColor = [UIColor grayColor].CGColor;
        _loginButton.layer.borderWidth = 0.5;
        _loginButton.layer.cornerRadius = SJAdapter(16);
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self addSubview:_loginButton];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.userInteractionEnabled = YES;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerButton setTitleColor: [UIColor hexString:@"569EED"] forState:UIControlStateNormal];
        [_registerButton setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
        [_registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_registerButton];
        
        __block NSMutableArray *buttons = @[].mutableCopy;
        NSArray *array = @[@"loginsina", @"loginqq", @"loginfacebook"];
        [array enumerateObjectsUsingBlock:^(NSString *imgName, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeCenter;
            button.size = CGSizeMake(30, 30);
            [self addSubview:button];
            [buttons addObject:button];
        }];
        _buttons = buttons;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (self.width - 40), height = 35, spacing = 17;
    
    _numberField.size = CGSizeMake(width, height);
    _numberField.top = 20;
    _numberField.centerX = self.width / 2;
    
    _passwordField.size = _numberField.size;
    _passwordField.top = _numberField.bottom + spacing;
    _passwordField.centerX = self.width / 2;
    
    _loginButton.size = CGSizeMake(width, 40);
    _loginButton.centerX = self.width / 2;
    _loginButton.top = _passwordField.bottom + spacing + 5;
    
    _registerButton.size = CGSizeMake(70, 30);
    _registerButton.top = _loginButton.bottom + 27;
    _registerButton.right = self.width - 20;
    
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.top = _registerButton.top;
        button.left = (button.width + 10) * idx + 20;
    }];
}

- (void)loginButtonClicked:(UIButton *)sender {
    if (self.loginClickedBlock) {
        self.loginClickedBlock(self);
    }
}

- (void)registerClicked:(UIButton *)sender {
    if (self.nextClickedBlock) {
        self.nextClickedBlock(self, sender);
    }
}

@end


@implementation xq_KeyboardView2

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = SJAdapter(16);
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"注册账号";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _numberField = [[xqUnderlineTextField alloc] init];
        _numberField.font = [UIFont systemFontOfSize:17];
        _numberField.underlineColor = [UIColor grayColor];
        _numberField.placeholder = @" 输入手机号";
        _numberField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _numberField.keyboardType = UIKeyboardTypeNumberPad;
        [_numberField becomeFirstResponder];
        [self addSubview:_numberField];
        
        _codeField = [[xqUnderlineTextField alloc] init];
        _codeField.font = [UIFont systemFontOfSize:17];
        _codeField.underlineColor = [UIColor grayColor];
        _codeField.placeholder = @" 输入验证码";
        _codeField.clearButtonMode=UITextFieldViewModeWhileEditing;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_codeField];
        
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor: [UIColor hexString:@"569EED"] forState:UIControlStateNormal];
        [_codeButton setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
        [self addSubview:_codeButton];
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.backgroundColor = RGB(246, 246, 246, 1.0);
        _nextButton.layer.borderColor = [UIColor grayColor].CGColor;
        _nextButton.layer.borderWidth = 0.5;
        _nextButton.layer.cornerRadius = SJAdapter(16);
        _nextButton.layer.masksToBounds = YES;
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gobackButton.userInteractionEnabled = YES;
        [_gobackButton setImage:[UIImage imageNamed:@"loginback"] forState:UIControlStateNormal];
        [_gobackButton addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_gobackButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = (self.width - 40), height = 35, spacing = 17;
    _numberField.size = CGSizeMake(width, height);
    _numberField.top = 55;
    _numberField.centerX = self.width / 2;
    
    _codeField.size = _numberField.size;
    _codeField.width /= 2;
    _codeField.top = _numberField.bottom + spacing;
    _codeField.left = 20;
    
    _codeButton.size = _codeField.size;
    _codeButton.top = _codeField.top;
    _codeButton.left = _codeField.width + 10;
    
    _nextButton.size = CGSizeMake(width, 40);
    _nextButton.centerX = self.width / 2;
    _nextButton.top = _codeField.bottom + spacing + 5;
    
    _gobackButton.size = CGSizeMake(30, 30);
    _gobackButton.origin = CGPointMake(20, 10);
    
    _titleLabel.size = CGSizeMake(70, 30);
    _titleLabel.top = 10;
    _titleLabel.centerX = self.width / 2;
}

- (void)nextClicked:(UIButton *)sender {
    [self endEditing:YES];
}

- (void)goBackClicked:(UIButton *)sender {
    if (self.gobackClickedBlock) {
        self.gobackClickedBlock(self, sender);
    }
}

@end


@interface xq_KeyboardView3()<UITextFieldDelegate>
@end

@implementation xq_KeyboardView3

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACKGRORD;
        
        _textField = [[UITextField alloc] init];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.placeholder = @" 请输入你的评论内容";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = SJAdapter(16);
        _textField.layer.borderWidth = 0.5;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.backgroundColor = [UIColor lightTextColor];
        _textField.tintColor = [UIColor hexString:@"569EED"];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField becomeFirstResponder];
        [self addSubview:_textField];
        
        _senderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _senderButton.userInteractionEnabled = YES;
//        [_senderButton setImage:[UIImage imageNamed:@"sender"] forState:UIControlStateNormal];
        [_senderButton setTitle:@"完成" forState:UIControlStateNormal];
        [_senderButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        [_senderButton addTarget:self action:@selector(senderClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _senderButton.imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_senderButton];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    if (self.senderClickedBlock) {
        self.senderClickedBlock(self, self.senderButton);
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.height - 20;
    CGFloat padding = 15;
    
    _senderButton.size = CGSizeMake(height, height);
    _senderButton.right = self.width - padding;
    _senderButton.centerY = self.height / 2;
    
    CGFloat spacing = 15;
    _textField.height = height;
    _textField.width = self.width - 2 * padding - _senderButton.width - spacing;
    _textField.left = 20;
    _textField.centerY = self.height / 2;
}

- (void)senderClicked:(UIButton *)sender {
    if (self.senderClickedBlock) {
        self.senderClickedBlock(self, sender);
    }
}


+ (void)showKeyboardView:(NSString *)text
             placeholder:(NSString *)placeholder
            keyboardType:(UIKeyboardType)kbType
      senderClickedBlock:(void(^)(NSString *textStr))block{
    CGRect rect = CGRectMake(0, 0, KWIDTH, 60);
    xq_KeyboardView3 *kbview = [[xq_KeyboardView3 alloc] initWithFrame:rect];
    kbview.textField.text = text;
    kbview.textField.placeholder = placeholder;
    kbview.textField.keyboardType = kbType;
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    kbview.senderClickedBlock = ^(xq_KeyboardView3 *keyboardView, UIButton *button) {
        block(keyboardView.textField.text);
        [rootVc.zh_popupController dismiss];
    };

    rootVc.zh_popupController = [zhPopupController new];
    rootVc.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    //    self.zh_popupController.offsetSpacingOfKeyboard = 30; // 可以设置与键盘之间的间距
    [rootVc.zh_popupController presentContentView:kbview duration:0.25 springAnimated:NO];
}
@end
