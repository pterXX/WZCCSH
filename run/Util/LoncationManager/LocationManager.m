//
//  LocationManager.m
//  proj
//
//  Created by asdasd on 2017/9/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>
/* 定位成功，进行成功信息 */
@property(nonatomic, copy) LocaltionManagerBlock localtionBlock;
/* 定位失败，进行回调错误信息 */
@property(nonatomic, copy) LocaltionFailBlock failBlock;

/* 定时器用于判断定位超时 */
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation LocationManager

/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(LocaltionManagerBlock)localBlock fail:(LocaltionFailBlock)fail{
    LocationManager  *locationManager = [[LocationManager alloc] init];
    locationManager.timeout = timeout;
    [locationManager localtionInformation:localBlock fail:fail];
}



- (instancetype)init{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.distanceFilter = kCLLocationAccuracyBest;
        self.timeout = 30;
    }
    return self;
}



- (void)startTimer{
    [self releaseTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(TimerEnd) userInfo:nil repeats:NO];
}



- (void)TimerEnd{
    [self releaseTimer];
    NSLog(@"定位超时");
    [self stopUpdatingLocation];
}



- (void)releaseTimer{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}



- (void)findMe{
    BOOL status = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
    if (status) {
        if (self.failBlock) {
            [self releaseTimer];
            NSError *error = [NSError errorWithDomain:@"定位失败" code:111111111 userInfo:@{@"errorMsg":@"当前定位不能使用,请确认启动了定位服务"}];
            self.failBlock(error);
        }
        return;
    }

    if([self respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        NSLog(@"requestWhenInUserAutionorization");
        [self requestWhenInUseAuthorization];
    }
    else{
        NSAssert(NO, @"请确认您在info.plist 添加了NSLocationWhenInUseUsageDescription或NSLocationAlwaysUsageDescription字段，或者启动了定位功能");
    }
    [self startUpdatingLocation];
}



- (void)startUpdatingLocation{
    [super startUpdatingLocation];
    [self startTimer];
}



- (void)stopUpdatingLocation{
    [super stopUpdatingLocation];
    [self releaseTimer];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = [location coordinate];
    NSLog(@"纬度:----------->%f  经度----------->%f",coordinate.latitude,coordinate.longitude);
    [manager stopUpdatingLocation];
    //  保存到本地
//    [[NSUserDefaults standardUserDefaults] setObject:@{@"latitude":@(coordinate.latitude),@"longitude":@(coordinate.longitude)} forKey:kCoordinateKey];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks == nil) {
            if (self.failBlock) {
                self.failBlock(error);
            }
            NSLog(@"您当前的地址找不到,可能在月球上");
        }
        else{
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            self.localtionBlock(self,firstPlacemark);
            [self startUpdatingLocation];
        }
    }];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    if (self.failBlock) {
        self.failBlock(error);
    }
}



//  获取地理位置信息
- (void)localtionInformation:(LocaltionManagerBlock)localBlock fail:(LocaltionFailBlock)fail{
    @try {
        [self findMe];
        self.localtionBlock = localBlock;
        if (fail) {
            self.failBlock = fail;
        }
    } @catch (NSException *exception) {
        if (fail) {
            NSError *error = [NSError errorWithDomain:@"定位失败" code:111111112 userInfo:@{@"errorMsg":@"程序不支持定位或者出现定位异常"}];
            fail(error);
        }
        NSLog(@"%@   , %@",exception.name,exception.reason);
    } @finally {


    }

}


- (CLGeocoder *)geocoder{
    if (_geocoder == nil) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}



@end
