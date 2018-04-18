//
//  ForgotPasswordViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ForgotPasswordViewModel.h"
#import "XQLoginExample.h"

@implementation ForgotPasswordViewModel

- (void)xq_initialize{
    self.nextBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, code)] reduce:^id(NSString *phone, NSString *code){
        return @(phone.length && code.length);
    }];

    @weakify(self);
    [self.nextBtnClickCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult *  _Nullable x) {
        @strongify(self);
        if (x) {
            ML_SHOW_MESSAGE(x.errmsg);
            if (x.errcode == 0) {
                [self.nextSubject sendNext:x.data[@"token_key"]];
                [self.nextSubject sendCompleted];
            }
        }else {
            ML_MESSAGE_NETWORKING;
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
}

- (RACCommand *)nextBtnClickCommand{
    if (!_nextBtnClickCommand) {
        @weakify(self);
        _nextBtnClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample checkPasswordServer:self.phone code:self.code code_name:self.code_name];
        }];
    }
    return _nextBtnClickCommand;
}

- (RACCommand *)sendCodeCommand{
    if (!_sendCodeCommand) {
        @weakify(self);
        _sendCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample forgotPasswordSmsSendServerWithMoble:self.phone];
        }];
    }
    return _sendCodeCommand;
}

- (RACSubject *)nextSubject{
    if (_nextSubject == nil) {
        _nextSubject = [RACSubject subject];
    }
    return _nextSubject;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

