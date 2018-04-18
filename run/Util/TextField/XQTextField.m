///
///  XQTextField.m
///  proj
///
///  Created by asdasd on 2017/12/13.
///  Copyright © 2017年 asdasd. All rights reserved.
///

#import "XQTextField.h"
#import <objc/runtime.h>

#define XQ_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define  AD_BI(value) (XQ_SCREEN_WIDTH / 375 * value)

#define  TEXT_PHONE_ICON @"login_icon_phone"
#define  TEXT_PASSWORD_ICON @"login_icon_password"
#define  TEXT_CODE_ICON @"login_icon_code"
#define  TEXT_ME_ICON @"login_icon_me"
@interface XQTextField ()
///   只有 styleType  等于 XQStylePhone 才会生效
@property (nonatomic ,assign) NSInteger phoneLenght;

///  只有 styleType XQStyleCode 才会生效
@property (nonatomic ,strong) UIButton *codeBtn;
@end

@implementation XQTextField

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.font = [UIFont adjustFont:13];
    [self.textFieldLeftBtn setTop:0];
    [self.textFieldLeftLabel setTop:0];
    [self.textFieldLeftBtn setHeight:self.height];
    [self.textFieldLeftLabel setHeight:self.height];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder style:(XQStyle)style
{
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
        [self setStyleType:style];
    }
    return self;
}

+ (instancetype)textWithPlaceholder:(NSString *)placeholder
{
    return [[XQTextField alloc] initWithPlaceholder:placeholder style:XQStyleNone];
}

+ (instancetype)textWithStyle:(XQStyle)style
{
    return [[XQTextField alloc] initWithPlaceholder:nil style:style];
}




#pragma mark - Getter Methods
- (UILabel *)textFieldLeftLabel
{
    if (_textFieldLeftLabel  == nil)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, AD_BI(60) , self.frame.size.height)];
        label.textColor = [UIColor colorWithRed:3.0f/255.0f green:3.0f/255.0f blue:3.0f/255.0f alpha:1.0f];
        label.font = [UIFont systemFontOfSize:AD_BI(16)];
        _textFieldLeftLabel = label;
    }
    return _textFieldLeftLabel;
}

- (UIButton *)textFieldLeftBtn{
    if (_textFieldLeftBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, AD_BI(40) , self.frame.size.height)];
        _textFieldLeftBtn = btn;
    }
    return _textFieldLeftBtn;
}

- (UITextFieldViewMode)leftModel
{
    return self.leftViewMode;
}

///  在验证码模式下验证码按钮的点击后的回调
- (void (^)(void))codeButtonTapBlcok
{
    return objc_getAssociatedObject(self, _cmd);
}

///  在验证码模式下验证码按钮的取消后的回调
- (void (^)(void))codeButtonCancelBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

///  在验证码模式下验证码按钮的持续禁用时间
- (NSTimeInterval)codeButtonDuration
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

