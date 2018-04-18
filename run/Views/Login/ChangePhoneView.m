//
//  ChangePhoneView.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePhoneView.h"
#import <YYText.h>
#import "ChangePhoneViewModel.h"
#import "xq_line.h"

@interface ChangePhoneView()<UITextFieldDelegate>
@property (nonatomic ,strong) ChangePhoneViewModel *viewModel;
@property (nonatomic ,strong) YYLabel *meg1Label;
@property (nonatomic ,strong) YYLabel *meg2Label;
@end
@implementation ChangePhoneView
- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (ChangePhoneViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.meg1Label];
    [self addSubview:self.meg2Label];
    [self addSubview:self.codeText];
    [self addSubview:self.nextBtn];

    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{
    RAC(self.viewModel, code) = self.codeText.rac_textSignal;
    RAC(self.nextBtn, enabled) = self.viewModel.nextBtnEnableSignal;

    @weakify(self);
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self xq_showHUD];
        [[self.viewModel.nextBtnClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            [self xq_hideHUD];
        } error:^(NSError * _Nullable error) {
            [self xq_hideHUD];
        }];
    }];
    self.codeText.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.nextBtnClickCommand execute:nil];
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


    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.meg2Label.mas_bottom).with.offset(SJAdapter(80));
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

    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.codeText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];
    [super updateConstraints];
}


#pragma mark - lazyLoad


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


- (XQButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [XQButton buttonWithFrame:CGRectMake(0, 0, 310, 11)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn.titleLabel setFont:[UIFont adjustFont:17]];
        //        //  设置自动禁用的输入框
        //        [_loginBtn setAutoDisable:YES disableTextFieldArray:@[self.phoneText,self.passwordText]];
    }
    return _nextBtn;
}


- (YYLabel *)meg1Label{
    if (!_meg1Label) {
        _meg1Label = [YYLabel new];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"更换手机号码需验证你的身份"];
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
        NSString *phone = [self.viewModel.phone replaceStringWithAsteriskStartLocation:3 lenght:6];
        NSString *phoneStr = [NSString stringWithFormat:@"验证码将发送到%@",phone];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:phoneStr];
        [text yy_setFont:[UIFont adjustFont:13] range:text.yy_rangeOfAll];//字体
        [text yy_setAlignment:NSTextAlignmentCenter range:text.yy_rangeOfAll];
        [text yy_setColor:COLOR_999999 range:text.yy_rangeOfAll];//  颜色
        _meg2Label.attributedText = text;
    }
    return _meg2Label;
}

@end
