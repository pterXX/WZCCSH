//
//  BindView.m
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "BindView.h"
#import "BindViewModel.h"
#import "xq_line.h"
#import "XQLoginExample.h"
@interface BindView()<UITextFieldDelegate>
@property (nonatomic ,strong) BindViewModel *viewModel;
@end

@implementation BindView

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (BindViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}


- (void)xq_setupViews{
    self.userInteractionEnabled = YES;
    [self addSubview:self.phoneText];
     [self addSubview:self.codeText];
    [self addSubview:self.sureBtn];

    //    [self xq_addRecturnKeyBoard];
}

- (void)xq_bindViewModel{

    RAC(self.viewModel, phone) = self.phoneText.rac_textSignal;
    RAC(self.viewModel, code) = self.codeText.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewModel.sureButtonEnableSignal;

    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self xq_showHUD];
        [[self.viewModel.sureClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            [self xq_hideHUD];
        } error:^(NSError * _Nullable error) {
            [self xq_hideHUD];
        }];
    }];
    self.codeText.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        [self.viewModel.sureClickCommand execute:nil];
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
        make.top.equalTo(self.phoneText.mas_bottom).with.offset(2);
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

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.with.offset(0);
        make.top.equalTo(self.codeText.mas_bottom).with.offset(SJAdapter(80));
        make.height.equalTo(self.mas_width).with.multipliedBy(88.0/ad_Width);
    }];

    [super updateConstraints];
}


#pragma mark - lazyLoad
- (BindViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[BindViewModel alloc] init];
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


- (void)dealloc{
    MLLog(@"释放了");
}
@end
