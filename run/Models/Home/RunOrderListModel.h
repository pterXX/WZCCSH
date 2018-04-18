//
//  OrderListModel.h
//  city
//
//  Created by 3158 on 2018/2/24.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Property.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface RunOrderListModel : NSObject <BMKRouteSearchDelegate>

@property (nonatomic ,strong) NSString *aid;             ///   订单ID
@property (nonatomic ,strong) NSString *order_id;        ///   订单编号
@property (nonatomic ,strong) NSString *start_address;   ///   开始地址
@property (nonatomic ,strong) NSString *end_address;     ///   结束地址
@property (nonatomic ,strong) NSString *order_dateline;  ///   发单时间
@property (nonatomic ,strong) NSString *status;          ///   订单状态
@property (nonatomic ,strong) NSString *total_money;     ///   订单金额
@property (nonatomic ,strong) NSString *user_name;       ///   下单用户名
@property (nonatomic ,strong) NSString *tx_pic;          ///   头像
@property (nonatomic ,strong) NSString *mobile;          ///   下单电话
@property (nonatomic ,strong) NSString *distance;        ///   两地距离
@property (nonatomic ,strong) NSString *order_status;    ///   订单状态0待接单1待取货2配送中3已完成
@property (nonatomic ,strong) NSString *start_lon;       ///   起始地址经度
@property (nonatomic ,strong) NSString *start_lat;       ///   起始地址纬度
@property (nonatomic ,strong) NSString *end_lon;         ///   终点地址经度
@property (nonatomic ,strong) NSString *end_lat;         ///   终点地址纬度
@property (nonatomic ,strong) NSString *run_mobile;      ///   跑腿员电话
@property (nonatomic ,strong) NSString *get_mobile;      ///   收件人电话

#pragma mark - Custom
@property (nonatomic ,assign) int start_distance; ///  离起点的距离
@property (nonatomic ,assign) int end_distance;   ///  离终点的距离
@property (nonatomic ,strong) BMKRouteSearch *start_routeSearch; ///  起点搜索
@property (nonatomic ,strong) BMKRouteSearch *end_routeSearch;  ///  终点搜索

///  检索距离
- (void)routeSearchWithStartCorrdinate:(CLLocationCoordinate2D)startCorrdinate
                    startDistanceBlock:(void(^)())startDistanceBlock
                      endDistanceBlock:(void(^)())endDistanceBlock;

///  获取起点地址距离后的回调
@property (nonatomic,copy) void (^startDistanceCompletionHandler)(void);
///  获取终点地址距离后的回调
@property (nonatomic,copy) void (^endDistanceCompletionHandler)(void);

///// 开始获取起点距离
//- (void)startGetStartDistanceWithlat:(NSString *)lat lon:(NSString *)lon;
///// 开始获取起点距离
//- (void)startGetEndDistanceWithlat:(NSString *)lat lon:(NSString *)lon;
//
//
///// 本地获取起点距离
//- (void)loadGetStartDistanceWithlat:(NSString *)lat lon:(NSString *)lon;
///// 本地获取起点距离
//- (void)loadGetEndDistanceWithlat:(NSString *)lat lon:(NSString *)lon;


///  NOTE:普通数组转换为Model数组
+ (NSMutableArray<RunOrderListModel *> *)modelArrayWithArray:(NSArray *)array;

@end
