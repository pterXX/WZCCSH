//
//  SelecteAPPIDViewController.m
//  city
//
//  Created by asdasd on 2017/7/25.
//  Copyright © 2017年 sjw. All rights reserved.
//


/*
 *         2.0.4 合并城市生活app
 *        新增页面  选择城市生活开通城市的app_id
 *        需求: 1.通过GPS定位出的城市，如果该城市已开通城市生活，点击后进入该城市首页。 如果该城市没有开通城市生活，点击后弹出提示
 *             2.A、B、C、D……只显示已开通的城市，没有开通的城市就不显示。例如，如果“E”没有城市，那么“E”以及E下面的城市都不显示
 *             3.点击显示的列表，就切换到到当前选中城市的内容
 *             4.如果用户没有选中，点击关闭按钮，默认选中万州
 */



#import "SelecteAPPIDViewController.h"
//#import "XWLocationManager.h"
#import "MJRefresh.h"
#import "UMMobClick/MobClick.h"
#import "OnlyLocationManager.h"
#import "CityInfo.h"
#import "MessageBox.h"
#import "XQLoginExample.h"
#import "MessageBox.h"
#import "BaiduLocationService.h"

/**
 *   首页-》选择城市的appid
 */
@interface SelecteAPPIDViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *tableHeadView; // 表头
@property (weak, nonatomic) IBOutlet UITableView *tableView;// 当前展示数据的数据表
@property (weak, nonatomic) IBOutlet UILabel     *CityName;// 定位成功后得到后的地理位置
@property (weak, nonatomic) IBOutlet UILabel     *subtitleLabel; //  地理位置后面的副标题

@property (nonatomic,strong) NSMutableDictionary *dataSource;// 数据源
@property (nonatomic,strong) NSMutableArray      *shortKeys;// 字母数组
@property (nonatomic,strong) NSString            *loctionCity;//  保存定位得到城市名
@property (nonatomic,strong) NSString            *loctionProvince;// 保存定位获得省市名
@property (nonatomic,strong) NSString            *localArea;// 保存得到的城市名称
@property (nonatomic,assign) BOOL                isLocaltion;//  判断是否定位成功
@end

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";

@implementation SelecteAPPIDViewController

- (void)viewDidLoad {
    [super viewDidLoad]; //
   //  设置表头和cell
    [self configTableHeadViewWithCellClass];
      // 定位
    [self localtionAction];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)xq_layoutNavigation{
    self.title = @"请选择城市";
    if ([XQLoginExample lastCityCode]) {
        UIButton *customBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [customBtn setBackgroundImage:[UIImage imageNamed:@"selectCity_close.png"] forState:UIControlStateNormal];
        customBtn.frame = CGRectMake(0, 0, 20, 20);
        [customBtn addTarget:self action:@selector(navigationItemLeftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    }
}


/**
 导航栏左侧按钮的点击
 当左侧按钮点击的时候，表示没有直接选择城市，所以就直接显示默认为万州的页面
 @param sender 当前点击的按钮
 */
- (void)navigationItemLeftButtonAction:(UIButton *)sender{
    if (APP_ID == nil || APP_ID.length == 0) {
        NSDictionary *cityInfo = [NSDictionary dictionary];
        //  需求4.如果用户没有选中，点击关闭按钮，默认选中万州
        cityInfo = @{@"id": @"1",@"cityname": @"万州",@"app_id": @"101", @"short":@"W"};


        //  保存当前城市的信息
        [CityInfo setCItyInfo:cityInfo];

        if (self.didCitySuccess) {
            self.didCitySuccess();
        }
//        [TemplateConfigs defaultDisplayCityOfCityInfo:CityInfo success:^{
//            
//        }];

        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 配置表头与cell
 */
- (void)configTableHeadViewWithCellClass{
    [self.tableView setTableHeaderView:self.tableHeadView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewIdentifier];
    self.tableView.sectionIndexBackgroundColor  = [UIColor clearColor];
    self.tableView.sectionIndexColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1.00];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor grayColor];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(xq_getNewData)];
}


- (void)xq_getNewData{
    [MLHTTPRequest GETWithURL:CSSH_GET_CITY_APP parameters:nil success:^(MLHTTPRequestResult *result) {
        if (result.errcode == 0) {
            NSMutableArray *array = [result.data allKeys].mutableCopy;
            self.shortKeys = [NSMutableArray array];

            //  排序
            self.shortKeys = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }].mutableCopy;


            [self.tableView.mj_header endRefreshing];
            self.dataSource = result.data;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
    } isResponseCache:YES];
}



