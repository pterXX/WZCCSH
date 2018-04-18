//
//  LoginView.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LoginView.h"
#import "xq_line.h"
#import <YYText.h>
#import "XQLoginExample.h"
@interface LoginView()<UITextFieldDelegate>
@property (nonatomic ,strong) LoginViewModel *viewModel;

@property (nonatomic ,strong) YYLabel *registeredText;
@property (nonatomic ,strong) YYLabel *backPassText;
@end

@implementation LoginView

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (LoginViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.phoneText];
    [self addSubview:self.passwordText];
    [self addSubview:self.loginBtn];
    [self addSubview:self.registeredText];
    [self addSubview:self.backPassText];

//    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{
    self.phoneText.text = self.viewModel.phone;
    self.passwordText.text = self.viewModel.password;

    RAC(self.viewModel, phone) = self.phoneText.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordText.rac_textSignal;
    RAC(self.loginBtn, enabled) = self.viewModel.loginButtonEnableSignal;

    @weakify(self);


    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self loginClick];
    }];
    self.passwordText.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self loginClick];
    }];

}


- (void)loginClick{
    [self xq_showHUD];
    [[self.viewModel.loginClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        [self xq_hideHUD];
    } error:^(NSError * _Nullable error) {
        [self xq_hideHUD];
    }];
}

- (void)updateConstraints{

    CGFloat ad_Width = 620.0;
    CGFloat bili = 107.0/ad_Width;
    @weakify(self);
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.equalTo(self.mas_width).with.multipliedBy(bili);
    }];

    if ([self viewWithTag:101] == nil) {
        xq_line *line1 =  [[xq_line alloc] init];
        line1.tag = 101;
        [self addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.phoneText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(2);
        make.height.equalTo(self.phoneText.mas_height);
    }];

    if ([self viewWithTag:102] == nil) {
        xq_line *line2 =  [[xq_line alloc] init];
        line2.tag = 102;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.passwordText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.passwordText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];

    [self.registeredText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(0);
        make.width.offset(100);
        make.height.with.offset(SJAdapter(80));
    }];

    [self.backPassText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.with.offset(0);
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(0);
        make.height.with.offset(SJAdapter(80));
        make.width.offset(100);
    }];
    [super updateConstraints];
}


#pragma mark - lazyLoad
- (LoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

- (XQTextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[XQTextField alloc] initWithPlaceholder:@"手机号/城市生活账号" style:XQStylePhone];
        [_phoneText setLeftModel:UITextFieldViewModeAlways];
        _phoneText.isLeftImg = YES;
    }
    return _phoneText;
}

- (XQTextField *)passwordText{
    if (!_passwordText) {
        _passwordText = [[XQTextField alloc] initWithPlaceholder:@"密码" style:XQStylePassword];
        [_passwordText setLeftModel:UITextFieldViewModeAlways];
        _passwordText.isLeftImg = YES;
    }
    return _passwordText;
}

- (XQButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [XQButton buttonWithFrame:CGRectMake(0, 0, 310, 11)];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont adjustFont:17]];
//        //  设置自动禁用的输入框
//        [_loginBtn setAutoDisable:YES disableTextFieldArray:@[self.phoneText,self.passwordText]];
    }
    return _loginBtn;
}

- (YYLabel *)registeredText{
    if (!_registeredText) {
        _registeredText = [YYLabel new];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"注册账号"];
        [text yy_setFont:[UIFont adjustFont:13] range:text.yy_rangeOfAll];//字体
        [text yy_setColor:COLOR_3C74A9 range:text.yy_rangeOfAll];//  颜色
        _registeredText.attributedText = text;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self.viewModel.registeredClickSubject sendNext:nil];
        }];
        [_registeredText addGestureRecognizer:tap];
    }
    return _registeredText;
}

- (YYLabel *)backPassText{
    if (!_backPassText) {
        _backPassText = [YYLabel new];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
        [text yy_setFont:[UIFont adjustFont:13] range:text.yy_rangeOfAll];//字体
        [text yy_setAlignment:NSTextAlignmentRight range:text.yy_rangeOfAll];
        [text yy_setColor:COLOR_999999 range:text.yy_rangeOfAll];//  颜色
        _backPassText.attributedText = text;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        @weakify(self);
        [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self);
            [self.viewModel.backPassClickSubject sendNext:nil];
        }];
        [_backPassText addGestureRecognizer:tap];
    }
    return _backPassText;
}

- (void)dealloc{
    MLLog(@"释放了");
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
