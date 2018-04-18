//
//  BaiDuMapViewViewController.m
//  city
//
//  Created by 3158 on 2017/9/6.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "BaiDuMapViewViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <MapKit/MKMapItem.h>


#import "SDAutoLayout.h"



/*
 *  首页-》餐饮美食-》详情-》地图定位
 */
@interface BaiDuMapViewViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
@property (nonatomic ,strong) BMKMapView* mapView;
@property (nonatomic ,strong) BMKLocationService *locService;
@end

static  NSString  *kBaiduMapIdentifier = @"kBaiduMapIdentifier";

@implementation BaiDuMapViewViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        //!  这里是测试参数，上架需要改为动态的参数
        //    self.latitude = @"33.073518";
        //    self.longitude = @"115.263452";
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //    116.339303,40.011823
    [self configMapView];
    [self configPoint];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (NSString *)description{
    return  [NSString stringWithFormat:@"current location: name = %@ ,addr = %@ , longitude = %@, latitude = %@, tx_longitude = %@, tx_latitude = %@", self.name,self.addr,self.longitude,self.latitude,self.tx_longitude,self.tx_latitude];
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //MLLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //MLLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

/**
 配置地图
 */
- (void)configMapView{
    // Do any additional setup after loading the view from its nib.
    BMKMapView* mapView          = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT - 64)];
    self.mapView                 = mapView;
    //  设置
    self.mapView.mapType         = BMKMapTypeStandard;//设置地图为标准地图
    self.mapView.logoPosition    = BMKLogoPositionLeftBottom;//  设置logo 显示位置
    self.mapView.gesturesEnabled = YES;///设定地图View能否支持所有手势操作
    self.mapView.delegate        = self;
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.view = mapView;
    

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}


/**
 配置需要显示的坐标
 */
- (void)configPoint{
    CLLocationDegrees latitude  = [self.latitude floatValue];
    CLLocationDegrees longitude = [self.longitude floatValue];
    if (latitude > 90.0f || latitude < 0.0f  || longitude > 180.0f || longitude < 90.0f ) {
        [MessageToast showMessage:@"地理位置错误"];
        return;
    }
    
    
    // 添加一个PointAnnotation
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    
    coor.latitude         = latitude;
    coor.longitude        = longitude;
    annotation.coordinate = coor;
    annotation.title      = self.addr;
    [_mapView addAnnotation:annotation];
    [_mapView setZoomLevel:18.0];
    
    [_mapView setCenterCoordinate:coor]; //  设置地图的中心点
    
    //  显示标注
//    [_mapView showAnnotations:@[annotation] animated:YES];
}


/**
 配置弹出框
 */