/// 获取处理后的文本
-(NSString *)realText
{
    if (self.styleType ==  XQStylePhone)
    {
        ///  删除全部空格
        return [[super text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return [super text];
}


#pragma mark - Setter Methods

- (void)setIsLeftImg:(BOOL)isLeftImg{
    _isLeftImg = isLeftImg;
    if (isLeftImg) {
        self.leftView = self.textFieldLeftBtn;
        switch (_styleType)
        {
            case XQStylePhone:
                [self.textFieldLeftBtn setImage:[UIImage imageNamed:TEXT_PHONE_ICON] forState:UIControlStateNormal];
                break;
            case XQStylePassword:
                [self.textFieldLeftBtn setImage:[UIImage imageNamed:TEXT_PASSWORD_ICON]forState:UIControlStateNormal];
                break;
            case XQStyleCode:
                [self.textFieldLeftBtn setImage:[UIImage imageNamed:TEXT_CODE_ICON] forState:UIControlStateNormal];
                break;
            case XQStyleNone:
                [self.textFieldLeftBtn setImage:[UIImage imageNamed:TEXT_ME_ICON] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

///  输入框的样式
- (void)setStyleType:(XQStyle)styleType
{
    _styleType = styleType;
    switch (styleType)
    {
        case XQStylePhone:
            [self _phoneStyle];
            break;
        case XQStylePassword:
            [self _passwordStyle];
            break;
        case XQStyleCode:
            [self _codeStyle];
            break;
        case XQStyleEmail:
            [self _emailStyle];
            break;
        case XQStyleURL:
            [self _urlStyle];
            break;
        default:
            break;
    }

    self.isLeftImg = _isLeftImg;
    ///  设置清除按钮
    self.clearButtonMode = UITextFieldViewModeUnlessEditing;

    [self addTarget:self action:@selector(textFieldChangeAction:)   forControlEvents:UIControlEventEditingChanged];
}

- (void)setLeftModel:(UITextFieldViewMode)leftModel
{
    self.leftViewMode = leftModel;
}


/// 设置验证码按钮点击的回调，只有在验证码模式的时候才生效
- (void)codeButtonTime:(NSTimeInterval)time touchUpInsidBlock:(void(^)(void))block cancelBlock:(void(^)(void))cancelBlock
{
    objc_setAssociatedObject(self, @selector(codeButtonTapBlcok), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, @selector(codeButtonCancelBlock), cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, @selector(codeButtonDuration), @(time), OBJC_ASSOCIATION_COPY_NONATOMIC);
}




#pragma mark - Private Methods
/**
 手机样式
 */
- (void)_phoneStyle{
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldLeftLabel.text = @"手机号";
    self.leftView =  self.textFieldLeftLabel;
    self.leftViewMode = self.leftModel;
}

/**
 密码
 */
- (void)_passwordStyle{
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.textFieldLeftLabel.text = @"密码";
    self.leftView =  self.textFieldLeftLabel;
    self.leftViewMode = self.leftModel;

    ///  密码模式
    self.secureTextEntry = YES;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AD_BI(60) , self.frame.size.height)];

    CGFloat buttonSizeWidth = AD_BI(22);
    CGFloat buttonOriginLeft = view.frame.size.width - buttonSizeWidth;
    CGFloat buttonOriginTop = (view.frame.size.height - buttonSizeWidth) /  2;
    self.passwordButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginLeft, buttonOriginTop, buttonSizeWidth, buttonSizeWidth)];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"login_see_hover_icon_22"] forState:UIControlStateSelected];
    [self.passwordButton setBackgroundImage:[UIImage imageNamed:@"login_see_icon_22"] forState:UIControlStateNormal];
    [self.passwordButton addTarget:self action:@selector(passwordModelSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.passwordButton];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordModelSwitch:)]];
    [view setUserInteractionEnabled:YES];

    self.rightView = view;
    if (self.limitLength == 0) {
        self.limitLength = 16;
    }
}



/**
 验证码的样式
 */
- (void)_codeStyle
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldLeftLabel.text = @"验证码";
    self.leftView =  self.textFieldLeftLabel;
    self.leftViewMode = self.leftModel;


    ///  验证码按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, AD_BI(100) , self.frame.size.height);
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_3C74A9 forState:UIControlStateNormal];
    [button setTitleColor:COLOR_999999 forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont adjustFont:13]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button addTarget:self action:@selector(codeButtonEventTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.codeBtn = button;
}


/**
 邮箱的样式
 */
- (void)_emailStyle
{
    self.keyboardType = UIKeyboardTypeEmailAddress;
    self.textFieldLeftLabel.text = @"邮箱";
    self.leftView =  self.textFieldLeftLabel;
    self.leftViewMode = self.leftModel;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
}

/**
 邮箱的样式
 */
- (void)_urlStyle
{
    self.keyboardType = UIKeyboardTypeURL;
    self.textFieldLeftLabel.text = @"URL";
    self.leftView =  self.textFieldLeftLabel;
    self.leftViewMode = self.leftModel;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
}

