//
//  ChangePasswordViewController.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordViewModel.h"


@interface ChangePasswordViewController ()
@property (nonatomic, strong) ChangePassView *changePassnView;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = COLOR_FFFFFF;
    [self.view addSubview:self.changePassnView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"修改密码";
}

- (void)xq_bindViewModel{
    
}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.changePassnView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.changePassnView.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (ChangePassView *)changePassnView{
    if (!_changePassnView) {
        _changePassnView = [[ChangePassView alloc] initWithViewModel:self.viewModel];
    }
    return _changePassnView;
}

- (ChangePasswordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ChangePasswordViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
