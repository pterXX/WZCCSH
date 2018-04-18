//
//  AliPayTiXianViewController.m
//  run
//
//  Created by asdasd on 2018/4/13.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "AliPayTiXianViewController.h"

#import <YYText.h>
#import "WalletViewController.h"
@interface AliPayTiXianViewController ()
@property (weak, nonatomic) IBOutlet XQButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UILabel *instructions;

@end

@implementation AliPayTiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)xq_addSubViews
{
    [UIFont adjusAllSubViewsFontWithUIScreen:375.0f youView:self.view reulOutViews:@[self.sureBtn,self.amount]];
    self.amount.placeholder = @"请输入提现金额";
    self.amount.keyboardType = UIKeyboardTypePhonePad;
    NSString *str = @"温馨提示:\n1.提现手续费:每笔0.3%(下限2元，上限25元)\n2.余额大于10元才能提现，单笔提现金额不超过2万元";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr yy_setFont:[UIFont adjustFont:12] range:attr.yy_rangeOfAll];
    [attr yy_setColor:COLOR_666666 range:attr.yy_rangeOfAll];
    [attr yy_setLineSpacing:6 range:attr.yy_rangeOfAll];
    self.instructions.numberOfLines = 0;
    self.instructions.preferredMaxLayoutWidth =  SJAdapter(710);
    self.instructions.attributedText = attr;

    @weakify(self);
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self xq_showHUD];
        [[self.viewModel.sureBtnCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            [self xq_hideHUD];
        } error:^(NSError * _Nullable error) {
            [self xq_hideHUD];
        }];
    }];
}

- (void)xq_bindViewModel{
    RAC(self.viewModel,amount) = self.amount.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewModel.sureButtonEnableSignal;

    @weakify(self);
    [self.viewModel.popVCSuject subscribeNext:^(NSNumber  *_Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[WalletViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                    break;
                }
            }

        }
    }];
}

- (void)xq_layoutNavigation{
    self.title = @"支付宝提现";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LazyLoad
- (AliPayViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[AliPayViewModel alloc] init];
    }
    return _viewModel;
}

@end

