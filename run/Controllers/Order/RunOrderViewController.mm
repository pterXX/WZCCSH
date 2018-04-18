//
//  RunOrderViewController.m
//  city
//
//  Created by asdasd on 2018/2/5.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "RunOrderViewController.h"
#import "UIScrollView+DataEmptyView.h"
#import "RouteAnnotation.h"
#import "BMKPolyline+type.h"
#import <YYText.h>
@interface RunOrderViewController () <BMKMapViewDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *amount; //  本单收入
@property (weak, nonatomic) IBOutlet UILabel *time;  //  时间
@property (weak, nonatomic) IBOutlet UILabel *s_address; //  起点地址
@property (weak, nonatomic) IBOutlet UILabel *s_subaddr; //  详细地址
@property (weak, nonatomic) IBOutlet UILabel *e_address; //  终点地址
@property (weak, nonatomic) IBOutlet UILabel *e_subadd;  //  子地址详细地址

@property (weak, nonatomic) IBOutlet UILabel *remark; // 备注
@property (weak, nonatomic) IBOutlet UILabel *distance; //  距离
@property (weak, nonatomic) IBOutlet UIView *bigBtnBackView; //  抢单按钮的第背景
@property (weak, nonatomic) IBOutlet UIButton *bigBtn; // 抢单按钮
@property (weak, nonatomic) IBOutlet UILabel *delivery_time; //   取件时间
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIView *mapBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *distanceBgView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *order_idLable;

@property (nonatomic ,strong) UIView *mapMaskView;
@property (nonatomic ,strong) BMKMapView *mapView;
@property (nonatomic ,strong) BMKRouteSearch *routeSearch;
@property (nonatomic ,strong) BMKRouteSearch *routeSelfSearch;
@property (nonatomic ,strong) BMKLocationService *locService;
@end

@implementation RunOrderViewController

- (void)dealloc{
    _mapView = nil;
    _routeSearch = nil;
    _routeSelfSearch = nil;
    _locService = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _routeSearch = [[BMKRouteSearch alloc] init];
    _routeSearch.delegate = self;

    _routeSelfSearch = [[BMKRouteSearch alloc] init];
    _routeSelfSearch.delegate = self;
}

//遵循代理写在viewwillappear中
- (void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locService.delegate = self;
    _routeSearch.delegate = self;
    _routeSelfSearch.delegate = self;

}

- (void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _locService.delegate = nil;
    _routeSearch.delegate = nil;
    _routeSelfSearch.delegate = nil;
}

- (void)search:(BOOL)isSearchSelf{
    //初始化检索对象
    //构造骑行查询基础信息类
    if (isSearchSelf) {
        BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
        option.from = self.viewModel.selfNode;
        option.to = self.viewModel.currentEndNode;
        BOOL flag = [self.routeSelfSearch ridingSearch:option];
        if (flag){
            MLLog(@"骑行规划检索发送成功");
        }else{
            MLLog(@"骑行规划检索发送失败");
        }
    }else{
        // 只有在非送货状态下才能显示当前取货点和货点的路线
        if ([self.viewModel isCurrentOfPickupGoods]) {
            BMKRidingRoutePlanOption *option = [[BMKRidingRoutePlanOption alloc]init];
            option.from = self.viewModel.start;
            option.to = self.viewModel.end;
            BOOL flag = [self.routeSearch ridingSearch:option];
            if (flag){
                MLLog(@"骑行规划检索发送成功");
            }else{
                MLLog(@"骑行规划检索发送失败");
            }
        }
    }
    

}

- (void)xq_addSubViews{
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    [UIFont adjusAllSubViewsFontWithUIScreen:375.0 youView:self.view];
    self.bigBtnBackView.hidden = YES;
    self.bigBtn.layer.cornerRadius = SJAdapter(6);
    self.bigBtn.layer.masksToBounds = YES;
    self.s_address.numberOfLines = 0;
    self.e_address.numberOfLines = 0;

    self.scrollView.bounces = NO;

    [self.mapBackgroundView addSubview:self.mapView];
    [self.mapBackgroundView sendSubviewToBack:self.mapView];
    [self.mapBackgroundView addSubview:self.mapMaskView];

    @weakify(self);
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.mapMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.mapView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];


    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [[self.viewModel mapMaskViewClickSubject] sendNext:nil];
    }];
    [self.mapMaskView addGestureRecognizer:tap];
}

-(void)xq_layoutNavigation{
    self.title = @"订单详情";
}