- (BMKPinAnnotationView *)configAnnotationViewOfForAnnotation:(id <BMKAnnotation>)annotation{
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kBaiduMapIdentifier];
    newAnnotationView.pinColor = BMKPinAnnotationColorRed; //  设置标点的动画
    newAnnotationView.animatesDrop  = YES; //  设置该标点动画显示
    UIView *areaPaoView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 70)];
    areaPaoView.backgroundColor     = [UIColor whiteColor];
    areaPaoView.layer.borderWidth   = 1;
    areaPaoView.layer.borderColor   = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.00].CGColor;
    areaPaoView.layer.masksToBounds = YES;
    areaPaoView.layer.cornerRadius  = 3;
    
    //  这里可以自定义内容气泡
    //注意：这里面控件的代码不完全，改成你们想要的View）
    UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [navigationBtn setBackgroundColor:COLOR_FE9928];
    [navigationBtn setTitle:@"导航" forState:UIControlStateNormal];
    [navigationBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [navigationBtn addTarget:self action:@selector(navigationButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    navigationBtn.layer.masksToBounds = YES;
    navigationBtn.layer.cornerRadius  = 3;
    [areaPaoView addSubview:navigationBtn];
    
    
    UILabel * labelNo = [[UILabel alloc]init];
    labelNo.textColor     = [UIColor blackColor];
    labelNo.font          = [UIFont systemFontOfSize:16];
    labelNo.numberOfLines = 0;
    labelNo.text          = self.name;
    [areaPaoView addSubview:labelNo];
    
    UILabel * labelStationName = [[UILabel alloc]init];
    labelStationName.textColor     = [UIColor blackColor];
    labelStationName.font          = [UIFont systemFontOfSize:13];
    labelStationName.textAlignment = NSTextAlignmentLeft;
    labelStationName.text          = self.addr;
    labelStationName.numberOfLines = 0;
    [areaPaoView addSubview:labelStationName];
    
    CGFloat margin                      = 10;
    CGFloat labelForWidthls             = 160;
    CGFloat labellNoForHeightls         = [self.name sizeWithFont:labelNo.font maxSize:CGSizeMake(labelForWidthls, CGFLOAT_MAX)].height;
    CGFloat labelStationNameForHeightls = [self.addr sizeWithFont:labelStationName.font maxSize:CGSizeMake(labelForWidthls, CGFLOAT_MAX)].height;
    CGFloat navigationForWidthls        = 70.0;
    CGFloat navigationForHeightls       = labellNoForHeightls + labelStationNameForHeightls + 5;
    navigationForHeightls = navigationForHeightls < navigationForWidthls ? navigationForWidthls:navigationForHeightls;
    
    [labelNo setFrame:CGRectMake(margin, margin, labelForWidthls, labellNoForHeightls)];
    [labelStationName setFrame:CGRectMake(margin, labelNo.bottom + 5, labelForWidthls, labelStationNameForHeightls)];
    [navigationBtn setFrame:CGRectMake(labelNo.right + margin, margin,  navigationForWidthls,navigationForHeightls)];
    [areaPaoView setBounds:CGRectMake(0, 0, navigationBtn.right + margin, navigationBtn.bottom + margin)];
    
    //布局完之后将View整体添加到BMKActionPaopaoView上
    BMKActionPaopaoView *paopao =[[BMKActionPaopaoView alloc] initWithCustomView:areaPaoView];
    newAnnotationView.paopaoView = paopao;
    //        newAnnotationView.
    return newAnnotationView;
}




- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response Methods
- (void)navigationButtonTaped:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([[UIApplication alloc] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self onDaoHangForBaiDuMap];
        }]];
    }
    
    if ([[UIApplication alloc] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [alert addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self onDaoHangForGaoDeMap];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"苹果自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self onDaoHangForIOSMap];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self onDaoHangForIOSMap];
    }]];
    
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}


#pragma mark - BMKMapViewDelegate

/**
 *地图初始化完毕时会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    MLLog(@"%s",__func__);
}

/**
 *地图渲染完毕后会调用此接口
 *@param mapView 地图View
 */
- (void)mapViewDidFinishRendering:(BMKMapView *)mapView{
    MLLog(@"%s",__func__);
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapView 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
    MLLog(@"%s",__func__);
}

/**
 *地图区域即将改变时会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    MLLog(@"%s",__func__);
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MLLog(@"%s",__func__);
}

/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    MLLog(@"%s",__func__);
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *pinAnnotationView =  [self configAnnotationViewOfForAnnotation:annotation];
        pinAnnotationView.selected =  YES; //  设置选中
//        [mapView mapForceRefresh]; //  pinAnnotationView 设置选中 强制刷新mapview才能显示选中的pinView
        return pinAnnotationView;
    }
    return nil;
}

/**
 *当mapView新添加annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 新添加的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    MLLog(@"%s",__func__);
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    MLLog(@"%s",__func__);
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    MLLog(@"%s",__func__);
}

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    MLLog(@"%s",__func__);
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    MLLog(@"%s",__func__);
}


#pragma mark ------------------------------ 导航 - 百度
-(void) onDaoHangForBaiDuMap{
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?destination=latlng:%@,%@|name:%@&mode=driving",self.latitude,self.longitude,self.name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
}

#pragma mark ------------------------------ 导航 - 高德
-(void) onDaoHangForGaoDeMap{
    //  使用高德或腾讯地图是使用腾讯坐标
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",[UIDevice appCurName],APP_URlSchema,self.tx_latitude, self.tx_longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
#pragma mark ------------------------------ 导航 - iosMap
-(void) onDaoHangForIOSMap{
    //  使用高德或腾讯地图是使用腾讯坐标
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.tx_latitude floatValue], [self.tx_longitude floatValue]);
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation      = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
    toLocation.name            =  self.name;
    
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                   MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
