//
//  OrderListModel.m
//  city
//
//  Created by 3158 on 2018/2/24.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "RunOrderListModel.h"

@implementation RunOrderListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"aid":@"id"};
}

+ (NSMutableArray<RunOrderListModel*> *)modelArrayWithArray:(NSArray *)array
{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id obj in array) {
        [modelArray addObject:[RunOrderListModel objectWithDictionary:obj]];
    }
    return modelArray;
}


- (void)dealloc
{
    self.start_routeSearch.delegate  = nil;
    self.end_routeSearch.delegate = nil;
}

- (void)routeSearchWithStartCorrdinate:(CLLocationCoordinate2D)startCorrdinate
                    startDistanceBlock:(void(^)(void))startDistanceBlock
                      endDistanceBlock:(void(^)(void))endDistanceBlock
{
    if (self.start_distance == 0) {
        CLLocationCoordinate2D startPt = {self.start_lat.floatValue,self.start_lon.floatValue};
        self.start_routeSearch =  [self routeSearchWithStartCorrdinate:startCorrdinate
                                                         endCorrdinate:startPt];
        self.startDistanceCompletionHandler =  startDistanceBlock;
    }
    
    if (self.end_distance == 0) {
        CLLocationCoordinate2D endPt = {self.end_lat.floatValue,self.end_lon.floatValue};
        self.end_routeSearch =  [self routeSearchWithStartCorrdinate:startCorrdinate
                                                       endCorrdinate:endPt];
        self.endDistanceCompletionHandler = endDistanceBlock;
    }
}

///  搜索
- (BMKRouteSearch *)routeSearchWithStartCorrdinate:(CLLocationCoordinate2D)startCorrdinate endCorrdinate:(CLLocationCoordinate2D)endCorrdinate
{
    //初始化检索对象
    BMKRouteSearch *routeSearch = [[BMKRouteSearch alloc] init];
    //设置delegate，用于接收检索结果
    routeSearch.delegate = self;
    
    //构造驾车查询基础信息类
    BMKPlanNode* start = [[BMKPlanNode alloc]init] ;
    CLLocationCoordinate2D startPt = startCorrdinate;
    start.pt =  startPt;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D endPt = endCorrdinate;
    end.pt =  endPt;
    BMKDrivingRoutePlanOption *driveRouteSearchOption =[[BMKDrivingRoutePlanOption alloc]init];
    driveRouteSearchOption.from = start;
    driveRouteSearchOption.to = end;
    driveRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_NONE;//不获取路况信息
    BOOL flag = [routeSearch drivingSearch:driveRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
    return routeSearch;
}

#pragma mark - BMKRouteSearchDelegate

/**
 *返回驾乘搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKDrivingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error {
    MLLog(@"onGetDrivingRouteResult error:%d", (int)error);
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine *line = result.routes.firstObject;
        if (line) {
            if (searcher == self.start_routeSearch) {
                self.start_distance = line.distance;
                !self.startDistanceCompletionHandler?:self.startDistanceCompletionHandler();
            }else{
                self.end_distance = line.distance;
                !self.endDistanceCompletionHandler?:self.endDistanceCompletionHandler();
            }
        }
        
        //  距离
        //        BMKTime *duration = line.duration;
        //        double consumTime = duration.minutes * 60 + duration.hours * 60 * 60 + duration.dates * 24 * 60 * 60 + duration.seconds;
        //  时间
        MLLog(@"时间: %@天 %@时 %@分 %@秒  距离: %@",@(line.duration.dates),@(line.duration.hours),@(line.duration.minutes),@(line.duration.seconds),@(line.distance));
    } else {
        //检索失败
    }
}


@end