- (void)xq_bindViewModel{
    @weakify(self);
    [self.viewModel.refreshDataCommand execute:nil];
    [self.viewModel.refreshUISubject subscribeNext:^(id x) {

        @strongify(self);
        [self.scrollView setIsShowDataEmpty:NO];

        [self.scrollView stopLoadingAnimation];
    }];

    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        [self.scrollView reloadEmptyDataSet];
        [self.scrollView stopLoadingAnimation];

        switch ([x integerValue]) {
                break;
            case XQHeaderRefresh_HasNoMoreData: {
                [self.scrollView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoOrderData];
            }
                break;
                break;
            case XQHeaderRefresh_HasLoadingData:{
                [self.scrollView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeLoading];
            }
                break;
            case XQRefreshError: {
                [self.scrollView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoNetwork];
            }
                break;

            default:
                break;
        }
    }];

    

    [RACObserve(self.viewModel, model) subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        if (x) {
            [self p_refreshCurrentDataOfPage];

            //  搜索路线
            [self search:NO];
            [self search:YES];
        }
    }];

    [RACObserve(self.viewModel.selfNode, pt) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //  搜索路线
        [self search:YES];
    }];

    [RACObserve(self.viewModel, distance) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
            self.distanceLabel.text = [self.viewModel distanceStr];
    }];

//    [self.viewModel.cellClickSubject subscribeNext:^(RunOrderListModel *  _Nullable x) {
//        RunOrderViewController *vc =    [[RunOrderViewController alloc] init];
//        vc.aid = x.aid;
//        vc.isGrabSingle = x.order_status.intValue == 0;
//        [self.navigationController pushViewController:vc animated:YES];
//    }];

}

//  刷新当前页面的数据
- (void)p_refreshCurrentDataOfPage
{
    RunOrderModel *model = self.viewModel.model;
    self.amount.text = model.income;
    NSInteger interger = [model.arrive_time integerValue];
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(interger / 60)];
    NSString *time = [NSString stringWithFormat:@"%@分钟内",timeStr];
    self.time.attributedText = [time changeString:@"分钟内" subFontColor:[UIColor
                                                                       colorWithRed:255.0f/255.0f
                                                                       green:136.0f/255.0f
                                                                       blue:3.0f/255.0f
                                                                       alpha:1.0f] subFont:[UIFont adjustFont:12]];

    self.s_address.text =  model.start_address;
    self.e_address.text =  model.end_address;

    self.delivery_time.text = model.delivery_dateline;
    self.distance.text = [NSString stringWithFormat:@"%.fkm",(model.distance.floatValue / 1000.0)];
    self.s_subaddr.text = model.start_addr;
    self.e_subadd.text = model.end_addr;

     self.remark.text = model.combination;
    self.view1.hidden = model.combination.length == 0;
    self.view2.hidden = self.view1.hidden;

    self.order_idLable.text = model.order_id;
    self.view3.hidden = model.order_id == 0;
    self.view4.hidden = self.view3.hidden;

    self.bigBtnBackView.hidden = [self.viewModel isGrabSingle] == NO;
}


- (void)sureAlert{
    __weak typeof(self) wkself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认抢单" message:@"请仔细查看订单信息,抢单成功后请务必按照平台规定完成配送" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"确认抢单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [wkself editOrderWithStatus:@"1" code:nil];
    }]];

    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (IBAction)bigBtnAction:(id)sender{
    [self sureAlert];
}

/*
 status    Y        订单状态（1抢单2取件完成3跑腿员确认送达4取消订单5删除订单）
 id    Y        订单ID
 code    Y        收货码，当转台为3时必填
 */
- (void)editOrderWithStatus:(NSString *)status code:(NSString *)code {
      self.bigBtn.enabled = NO;
    __weak typeof(self) wkself = self;

    [MLHTTPRequest POSTWithURL:RUN_ORDER_EDITSTATUS parameters:@{@"status":status,
                                                                 @"id":self.viewModel.model.aid?:@"",
                                                                 @"code":code?:@"" }
                       success:^(MLHTTPRequestResult *result) {
                           if (result.errcode == 0) {
                               [self alert:nil message:result.errmsg sureBlock:^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];

                           }else{
                               self.bigBtn.hidden = YES;
                               [self alert:nil message:result.errmsg sureBlock:^{
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
                           }
                       } failure:^(NSError *error) {
                           self.bigBtn.enabled = YES;
                       }];
}

- (void)alert:(NSString *)title message:(NSString *)message sureBlock:(void(^)(void))sureBlock{
//    __weak typeof(self) wkself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock();
    }]];
    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    //MLLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    self.viewModel.selfNode.pt = userLocation.location.coordinate;
    //  结束定位
    [self.locService stopUserLocationService];
}

#pragma mark - 设置标记点
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

#pragma mark 根据overlay生成对应的View
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        //  分段颜色
        polylineView.colors  = [NSArray arrayWithObjects:
                                RGB(32, 203, 235, 1.0),
                                RGB(0, 210, 0, 1.0),nil];
        polylineView.lineWidth = 1.0;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"icon_dis"]];
        return polylineView;
    }
    return nil;
}

