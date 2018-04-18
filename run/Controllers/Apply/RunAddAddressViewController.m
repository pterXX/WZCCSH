//
//  RunAddAddressViewController.m
//  city
//
//  Created by 3158 on 2018/2/7.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "RunAddAddressViewController.h"
#import "CallAddressViewController.h"
#import "UIFont+runtime.h"
#import "IQKeyboardManager.h"

 NSString *const R_ADDRESS = @"address";
 NSString *const R_LATITUDE = @"latitude";
 NSString *const R_LONGITUDE = @"longitude";
 NSString *const R_FLOOR = @"floor";
 NSString *const R_TEL = @"tel";
 NSString *const R_CONSIGNEE = @"consignee";
 NSString *const R_ID = @"id";
 NSString *const R_CITY = @"city";
 NSString *const R_DETAILNAME = @"detailname";

@interface RunAddAddressViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *floorText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

//  保存选择地址的经纬度
@property (nonatomic ,strong) NSString *lat;
@property (nonatomic ,strong) NSString *lon;

@end

@implementation RunAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0 green:245.0f/255.0 blue:245.0f/255.0 alpha:1.0];
    self.address.text = self.runAddress;
    self.address.userInteractionEnabled = YES;
    self.nameText.placeholder = self.isConsignor ? @"发货人姓名":@"收货人姓名";
    self.phoneText.placeholder = self.isConsignor ? @"发货人手机号":@"收货人手机号";
    self.title = @"同城跑腿";
    [UIFont adjusAllSubViewsFontWithUIScreen:375.0 youView:self.view];
    [self p_updateCurrentPage];
}

- (void)p_updateCurrentPage
{
    if (self.dict.count > 0) {
        self.address.text = self.dict[R_ADDRESS]?:self.runAddress;
        self.nameText.text = self.dict[R_CONSIGNEE];
        self.floorText.text = self.dict[R_FLOOR];
        self.phoneText.text = self.dict[R_TEL];
    }
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
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.saveBtn.layer.cornerRadius = self.saveBtn.height / 2;
    [self.saveBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 地址按钮的点击
- (IBAction)addressTap:(id)sender {
    CallAddressViewController *vc = [[CallAddressViewController alloc] init];
    vc.city = self.city;
    vc.longitude = self.longitude;
    vc.latitude =  self.latitude;
    __weak typeof(self) wkself = self;
    //  回调
    [vc setCallBackBlock:^(NSString *address, NSString *latitude, NSString *longitude,NSString *name) {
        wkself.lon = longitude;
        wkself.lat = latitude;
        wkself.detailedAddress =  name;
        wkself.address.text = [NSString stringWithFormat:@"%@",name];
        wkself.runAddress = wkself.address.text;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

// 保存按钮点击
- (IBAction)saveTtnTap:(id)sender
{
    [self p_endEdit];
    /*
     address    Y        地址
     longitude    Y        经度
     latitude    Y        纬度
     floor    N        门牌、楼层号
     consignee    Y        姓名
     tel
     */
    
    //  判断是否已存在经纬度
    self.longitude = self.dict[R_LONGITUDE].length > 0? self.dict[R_LONGITUDE]:self.longitude;
    self.latitude = self.dict[R_LATITUDE].length >0? self.dict[R_LATITUDE]:self.latitude;
    NSString *lo = self.lon.length > 0?self.lon:self.longitude;
    NSString *la = self.lat.length > 0?self.lat:self.latitude;
    __weak typeof(self) wkself = self;
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setDetailsLabelText:@"请稍后..."];
    NSMutableDictionary *dict = @{R_ADDRESS:self.address.text?:@"",
                                  R_LONGITUDE:lo?:@"",
                                  R_LATITUDE:la?:@"",
                                  R_FLOOR:self.floorText.text?:@"",
                                  R_CONSIGNEE:self.nameText.text?:@"",
                                  R_TEL:self.phoneText.text?:@"",
                                  @"lng":lo?:@"",
                                  @"lat":la?:@"",
                                  }.mutableCopy;

    [MLHTTPRequest POSTWithURL:RUN_ORDER_ADDRESS parameters:dict success:^(MLHTTPRequestResult *result) {
        [MBProgressHUD hideAllHUDsForView:wkself.view animated:YES];
        [MessageToast showMessage:result.errmsg];
        if (result.errcode == 0) {
            //  回调数据
            [dict setObject:result.data[@"id"] forKey:R_ID];
            [dict setObject:self.detailedAddress forKey:R_DETAILNAME];
            wkself.callBackBlck?wkself.callBackBlck(dict):nil;
            [wkself.navigationController popViewControllerAnimated:YES];
        }else
        {

        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:wkself.view animated:YES];
        [MessageToast showMessage:@"网络连接失败..."];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self p_endEdit];
}

- (void)p_endEdit
{
    [self.floorText endEditing:YES];
    [self.nameText endEditing:YES];
    [self.phoneText endEditing:YES];
}


@end
