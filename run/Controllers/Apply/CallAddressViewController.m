//
//  CallAddressViewController.m
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "CallAddressViewController.h"
#import "UIView+Category.h"
#import "CallAddressTableViewCell.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "IQKeyboardManager.h"

@interface CallAddressViewController () <UITableViewDelegate,UITableViewDataSource,BMKSuggestionSearchDelegate,BMKPoiSearchDelegate>
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) BMKSuggestionSearch *sugSearch;
@property (nonatomic ,strong) BMKPoiSearch *searcher;


@property (nonatomic ,strong) NSArray<CallAddressModel *> *dataSouce;
@end

@implementation CallAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB(245.0f, 245.0f, 245.0f, 1.0) ;
    [self p_setupViews];
    [self p_initializeSercher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    [self p_dataRquest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    _sugSearch.delegate = nil;
    _searcher.delegate = nil;
}

#pragma mark - Private
//  适配iPhoneX
- (void)p_adapterIPhonex
{
    if (@available(iOS 11.0, *)) {
        self.tableView .contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)p_setupViews
{
    self.title = @"选择地址";
    //层级：1，父视图：UIView 的UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0.00f, 0.00f, 375.00f,667.00f) style:UITableViewStylePlain];
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[UIView new]];
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    //  适配iPhone X
    [self p_adapterIPhonex];
    
    //层级：2，父视图：UITableView 的UIView
    UIView *addressTextBgView          = [[UIView alloc]initWithFrame:CGRectMake(0.00f,0.00f,375.00f,48.00f)];
    addressTextBgView.backgroundColor  = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self.view addSubview:addressTextBgView];
    
    //层级：3，父视图：UIView 的UIImageView
    UIImageView *icon = [[UIImageView alloc]init];
    icon.frame        = CGRectMake(10.00f,15.00f,18.50f,18.00f);
    icon.image        = [UIImage imageNamed:@"search_ser_Icon"];
    icon.userInteractionEnabled  = NO;
    [addressTextBgView addSubview:icon];
    
    //层级：3，父视图：UIView 的UITextField
    UITextField *addressTextF = [[UITextField alloc]initWithFrame:CGRectMake(43.50f,0.00f,321.50f,48.00f)];
    addressTextF.borderStyle  = UITextBorderStyleNone;
    addressTextF.backgroundColor  = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.00f];
    addressTextF.placeholder  = @"小区名/大厦名/街道门牌号";
    addressTextF.font         = [UIFont fontWithName:@".SFUIText" size:14.00f];
    addressTextF.textColor    = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
    addressTextF.secureTextEntry = NO;
    addressTextF.autocorrectionType = UITextAutocorrectionTypeDefault;
    addressTextF.keyboardType  = UIKeyboardTypeDefault;
    addressTextF.returnKeyType = UIReturnKeyDefault;
    [addressTextBgView addSubview:addressTextF];
    self.textField = addressTextF;
    
    // 适配大小
    [addressTextBgView adaptSizeSubViewsYouUIScreenWidth:375.0f];
    [addressTextBgView setFrame:CGRectMake(0, 0, KWIDTH, SJAdapter(96))];
    [self.tableView setFrame:CGRectMake(0,
                                        addressTextBgView.height + 20,
                                        KWIDTH,
                                        KHEIGHT - SafeAreaTopHeight - addressTextBgView.height - 20)];
}

//  poi 检索
- (void)p_initializeSercher
{
    //初始化搜索对象 ，并设置代理
    _sugSearch  = [[BMKSuggestionSearch alloc]init];
    _sugSearch.delegate = self;
    
    //初始化搜索对象 ，并设置代理
    _searcher  = [[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
}

#pragma mark - Private
- (void)p_dataRquest
{
    //请求参数类BMKCitySearchOption
    BMKSuggestionSearchOption *sugSearchOption = [[BMKSuggestionSearchOption alloc]init];
    sugSearchOption.cityname = self.city;
    sugSearchOption.keyword = self.textField.text.length  ==  0 ?self.city:self.textField.text;
    
    //发起城市内POI检索
    BOOL flag = [_sugSearch suggestionSearch:sugSearchOption];
    if(flag) {
        NSLog(@"城市内检索发送成功");
    }
    else {
        NSLog(@"城市内检索发送失败");
    }
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 30;
    //    option.city = self.city;
    option.keyword = self.textField.text.length  ==  0 ?self.city:self.textField.text;
    option.radius = 1000;
    CLLocationCoordinate2D pt = {[self.latitude floatValue],[self.longitude floatValue]};
    option.location = pt;
    //发起城市内POI检索
    //    BOOL flag1 = [_searcher poiSearchInCity:citySearchOption];
    BOOL flag2 = [_searcher poiSearchNearBy:option];
    if(flag2) {
        NSLog(@"城市内检索发送成功");
    }
    else {
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark - Event Method
- (void)textChange:(NSNotification *)sender
{
    //  检索数据
    [self p_dataRquest];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSouce.count;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"callAddressCell_id";
    CallAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell  ==  nil) {
        [tableView registerClass:[CallAddressTableViewCell class] forCellReuseIdentifier:cell_id];
        cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    }
    cell.model = self.dataSouce[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallAddressModel *model = self.dataSouce[indexPath.row];
    return model.cell_height;
}
#pragma mark - TabeView Delagate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CallAddressModel *model = self.dataSouce[indexPath.row];
    NSString *address = model.subTitle;
    NSString *latitude = [NSString stringWithFormat:@"%@",@(model.bmInfo.pt.latitude)];
    NSString *longitude = [NSString stringWithFormat:@"%@",@(model.bmInfo.pt.longitude)];
    if (self.callBackBlock) {
        self.callBackBlock(address, latitude, longitude,model.title);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BMKSuggestionSearchDelegate

//实现Delegate处理回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error  ==  BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        MLLog(@"BMKSuggestionResult %@ %@ %@",result.keyList,result.districtList,result.cityList);
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - PoiSearchDeleage
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error  ==  BMK_SEARCH_NO_ERROR) {
        self.dataSouce = [CallAddressModel modelsConversionBaiduInfoModel:poiResultList.poiInfoList];
        
        //在此处理正常结果
        [poiResultList.poiInfoList enumerateObjectsUsingBlock:^( BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ///POI名称
            MLLog(@" name %@",obj.name);
            ///POI地址
           MLLog(@" address %@",obj.address);
            ///POI所在城市
           MLLog(@" city %@",obj.city);
                
        }];
        
        [self.tableView reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}



@end
