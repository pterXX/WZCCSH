//
//  RecordViewModel.h
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "WalletListModel.h"
@interface RecordViewModel : XQViewModel

@property (nonatomic ,assign) NSInteger page;

@property (nonatomic ,strong) NSMutableArray<NSArray <WalletListModel *>*> *dataSource;
@property (nonatomic ,strong) NSMutableArray<NSString *> *groupKeys;

@property (nonatomic ,strong) RACSubject *refreshEndSubject;

@property (nonatomic ,strong) RACSubject *refreshUISubject;

@property (nonatomic ,strong) RACSubject *cellClickSubject;

@property (nonatomic ,strong) RACCommand *refreshDataCommand;

@property (nonatomic ,strong) RACCommand *nextPageCommand;
@end
