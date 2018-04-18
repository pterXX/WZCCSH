//
//  OrderViewModel.h
//  run
//
//  Created by asdasd on 2018/4/11.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"
#import "RunOrderModel.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Search/BMKRouteSearch.h>//路径规划

@interface OrderViewModel : XQViewModel
@property (nonatomic ,strong) NSString *aid;
@property (nonatomic ,assign) BOOL isGrabSingle; //  是否是抢单页面
@property (strong, nonatomic) RunOrderModel *model;

@property (strong, nonatomic)  BMKPlanNode* start;
@property (strong, nonatomic)  BMKPlanNode* end;
@property (strong, nonatomic)  BMKPlanNode* selfNode;
//  根据订单状态判断状态
@property (nonatomic ,strong) BMKPlanNode *currentEndNode;

@property (assign, nonatomic)  int distance; //  距离目的地的距离

@property (strong, nonatomic)  NSMutableArray<BMKPointAnnotation *> *annotationArr;

@property (nonatomic ,strong) RACSubject *refreshEndSubject;

@property (nonatomic ,strong) RACSubject *refreshUISubject;

@property (nonatomic ,strong) RACSubject *mapMaskViewClickSubject;

@property (nonatomic ,strong) RACCommand *refreshDataCommand;

//  距离
- (NSString *)distanceStr;

//  当前是否是取货
- (BOOL)isCurrentOfPickupGoods;

- (NSArray *)openMapViewActionTitles;
@end
