//
//  UserDataViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UserDataViewController.h"
#import "Xq_ImagePickerCollectionImagePicker.h"
#import "xq_KeyboardView.h"
#import "XQLoginExample.h"
#import "OnlyLocationManager.h"
#import "SelecteAPPIDViewController.h"
#import "ChangePasswordViewController.h"
#import "ChangePhoneViewController.h"
#import "AlipayEditViewController.h"
#import "WeChatViewController.h"
@interface UserDataViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIImageView *headImg;

@end


static NSString *UserDataTableView_Id = @"UserDataTableView_Id";
@implementation UserDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //  防止出现两个完成按钮
    self.viewModel.enableAutoToolbar = [IQKeyboardManager sharedManager].enableAutoToolbar;
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:self.viewModel.enableAutoToolbar];
}


- (void)xq_addSubViews{
    [self.view addSubview:self.tableView];
    
    UIView *view = [UIView new];
    [view setFrame:CGRectMake(0, 0, KWIDTH, SJAdapter(440))];
    _tableView.tableFooterView = view;

    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

}



- (void)xq_bindViewModel{
    @weakify(self);

    [self.viewModel.headSrcSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [Xq_ImagePickerCollectionImagePicker Xq_ImagePickerControllerWithMaxImagesCount:1 didSelectedAssest:nil successBlock:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSString *> *imageSrcs) {
            self.viewModel.headAssets = assets;
            self.viewModel.model.tx_pic = imageSrcs.count > 0?imageSrcs.firstObject:nil;
            ///  保存数据
            [self.viewModel.saveDataCommand execute:nil];
        }];
    }];

    [[RACObserve(self.viewModel,model) distinctUntilChanged] subscribeNext:^(UserDataModel  *_Nullable x) {
        @strongify(self);
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:x.tx_pic] placeholderImage:Img([x.sex isEqualToString:@"男"]?@"user_icon_head1":@"user_icon_head2")];
        [[NSNotificationCenter defaultCenter] postNotificationName:KChangeEadPoretraitIconNoteKey object:x.tx_pic];

        [self.tableView reloadData];
    }];


    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(ToolModel *  _Nullable x) {
        @strongify(self);
        [self cellClickWithToolModel:x];
    }];
}

- (void)xq_getNewData{
    
}

- (void)xq_layoutNavigation{
    self.title = @"个人信息";
}

#pragma mark - Private
- (void)pushSwitchCityVC{
    @weakify(self);
    SelecteAPPIDViewController *vc = [[SelecteAPPIDViewController alloc] init];
    [vc setDidCitySuccess:^{
        @strongify(self);
        [self.tableView reloadData];
    }];

    ///  跳转到选择城市的页面
    CustomNavigationViewController *nav = [[CustomNavigationViewController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)pushChangPhoneVC{
    @weakify(self);
    ChangePhoneViewController *vc = [[ChangePhoneViewController alloc] init];
    vc.viewModel.phone = self.viewModel.model.mobile;
    [vc setReloadDataBlock:^{
        @strongify(self);
        [self.viewModel.getUserInfoCommand execute:nil];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushChangePasswordVC {
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)bindAction:(NSString *)placeholder des:(NSString *)str {
     @weakify(self);
    if ([str isEqualToString:@"未绑定"]) {
        if ([placeholder isEqualToString:@"微信"]) {
            ///  跳转到微信授权
            [ShareUtil LoginExampleWithPlatform:SSDKPlatformTypeWechat success:^(SSDKUser *user) {
                [MLHTTPRequest POSTWithURL:RUN_BIND_WECHAT parameters:@{@"open_id":user.uid?:@""} success:^(MLHTTPRequestResult *result) {
                    if (result.errcode == NO) {
                        [self.viewModel.getUserInfoCommand execute:nil];
                        ML_SHOW_MESSAGE(@"绑定成功");
                    }else{
                        ML_SHOW_MESSAGE(@"绑定失败");
                    }
                } failure:^(NSError *error) {
                    ML_SHOW_MESSAGE(@"绑定失败");
                }];
            } fail:^(NSError *error) {
                ML_SHOW_MESSAGE(@"绑定失败");
            }];
        }else{
            AlipayEditViewController *vc = [[AlipayEditViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }
    }else{
        NSString *msg = [NSString stringWithFormat:@"解除后将不能提现到该%@账户",placeholder];
        [MessageBox showConfirmWithTitle:@"您是否要解除关联?" message:msg otherTitle:@"解除关联" block:^(NSInteger index) {
            @strongify(self);
            if (index == 1){
                if ([placeholder isEqualToString:@"微信"]) {
                    self.viewModel.origin = @"2";
                }else{
                    self.viewModel.origin = @"1";
                }
            }
        }];
    }
}

- (void)localtionAction {
    @weakify(self);
    [MessageBox showConfirmWithTitle:@"是否重新定位到当前区域" message:nil otherTitle:@"确认" block:^(NSInteger index) {
        [OnlyLocationManager getLocation:^(CLLocationCoordinate2D coordinate, CLLocation *location, OnlyLocationVO *locationVO) {
            @strongify(self);
            self.viewModel.latitude = [NSString stringWithFormat:@"%@",@(coordinate.latitude)];
            self.viewModel.longitude = [NSString stringWithFormat:@"%@",@(coordinate.longitude)];

            self.viewModel.areas = [NSString stringWithFormat:@"%@,%@,%@",locationVO.addressComponent.city,locationVO.addressComponent.district,locationVO.addressComponent.street];
            ///  保存数据
            [self.viewModel.saveDataCommand execute:nil];
        }];
    }];
}

- (void)cellClickWithToolModel:(ToolModel * _Nullable)x {
    NSMutableAttributedString *title = x.title;
    NSMutableAttributedString *des = x.detialTitle;
    NSString *placeholder = title.string;
    NSString *str = des.string;
    if ([placeholder isEqualToString:@"切换城市"]) {
        [self pushSwitchCityVC];
    }else if([placeholder isEqualToString:@"更换联系方式"]){
        [self pushChangPhoneVC];
    }else if([placeholder isEqualToString:@"修改密码"]){
        [self pushChangePasswordVC];
    }else if ([placeholder isEqualToString:@"微信"] ||
              [placeholder isEqualToString:@"支付宝"]){
        [self bindAction:placeholder des:str];
    }else if ([placeholder isEqualToString:@"所在地区"]){
        [self localtionAction];
    }else {

    }
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.toolModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.toolModels[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserDataTableView_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:UserDataTableView_Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ToolModel *model = self.viewModel.toolModels[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = self.headImg;
        cell.textLabel.attributedText = model.title;
        //         [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.iconImage] placeholderImage:Img(model.iconImage)];

    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
        cell.textLabel.attributedText = model.title;
        cell.detailTextLabel.attributedText = model.detialTitle;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return SJAdapter(200);
    }else{
        return SJAdapter(100);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0){
        [self.viewModel.headSrcSubject sendNext:indexPath];
    }else{
        [self.viewModel.cellClickSubject sendNext:self.viewModel.toolModels[indexPath.section][indexPath.row]];
    }
}


#pragma mark - LazyLoad
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.sectionFooterHeight = SJAdapter(20);
        _tableView.sectionHeaderHeight = CGFLOAT_MIN;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)headImg{
    if (_headImg == nil) {
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SJAdapter(120), SJAdapter(120))];
        _headImg.image = [UIImage imageNamed:@"uesr_icon_head1"];
        _headImg.layer.cornerRadius = SJAdapter(60);
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}



- (UserDataViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[UserDataViewModel alloc] initWithModel:[[UserDataModel alloc] init] ];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
