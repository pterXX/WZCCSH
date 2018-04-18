//
//  RunApplyViewController.m
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "RunApplyViewController.h"
#import "UIButton+Layout.h"
#import "UIView+Category.h"
#import "OtherKitExample.h"
#import "xq_ImagePickerCollectionImagePicker.h"
#import "CQCountDownButton.h"
#import "TGWebViewController.h"
#import "CallAddressViewController.h"
#import "XQLoginExample.h"
#import "BaiduGeoReusltService.h"

#define Rect(x,y,w,h) CGRectMake(x,y,w,h)
#define Img(name) [UIImage imageNamed:name]
@interface RunApplyViewController ()<BMKGeoCodeSearchDelegate>
@property (nonatomic ,strong) UIButton *radioBtn;
@property (nonatomic ,strong) UITextField *nameText;
@property (nonatomic ,strong) UITextField *phoneText;
@property (nonatomic ,strong) UITextField *codeText;
@property (nonatomic ,strong) UILabel *addressLabel;
@property (nonatomic ,strong) CQCountDownButton *sendCode;

@property (nonatomic ,strong) NSMutableArray<NSString *> *pictures;
@property (nonatomic ,strong) NSString *code_name;

@property (nonatomic ,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic ,strong) BMKReverseGeoCodeOption *reverseGeoCodeOption;
@end

@implementation RunApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"跑腿员申请";
    self.view.backgroundColor =  RGB(245.0f, 245.0f, 245.0f, 1.0);
}

- (void)radioFrame:(UIButton *)agreementBtn {
    CGFloat height = self.radioBtn.height;
    CGFloat width = [self.radioBtn.currentTitle
                     sizeWithFont:self.radioBtn.titleLabel.font
                     maxSize:CGSizeMake(200, 15)].width;
    CGFloat minX = self.radioBtn.left;
    CGFloat minY = self.radioBtn.top;
    CGFloat maxX = maxX;
    CGFloat btnMinY = agreementBtn.top;
    CGFloat btnHeight = agreementBtn.height;
    UIFont *btnFont = agreementBtn.titleLabel.font;
    [self.radioBtn
     setImageRect:Rect(0,(height - 15)/2.0, 15, 15)];

    [self.radioBtn setTitleRect:Rect(20, (height - 15)/2.0, width, 15)];
    [self.radioBtn setFrame:Rect(minX,minY, 20 + width, height)];
    CGFloat bWidth = [agreementBtn.currentTitle
                      sizeWithFont:btnFont
                      maxSize:CGSizeMake(200, 15)].width;
    [agreementBtn setFrame:Rect(self.radioBtn.right + 5, btnMinY, bWidth, btnHeight)];
}

- (UITextField *)textFieldInit:(CGRect)frame {
    UITextField *text = [[UITextField alloc]initWithFrame:frame];
    text.borderStyle = UITextBorderStyleNone;
    text.font = [UIFont systemFontOfSize:14.0];
    text.textColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.00f];
    text.secureTextEntry = NO;
    text.autocorrectionType = UITextAutocorrectionTypeDefault;
    text.keyboardType = UIKeyboardTypeDefault;
    text.returnKeyType = UIReturnKeyDefault;
    return text;
}

- (UILabel *)labelWithInit:(CGRect)frame text:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
    label.backgroundColor = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.00f];
    label.font = [UIFont systemFontOfSize:14.0];
    label.numberOfLines = 1;
    return label;
}

- (UIImageView *)imageWithInit:(CGRect)frame imgName:(NSString *)imgName {
    UIImageView *pic1 = [[UIImageView alloc]init];
    pic1.frame = frame;
    pic1.userInteractionEnabled = YES;
    pic1.image =  Img(imgName);
    [pic1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)]];

    return pic1;
}

