//
//  MessageViewModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "MessageModel.h"

@interface MessageViewModel : XQViewModel
@property (nonatomic ,assign) BOOL isSystem; //  是否是系统消息
@property (nonatomic ,assign) NSInteger page;


@property (nonatomic ,strong) NSMutableArray<MessageModel *> *dataSource;


@property (nonatomic ,strong) RACSubject *refreshEndSubject;

@property (nonatomic ,strong) RACSubject *refreshUISubject;

@property (nonatomic ,strong) RACSubject *cellClickSubject;

@property (nonatomic ,strong) RACCommand *refreshDataCommand;

@property (nonatomic ,strong) RACCommand *nextPageCommand;
@end
