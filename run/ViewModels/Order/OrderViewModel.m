//
//  OrderViewModel.m
//  run
//
//  Created by asdasd on 2018/4/11.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "OrderViewModel.h"
#import "JZLocationConverter.h"

@interface OrderViewModel()

@end

@implementation OrderViewModel

-(void)xq_initialize
{
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(MLHTTPRequestResult * _Nullable x) {
        @strongify(self);
        if (x == nil) {
            [self.refreshEndSubject sendNext:@(XQRefreshError)];
            ML_MESSAGE_NETWORKING;
            return ;
        }

        if (x.errcode == 0) {
            self.model = [RunOrderModel objectWithDictionary:x.data];
            [self.refreshUISubject sendNext:nil];
        }else{
            ML_SHOW_MESSAGE(x.errmsg);
            [self.refreshEndSubject sendNext:@(XQFooterRefresh_HasNoMoreData)];
        }
    }];

    
    [[[self.refreshDataCommand.executing skip:1] take:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x isEqualToNumber:@(YES)]) {
            [self.refreshEndSubject sendNext:@(XQHeaderRefresh_HasLoadingData)];
        }
    }];


    [self.mapMaskViewClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [MessageBox showSheetWithTitle:nil message:nil item:[self openMapViewActionTitles] block:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self openNativeNavi];
                    break;
                case 1:
                    [self openMapWalkOrRideNavi:YES];
                    break;

                case 2:
                    [self openMapWalkOrRideNavi:NO];
                    break;
                case 3:
                    [self onDaoHangForIOSMap];
                    break;
                case 4:
                    [self onDaoHangForGaoDeMap];

                    break;
                default:
                    break;
            }
        }];
    }];
}

#pragma mark - Public
- (NSString *)distanceStr{
    /// NOTE: 订单状态 1待付款 2待接单 3待取货 4配送中 5已完成 6已取消
    if ([self isCurrentOfPickupGoods]) {
        if (self.distance < 1000) {
            return  [NSString stringWithFormat:@"距离取货点%dm",self.distance];
        }else{
            return [NSString stringWithFormat:@"距离取货点%.1fkm",self.distance / 1000.0];
        }
    }else{
        if (self.distance < 1000) {
            return  [NSString stringWithFormat:@"距离收货点%dm",self.distance];
        }else{
            return [NSString stringWithFormat:@"距离收货点%.1fkm",self.distance / 1000.0];
        }
    }

}


//  当前是否是取货
- (BOOL)isCurrentOfPickupGoods
{
    /// NOTE: 订单状态 1待付款 2待接单 3待取货 4配送中 5已完成 6已取消
    return  (self.model.status == 2 || self.model.status == 3 || self.model.status ==  5 || self.model.status == 6);
}

#pragma mark - Private
- (NSDictionary *)requestListWithParam{
    return @{@"id":self.aid?:@""};
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

- (RACSubject *)mapMaskViewClickSubject {
    if (!_mapMaskViewClickSubject) {
        _mapMaskViewClickSubject = [RACSubject subject];
    }
    return _mapMaskViewClickSubject;
}


- (RACCommand *)refreshDataCommand {
    if (!_refreshDataCommand) {
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                [MLHTTPRequest POSTWithURL:RUN_ORDER_GRAB_ORDER parameters:[self requestListWithParam] success:^(MLHTTPRequestResult *result) {
                    [subscriber sendNext:result];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    ML_MESSAGE_NETWORKING;
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                } isResponseCache:NO];
                return nil;
            }];
        }];
    }
    
    return _refreshDataCommand;
}


- (BMKPlanNode *)start{
    if (_start == nil) {
        //构造骑行查询基础信息类
        _start = [[BMKPlanNode alloc]init];
    }

    CLLocationCoordinate2D sPt = {self.model.start_lat.floatValue,self.model.start_lng.floatValue};
    _start.pt = sPt;

    return _start;
}


- (BMKPlanNode *)end{
    if (_end == nil) {
        _end = [[BMKPlanNode alloc] init];
    }

    CLLocationCoordinate2D ePt = {self.model.end_lat.floatValue,self.model.end_lng.floatValue};
    _end.pt = ePt;
    return _end;
}

- (BMKPlanNode *)selfNode{
    if (_selfNode == nil) {
        _selfNode = [[BMKPlanNode alloc] init];
    }
    return _selfNode;
}



- (BMKPlanNode *)currentEndNode{
    /// NOTE: 订单状态 1待付款 2待接单 3待取货 4配送中 5已完成 6已取消
    if ([self isCurrentOfPickupGoods]) {
        _currentEndNode = self.start;
    }else{
        _currentEndNode = self.end;
    }
    return _currentEndNode;
}


