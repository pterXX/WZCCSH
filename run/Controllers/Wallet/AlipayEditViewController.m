//
//  AlipayViewController.m
//  running man
//
//  Created by asdasd on 2018/3/31.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "AlipayEditViewController.h"
#import <YYText.h>
#import "AliPayTiXianViewController.h"
#import "XQLoginExample.h"
@interface AlipayEditViewController ()

@property (weak, nonatomic) IBOutlet XQButton *sureBtn;
@property (weak, nonatomic) IBOutlet XQTextField *phoneText;
@property (weak, nonatomic) IBOutlet XQTextField *codeText;
@property (weak, nonatomic) IBOutlet XQTextField *nameText;
@property (weak, nonatomic) IBOutlet XQTextField *accountText;
@property (weak, nonatomic) IBOutlet UILabel *instructions;

@end

@implementation AlipayEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)xq_addSubViews
{

    [UIFont adjusAllSubViewsFontWithUIScreen:375.0f youView:self.view reulOutViews:@[self.sureBtn,self.nameText,self.phoneText,self.accountText,self.codeText]];
    self.phoneText.placeholder = @"请输入手机号";
    self.phoneText.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneText.text = [XQLoginExample lastPhone];

    self.codeText.placeholder = @"请输入验证码";
    self.codeText.keyboardType = UIKeyboardTypePhonePad;
    self.accountText.placeholder = @"请输入您的支付宝账号";
    self.accountText.keyboardType = UIKeyboardTypeASCIICapable;

    self.nameText.placeholder = @"请输入您的姓名";

    [self.phoneText setStyleType:XQStylePhone];
    self.phoneText.clearButtonMode = UITextFieldViewModeNever;
    self.phoneText.leftModel = UITextFieldViewModeAlways;
    [self.codeText setStyleType:XQStyleCode];

    NSString *str = @"温馨提示:\n为了不影响你的正常提现，请确保你已经通过支付宝的实名认证";
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

    [self.codeText codeButtonTime:60 touchUpInsidBlock:^{
        @strongify(self);
        [self.viewModel.sendCodeCommand execute:nil];
    } cancelBlock:^{

    }];

    [self xq_addRecturnKeyBoard];
}


- (void)xq_layoutNavigation{
    self.title = @"支付宝绑定";
}

- (void)xq_bindViewModel{
    RAC(self.viewModel,phone) = self.phoneText.rac_textSignal;
    RAC(self.viewModel,code) = self.codeText.rac_textSignal;
    RAC(self.viewModel,name) = self.nameText.rac_textSignal;
    RAC(self.viewModel,account) = self.accountText.rac_textSignal;
    RAC(self.sureBtn, enabled) = self.viewModel.sureButtonEnableSignal;

    @weakify(self);
    [self.viewModel.popSuccessSubject subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            AliPayTiXianViewController *vc = [[AliPayTiXianViewController alloc] init];
            vc.viewModel.open_id = self.viewModel.account;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)xq_addRecturnKeyBoard{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
    }];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - LazyLoad
- (AliPayEditViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[AliPayEditViewModel alloc] init];
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
