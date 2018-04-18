//
//  BaiduLocationService.h
//  city
//
//  Created by 3158 on 2017/9/7.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

typedef void(^BaiduLocaltionManagerBlock)(BMKLocationService *localManager , CLPlacemark *placemark);
typedef void(^GeoCodeResult)(BMKLocationService *localManager , BMKReverseGeoCodeResult *result);
typedef void(^BaiduLocaltionFailBlock)(NSError * error);
@interface BaiduLocationService : NSObject

/*!  是否持续定位 */
@property (nonatomic ,assign) BOOL isContinuousLocal;


/*!  超时时间 */
@property (nonatomic, assign) NSTimeInterval timeout;

/*!  获取地理位置信息 */
- (void)BaiduLocaltionInformation:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail;


/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail;

/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout isContinuousLocal:(BOOL)isContinuousLocal localSuceess:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail;

+ (void)openLocationServiceWithBlock:(void(^)(bool isOpen))returnBlock;
@end
