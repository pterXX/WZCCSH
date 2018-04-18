//
//  ChangePasswordViewModel.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "XQLoginExample.h"

@implementation ChangePasswordViewModel

- (void)xq_initialize{
    self.sureBtnEnableSignal = [RACSignal combineLatest:@[RACObserve(self, oPass),RACObserve(self, nPass), RACObserve(self, sPass)] reduce:^id(NSString *oPass, NSString *nPass,NSString *sPass){
        return @(oPass.length && nPass.length && sPass.length);
    }];

    @weakify(self);
    [self.sureBtnClickCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        if (x.errcode == 0) {
            ML_SHOW_MESSAGE(@"修改成功请重新登录...");
            [XQLoginExample exampleLoginOuted];
        }else{
            ML_SHOW_MESSAGE(x.errmsg);
        }
    }];

    [self.sureBtnClickCommand.errors subscribeNext:^(NSError * _Nullable x) {
        ML_MESSAGE_NETWORKING;
    }];


    [self.sureBtnClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (![self.nPass isEqualToString:self.sPass]) {
            ML_SHOW_MESSAGE(@"两次输入的新密码不一致,请重新输入");
            return;
        }else{
            int length = (int)[self.nPass length];
            for (int i=0; i<length; ++i)
            {
                NSRange range = NSMakeRange(i, 1);
                NSString *subString = [self.nPass substringWithRange:range];
                const char   *cString = [subString UTF8String];
                if (strlen(cString) == 3)
                {
                    ML_SHOW_MESSAGE(@"密码中不能含中文字符，请重新设置");
                    return;
                }
            }

        }

        [self.sureBtnClickCommand execute:nil];
    }];
}

- (RACCommand *)sureBtnClickCommand{
    if (!_sureBtnClickCommand) {
        @weakify(self);
        _sureBtnClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            return [XQLoginExample changePasswordServer:self.oPass nPass:self.nPass];
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
