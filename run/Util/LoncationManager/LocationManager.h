//
//  LocationManager.h
//  proj
//
//  Created by asdasd on 2017/9/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^LocaltionManagerBlock)(CLLocationManager *localManager , CLPlacemark *placemark);
typedef void(^LocaltionFailBlock)(NSError * error);
@interface LocationManager : CLLocationManager

/*!  超时时间 */
@property (nonatomic, assign)NSTimeInterval timeout;

/*!  获取地理位置信息 */
- (void)localtionInformation:(LocaltionManagerBlock)localBlock fail:(LocaltionFailBlock)fail;


/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(LocaltionManagerBlock)localBlock fail:(LocaltionFailBlock)fail;

@end
