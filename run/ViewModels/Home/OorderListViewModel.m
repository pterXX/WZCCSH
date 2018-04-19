//
//  OorderListViewModel.m
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "OorderListViewModel.h"
#import "XQLoginExample.h"
@implementation OorderListViewModel

-(void)xq_initialize
{
    @weakify(self);
    //  刷新数据的命令
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x.errcode == 2) {
            //  未开工的状态  先将数据清空
            [self.dataSource removeAllObjects];
            [self.refreshEndSubject sendNext:@(XQRefreshNoIsWork)];
        }else if (x.errcode == 1 && [x.errmsg isEqualToString:@"地址获取失败"] == NO){  //  不是跑腿员
            [self.dataSource removeAllObjects];
            [self.refreshEndSubject sendNext:@(XQRefreshNoIsCheck)];
        }else{
            [self ls_setHeaderRefreshWithArray:[self addDataWithResult:x]];
        }

        //  只有在待接单的情况下 并且 x.errCode 等于2 的情况下才能决定是否是开工和收工状态
        [XQNotificationCenter postNotificationName:kIsWorkingNotificationKey object:@(x.errcode != 2)];
    }];

    //  添加数据的命令
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x.errcode == 2) {
            //  未开工的状态
            [self.refreshEndSubject sendNext:@(XQRefreshNoIsWork)];
        }else{
            [self ls_setFooterRefreshWithArray:[self addDataWithResult:x]];
        }

    }];

    //  跳过第一步请求
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x isEqualToNumber:@(YES)]) {
            [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasLoadingData)];
        }
    }];

    //  开工按钮点击的命令
    [self.startBtnAndEndBtnCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            ML_MESSAGE_NETWORKING;
            return ;
        }

        ML_SHOW_MESSAGE(x.errmsg);
        [self.refreshDataCommand execute:nil];
    }];

    ///  直到存在经纬度的时候才能获取数据
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NSArray *info = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
        if (info.count == 2) {
            [subscriber sendNext:info];
            [subscriber sendCompleted];
        }else{
            NSLog(@"没有定位经纬度");
            [subscriber sendError:nil];
        }
        return nil;
    }] throttle:2] retry] subscribeNext:^(NSArray *x) {
        @strongify(self);
        self.latitude = x.firstObject;
        self.longitude = x.lastObject;
        if (self.dataSource.count == 0) {
            //  直到存在经纬度的时候才能获取数据
            [self.refreshDataCommand execute:nil];
        }
    } error:^(NSError *error) {

    }];
}

- (void)setSelectedId:(NSString *)selectedId{
    _selectedId = selectedId;
    [self.refreshDataCommand execute:nil];
}

#pragma mark - Private
- (NSDictionary *)requestListWithParam{
    self.page = self.page <= 0 ?1:self.page;
    return @{@"status":self.selectedId?:@"0",
             @"longitude":self.longitude?:@"",
             @"latitude":self.latitude?:@"",
             @"lng":self.longitude?:@"",
             @"lat":self.latitude?:@"",
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
            return [RunOrderListModel objectWithDictionary:value];
        }] array].mutableCopy;
        if (self.page == 1) {
            self.dataSource = array;
        }else{
            [self.dataSource addObjectsFromArray:array];
        }
        return array;
    }else{
        // 无数据
        [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasNoMoreData)];
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
                [MLHTTPRequest POSTWithURL:RUN_ORDER_LIST parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {

                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } isResponseCache:NO];
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
                [MLHTTPRequest POSTWithURL:RUN_ORDER_LIST parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    @strongify(self);
                    self.page --;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } isResponseCache:NO];
                return nil;
            }];
        }];
    }

    return _nextPageCommand;
}

- (NSMutableArray<RunOrderListModel *> *)dataSource {

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

- (NSString *)latitude{
    if (_latitude == nil) {
        NSArray *info = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
        if (info.count == 2) {
            _latitude = info.firstObject;
        }
    }
    return _latitude;
}

- (NSString *)longitude{
    if (_longitude == nil) {
        NSArray *info = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
        if (info.count == 2) {
            _longitude = info.lastObject;
        }
    }
    return _longitude;
}


- (void)setMenuInfo:(MenuInfo *)menuInfo
{
    _menuInfo = menuInfo;
    self.selectedId = menuInfo.menuId;
}

- (RACCommand *)startBtnAndEndBtnCommand {

    if (!_startBtnAndEndBtnCommand) {
        @weakify(self);
        _startBtnAndEndBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            // 开工
            return [XQLoginExample isWokringServer:YES];
        }];
    }

    return _startBtnAndEndBtnCommand;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