- (NSArray *)openMapViewActionTitles{
   NSMutableArray *arr = [[NSMutableArray alloc]initWithObjects:
                   @"百度地图驾车导航",
                   @"百度地图步行导航",
                   @"百度地图骑行导航",
            @"苹果地图导航",
                   nil];

    if ([[UIApplication alloc] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [arr addObject:@"高德地图导航"];
    }
    return arr;
}

#pragma mark - private
#define RETURN_appScheme @"baidumaprunapp://mapsdk.baidu.com"

//打开客户端导航
- (void)openNativeNavi {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    start.pt = self.selfNode.pt;
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    para.startPoint = start;
    //指定终点
    para.endPoint = self.currentEndNode;

    //指定返回自定义scheme
    para.appScheme = RETURN_appScheme;

    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
}

//打开客户端步行/骑行导航
- (void)openMapWalkOrRideNavi:(BOOL) walk {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定终点
    para.endPoint = self.currentEndNode;

    //指定返回自定义scheme
    para.appScheme = RETURN_appScheme;

    //调启百度地图客户端
    if (walk) {
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapWalkNavigation:para];
        NSLog(@"调起步行导航：errorcode=%d", code);
    } else {
        BMKOpenErrorCode code = [BMKNavigation openBaiduMapRideNavigation:para];
        NSLog(@"调起骑行导航：errorcode=%d", code);
    }
}

#pragma mark ------------------------------ 导航 - 高德
-(void) onDaoHangForGaoDeMap{
    //  使用高德或腾讯地图是使用腾讯坐标
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",[UIDevice appCurName],RETURN_appScheme,@(self.currentEndNode.pt.latitude), @(self.currentEndNode.pt.longitude)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
#pragma mark ------------------------------ 导航 - iosMap
-(void) onDaoHangForIOSMap{
    //  百度经纬度转中国经纬度
    CLLocationCoordinate2D sloc = [JZLocationConverter bd09ToGcj02:self.selfNode.pt];
    CLLocationCoordinate2D loc = [JZLocationConverter bd09ToGcj02:self.currentEndNode.pt];
    MKMapItem *currentLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:sloc addressDictionary:nil]];
    currentLocation.name = self.selfNode.name;
    MKMapItem *toLocation      = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    toLocation.name            =  self.model.end_address;

    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}


//打开地图 poi详情
- (void)openMapPoiDetail {
    BMKOpenPoiDetailOption *opt = [[BMKOpenPoiDetailOption alloc] init];
    opt.appScheme = RETURN_appScheme;
    opt.poiUid = @"65e1ee886c885190f60e77ff";//天安门
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiDetailPage:opt];
    return;
}

//打开地图 poi周边
- (void)openMapPoiNearby {
    BMKOpenPoiNearbyOption *opt = [[BMKOpenPoiNearbyOption alloc] init];
    opt.appScheme = RETURN_appScheme;
    opt.keyword = @"美食";

    opt.location = CLLocationCoordinate2DMake(39.915,116.360582);
    opt.radius = 1000;
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiNearbySearch:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 驾车路线检索
- (void)openMapDrivingRoute {
    BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
    //    opt.appName = @"SDK调起Demo";
    opt.appScheme = RETURN_appScheme;
    //指定起点
    opt.startPoint = self.selfNode;

    opt.endPoint = self.currentEndNode;
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 公交路线检索
- (void)openMapTransitRoute {
    BMKOpenTransitRouteOption *opt = [[BMKOpenTransitRouteOption alloc] init];
    //    opt.appName = @"SDK调起Demo";
    opt.appScheme = RETURN_appScheme;
    opt.startPoint = self.selfNode;

    opt.endPoint = self.currentEndNode;

    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapTransitRoute:opt];
    NSLog(@"%d", code);
    return;
}

//打开地图 步行路线检索
- (void)openMapWalkingRoute {
    BMKOpenWalkingRouteOption *opt = [[BMKOpenWalkingRouteOption alloc] init];
    opt.appScheme = RETURN_appScheme;
    opt.startPoint = self.selfNode;

    opt.endPoint = self.currentEndNode;

    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapWalkingRoute:opt];
    NSLog(@"%d", code);
    return;
}



//打开客户端步行AR导航
- (void)openMapARWalkNavi{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];

    para.endPoint = self.currentEndNode;

    //指定返回自定义scheme
    para.appScheme = RETURN_appScheme;

    //调启百度地图客户端
    BMKOpenErrorCode code = [BMKNavigation openBaiduMapwalkARNavigation:para];
    NSLog(@"调起步行导航：errorcode=%d", code);
}

@end
