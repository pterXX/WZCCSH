//
//  MessageViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "MessageViewModel.h"

@implementation MessageViewModel

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
        @strongify(self);
        if ([x isEqualToNumber:@(YES)]) {
            [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasLoadingData)];
        }
    }];

}

#pragma mark - Private
- (NSDictionary *)requestListWithParam{
    self.page = self.page <= 0 ?1:self.page;
    return @{@"type":self.isSystem?@"2":@"1",
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
        NSMutableArray *array = [[((NSArray *)retult.data).rac_sequence map:^id _Nullable(id  _Nullable value) {
            return [MessageModel objectWithDictionary:value];
        }] array].mutableCopy;

        if (self.page == 1) {
            self.dataSource = array;
        }else{
            [self.dataSource addObjectsFromArray:array];
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
                [MLHTTPRequest POSTWithURL:RUN_MSG_LIST parameters:[self requestListWithParam] responseCache:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                } success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    ML_MESSAGE_NETWORKING;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                }];
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
                [MLHTTPRequest POSTWithURL:RUN_MSG_LIST parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
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

- (NSMutableArray<MessageModel *> *)dataSource {

    if (!_dataSource) {

        _dataSource = [[NSMutableArray alloc] init];
    }

    return _dataSource;
}

- (RACSubject *)cellClickSubject {

    if (!_cellClickSubject) {

        _cellClickSubject = [RACSubject subject];
    }

    return _cellClickSubject;
}


#pragma mark - Setter
- (void)setIsSystem:(BOOL)isSystem{
    _isSystem = isSystem;

    //  根据状态请求不同的数据
    [self.refreshDataCommand execute:nil];
}

@end