/**
 *返回骑行搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKRidingRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetRidingRouteResult:(BMKRouteSearch *)searcher result:(BMKRidingRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        [self mapViewGenerateLine:result searcher:searcher];

        [self mapViewDistance:result searcher:searcher];

    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR) {

    }
}

#pragma mark - 获取距离取货点的距离
- (void)mapViewDistance:(BMKRidingRouteResult *)result searcher:(BMKRouteSearch *)searcher {
    ///  判断当前是否是取货状态
    if ([self.viewModel isCurrentOfPickupGoods] && self.routeSearch == searcher) {
        ///  获取取货点的距离
        BMKRidingRouteLine *line =  result.routes.count > 0?result.routes.firstObject:nil;
        self.viewModel.distance = line?line.distance:0;
    }else{
        ///  获取收货点的距离
        BMKRidingRouteLine *line =  result.routes.count > 0?result.routes.firstObject:nil;
        self.viewModel.distance = line?line.distance:0;
    }
}

#pragma mark - 根据路线生成节点线条
- (void)mapViewGenerateLine:(BMKRidingRouteResult *)result searcher:(BMKRouteSearch *)searcher {
    BMKRidingRouteLine* plan = (BMKRidingRouteLine*)[result.routes objectAtIndex:0];
    NSInteger size = [plan.steps count];
    int planPointCounts = 0;
    for (int i = 0; i < size; i++) {
        BMKRidingStep* transitStep = [plan.steps objectAtIndex:i];
        if (i == 0) {
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.starting.location;
            if (searcher == self.routeSearch) {
                item.title = @"取货地点";
                item.type = 0;
            }else if (searcher == self.routeSelfSearch){
                item.title = @"当前位置";
                item.type = 7;
            }

            [_mapView addAnnotation:item]; // 添加起点标注
        }
        if(i == size - 1){
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = plan.terminal.location;
            if (searcher == self.routeSearch) {
                item.title = @"终点";
                item.type = 1;
            }else if (searcher == self.routeSelfSearch){
                if ([self.viewModel isCurrentOfPickupGoods]) {
                     item.title = @"取货地点";
                    item.type = 0;
                }else{
                    item.title = @"收货地点";
                    item.type = 1;
                }
            }


            [_mapView addAnnotation:item]; // 添加起点标注
        }
//        //添加annotation节点
//        RouteAnnotation* item = [[RouteAnnotation alloc]init];
//        item.coordinate = transitStep.entrace.location;
//        item.title = transitStep.instruction;
//        item.degree = (int)transitStep.direction * 30;
//        item.type = 4;
//        [_mapView addAnnotation:item];

        //轨迹点总数累计
        planPointCounts += transitStep.pointsCount;
    }

    //轨迹点
    BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
    int i = 0;
    for (int j = 0; j < size; j++) {
        BMKRidingStep* transitStep = [plan.steps objectAtIndex:j];
        int k=0;
        for(k=0;k<transitStep.pointsCount;k++) {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }

    }
    NSMutableArray *textureIndex = [NSMutableArray array];
    if (searcher == self.routeSearch) {
        for (NSInteger i = 0; i < planPointCounts; i ++) {
            [textureIndex addObject:@(0)];
        }
    }else if (searcher == self.routeSelfSearch){
        for (NSInteger i = 0; i < planPointCounts; i ++) {
            [textureIndex addObject:@(1)];
        }
    }
    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts textureIndex:textureIndex];
    [_mapView addOverlay:polyLine]; // 添加路线overlay
    delete []temppoints;
    [self mapViewFitPolyLine:polyLine];
}


#pragma mark  根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;

    if (polyLine.pointCount < 1) return;
    BMKMapPoint pt = polyLine.points[0];
    static_cast<void>(ltX = pt.x), ltY = pt.y;
    static_cast<void>(rbX = pt.x), rbY = pt.y;

    for (int i = 0; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}


#pragma mark - LazyLoad
- (OrderViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[OrderViewModel alloc] init];
    }
    return _viewModel;
}

- (BMKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
        _mapView.mapType         = BMKMapTypeStandard;//设置地图为标准地图
        _mapView.logoPosition    = BMKLogoPositionLeftBottom;//  设置logo 显示位置
        _mapView.gesturesEnabled = YES;///设定地图View能否支持所有手势操作
        _mapView.delegate        = self;
        _mapView.backgroundColor = [UIColor whiteColor];


        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //启动LocationService
        [_locService startUserLocationService];
    }
    return _mapView;
}

- (UIView *)mapMaskView{
    if (_mapMaskView == nil) {
        _mapMaskView = [[UIView alloc] init];
    }
    return _mapMaskView;
}


#pragma mark - Preview Actions

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {

    if (self.viewModel.isGrabSingle) {
//        UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"抢单" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//            [self sureAlert];
//        }];
//
//        UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//        }];
        return nil;
    }else{
//        UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Destructive Action" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//            NSLog(@"Destructive Action triggered");
//        }];
//
//        UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Selected Action" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//            NSLog(@"Selected Action triggered");
//        }];
//         return @[action2,action3];
        return nil;
    }
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
