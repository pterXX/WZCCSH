//
//  BindViewController.m
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "BindViewController.h"
#import "BindView.h"
#import "BindViewModel.h"
#import "LoginTripartiteView.h"
#import "LoginTripartiteViewModel.h"
#import "RegisterViewController.h"
#import "ChangePasswordViewController.h"
#import "SelecteAPPIDViewController.h"
#import "XQLoginExample.h"


@interface BindViewController ()
@property (nonatomic, strong) BindView *bindView;
@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = COLOR_FFFFFF;
    [self.view addSubview:self.bindView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"绑定手机号";
}

- (void)xq_bindViewModel{

    @weakify(self);

}

- (void)dealloc{
    MLLog(@"释放了");
}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.bindView.mas_width);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];


    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (BindView *)bindView{
    if (!_bindView) {
        _bindView = [[BindView alloc] initWithViewModel:self.viewModel];
    }
    return _bindView;
}

- (BindViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[BindViewModel alloc] init];
    }
    return _viewModel;
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
