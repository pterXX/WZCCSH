//
//  ChangePhoneViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePhoneViewModel.h"
#import "XQLoginExample.h"

@implementation ChangePhoneViewModel


- (void)xq_initialize{
    self.nextBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, code)] reduce:^id(NSString *phone, NSString *code){
        return @(phone.length && code.length);
    }];

    self.sureBtnEnableSignal = self.nextBtnClickSubject;


    @weakify(self);
    [self.nextBtnClickCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult  * _Nullable x) {
        @strongify(self);
        if (x.errcode == 0) {
            [self.nextBtnClickSubject sendNext:nil];
        }else{
            ML_SHOW_MESSAGE(x.errmsg);
        }
    }];

    [self.nextBtnClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_MESSAGE_NETWORKING;
    }];

    [self.sureBtnClickCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult  * _Nullable x) {
        @strongify(self);
        ML_SHOW_MESSAGE(x.errmsg);
        [self.sureBtnClickSubject sendNext:@(x.errcode == 0)];
    }];

    [self.sureBtnClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_MESSAGE_NETWORKING;
    }];

    [self.sendCodeCommand.executionSignals.switchToLatest subscribeNext:^(CodeModel  *_Nullable x) {
        @strongify(self);
        NSString *code_name = x.code_name;
        NSString *msg = x.msg;
        self.code_name = code_name;
        [MessageToast showMessage:msg];
    }];

    [self.sendCodeCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_MESSAGE_NETWORKING;
    }];
}

- (RACCommand *)nextBtnClickCommand{
    if (!_nextBtnClickCommand) {
        @weakify(self);
        _nextBtnClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample checkPhoneServer:self.phone code:self.code code_name:self.code_name];
        }];
    }
    return _nextBtnClickCommand;
}




- (RACCommand *)sendCodeCommand{
    if (!_sendCodeCommand) {
        @weakify(self);
        _sendCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample bindPhoneSmsSendServerWithMoble:self.phone];
        }];
    }
    return _sendCodeCommand;
}

- (RACSubject *)nextBtnClickSubject{
    if (_nextBtnClickSubject == nil) {
        _nextBtnClickSubject = [RACSubject subject];
    }
    return _nextBtnClickSubject;
}

- (RACCommand *)sureBtnClickCommand{
    if (!_sureBtnClickCommand) {
        @weakify(self);
        _sureBtnClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample changePhoneServer:self.phone code:self.code code_name:self.code_name];
        }];
    }
    return _sureBtnClickCommand;
}


- (RACSubject *)sureBtnClickSubject{
    if (_sureBtnClickSubject == nil) {
        _sureBtnClickSubject = [RACSubject subject];
    }
    return _sureBtnClickSubject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
