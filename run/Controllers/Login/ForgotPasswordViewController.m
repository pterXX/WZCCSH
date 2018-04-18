//
//  ForgotPasswordViewController.m
//  running man
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ForgotPasswordViewController.h"

#import "ForgotPasswordView.h"
#import "FindPasswordView.h"
#import "FindPasswordViewModel.h"
@interface ForgotPasswordViewController ()
@property (nonatomic, strong) ForgotPasswordView *forgotPasswordView;
@property (nonatomic, strong) FindPasswordView *findPasswordView;
@property (nonatomic, strong) FindPasswordViewModel *findViewModel;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = COLOR_FFFFFF;
    [self.view addSubview:self.forgotPasswordView];
    [self.view addSubview:self.findPasswordView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"忘记密码";
}

- (void)xq_bindViewModel{
    @weakify(self);
    [self.viewModel.nextSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        // 动画
        self.findPasswordView.hidden = NO;
        self.findViewModel.token_key = x;
        [UIView animateWithDuration: 1.0 animations:^{
            //
            self.forgotPasswordView.transform = CGAffineTransformMakeTranslation(- KWIDTH, 0);
            self.findPasswordView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.forgotPasswordView.hidden = YES;
        }];
    }];

    [self.findViewModel.successSubject subscribeNext:^(id  _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.forgotPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.forgotPasswordView.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [self.findPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.forgotPasswordView.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (ForgotPasswordView *)forgotPasswordView{
    if (!_forgotPasswordView) {
        _forgotPasswordView = [[ForgotPasswordView alloc] initWithViewModel:self.viewModel];
    }
    return _forgotPasswordView;
}

- (ForgotPasswordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ForgotPasswordViewModel alloc] init];
    }
    return _viewModel;
}

- (FindPasswordView *)findPasswordView{
    if (!_findPasswordView) {
        _findPasswordView = [[FindPasswordView alloc] initWithViewModel:self.findViewModel];
        _findPasswordView.hidden = YES;
        _findPasswordView.transform = CGAffineTransformMakeTranslation(KWIDTH, 0);
    }
    return _findPasswordView;
}

- (FindPasswordViewModel *)findViewModel {
    if (!_findViewModel) {
        _findViewModel = [[FindPasswordViewModel alloc] init];
    }
    return _findViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

