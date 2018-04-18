//
//  OnlyLocationManager.m
//  OnlyLocation
//
//  Created by Mr.S on 2016/12/22.
//  Copyright © 2016年 ST.MEDIA. All rights reserved.
//

#import "OnlyLocationManager.h"
#define GEOCODING @"https://api.map.baidu.com/geocoder/v2/?ak=%@&location=%f,%f&output=json"

@interface OnlyLocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    CLLocation *_location;
    CLLocationCoordinate2D _coordinate;
    BOOL inited;
}

@property InitResultCallBack initCallBack;
@property ResultCallBack resultCallBack;
@property BOOL always;
@property BOOL needVO;

@end

@implementation OnlyLocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([change[NSKeyValueChangeNewKey] integerValue] != [change[NSKeyValueChangeOldKey] integerValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationStateNoti object:nil];
    }
}

+(instancetype)getLocationManager{
    static OnlyLocationManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OnlyLocationManager alloc]init];
        manager.state = 0;
    });
    return manager;
}

+(instancetype)shareManager:(BOOL)always needVO:(BOOL)needVO initCallBack:(InitResultCallBack)initCallBack resultCallBack:(ResultCallBack)resultCallBack{
    OnlyLocationManager* manager = [OnlyLocationManager getLocationManager];
    manager.initCallBack = initCallBack;
    manager.resultCallBack = resultCallBack;
    manager.always = always;
    manager.needVO = needVO;
    [manager initLocationManager];
    
    return manager;
}

-(void)initLocationManager{
    
    if (!_geocoder && self.needVO) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager requestAlwaysAuthorization];
        }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            if (self.initCallBack) {
                self.initCallBack(2,nil);
            }
        }else{
            [self fillLocationManager];
        }
    }else
    {
        if (self.initCallBack) {
            self.initCallBack(1,nil);
        }
    }
}

-(void)fillLocationManager{
    inited = YES;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locationManager.distanceFilter = distance;
    if (self.initCallBack) {
        self.initCallBack(0,_locationManager);
    }
    self.state = InLocalization;
    [_locationManager startUpdatingLocation];
}

+(OnlyLocationVO *)getOldLocation
{
    return [OnlyLocationVO getLastLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    _location=[locations firstObject];//取出第一个位置
    _coordinate=_location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",_coordinate.longitude,_coordinate.latitude,_location.altitude,_location.course,_location.speed);
    
    if (self.always) {
        self.state = Continually;
        if (self.resultCallBack) {
            self.resultCallBack(_coordinate,_location,nil);
        }
    }else
    {
        self.state = LocatedNOVO;
        if (self.needVO) {
            [self getAddress:self.resultCallBack];
            [_locationManager stopUpdatingLocation];
        }else
        {
            if (self.resultCallBack) {
                self.resultCallBack(_coordinate,_location,nil);
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusDenied){
        if (self.initCallBack) {
            self.initCallBack(2,nil);
        }
    }else
    {
        [self fillLocationManager];
    }
}

#pragma mark 根据坐标取得地名
-(void)getAddress:(ResultCallBack)resultCallBack{
    //反地理编码
    NSString* url=[NSString stringWithFormat:GEOCODING,GEOCODINGAK,_coordinate.latitude,_coordinate.longitude];
    [NetAndUDManager getWith:url completionHandler:^(NSDictionary *data, NSError *error) {
        NSLog(@"%@",data);
        if (error) {
            self.state = LocatedVOFiled;
            if (resultCallBack) {
                resultCallBack(_coordinate,_location,nil);
            }
            
        }else
        {
            self.state = Located;
            OnlyLocationVO* locationVO = [OnlyLocationVO getLocationFromDic:data[@"result"]];
            [locationVO saveToUD];
            if (resultCallBack) {
                resultCallBack(_coordinate,_location,locationVO);
            }
        }
    }];
}

+(void)getLocation:(ResultCallBack)resultCallBack
{
    [[OnlyLocationManager getLocationManager] getAddress:resultCallBack];
}

@end
