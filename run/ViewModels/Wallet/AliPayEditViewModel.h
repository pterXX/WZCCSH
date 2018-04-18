//
//  AliPayEditViewModel.h
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface AliPayEditViewModel : XQViewModel
@property (nonatomic ,strong) NSString *phone;

@property (nonatomic ,strong) NSString * code;

@property (nonatomic ,strong) NSString * code_name;

@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSString *account;

@property (nonatomic ,strong) RACCommand *sureBtnCommand;

@property (nonatomic ,strong) RACSubject *popSuccessSubject; //   成功后的操作

@property (nonatomic, strong) RACSignal *sureButtonEnableSignal;

@property (nonatomic, strong) RACCommand *sendCodeCommand;
@end


@interface AliPayViewModel : XQViewModel
@property (nonatomic ,strong) NSString *open_id;

@property (nonatomic ,assign) BOOL is_bind;

@property (nonatomic ,strong) NSString *amount;

@property (nonatomic ,strong) RACSubject *weChatBtnBindSubject;

@property (nonatomic ,strong) RACSubject *popVCSuject;

@property (nonatomic ,strong) RACCommand *sureBtnCommand;

@property (nonatomic, strong) RACSignal *sureButtonEnableSignal;
@end
