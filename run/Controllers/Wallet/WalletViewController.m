//
//  WalletViewController.m
//  running man
//
//  Created by asdasd on 2018/3/30.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "WalletViewController.h"
#import "WeChatViewController.h"
#import "AlipayEditViewController.h"
#import "WalletViewModel.h"
#import "AliPayTiXianViewController.h"
#import "RecordViewController.h"
@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UIView *topAmountBg;
@property (strong ,nonatomic) WalletViewModel *viewModel;
@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel requestData];
}

#pragma mark - XQBassViewControllerProtocol
- (void)xq_addSubViews{
    // 字体大小统一适配
    [UIFont adjusAllSubViewsFontWithUIScreen:375.0 youView:self.view];
    self.amount.font = [UIFont boldSystemFontOfSize:self.amount.font.pointSize];
}

- (void)xq_layoutNavigation{
    self.title = @"我的钱包";
}

- (void)xq_bindViewModel{
    [RACObserve(self.viewModel, amount) subscribeNext:^(NSString  * _Nullable x) {
        self.amount.text = [NSString stringWithFormat:@"￥%.2f",[x floatValue]];
    }];
}

- (void)xq_getNewData{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// NOTE:微信
- (IBAction)weChatTap:(id)sender {
    WeChatViewController *vc = [[WeChatViewController alloc] init];
    vc.viewModel.open_id = self.viewModel.open_id;
    [self.navigationController pushViewController:vc animated:YES];
}
/// NOTE:支付宝
- (IBAction)aliPayTap:(id)sender {
    //  无账号时去绑定
    if (self.viewModel.zfb_account.length == 0) {
        AlipayEditViewController *vc = [[AlipayEditViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //  有账号时去绑定
        AliPayTiXianViewController *vc = [[AliPayTiXianViewController alloc] init];
        vc.viewModel.open_id = self.viewModel.zfb_account;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
/// NOTE:提现记录
- (IBAction)record:(id)sender {

    RecordViewController *vc = [[RecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - LazyLoad
- (WalletViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[WalletViewModel alloc] init];
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
