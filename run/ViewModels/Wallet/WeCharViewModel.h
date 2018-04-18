//
//  WeCharViewModel.h
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@interface WeCharViewModel : XQViewModel
@property (nonatomic ,strong) NSString *open_id;

@property (nonatomic ,assign) BOOL is_bind;

@property (nonatomic ,strong) NSString *amount;

@property (nonatomic ,strong) RACSubject *weChatBtnBindSubject;

@property (nonatomic ,strong) RACSubject *popVCSuject;

@property (nonatomic ,strong) RACCommand *sureBtnCommand;

@property (nonatomic, strong) RACSignal *sureButtonEnableSignal;
@end
