//
//  FindPasswordViewModel.h
//  run
//
//  Created by asdasd on 2018/4/12.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "XQLoginExample.h"
@interface FindPasswordViewModel : XQViewModel
@property (nonatomic, strong) NSString *token_key;
@property (nonatomic, strong) NSString *nPass;
@property (nonatomic, strong) NSString *sPass;

@property (nonatomic, strong) RACSignal *sureBtnEnableSignal;
@property (nonatomic, strong) RACSubject *sureBtnClickSubject;
@property (nonatomic, strong) RACSubject *successSubject;
@property (nonatomic, strong) RACCommand *sureBtnClickCommand;
@end
