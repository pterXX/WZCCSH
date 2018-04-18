//
//  LoginTripartiteView.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LoginTripartiteView.h"
#import "LoginTripartiteViewModel.h"
#import "UIButton+Layout.h"
#import "xq_line.h"
@interface LoginTripartiteView()
@property (nonatomic ,strong) UIButton *weChatBtn;
@property (nonatomic ,strong) UIButton *qqBtn;
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic ,strong) LoginTripartiteViewModel *viewModel;
@end

@implementation LoginTripartiteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel{
    self.viewModel = (LoginTripartiteViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

-(void)xq_bindViewModel{
}

- (void)xq_setupViews{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont adjustFont:12];
    label.text = @"第三方登录";
    label.textColor = COLOR_999999;
    label.backgroundColor = COLOR_FFFFFF;
    [self addSubview:label];
    self.label = label;

    [self addSubview:self.weChatBtn];
    [self addSubview:self.qqBtn];

    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[self class]]] setTitleColor:COLOR_999999 forState:UIControlStateNormal];

    @weakify(self);
    [[self.weChatBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.weChatBtn.enabled = NO;
        [[self.viewModel.wechatClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            self.weChatBtn.enabled = YES;
        }];
    }];

    [[self.qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.qqBtn.enabled = NO;
        [[self.viewModel.qqClickCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            self.qqBtn.enabled = YES;
        }];
    }];
}

#pragma mark - system
- (void)updateConstraints{

    @weakify(self);
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.mas_width).with.multipliedBy(108.0f/310);
        make.height.offset(SJAdapter(24));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self.mas_centerX);
    }];

    if ([self viewWithTag:101] == nil) {
        xq_line *line1 =  [[xq_line alloc] init];

        line1.tag = 101;
        [self addSubview:line1];
        [self bringSubviewToFront:self.label];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
             @strongify(self);
            make.left.and.right.with.offset(0);
            make.centerY.equalTo(self.label.mas_centerY);
            make.height.with.offset(1);
        }];
    }

    NSArray *array = @[self.weChatBtn,self.qqBtn];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SJAdapter(64) leadSpacing:SJAdapter(183) tailSpacing:SJAdapter(183)];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
      make.height.with.offset(SJAdapter(160));
      make.top.equalTo(self.mas_top).with.offset(SJAdapter(64));
    }];
    [super updateConstraints];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.weChatBtn setImgePosition:UIButtonImagePositionTop spacer:SJAdapter(24)];
    [self.qqBtn setImgePosition:UIButtonImagePositionTop spacer:SJAdapter(24)];
}


#pragma mark - lazyload
- (UIButton *)weChatBtn{
    if (!_weChatBtn) {
        _weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weChatBtn setImage:Img(@"login_icon_wechat") forState:UIControlStateNormal];
        [_weChatBtn setTitle:@"微信" forState:UIControlStateNormal];
        [_weChatBtn.titleLabel setFont:[UIFont adjustFont:12]];
    }
    return _weChatBtn;
}

- (UIButton *)qqBtn{
    if (!_qqBtn) {
        _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqBtn setImage:Img(@"login_icon_qq") forState:UIControlStateNormal];
        [_qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
        [_qqBtn.titleLabel setFont:[UIFont adjustFont:12]];
    }
    return _qqBtn;
}


@end
