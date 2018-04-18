//
//  BaiduGeoReusltService.h
//  running man
//
//  Created by asdasd on 2018/4/8.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

typedef void(^GeoCodeResult)(BMKLocationService *localManager , BMKReverseGeoCodeResult *result);
typedef void(^BaiduLocaltionFailBlock)(NSError * error);

@interface BaiduGeoReusltService : NSObject

@property (nonatomic ,strong) BMKLocationService *locService;
@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic ,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;
@property (nonatomic ,strong) BMKReverseGeoCodeResult *result;
@property (nonatomic ,strong) CLLocation *userLocation;
/*!  超时时间 */
@property (nonatomic, assign) NSTimeInterval timeout;

/*!  获取地理位置信息 */
- (void)BaiduLocaltionInformation:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail;


/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail;

/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout isContinuousLocal:(BOOL)isContinuousLocal localSuceess:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail;

@end