/**
  需求1: 通过GPS定位出的城市，如果该城市已开通城市生活，点击后进入该城市首页。
   如果该城市没有开通城市生活，点击后弹出提示
 */
- (void)determineWhetherCurrentCityHasBeenOpenedAppOfCity:(NSString *)city
{
    NSDictionary *citys = @{@"citys": city};
    [MLHTTPRequest GETWithURL:CSSH_GET_LOC_CITY_APP parameters:citys success:^(MLHTTPRequestResult *result) {
        if (result.errcode == 0) {
            [XQLoginExample setLastCity:result.data[@"cityname"]];
            [XQLoginExample setLastCityCode:result.data[@"app_id"]];
            if (self.didCitySuccess) {
                self.didCitySuccess();
            }
            //  选择默认显示的城市
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MessageBox showAlertWithTitle:@"提示" message:@"该城市暂未开通城市生活,请选择其他城市" block:^(NSInteger index) {

            }];
        }
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
    } isResponseCache:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shortKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)self.dataSource[self.shortKeys[section]]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
    cell.textLabel.text = self.dataSource[self.shortKeys[indexPath.section]][indexPath.row][@"cityname"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.shortKeys[section];
}

#pragma mark -  设置右侧索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return  self.shortKeys;
}

#pragma mark - 设置右侧索引的点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionTop];
    return index;
}

#pragma mark - UITableViewDelegate
/**
 需求3:点击显示的列表，就切换到到当前选中城市的内容

 @param tableView 当前显示的城市列表
 @param indexPath 当前城市的序列
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CityInfo setCItyInfo:self.dataSource[self.shortKeys[indexPath.section]][indexPath.row]];
    [XQLoginExample setLastCity:[CityInfo CityName]];
    [XQLoginExample setLastCityCode:[CityInfo CityAPP_ID]];
    if (self.didCitySuccess) {
        self.didCitySuccess();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



/**
 点击定位View,当点击的时候就直接进行定位的操作，
 如果定位到城市的话就直接显示当前的城市的城市名，如果没有定位成功就显示定位失败的的问题
 定位失败后可以继续点击进行定位，否者就直接判断当前城市是否已经开通城市生活

 @param sender 当前点击的手势
 */
- (IBAction)localtionViewTapGesture:(id)sender {
    
    //  判断是否已经定位成功,如果已经定位成功，就直接选择城市判断是否已经开通了城市生活
    if (self.isLocaltion) {
        [self determineWhetherCurrentCityHasBeenOpenedAppOfCity:self.localArea];
        return;
    }
    //  定位
    [self localtionAction];
    
}

- (void)localtionAction{
    self.CityName.text = @"定位中...";
    [BaiduLocationService localtionManagerWithTimeOut:20  localSuceess:^(BMKLocationService *localManager, CLPlacemark *placemark) {
        self.isLocaltion = YES;
        //获取城市
        NSString *city = placemark.locality;
        if (!city) {
            //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
            city = placemark.administrativeArea;
        }
        self.CityName.text = [NSString stringWithFormat:@"%@  %@",city,placemark.subLocality];
        self.localArea =  [NSString stringWithFormat:@"%@,%@,%@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
        //  保存定位的城市名，再次点击定位城市cell的时候回直接跳转到资讯的页面
        _loctionCity = placemark.subLocality;
        _loctionProvince = city;
    } fail:^(NSError *error) {
        self.isLocaltion = NO;
        self.CityName.text = @"定位失败";
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end

