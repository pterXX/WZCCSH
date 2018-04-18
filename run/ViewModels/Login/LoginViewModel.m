//
//  LoginViewModel.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LoginViewModel.h"
#import "XQLoginExample.h"

@implementation LoginViewModel


- (void)xq_initialize{
    self.loginButtonEnableSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, password)] reduce:^id(NSString *phone, NSString *password){
        return @(phone.length && password.length);
    }];

    [self.loginClickCommand.executionSignals.switchToLatest  subscribeNext:^(MLHTTPRequestResult  *_Nullable x) {
        if (x.errcode == 0) {
            //  是跑腿员
            [XQLoginExample pushMainController];
        }else{
            ML_SHOW_MESSAGE(x.errmsg);
        }
    }];

    [self.loginClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([[[x userInfo] allKeys] containsObject:@"msg"]) {
            ML_SHOW_MESSAGE([x userInfo][@"msg"]);
        }
    }];
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


- (RACSubject *)backPassClickSubject{
    if (!_backPassClickSubject) {
        _backPassClickSubject = [RACSubject subject];
    }
    return _backPassClickSubject;
}

- (RACSubject *)registeredClickSubject{
    if (!_registeredClickSubject) {
        _registeredClickSubject = [RACSubject subject];
    }
    return _registeredClickSubject;
}

- (RACSubject *)loginSubject{
    if (!_loginSubject) {
        _loginSubject = [RACSubject subject];
    }
    return _loginSubject;
}

- (NSString *)phone{
    if (_phone == nil) {
        _phone = [XQLoginExample lastPhone];
    }
    return _phone;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
