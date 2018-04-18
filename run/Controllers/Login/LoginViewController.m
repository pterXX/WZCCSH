//
//  LoginViewController.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "LoginViewModel.h"
#import "LoginTripartiteView.h"
#import "LoginTripartiteViewModel.h"
#import "RegisterViewController.h"
#import "ChangePasswordViewController.h"
#import "SelecteAPPIDViewController.h"
#import "XQLoginExample.h"
#import "BindViewController.h"
#import "ForgotPasswordViewController.h"
#import "BaiduLocationService.h"

@interface LoginViewController ()
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginViewModel *viewModel;
@property (nonatomic, strong) LoginTripartiteView *tripartiteView;
@property (nonatomic, strong) LoginTripartiteViewModel *tripartiteViewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([XQLoginExample lastCityCode].length == 0) {
        [BaiduLocationService openLocationServiceWithBlock:^(bool isOpen) {
            CustomNavigationViewController *nav = [[CustomNavigationViewController alloc] initWithRootViewController:[[SelecteAPPIDViewController alloc] init]];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }];
    }
}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = COLOR_FFFFFF;
    [self.view addSubview:self.loginView];
    [self.view addSubview:self.tripartiteView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"登录";
}

- (void)xq_bindViewModel{

     @weakify(self);
    [self.viewModel.registeredClickSubject subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [self.viewModel.backPassClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ForgotPasswordViewController *vc = [[ForgotPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [self.tripartiteViewModel.bindPhoneSubject subscribeNext:^(NSDictionary * _Nullable x) {
        BindViewController *vc = [[BindViewController alloc] init];
        vc.viewModel.bind_id = x[@"bind_id"];
        vc.viewModel.type = [x[@"type"] integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)dealloc{
    MLLog(@"释放了");
}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.loginView.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [self.tripartiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
    make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
    make.height.equalTo(self.tripartiteView.mas_width).with.multipliedBy(128/m_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (LoginView *)loginView{
    if (!_loginView) {
        _loginView = [[LoginView alloc] initWithViewModel:self.viewModel];
    }
    return _loginView;
}

- (LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

- (LoginTripartiteView *)tripartiteView{
    if (!_tripartiteView) {
        _tripartiteView = [[LoginTripartiteView alloc] initWithViewModel:self.tripartiteViewModel];
    }
    return _tripartiteView;
}

- (LoginTripartiteViewModel *)tripartiteViewModel {
    if (!_tripartiteViewModel) {
        _tripartiteViewModel = [[LoginTripartiteViewModel alloc] init];
    }
    return _tripartiteViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
