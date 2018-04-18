//
//  LoginTripartiteViewModel.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LoginTripartiteViewModel.h"
#import "XQLoginExample.h"

@implementation LoginTripartiteViewModel


- (void)xq_initialize
{
    @weakify(self);
    [[self.wechatClickCommand.executionSignals.switchToLatest takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self bindSendNext:x type:0];
    }];

    [self.wechatClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_SHOW_MESSAGE(@"登录失败");
    }];

    [[self.qqClickCommand.executionSignals.switchToLatest takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self bindSendNext:x type:1];
    }];

    [self.qqClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_SHOW_MESSAGE(@"登录失败");
    }];
}

- (void)bindSendNext:(NSDictionary *)x type:(NSInteger)type{
    if ([x[@"status"] intValue] == 1) {
         [XQLoginExample pushMainController];
    }else{
        [self.bindPhoneSubject sendNext:@{@"bind_id":x[@"bind_id"]?:@"",@"type":@(type)}];
        [self.bindPhoneSubject sendCompleted];
    }
}

- (RACCommand *)wechatClickCommand{
    if (!_wechatClickCommand) {
        _wechatClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [XQLoginExample weChatLoginWithSuccess:^(NSInteger status, NSString *bind_id) {
                    [subscriber sendNext:@{@"status":@(status),@"bind_id":bind_id?:@""}];
                    [subscriber sendCompleted];
                } fail:^(NSError *error) {
                    [subscriber sendError:[XQLoginExample loginError:[NSMutableDictionary dictionary]]];
                }];
                return nil;
            }];
        }];
    }
    return _wechatClickCommand;
}

- (RACCommand *)qqClickCommand{
    if (!_qqClickCommand) {
        _qqClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [XQLoginExample qqLoginWithSuccess:^(NSInteger status, NSString *bind_id) {
                    [subscriber sendNext:@{@"status":@(status),@"bind_id":bind_id?:@""}];
                    [subscriber sendCompleted];
                } fail:^(NSError *error) {
                    [subscriber sendError:[XQLoginExample loginError:[NSMutableDictionary dictionary]]];
                }];
                return nil;
            }];

        }];
    }
    return _qqClickCommand;
}

- (RACSubject *)bindPhoneSubject{
    if (_bindPhoneSubject == nil) {
        _bindPhoneSubject = [RACSubject subject];
    }
    return _bindPhoneSubject;
}

- (RACSubject *)loginSuccessSubject{
    if (_loginSuccessSubject == nil) {
        _loginSuccessSubject = [RACSubject subject];
    }
    return _loginSuccessSubject;
}
@end
