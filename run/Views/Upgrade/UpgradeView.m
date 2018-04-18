//
//  UpgradeView.m
//  running man
//
//  Created by asdasd on 2018/4/3.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UpgradeView.h"
#import <zhPopupController.h>

@implementation UpgradeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xq_setupViews];
    }
    return self;
}

- (void)xq_setupViews{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8;
    self.bassImg = [[UIImageView alloc] init];
    self.bassImg.image = [UIImage imageNamed:@"upgrade_bg"];
    [self addSubview:self.bassImg];

    self.titleLabel = [YYLabel new];
    [self addSubview:self.titleLabel];

    self.detailLabel = [YYLabel new];
    self.detailLabel.numberOfLines = 0;
    [self addSubview:self.detailLabel];

    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureBtn setBackgroundColor:RGB(255, 153, 40, 1.0)];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [self.sureBtn.titleLabel setFont:[UIFont adjustFont:18]];
    [self.sureBtn.layer setCornerRadius:SJAdapter(6)];
    [self.sureBtn.layer setMasksToBounds:YES];
    [self addSubview:self.sureBtn];

    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setImage:[UIImage imageNamed:@"upgrade_close@3x"] forState:UIControlStateNormal];
    [self addSubview:self.closeBtn];
    [self sendSubviewToBack:self.closeBtn];


     @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        !self.sureBtnTapBlock?:self.sureBtnTapBlock();
    }];

    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        !self.closeBtnTapBlock?:self.closeBtnTapBlock();
    }];




    [self.bassImg mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.and.offset(0);
        make.top.offset(- SJAdapter(80));
        make.height.equalTo(self.bassImg.mas_width).multipliedBy(805.0/550.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(SJAdapter(470));
        make.centerX.equalTo(self.bassImg.mas_centerX);
        make.top.equalTo(self.bassImg.mas_top).offset(SJAdapter(350));
    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(SJAdapter(470));
        make.centerX.equalTo(self.bassImg.mas_centerX);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SJAdapter(60));
    }];

    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(SJAdapter(400));
        make.centerX.equalTo(self.bassImg.mas_centerX);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(SJAdapter(100));
        make.height.equalTo(self.sureBtn.mas_width).multipliedBy(44.0/200.0);
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.sizeOffset(CGSizeMake(24,48));
        make.right.equalTo(self.bassImg.mas_right).with.offset( - SJAdapter(20));
        make.bottom.equalTo(self.mas_top).offset(0);
    }];

    self.width = SJAdapter(550);
    self.height = SJAdapter(705);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat max_h = self.sureBtn.bottom + SJAdapter(30);
    self.height = max_h;
}



+ (void)show:(NSString *)title info:(NSString *)info trackViewUrl:(NSString *)trackViewUrl
{
    UpgradeView *v = [[UpgradeView alloc] init];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"最新版本:V%@",title]];
    [attr yy_setColor:COLOR_353535 range:attr.yy_rangeOfAll];
    [attr yy_setFont:[UIFont adjustFont:15] range:attr.yy_rangeOfAll];
    v.titleLabel.attributedText = attr;

    NSMutableAttributedString *attrInfo = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"更新内容:\n%@",info]];
    [attrInfo yy_setColor:COLOR_666666 range:attrInfo.yy_rangeOfAll];
    [attrInfo yy_setFont:[UIFont adjustFont:15] range:attrInfo.yy_rangeOfAll];
    [attrInfo yy_setLineSpacing:5 range:attrInfo.yy_rangeOfAll];
    v.detailLabel.attributedText = attrInfo;

    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [v setSureBtnTapBlock:^{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:trackViewUrl]]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
            }
        }
        [vc.zh_popupController dismiss];
    }];

    [v setCloseBtnTapBlock:^{
        [vc.zh_popupController dismiss];
    }];




//    [pView setShareViewSuccessBlock:success];

    vc.zh_popupController = [zhPopupController new];
    vc.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    vc.zh_popupController.dismissOnMaskTouched = YES;
    //    vc.zh_popupController.allowPan = YES;
    [vc.zh_popupController presentContentView:v];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
