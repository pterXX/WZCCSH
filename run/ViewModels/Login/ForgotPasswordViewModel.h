//
//  ForgotPasswordViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "XQLoginExample.h"
@interface ForgotPasswordViewModel : XQViewModel
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *code_name;

@property (nonatomic, strong) RACSignal *nextBtnEnableSignal;
@property (nonatomic, strong) RACSubject *nextSubject;
@property (nonatomic, strong) RACCommand *nextBtnClickCommand;
@property (nonatomic, strong) RACCommand *sendCodeCommand;
@end
