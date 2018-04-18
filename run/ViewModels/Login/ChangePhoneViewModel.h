//
//  ChangePhoneViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "XQLoginExample.h"
@interface ChangePhoneViewModel : XQViewModel
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *code_name;

@property (nonatomic, strong) RACCommand *sendCodeCommand;
@property (nonatomic, strong) RACSignal *nextBtnEnableSignal;
@property (nonatomic, strong) RACCommand *nextBtnClickCommand;
@property (nonatomic, strong) RACSubject *nextBtnClickSubject;

@property (nonatomic, strong) RACSignal *sureBtnEnableSignal;
@property (nonatomic, strong) RACSubject *sureBtnClickSubject;
@property (nonatomic, strong) RACCommand *sureBtnClickCommand;
@end
