//
//  BindViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "LoginTripartiteViewModel.h"
@interface BindViewModel : XQViewModel
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *code_name;
@property (nonatomic, strong) NSString *bind_id;
@property (nonatomic, assign) NSInteger type; //  0 微信登录 1 qq登录

@property (nonatomic ,strong) LoginTripartiteViewModel *tripartiteViewModel;  //   三方登录

@property (nonatomic, strong) RACSignal *sureButtonEnableSignal;
@property (nonatomic, strong) RACCommand *sureClickCommand;
@property (nonatomic, strong) RACCommand *sendCodeCommand;
@end
