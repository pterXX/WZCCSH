//
//  RecordViewModel.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "RecordViewModel.h"

@implementation RecordViewModel

-(void)xq_initialize
{
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        [self ls_setHeaderRefreshWithArray:[self addDataWithResult:x]];
    }];

    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        [self ls_setFooterRefreshWithArray:[self addDataWithResult:x]];
    }];

    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x isEqualToNumber:@(YES)]) {
            [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasLoadingData)];
        }
    }];

}

#pragma mark - Private
- (NSDictionary *)requestListWithParam{
    self.page = self.page <= 0 ?1:self.page;
    return @{
             @"page":@(self.page)
             };
}


- (NSArray *)addDataWithResult:(MLHTTPRequestResult *)retult{
    if (retult == nil) {
        ML_MESSAGE_NETWORKING;
        ///  无网的情况
        [self.refreshEndSubject sendNext:@(XQRefreshError)];
        return nil;
    }

    if (retult.errcode == 0) {
        NSArray *arr = retult.data;
        NSMutableArray< WalletListModel *> *array = [[arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
            return [WalletListModel objectWithDictionary:value];
        }] array].mutableCopy;



        NSMutableDictionary<NSString *,NSMutableArray <WalletListModel *>*>*group= [NSMutableDictionary dictionary];
        for (WalletListModel *model in array) {
            if ([[group allKeys] containsObject:model.group_name]) {
                NSMutableArray *modeArr = [group objectForKey:model.group_name];
                [modeArr addObject:model];
                [group setObject:modeArr forKey:model.group_name];
            }else{
                [group setObject:@[].mutableCopy forKey:model.group_name];
            }
        }

        NSMutableArray *dataSource = [NSMutableArray array];
        for (NSString *key in [group allKeys]) {
            NSArray *a = [group objectForKey:key];
            [dataSource addObject:a];
        }

        if (self.page == 1) {
            self.dataSource = dataSource;
            self.groupKeys = [group allKeys].mutableCopy;
        }else{
            [self.dataSource addObjectsFromArray:dataSource];
            [self.groupKeys addObjectsFromArray:[group allKeys]?:@[]];
        }
        return array;
    }
    return nil;
}

- (void)ls_setFooterRefreshWithArray:(NSArray *)array {
    if (array == nil) {
        return;
    }
    if (array.count == 0) {

        [self.refreshEndSubject sendNext:@(XQFooterRefresh_HasNoMoreData)];
    } else {

        [self.refreshEndSubject sendNext:@(XQFooterRefresh_HasMoreData)];
    }
}

- (void)ls_setHeaderRefreshWithArray:(NSArray *)array {
    if (array == nil) {
        return;
    }
    if (array.count == 0) {

        [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasNoMoreData)];
    } else {

        [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasMoreData)];
    }
}

#pragma mark - lazyLoad
- (RACSubject *)refreshUISubject {

    if (!_refreshUISubject) {

        _refreshUISubject = [RACSubject subject];
    }

    return _refreshUISubject;
}

- (RACSubject *)refreshEndSubject {

    if (!_refreshEndSubject) {

        _refreshEndSubject = [RACSubject subject];
    }

    return _refreshEndSubject;
}


- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                self.page = 1;
                [MLHTTPRequest POSTWithURL:RUN_TIXIAN_RECORD parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    ML_MESSAGE_NETWORKING;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } isResponseCache:YES];
                return nil;
            }];
        }];
    }

    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {

    if (!_nextPageCommand) {

        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                self.page ++;
                [MLHTTPRequest POSTWithURL:RUN_TIXIAN_RECORD parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    @strongify(self);
                    self.page --;
                    ML_MESSAGE_NETWORKING;
                    [subscriber sendCompleted];
                } isResponseCache:YES];
                return nil;
            }];
        }];
    }

    return _nextPageCommand;
}

- (NSMutableArray<WalletListModel *> *)dataSource {

    if (!_dataSource) {

        _dataSource = [[NSMutableArray alloc] init];
    }

    return _dataSource;
}

@end
