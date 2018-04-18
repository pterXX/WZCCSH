//
//  ChangePhoneView2.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePhoneView2.h"
#import <YYText.h>
#import "ChangePhoneViewModel.h"
#import "xq_line.h"

@interface ChangePhoneView2()<UITextFieldDelegate>
@property (nonatomic ,strong) ChangePhoneViewModel *viewModel;
@property (nonatomic ,strong) YYLabel *meg1Label;
@property (nonatomic ,strong) YYLabel *meg2Label;
@end
@implementation ChangePhoneView2
- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (ChangePhoneViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.meg1Label];
    [self addSubview:self.meg2Label];
    [self addSubview:self.phoneText];
    [self addSubview:self.codeText];
    [self addSubview:self.sureBtn];

    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{
    RAC(self.viewModel, phone) = self.phoneText.rac_textSignal;
    RAC(self.viewModel, code) = self.codeText.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewModel.nextBtnEnableSignal;

    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self xq_showHUD];
        [[self.viewModel.sureBtnClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            [self xq_hideHUD];
        } error:^(NSError * _Nullable error) {
            [self xq_hideHUD];
        }];
    }];
    self.codeText.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self xq_showHUD];
        [[self.viewModel.sureBtnClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            [self xq_hideHUD];
        } error:^(NSError * _Nullable error) {
            [self xq_hideHUD];
        }];
    }];


    self.codeText.returnKeyType = UIReturnKeyNext;
}


- (void)updateConstraints{

    CGFloat ad_Width = 620.0;
    CGFloat bili = 107.0/ad_Width;
    @weakify(self);
    [self.meg1Label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.height.with.offset(SJAdapter(40));
    }];

    [self.meg2Label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.meg1Label.mas_bottom).with.offset(SJAdapter(20));
        make.height.with.offset(SJAdapter(30));
    }];

    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.meg2Label.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(bili);
    }];

    if ([self viewWithTag:101] == nil) {
        xq_line *line2 =  [[xq_line alloc] init];
        line2.tag = 101;
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.with.offset(0);
            make.top.equalTo(self.phoneText.mas_bottom).with.offset(0);
            make.height.with.offset(1);
        }];
    }


    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(1);
        make.height.equalTo(self.mas_width).with.multipliedBy(bili);
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

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.codeText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];
    [super updateConstraints];
}


#pragma mark - lazyLoad

- (XQTextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[XQTextField alloc] initWithPlaceholder:@"输入手机号" style:XQStylePhone];
        [_phoneText setLeftModel:UITextFieldViewModeAlways];
        _phoneText.isLeftImg = YES;
    }
    return _phoneText;
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


- (YYLabel *)meg1Label{
    if (!_meg1Label) {
        _meg1Label = [YYLabel new];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"输入新的手机号"];
        [text yy_setFont:[UIFont adjustFont:15] range:text.yy_rangeOfAll];//字体
        [text yy_setColor:COLOR_353535 range:text.yy_rangeOfAll];//  颜色
        [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
        _meg1Label.attributedText = text;
    }
    return _meg1Label;
}

- (YYLabel *)meg2Label{
    if (!_meg2Label) {
        _meg2Label = [YYLabel new];
        NSString *phoneStr = @"更换号码后，将使用新的手机号作为联系方式";
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:phoneStr];
        [text yy_setFont:[UIFont adjustFont:13] range:text.yy_rangeOfAll];//字体
        [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
        [text yy_setColor:COLOR_999999 range:text.yy_rangeOfAll];//  颜色
        _meg2Label.attributedText = text;
    }
    return _meg2Label;
}

@end
