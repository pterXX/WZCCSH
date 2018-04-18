//
//  BindViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "BindViewModel.h"
#import "XQLoginExample.h"

@implementation BindViewModel
- (void)xq_initialize{
    self.sureButtonEnableSignal = [RACSignal combineLatest:@[RACObserve(self, phone), RACObserve(self, code)] reduce:^id(NSString *phone, NSString *code){
        return @(phone.length && code.length);
    }];

    @weakify(self);
    [[self.sureClickCommand.executionSignals.switchToLatest takeUntil:self.rac_willDeallocSignal] subscribeNext:^(MLHTTPRequestResult  *_Nullable x) {
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
        }else{
            if (x.errcode == 0) {
                if (self.type == 0) {
                    [self.tripartiteViewModel.wechatClickCommand execute:nil];
                }else{
                     [self.tripartiteViewModel.qqClickCommand execute:nil];
                }
            }else{
                ML_SHOW_MESSAGE(x.errmsg);
            }
        }
    }];

    [self.sureClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        if ([[[x userInfo] allKeys] containsObject:@"msg"]) {
            ML_SHOW_MESSAGE([x userInfo][@"msg"]);
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
        ML_MESSAGE_NETWORKING;
    }];
}

- (RACCommand *)sureClickCommand{
    if (!_sureClickCommand) {
        @weakify(self);
        _sureClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);

            //  绑定接口
            return [XQLoginExample bindPhoneServerWithPhone:self.phone code:self.code code_name:self.code_name bind_id:self.bind_id];
        }];
    }
    return _sureClickCommand;
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

- (LoginTripartiteViewModel *)tripartiteViewModel{
    if (_tripartiteViewModel == nil) {
        _tripartiteViewModel = [[LoginTripartiteViewModel alloc] init];
    }
    return _tripartiteViewModel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

