//
//  WalletViewModel.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "WalletViewModel.h"

@implementation WalletViewModel

-(void)xq_initialize{
    [self requestData];
}

- (void)requestData{
    @weakify(self);
    [MLHTTPRequest GETWithURL:RUN_TIXIAN_INDEX parameters:nil success:^(MLHTTPRequestResult *result) {
        @strongify(self);
        self.amount = result.data[@"balance"];
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
    } isResponseCache:YES];

    [MLHTTPRequest GETWithURL:CSSH_USER_ACCOUNT_INFO parameters:nil success:^(MLHTTPRequestResult *result) {
        @strongify(self);
        if(result.errcode == 0)
        {
            self.open_id = [result.data objectForKey:@"open_id"];
            self.zfb_account = [result.data objectForKey:@"zfb_account"];
            self.tishi = [result.data objectForKey:@"withdraw_msg"];
        }
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
    } isResponseCache:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
