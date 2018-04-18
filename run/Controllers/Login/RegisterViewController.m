//
//  RegisterViewController.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "RegisterViewController.h"

#import "RegisterView.h"
@interface RegisterViewController ()
@property (nonatomic, strong) RegisterView *registerView;
@property (nonatomic, strong) RegisterViewModel *viewModel;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = COLOR_FFFFFF;
    [self.view addSubview:self.registerView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"注册";
}

- (void)xq_bindViewModel{


}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.registerView.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (RegisterView *)registerView{
    if (!_registerView) {
        _registerView = [[RegisterView alloc] initWithViewModel:self.viewModel];
    }
    return _registerView;
}

- (RegisterViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RegisterViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
