//
//  LoginTripartiteViewModel.h
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface LoginTripartiteViewModel : XQViewModel

@property (nonatomic, strong) RACCommand *qqClickCommand;
@property (nonatomic, strong) RACCommand *wechatClickCommand;

@property (nonatomic, strong) RACSubject *loginSuccessSubject;
@property (nonatomic, strong) RACSubject *bindPhoneSubject;
@end
