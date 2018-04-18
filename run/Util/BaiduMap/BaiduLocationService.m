//
//  BaiduLocationService.m
//  city
//
//  Created by 3158 on 2017/9/7.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "BaiduLocationService.h"

@interface BaiduLocationService ()<BMKLocationServiceDelegate>
@property (nonatomic ,strong) BMKLocationService *locService;

/* 定位成功，进行成功信息 */
@property(nonatomic, copy) BaiduLocaltionManagerBlock localtionBlock;
/* 定位失败，进行回调错误信息 */
@property(nonatomic, copy) BaiduLocaltionFailBlock failBlock;

/* 定时器用于判断定位超时 */
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation BaiduLocationService

- (void)dealloc{
    _locService.delegate = nil;
}


#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //MLLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//    if (userLocation.heading == nil) {
//        return;
//    }
    
    MLLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    !self.isContinuousLocal?:[self stopUpdatingLocation];
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks == nil) {
            if (self.failBlock) {
                self.failBlock(error);
            }
            MLLog(@"您当前的地址找不到,可能在月球上");
        }
        else{
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            self.localtionBlock(self.locService,firstPlacemark);
        }
    }];
}



/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail{
    [self localtionManagerWithTimeOut:timeout isContinuousLocal:NO localSuceess:localBlock fail:fail];
}

/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout isContinuousLocal:(BOOL)isContinuousLocal localSuceess:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail{

    BaiduLocationService  *locationManager = [[BaiduLocationService alloc] init];
    locationManager.timeout = timeout;
    locationManager.isContinuousLocal = isContinuousLocal;
    [locationManager BaiduLocaltionInformation:localBlock fail:fail];
}




- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        [self findMe];
    }
    return self;
}

- (void)startTimer{
    [self releaseTimer];
    if (self.isContinuousLocal == NO) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(TimerEnd) userInfo:nil repeats:NO];
    }
}



- (void)TimerEnd{
    [self releaseTimer];
    MLLog(@"定位超时");
    
    if (self.failBlock) {
        NSError *error = [NSError errorWithDomain:@"定位失败" code:111111111 userInfo:@{@"errorMsg":@"当前定位不能使用,请确认启动了定位服务"}];
        self.failBlock(error);
    }

    [self stopUpdatingLocation];
}



- (void)releaseTimer{
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}



- (void)findMe{
    [BaiduLocationService openLocationServiceWithBlock:^(bool isOpen) {
        if (isOpen) {
             [self releaseTimer];
            [self startUpdatingLocation];
        }else{
            [self releaseTimer];
            NSError *error = [NSError errorWithDomain:@"定位失败" code:111111111 userInfo:@{@"errorMsg":@"当前定位不能使用,请确认启动了定位服务"}];
            self.failBlock(error);
        }
    }];
}


+ (void)openLocationServiceWithBlock:(void(^)(bool isOpen))returnBlock
{
    BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        isOPen = YES;
    }
    if (returnBlock) {
        returnBlock(isOPen);
    }
}


- (void)startUpdatingLocation{
    //启动LocationService
    [_locService startUserLocationService];
    [self startTimer];
}



- (void)stopUpdatingLocation{
    [_locService stopUserLocationService];
    [self releaseTimer];
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
- (void)BaiduLocaltionInformation:(BaiduLocaltionManagerBlock)localBlock fail:(BaiduLocaltionFailBlock)fail{
    @try {
        
        self.localtionBlock = localBlock;
        if (fail) {
            self.failBlock = fail;
        }
        [self findMe];
    } @catch (NSException *exception) {
        if (fail) {
            NSError *error = [NSError errorWithDomain:@"定位失败" code:111111112 userInfo:@{@"errorMsg":@"程序不支持定位或者出现定位异常"}];
            fail(error);
        }
        MLLog(@"%@   , %@",exception.name,exception.reason);
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