- (void)xq_addSubViews{
    UIView *backgroundView = [[UIView alloc]initWithFrame:Rect(0.00f,0.00f,375.00f,380.00f)];
    backgroundView.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self.view addSubview:backgroundView];

    UILabel *nameLabel =[self labelWithInit:Rect(10.00f,00.00f,70.00f,50.00f) text:@"姓       名:"];
    [backgroundView addSubview:nameLabel];

    UITextField * nameText = [self textFieldInit:Rect(90.00f,00.00f,275.00f,50.00f)];
    [backgroundView addSubview:nameText];
    self.nameText =  nameText;

    UILabel * phoneTitle = [self labelWithInit:Rect(10.00f,50.00f,70.00f,50.00f) text:@"联系电话:"];
    [backgroundView addSubview:phoneTitle];

    UITextField *phoneTextF = [self textFieldInit:Rect(90.00f,50.00f,175.00f,50.00f)];
    phoneTextF.keyboardType = UIKeyboardTypePhonePad;
    [backgroundView addSubview:phoneTextF];
    self.phoneText =  phoneTextF;

    [self p_initializesendCodeBtn];
    [backgroundView addSubview:self.sendCode];

    UILabel *codeTitle = [self labelWithInit:Rect(10.00f,100.00f,70.00f,50.00f) text:@"验  证 码:"];
    [backgroundView addSubview:codeTitle];

    UITextField *codeTextF = [self textFieldInit:Rect(90.00f,100.00f,275.00f,50.00f)];
    codeTextF.keyboardType = UIKeyboardTypePhonePad;
    [backgroundView addSubview:codeTextF];
    self.codeText =  codeTextF;

    UILabel *addressTitle = [self labelWithInit:Rect(10.00f,150.00f,70.00f,50.00f) text:@"所在地点:"];
    [backgroundView addSubview:addressTitle];

    UILabel *addressTextF = [self labelWithInit:Rect(80.00f,150.00f,285.00f,50.00f) text:self.address];
    addressTextF.userInteractionEnabled =   YES;
    [addressTextF addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapAction:)]];
    self.addressLabel =  addressTextF;
    [backgroundView addSubview:addressTextF];

    UIImageView *accessView =  [[UIImageView alloc] initWithImage:Img(@"user_icon_back")];
    accessView.frame =  Rect(357, 168.0, 8, 14);
    [backgroundView addSubview:accessView];


    UILabel *picTitle = [self labelWithInit:Rect(10.00f,200.00f,355.00f,50.00f) text:@"请上传身份证正反面照片"];
    [backgroundView addSubview:picTitle];

    UIImageView * pic1 = [self imageWithInit:Rect(10.00f,250.0f,170.00f,114.00f) imgName:@"apply_icon1"];
    pic1.tag =  100;
    [backgroundView addSubview:pic1];

    UIImageView *pic2 = [self imageWithInit:Rect(195.00f,250.0f,170.00f,114.00f) imgName:@"apply_icon2"];
    pic2.tag =  101;
    [backgroundView addSubview:pic2];

    UIButton *radioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    radioBtn.frame = Rect(10.00f, 400.00f, 30.00f,15.0);
    [radioBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [radioBtn setImageRect:Rect(0, 0, 15, 15)];
    [radioBtn setImage:Img(@"apply_icon_nor") forState:UIControlStateNormal];
    [radioBtn setImage:Img(@"apply_icon_sel") forState:UIControlStateSelected];
    radioBtn.titleLabel.font = [UIFont fontWithName:@".PingFangSC-Regular" size:11.00f];
    [radioBtn setTitle:@"提交资料表示同意" forState:UIControlStateNormal];
    [radioBtn setTitleColor:[UIColor hexString:@"333333"] forState:UIControlStateNormal];
    [radioBtn addTarget:self action:@selector(radioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:radioBtn];
    radioBtn.selected =  YES;
    self.radioBtn =  radioBtn;

    UIButton *agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = Rect(40.00f, 400.00f, 158.00f,15.00f);
    [agreementBtn setTitle:@"" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:0.00f] forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:11.00f];
    [agreementBtn setTitleColor:[UIColor
                                       colorWithRed:58.0f/255.0f
                                       green:139.0f/255.0f
                                       blue:249.0f/255.0f
                                       alpha:1.0f] forState:UIControlStateNormal];
    [agreementBtn setTitle:@"《合作协议》" forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];

    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = Rect(87.50f, 500, 200.00f,44.00f);
    [submitBtn setTitle:@"提交资料" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:@".SFUIText" size:15.00f];
    submitBtn.backgroundColor = [UIColor colorWithRed:1.00f green:0.53f blue:0.01f alpha:1.00f];
    [submitBtn addTarget:self action:@selector(sureBtnTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];

    // 适配大小
    [self.view adaptSizeSubViewsYouUIScreenWidth:375.0f];
    self.sendCode.frame =  Rect(SJAdapter(530), SJAdapter(100), SJAdapter(200),SJAdapter(100));
    [self radioFrame:agreementBtn];

    //  设置圆角
    submitBtn.layer.cornerRadius =  submitBtn.height / 2.0f;
    submitBtn.layer.masksToBounds =  YES;

    [OtherKitExample createViewHorizontalShapeLayerWithView:backgroundView startPoint:CGPointMake(0, SJAdapter(100)) width:KWIDTH];
    [OtherKitExample createViewHorizontalShapeLayerWithView:backgroundView startPoint:CGPointMake(0, SJAdapter(200)) width:KWIDTH];
    [OtherKitExample createViewHorizontalShapeLayerWithView:backgroundView startPoint:CGPointMake(0, SJAdapter(300)) width:KWIDTH];
    [OtherKitExample createViewHorizontalShapeLayerWithView:backgroundView startPoint:CGPointMake(0, SJAdapter(400)) width:KWIDTH];
}

- (void)xq_getNewData{

    if (self.addressLabel.text) {
        ///  NOTE:如果有值就不显示当前位置
        return;
    }
    _reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    NSArray<NSString *> *lalo = [[XQLoginExample lastLatitudeAndLongitude] componentsSeparatedByString:@","];
    if (lalo.count == 2) {
        float y = lalo.firstObject.floatValue ;//纬度
        float x = lalo.lastObject.floatValue;//经度
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
}


//  发送验证码按钮
- (void)p_initializesendCodeBtn
{
    __weak __typeof__(self) weakSelf =  self;
    
    self.sendCode =  [[CQCountDownButton alloc] initWithDuration:60 buttonClicked:^{
        //------- 按钮点击 -------//
        // 请求数据
        [weakSelf p_sendCodeRequestWithSuccess:^{
            // 获取到验证码后开始倒计时
            [weakSelf.sendCode startCountDown];
        } fail:^{
            // 获取失败
            [weakSelf.sendCode setEnabled:YES];
        }];
    } countDownStart:^{
        //------- 倒计时开始 -------//
        NSLog(@"倒计时开始");
    } countDownUnderway:^(NSInteger restCountDownNum) {
        //------- 倒计时进行中 -------//
        [weakSelf.sendCode setTitle:[NSString stringWithFormat:@"再次获取(%ld秒)", restCountDownNum] forState:UIControlStateDisabled];
    } countDownCompletion:^{
        //------- 倒计时结束 -------//
        [weakSelf.sendCode setEnabled:YES];
    }];
    
    
    self.sendCode.frame =  Rect(245.00f, 50.00f,120.0f,50.00f);
    [self.sendCode setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.sendCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendCode.titleLabel setFont:[UIFont adjustFont:14]];
    [self.sendCode setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:170.0f/255.0f blue:238.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [self.sendCode setTitleColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f] forState:UIControlStateDisabled];
}


#pragma mark - Actions
//  选择图片
- (void)imageTaped:(UIGestureRecognizer *)ges
{
     __weak __typeof__(self) weakSelf =  self;
    if (self.pictures ==  nil) {
        self.pictures =  [NSMutableArray array];
        [self.pictures addObject:@""];
        [self.pictures addObject:@""];
    }
    [Xq_ImagePickerCollectionImagePicker Xq_ImagePickerControllerWithMaxImagesCount:1 didSelectedAssest:nil successBlock:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSString *> *imageSrcs) {
        UIImageView *imgView =  (UIImageView *)ges.view;
        imgView.image =  photos.firstObject;
        if (ges.view.tag ==  100) {
            weakSelf.pictures[0] =  imageSrcs.firstObject?:@"";
        }else
        {
            weakSelf.pictures[1] =  imageSrcs.firstObject?:@"";
        }
    }];
    
}

//  单选按钮点击
- (void)radioBtnAction:(UIButton *)sender
{
    sender.selected =  !sender.isSelected;
}


- (void)agreementBtnAction:(UIButton *)sender
{
    self.radioBtn.selected =  YES;
    TGWebViewController *web =  [[TGWebViewController alloc] init];
    web.url =  RUN_AGREEMENT;
    web.progressColor =  COLOR_MAIN;
    [self.navigationController pushViewController:web animated:YES];
}

//  提交按钮点击
- (void)sureBtnTapAction:(UIButton *)sender
{
    [self p_registerRunMan];
}

//  地址点击
- (void)addressTapAction:(UIGestureRecognizer *)sender
{
    CallAddressViewController *vc =  [[CallAddressViewController alloc] init];
    vc.latitude =  self.latitude;
    vc.longitude =  self.longitude;
    vc.city =  self.city;
    __weak typeof(self) wkself =  self;
    [vc setCallBackBlock:^(NSString *address, NSString *latitude, NSString *longitude,NSString *name) {
        wkself.address =  [NSString stringWithFormat:@"%@",name];
        wkself.addressLabel.text =  wkself.address;
        wkself.latitude =  latitude;
        wkself.longitude =  longitude;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
- (void)p_registerRunMan
{
    NSString *name =  self.nameText.text?:@"";
    NSString *mobile =  self.phoneText.text?:@"";
    NSString *code =  self.codeText.text?:@"";
    NSString *code_name =  self.code_name?:@"";
    NSString *latitude =  self.latitude?:@"";
    NSString *longitude =   self.longitude?:@"";
    NSString *address =  self.address?:@"";
    
    NSString *check;
    if (self.radioBtn.isSelected) {
        check =  @"1";
    }else
    {
        check =  @"0";
    }

    NSMutableArray *pictures =  [NSMutableArray array];
    [self.pictures enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            [pictures addObject:obj];
        }
    }];
    
    if (pictures.count !=  2){
        [MessageToast showMessage:@"请上传身份证正反面"];
        return;
    }
    
    if (self.radioBtn.selected ==  NO) {
        [MessageToast showMessage:@"请同意《合作协议》"];
        return;
    }
    
    
    NSMutableDictionary *dict =  [NSMutableDictionary dictionary];
    [dict setObject:mobile forKey:@"mobile"];
    [dict setObject:code forKey:@"code"];
    [dict setObject:latitude forKey:@"latitude"];
    [dict setObject:longitude forKey:@"longitude"];
    [dict setObject:address forKey:@"address"];
    [dict setObject:code_name?:@"" forKey:@"code_name"];
    [dict setObject:check forKey:@"check"];
    [dict setObject:[pictures componentsJoinedByString:@"|"] forKey:@"pictures"];
    [dict setObject:name forKey:@"name"];
    __weak typeof(self) wkself =  self;
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setDetailsLabelText:@"请稍后..."];
    [MLHTTPRequest POSTWithURL:RUN_MAIN_REGISTER parameters:dict success:^(MLHTTPRequestResult *result) {
        if (result.errcode ==  0) {
            [XQLoginExample pushMainController];
        }else{
            [MessageToast showMessage:result.errmsg];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:wkself.view animated:YES];
    }];

}

// 发送验证码
- (void)p_sendCodeRequestWithSuccess:(void (^)(void))success fail:(void (^)(void))fail
{
    if (_phoneText.text.length ==  0) {
        [MessageToast showMessage:@"请输入手机号"];
        fail();
        return;
    }
    [MLHTTPRequest POSTWithURL:CSSH_USER_SENDE_CODE parameters:@{@"mobile":_phoneText.text?:@"",@"type":@"9"} /* type ==  9 跑腿发送验证码 */ success:^(MLHTTPRequestResult *result) {
        if (result.errcode ==  0) {
            success();
            _code_name =  [result.data objectForKey:@"code_name"];
        }else
        {
            ML_SHOW_MESSAGE(result.errmsg);
            fail();
        }
    } failure:^(NSError *error) {
        ML_MESSAGE_NETWORKING;
        fail();
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nameText endEditing:YES];
    [self.phoneText endEditing:YES];
    [self.codeText endEditing:YES];
}

#pragma mark -- BMKGeoCodeSearchDelegate
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
    NSString * longitude;
    NSString * latitude;
    NSString * address;
    longitude = [NSString stringWithFormat:@"%@",@(result.location.longitude)];
    latitude = [NSString
                stringWithFormat:@"%@",@(result.location.latitude)];
    address = result?result.address:@"";
    self.address = address;
    self.longitude = longitude;
    self.latitude = latitude;
    self.city = result.addressDetail.district;
    self.addressLabel.text = address;
}
@end
