//
//  LoginViewModel.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface LoginViewModel : XQViewModel
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACSignal *loginButtonEnableSignal;
@property (nonatomic, strong) RACCommand *loginClickCommand;
@property (nonatomic, strong) RACSubject *loginSubject;

@property (nonatomic, strong) RACSubject *registeredClickSubject;
@property (nonatomic, strong) RACSubject *backPassClickSubject;

@end
