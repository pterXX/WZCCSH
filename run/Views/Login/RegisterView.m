//
//  RegisterView.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "RegisterView.h"
#import "xq_line.h"
@interface RegisterView()<UITextFieldDelegate>
@property (nonatomic ,strong) RegisterViewModel *viewModel;
@end

@implementation RegisterView

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (RegisterViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.phoneText];
    [self addSubview:self.codeText];
    [self addSubview:self.nicknameText];
    [self addSubview:self.passwordText];
    [self addSubview:self.registerBtn];

    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{
    RAC(self.viewModel, phone) = self.phoneText.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordText.rac_textSignal;
    RAC(self.viewModel, nickname) = self.nicknameText.rac_textSignal;
    RAC(self.viewModel, code) = self.codeText.rac_textSignal;
    RAC(self.registerBtn, enabled) = self.viewModel.registerBtnEnableSignal;

    @weakify(self);
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        [self.viewModel.registerCommand execute:nil];
    }];
    self.passwordText.delegate = self;
    self.codeText.delegate = self;
    self.nicknameText.delegate = self;
    self.phoneText.delegate = self;

    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.registerCommand execute:nil];
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

    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(1);
        make.height.equalTo(self.phoneText.mas_height);
    }];

    if ([self viewWithTag:102] == nil) {
        xq_line *line2 =  [[xq_line alloc] init];
        line2.tag = 102;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.codeText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.nicknameText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.codeText.mas_bottom).with.offset(1);
        make.height.equalTo(self.phoneText.mas_height);
    }];

    if ([self viewWithTag:103] == nil) {
        xq_line *line3 =  [[xq_line alloc] init];
        line3.tag = 103;
        [self addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.nicknameText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.nicknameText.mas_bottom).with.offset(1);
        make.height.equalTo(self.phoneText.mas_height);
    }];

    if ([self viewWithTag:104] == nil) {
        xq_line *line4 =  [[xq_line alloc] init];
        line4.tag = 104;
        [self addSubview:line4];
        [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.passwordText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.passwordText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];

    [super updateConstraints];
}


#pragma mark - lazyLoad
- (RegisterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[RegisterViewModel alloc] init];
    }
    return _viewModel;
}

- (XQTextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[XQTextField alloc] initWithPlaceholder:@"输入手机号" style:XQStylePhone];
        [_phoneText setLeftModel:UITextFieldViewModeAlways];
        _phoneText.isLeftImg = YES;
    }
    return _phoneText;
}

- (XQTextField *)passwordText{
    if (!_passwordText) {
        _passwordText = [[XQTextField alloc] initWithPlaceholder:@"设置密码" style:XQStylePassword];
        [_passwordText setLeftModel:UITextFieldViewModeAlways];
        _passwordText.isLeftImg = YES;
    }
    return _passwordText;
}

- (XQTextField *)codeText{
    if (!_codeText) {
        _codeText = [[XQTextField alloc] initWithPlaceholder:@"输入验证码" style:XQStyleCode];
        [_codeText setLeftModel:UITextFieldViewModeAlways];

        @weakify(self);
        [_codeText codeButtonTime:60 touchUpInsidBlock:^{
            @strongify(self);
            [[self.viewModel.sendCodeCommand execute:nil] subscribeNext:^(CodeModel *  _Nullable x) {
                if (x.code_name) {
                    [_codeText codeBtnBeginKeepTime];
                }
            }];
        } cancelBlock:^{

        }];
        _codeText.isLeftImg = YES;
    }
    return _codeText;
}

- (XQTextField *)nicknameText{
    if (!_nicknameText) {
        _nicknameText = [[XQTextField alloc] initWithPlaceholder:@"设置昵称" style:XQStyleNone];
        [_nicknameText setLeftModel:UITextFieldViewModeAlways];
        _nicknameText.isLeftImg = YES;
    }
    return _nicknameText;
}

- (XQButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [XQButton buttonWithFrame:CGRectMake(0, 0, 310, 11)];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn.titleLabel setFont:[UIFont adjustFont:17]];
        //        //  设置自动禁用的输入框
        //        [_loginBtn setAutoDisable:YES disableTextFieldArray:@[self.phoneText,self.passwordText]];
    }
    return _registerBtn;
}

@end
