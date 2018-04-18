//
//  WeChatViewController.m
//  running man
//
//  Created by asdasd on 2018/3/31.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "WeChatViewController.h"
#import <YYText.h>
#import "UIScrollView+DataEmptyView.h"
@interface WeChatViewController ()
@property (weak, nonatomic) IBOutlet XQButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UILabel *instructions;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation WeChatViewController

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
    [self.scrollView setDataEmptyBtnTapedBlock:^{
        @strongify(self);
        [self.viewModel.weChatBtnBindSubject sendNext:nil];
    }];

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
    [RACObserve(self.viewModel,open_id) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
         [self.scrollView setIsShowDataEmpty:self.viewModel.is_bind == NO emptyViewType:DataEmptyViewTypeWeChat];
    }];

    [self.viewModel.popVCSuject subscribeNext:^(NSNumber  *_Nullable x) {
         @strongify(self);
        if ([x boolValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    }];
}

- (void)xq_layoutNavigation{
    self.title = @"微信提现";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - LazyLoad
- (WeCharViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[WeCharViewModel alloc] init];
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