#pragma mark - Action Methods
- (void)textFieldChangeAction:(XQTextField *)textField
{
    ///  手机号格式化
    if (XQStylePhone ==  textField.styleType)
    {
        if (textField.text.length > self.phoneLenght)
        {
            if (textField.text.length == 4 || textField.text.length == 9 )
            {  ///输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
            }

            if (textField.text.length >= 13 )
            {///输入完成
                textField.text = [textField.text substringToIndex:13];
                [textField resignFirstResponder];
            }
            self.phoneLenght = textField.text.length;

        }else if (textField.text.length < self.phoneLenght)
        {   ///删除
            if (textField.text.length == 4 || textField.text.length == 9)
            {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            self.phoneLenght = textField.text.length;
        }
    }
    else if(XQStylePassword ==  textField.styleType)
    {   ///密码模式
        if (textField.text.length >= self.limitLength )
        {
            textField.text = [textField.text substringToIndex:self.limitLength];
        }

    }else if(XQStyleCode ==  textField.styleType)
    { ///  验证码模式
        if (self.limitLength != 0)
        {  ///   不等于0就限制长度
            textField.text = [textField.text substringToIndex:self.limitLength];
        }
    }
    else if (XQStyleEmail == textField.styleType)
    {
        ///  邮箱模式
        if (self.limitLength != 0)
        {  ///   不等于0就限制长度
            textField.text = [textField.text substringToIndex:self.limitLength];
        }
    }
    else{
        NSLog(@"limitLength  %@",@(self.limitLength));
        ///  其他
        if (self.limitLength != 0 && textField.text.length >= self.limitLength)
        {  ///   不等于0就限制长度
            textField.text = [textField.text substringToIndex:self.limitLength];
        }
    }
}

///  密码按钮，点击后可查看铭文密码
- (void)passwordModelSwitch:(id)sender
{
    ///  切换密码模式
    self.passwordButton.selected = !self.passwordButton.isSelected;
    self.secureTextEntry = !self.passwordButton.isSelected;
    self.text = self.text;
}

///  验证码按钮点击
- (void)codeButtonEventTouchUpInside:(UIButton *)sender
{
    ///  执行验证码按钮点击后的回调
    void(^block)(void) = [self codeButtonTapBlcok];
    if (block) {
        block();
    }

}


#pragma mark -  Public Method
/// 验证码按钮开始计时
- (void)codeBtnBeginKeepTime
{
    if (self.styleType == XQStyleCode)
    {
        self.codeBtn.enabled = NO;
        NSTimeInterval period = 1.0; ///设置时间间隔
        NSTimeInterval duration = [self codeButtonDuration]; ///   获取时间
        __block NSInteger index = duration == 0.0 ? 60:duration;
        dispatch_queue_t queue = dispatch_get_main_queue();

        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); ///每秒执行

        dispatch_source_set_event_handler(_timer, ^{
            ///在这里执行事件
            index -= 1;
            NSString *str = [NSString stringWithFormat:@"%ld秒后重发",index];
            [self.codeBtn setTitle:str forState:UIControlStateDisabled];
            if (index == 0)
            {
                dispatch_cancel(_timer);
                [self.codeBtn setEnabled:YES];

                ///  执行验证码按钮禁用时间结束后的回调
                void(^cancelBlock)(void) = [self codeButtonCancelBlock];
                if (cancelBlock)
                {
                    cancelBlock();
                }
            }
        });
        dispatch_resume(_timer);
    }
}

///  判断是否是邮箱地址,只有在邮箱模式的时候才能正常使用
-(BOOL)isValidateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.text];
}

- (void)setXqText:(NSString *)text
{
    NSMutableString *stext = text.mutableCopy;
    if (self.styleType == XQStylePhone) {
        if (text.length < 11) return;
        [stext insertString:@" " atIndex:3];
        [stext insertString:@" " atIndex:8];
        [super setText:stext];
    }
    else{
        [super setText:text];
    }
}
/*
 /// Only override drawRect: if you perform custom drawing.
 /// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 /// Drawing code
 }
 */

@end
