//
//  BaiduGeoReusltService.m
//  running man
//
//  Created by asdasd on 2018/4/8.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "BaiduGeoReusltService.h"

@interface BaiduGeoReusltService ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>


/* 定位成功，进行成功信息 */
@property(nonatomic, copy) GeoCodeResult localtionBlock;
/* 定位失败，进行回调错误信息 */
@property(nonatomic, copy) BaiduLocaltionFailBlock failBlock;

/* 定时器用于判断定位超时 */
@property(nonatomic, weak) NSTimer *timer;
@end

@implementation BaiduGeoReusltService

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return self;
}


- (void)dealloc{
    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
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

    [self stopUpdatingLocation];
    self.userLocation = userLocation.location;
    [self p_searcher];
}

// 检索
- (void)p_searcher
{
    _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    float y = self.userLocation.coordinate.latitude;//纬度
    float x = self.userLocation.coordinate.longitude;//经度
    //发起反向地理编码检索
    CLLocationCoordinate2D pt1 = (CLLocationCoordinate2D){y, x};
    _reverseGeoCodeOption.reverseGeoPoint = pt1;
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    BOOL flag = [self.geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];

    if (flag)
    {
        MLLog(@"反geo检索发送成功");
    } else {
        MLLog(@"反geo检索发送失败");
    }
}


/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout localSuceess:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail{
    [self localtionManagerWithTimeOut:timeout isContinuousLocal:NO localSuceess:localBlock fail:fail];
}

/* 定位 */
+ (void)localtionManagerWithTimeOut:(NSTimeInterval)timeout isContinuousLocal:(BOOL)isContinuousLocal localSuceess:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail{

    BaiduGeoReusltService  *locationManager = [[BaiduGeoReusltService alloc] init];
    locationManager.timeout = timeout;
    [locationManager BaiduLocaltionInformation:localBlock fail:fail];
}


- (void)startTimer{
    [self releaseTimer];
   {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeout target:self selector:@selector(TimerEnd) userInfo:nil repeats:NO];
    }
}



- (void)TimerEnd{
    [self releaseTimer];
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
    BOOL status = [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied;
    if (status) {
        if (self.failBlock) {
            [self releaseTimer];
            NSError *error = [NSError errorWithDomain:@"定位失败" code:111111111 userInfo:@{@"errorMsg":@"当前定位不能使用,请确认启动了定位服务"}];
            self.failBlock(error);
        }
        return;
    }

    [self startUpdatingLocation];
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
- (void)BaiduLocaltionInformation:(GeoCodeResult)localBlock fail:(BaiduLocaltionFailBlock)fail{
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

#pragma mark -- BMKGeoCodeSearchDelegate
#pragma mark 代理方法返回地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (result) {
        NSString *locationString = [NSString stringWithFormat:@"经度为：%.2f   纬度为：%.2f", result.location.longitude, result.location.latitude];
        NSLog(@"经纬度为：%@ 的位置结果是：%@", locationString, result.address);
        //        NSLog(@"%@", result.address);
    }else{
        //        self.location.text = @"找不到相对应的位置";
        NSLog(@"%@", @"找不到相对应的位置");
    }
}

//周边信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    for (BMKPoiInfo *poi in result.poiList) {
        NSLog(@"%@",poi.name);//周边建筑名
        NSLog(@"%d",poi.epoitype);

    }
    self.result = result;
    self.localtionBlock(self.locService, result);
}
@end
