//
//  ChangePhoneViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePhoneViewController.h"

#import "ChangePhoneView.h"
#import "ChangePhoneView2.h"
#import "UIScrollView+DataEmptyView.h"

@interface ChangePhoneViewController ()
@property (nonatomic, strong) ChangePhoneView *changePhoneView;
@property (nonatomic, strong) ChangePhoneView2 *bindView;
@property (nonatomic ,strong) ChangePhoneViewModel *bindViewModel;
@property (nonatomic ,strong) UIScrollView *scrollView;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = YES;
}

#pragma mark - private
- (void)xq_addSubViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.changePhoneView];
    [self.view addSubview:self.bindView];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

- (void)xq_layoutNavigation{
    self.title = @"更换手机号码";
}

- (void)xq_bindViewModel{
    @weakify(self);


    [self.viewModel.nextBtnClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        // 动画
         self.bindView.hidden = NO;
    }];

    [self.bindViewModel.sureBtnClickSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        self.scrollView.hidden = NO;
        //  显示不同的状态
        [self.scrollView setIsShowDataEmpty:YES emptyViewType:[x boolValue]?DataEmptyViewTypeSuccess:DataEmptyViewTypeFail];
        ///  刷新之前的页面
        if (self.reloadDataBlock) {
            self.reloadDataBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - system
- (void)updateViewConstraints{
    CGFloat m_width = 310.0;
    CGFloat multipliedBy_w = m_width/375.0;
    @weakify(self);
    [self.changePhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.changePhoneView.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(multipliedBy_w);
        make.height.equalTo(self.changePhoneView.mas_width).multipliedBy(1.5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(SJAdapter(80));
    }];

    [super updateViewConstraints];
}

#pragma mark - layzLoad
- (ChangePhoneView *)changePhoneView{
    if (!_changePhoneView) {
        _changePhoneView = [[ChangePhoneView alloc] initWithViewModel:self.viewModel];
        _changePhoneView.hidden = YES;
    }
    return _changePhoneView;
}

- (ChangePhoneView2 *)bindView {
    if (!_bindView) {
        _bindView = [[ChangePhoneView2 alloc] initWithViewModel:self.bindViewModel];
    }
    return _bindView;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.hidden = YES;
    }
    return _scrollView;
}


- (ChangePhoneViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ChangePhoneViewModel alloc] init];
    }
    return _viewModel;
}

- (ChangePhoneViewModel *)bindViewModel {
    if (!_bindViewModel) {
        _bindViewModel = [[ChangePhoneViewModel alloc] init];
    }
    return _bindViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

