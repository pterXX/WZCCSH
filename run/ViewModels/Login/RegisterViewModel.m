//
//  RegisterViewModel.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "RegisterViewModel.h"
#import "XQLoginExample.h"
@implementation RegisterViewModel


- (void)xq_initialize{
    self.registerBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, password),RACObserve(self, code),RACObserve(self,nickname),] reduce:^id(NSString *phone, NSString *password,NSString *code ,NSString *nickname){
        return @(phone.length && password.length && code.length&& nickname.length);
    }];

    @weakify(self);
    [self.registerCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *_Nullable x) {
        @strongify(self);
        if ([x[@"status"] boolValue]) {
            [self.loginClickCommand execute:nil];
        }else{
            ML_SHOW_MESSAGE(x[@"msg"]);
        }
    }];

    [[self.sendCodeCommand.executionSignals.switchToLatest takeUntil:self.rac_willDeallocSignal] subscribeNext:^(CodeModel  *_Nullable x) {
        @strongify(self);
        NSString *code_name = x.code_name;
        NSString *msg = x.msg;
        self.code_name = code_name;
        [MessageToast showMessage:msg];
    }];

    [self.sendCodeCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [MessageToast showMessage:@"网络出了一点小问题,请稍后再试"];
    }];

    [[self.loginClickCommand.executionSignals.switchToLatest takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MLHTTPRequestResult  *_Nullable x) {
        if (x.errcode == 0) {
            [XQLoginExample pushMainController];
        }else{
        }
    }];

    [self.loginClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([[[x userInfo] allKeys] containsObject:@"msg"]) {
            ML_SHOW_MESSAGE([x userInfo][@"msg"]);
        }
    }];

}

- (RACCommand *)registerCommand{
    if (!_registerCommand) {
        @weakify(self);
        _registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample registerServer:self.phone password:self.password nickname:self.nickname code:self.code code_name:self.code_name];
        }];
    }
    return _registerCommand;
}

- (RACCommand *)loginClickCommand{
    if (!_loginClickCommand) {
        @weakify(self);
        _loginClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);

            //  登录接口
            return [XQLoginExample loginServer:self.phone password:self.password];
        }];
    }
    return _loginClickCommand;
}


- (RACCommand *)sendCodeCommand{
    if (!_sendCodeCommand) {
        @weakify(self);
        _sendCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample registerSmsSendServerWithMobile:self.phone];
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
