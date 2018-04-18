//
//  AliPayEditViewModel.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "AliPayEditViewModel.h"
#import "XQLoginExample.h"
@implementation AliPayEditViewModel


- (void)xq_initialize
{
    self.sureButtonEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, phone),RACObserve(self, code),RACObserve(self, name)] reduce:^id(NSString *account,NSString *phone,NSString *code,NSString *name){
        return @(account.length && phone.length && code.length && name.length);
    }];

    @weakify(self);
    [self.sureBtnCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }
        ML_SHOW_MESSAGE(x.errmsg);
        if (x.errcode == 0) {
            self.account = x.data[@"zfb_account"];
            [self.popSuccessSubject sendNext:@(YES)];
        }else{
            [self.popSuccessSubject sendNext:@(NO)];
        }
    }];

    [self.sendCodeCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }
        ML_SHOW_MESSAGE(x.errmsg);
        if (x.errcode == 0) {
            self.code_name = x.data[@"code_name"];
        }
    }];
}

#pragma mark - Private
- (NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.account?:@"",@"zfb_account",self.name?:@"",@"user_name",self.code?:@"",@"code",self.code_name?:@"",@"code_name", nil];
    return params;
}

#pragma mark - LazyLoad
- (RACCommand *)sureBtnCommand{
    if (_sureBtnCommand == nil) {
        _sureBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

                [MLHTTPRequest POSTWithURL:CSSH_BIND_ALIPAY parameters:[self param] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];

        }];
    }
    return _sureBtnCommand;
}


- (RACSubject *)popSuccessSubject{
    if (_popSuccessSubject == nil) {
        _popSuccessSubject = [RACSubject subject];
    }
    return _popSuccessSubject;
}


- (RACCommand *)sendCodeCommand{
    if (!_sendCodeCommand) {
        @weakify(self);
        _sendCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               [XQLoginExample trySmsSendServerWithMobile:self.phone from:@"4" success:^(MLHTTPRequestResult *result) {
                   [subscriber sendNext:result];
                   [subscriber sendCompleted];
               } fail:^(NSError *err) {
                   [subscriber sendNext:nil];
                   [subscriber sendCompleted];
               }];
                return nil;
            }];

        }];
    }
    return _sendCodeCommand;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation AliPayViewModel

- (void)xq_initialize
{
    self.sureButtonEnableSignal = [RACSignal combineLatest:@[RACObserve(self, amount)] reduce:^id(NSString *amount){
        return @(amount.length);
    }];

    @weakify(self);
    [self.weChatBtnBindSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);

        ///  跳转到微信授权
        [ShareUtil LoginExampleWithPlatform:SSDKPlatformTypeWechat success:^(SSDKUser *user) {
            [MLHTTPRequest POSTWithURL:RUN_BIND_WECHAT parameters:@{@"open_id":user.uid?:@""} success:^(MLHTTPRequestResult *result) {
                if (result.errcode == NO) {
                    self.open_id = user.uid;
                    ML_SHOW_MESSAGE(@"绑定成功");
                }else{
                    ML_SHOW_MESSAGE(@"绑定失败");
                }
            } failure:^(NSError *error) {
                ML_SHOW_MESSAGE(@"绑定失败");
            }];
        } fail:^(NSError *error) {
            ML_SHOW_MESSAGE(@"绑定失败");
        }];
    }];

    [self.sureBtnCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }
        ML_SHOW_MESSAGE(x.errmsg);
        if (x.errcode == 0) {
            [self.popVCSuject sendNext:@(YES)];
        }else{

            [self.popVCSuject sendNext:@(NO)];
        }
    }];
}

#pragma mark - LazyLoad
- (BOOL)is_bind{
    return self.open_id.length > 0;
}

- (RACSubject *)weChatBtnBindSubject{
    if (_weChatBtnBindSubject == nil) {
        _weChatBtnBindSubject = [RACSubject subject];
    }
    return _weChatBtnBindSubject;
}

- (RACSubject *)popVCSuject{
    if (_popVCSuject == nil) {
        _popVCSuject = [RACSubject subject];
    }
    return _popVCSuject;
}


- (RACCommand *)sureBtnCommand{
    if (_sureBtnCommand == nil) {
        _sureBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"pay_type",self.amount?:@"0",@"cash", nil];
                [MLHTTPRequest POSTWithURL:RUN_GET_APPLY_WITHDRAWALS parameters:dict success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _sureBtnCommand;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
