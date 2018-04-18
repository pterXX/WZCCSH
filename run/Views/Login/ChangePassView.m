//
//  ChangePassView.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePassView.h"
#import "xq_line.h"
#import <YYText.h>
@interface ChangePassView()<UITextFieldDelegate>
@property (nonatomic ,strong) ChangePasswordViewModel *viewModel;

@end

@implementation ChangePassView

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (ChangePasswordViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.oPassText];
    [self addSubview:self.nPassText];
    [self addSubview:self.sPassText];
    [self addSubview:self.sureBtn];


    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{
    RAC(self.viewModel, oPass) = self.oPassText.rac_textSignal;
    RAC(self.viewModel, nPass) = self.nPassText.rac_textSignal;
    RAC(self.viewModel, sPass) = self.sPassText.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewModel.sureBtnEnableSignal;

    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ///  确认按钮点击
        [self.viewModel.sureBtnClickSubject sendNext:nil];

    }];
    self.sPassText.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
         ///  确认按钮点击
        [self.viewModel.sureBtnClickSubject sendNext:nil];
    }];
    self.sPassText.returnKeyType = UIReturnKeySend;
}


- (void)updateConstraints{

    CGFloat ad_Width = 620.0;
    CGFloat bili = 107.0/ad_Width;
    @weakify(self);
    [self.oPassText mas_makeConstraints:^(MASConstraintMaker *make) {
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
            make.top.equalTo(self.oPassText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.nPassText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.oPassText.mas_bottom).with.offset(1);
        make.height.equalTo(self.oPassText.mas_height);
    }];

    if ([self viewWithTag:102] == nil) {
        xq_line *line2 =  [[xq_line alloc] init];
        line2.tag = 102;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.nPassText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.sPassText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.nPassText.mas_bottom).with.offset(1);
        make.height.equalTo(self.oPassText.mas_height);
    }];

    if ([self viewWithTag:103] == nil) {
        xq_line *line3 =  [[xq_line alloc] init];
        line3.tag = 103;
        [self addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.sPassText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.sPassText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];
    [super updateConstraints];
}


#pragma mark - lazyLoad
- (ChangePasswordViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ChangePasswordViewModel alloc] init];
    }
    return _viewModel;
}

- (XQTextField *)oPassText{
    if (!_oPassText) {
        _oPassText = [[XQTextField alloc] initWithPlaceholder:@"输入原密码" style:XQStylePassword];
        [_oPassText setLeftModel:UITextFieldViewModeAlways];
        _oPassText.isLeftImg = YES;
    }
    return _oPassText;
}

- (XQTextField *)nPassText{
    if (!_nPassText) {
        _nPassText = [[XQTextField alloc] initWithPlaceholder:@"输入新密码" style:XQStylePassword];
        [_nPassText setLeftModel:UITextFieldViewModeAlways];
        _nPassText.isLeftImg = YES;
    }
    return _nPassText;
}


- (XQTextField *)sPassText{
    if (!_sPassText) {
        _sPassText = [[XQTextField alloc] initWithPlaceholder:@"确认新密码" style:XQStylePassword];
        [_sPassText setLeftModel:UITextFieldViewModeAlways];
        _sPassText.isLeftImg = YES;
    }
    return _sPassText;
}

- (XQButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [XQButton buttonWithFrame:CGRectMake(0, 0, 310, 11)];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont adjustFont:17]];
        //        //  设置自动禁用的输入框
        //        [_loginBtn setAutoDisable:YES disableTextFieldArray:@[self.phoneText,self.passwordText]];
    }
    return _sureBtn;
}

@end
