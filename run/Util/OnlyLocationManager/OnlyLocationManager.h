//
//  OnlyLocationManager.h
//  OnlyLocation
//
//  Created by Mr.S on 2016/12/22.
//  Copyright © 2016年 ST.MEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OnlyLocationVO.h"

//设置反地理编码ak
#define GEOCODINGAK @"a31UK8dZVT2OoGuOi3DqU1GL"
#define LocationStateNoti @"LocationStateNoti"

typedef NS_ENUM(NSInteger, LocationInitType) {
    Success         = 0, //成功
    ServicesUnabled = 1, //定位服务不可用
    Denied          = 2, //被拒绝
};

typedef NS_ENUM(NSInteger, LocationState) {
    LocationInitFiled   = 0, //初始化失败
    InLocalization      = 1, //定位中
    Continually         = 2, //已获取初始位置并持续定位中
    LocatedNOVO         = 3, //已定位，正在逆地理编码
    Located             = 4, //已定位，逆地理编码完成
    LocatedVOFiled      = 5, //已定位，逆地理编码失败
};

/**
 * @brief  初始化回调(异步)
 *
 * @param  type 初始化结果
 */
typedef void (^InitResultCallBack)(LocationInitType type , CLLocationManager* manager);

/**
 * @brief  定位回调(异步)
 *
 * @param  coordinate 定位坐标
 * @param  location 定位CLLocation对象
 * @param  locationVO 逆地理编码（持续定位不返回）
 */
typedef void (^ResultCallBack)(CLLocationCoordinate2D coordinate,CLLocation *location,OnlyLocationVO *locationVO);

@interface OnlyLocationManager : NSObject

@property LocationState state;

+(instancetype)getLocationManager;
+(instancetype)shareManager:(BOOL)always needVO:(BOOL)needVO initCallBack:(InitResultCallBack)initCallBack resultCallBack:(ResultCallBack)resultCallBack;
+(OnlyLocationVO *)getOldLocation;
+(void)getLocation:(ResultCallBack)resultCallBack;

@end
