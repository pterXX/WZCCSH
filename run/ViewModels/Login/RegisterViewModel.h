//
//  RegisterViewModel.h
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "XQLoginExample.h"

@interface RegisterViewModel : XQViewModel
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *code_name;

@property (nonatomic, strong) RACSignal *registerBtnEnableSignal;
@property (nonatomic, strong) RACCommand *registerCommand;
@property (nonatomic, strong) RACCommand *sendCodeCommand;
@property (nonatomic, strong) RACCommand *loginClickCommand;
@end
