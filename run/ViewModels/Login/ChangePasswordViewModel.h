//
//  ChangePasswordViewModel.h
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface ChangePasswordViewModel : XQViewModel
@property (nonatomic, strong) NSString *oPass;
@property (nonatomic, strong) NSString *nPass;
@property (nonatomic, strong) NSString *sPass;

@property (nonatomic, strong) RACSignal *sureBtnEnableSignal;
@property (nonatomic, strong) RACSubject *sureBtnClickSubject;
@property (nonatomic, strong) RACCommand *sureBtnClickCommand;

@end
