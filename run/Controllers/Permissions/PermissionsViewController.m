//
//  PermissionsViewController.m
//  run
//
//  Created by asdasd on 2018/4/17.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "PermissionsViewController.h"
#import "XQLoginExample.h"
@interface PermissionsViewController ()

@end

@implementation PermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)xq_addSubViews{
    UIView *bgView = [UIView new];
    bgView.backgroundColor = RGB(255,172,79,1.0);
    [self.view addSubview:bgView];

    UIImageView *iconView = [UIImageView new];
    [iconView setImage:[UIImage imageNamed:@"icon-1024"]];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = SJAdapter(16.0);
    [bgView addSubview:iconView];

    YYLabel *label = [YYLabel new];
    label.text = @"同城跑腿需要获得以下权限";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont adjustFont:15];
    [bgView addSubview:label];

//    @weakify(self);
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.offset(0);
        make.height.equalTo(bgView.mas_width).multipliedBy(200.0/375.0f);
    }];

    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(SJAdapter(106));
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView.mas_top).offset(SJAdapter(100));
    }];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(CGSizeMake(200, 18));
        make.centerX.equalTo(bgView);
        make.top.equalTo(iconView.mas_bottom).offset(SJAdapter(60));
    }];

    [self itemWithIcon:@"permissions_locl" title:@"位置授权" subtitle:@"实时定位跑腿员位置，方便接单、配送" top:SJAdapter(460)];
    [self itemWithIcon:@"permissions_note" title:@"通知授权" subtitle:@"第一时间告知订单信息" top:SJAdapter(606)];
    [self itemWithIcon:@"permissions_data" title:@"数据授权" subtitle:@"打开数据连接才能及时收到订单哦" top:SJAdapter(754)];

    [self.view drawLineOfDashByCAShapeLayerLineLength:3 lineSpacing:2 lineColor:RGB(187, 187, 187, 1.0) width:0.5 startPoint:CGPointMake(SJAdapter(20), SJAdapter(566)) endPoint:CGPointMake(KWIDTH -SJAdapter(20), SJAdapter(566))];
    [self.view drawLineOfDashByCAShapeLayerLineLength:3 lineSpacing:2 lineColor:RGB(187, 187, 187, 1.0) width:0.5 startPoint:CGPointMake(SJAdapter(20), SJAdapter(712)) endPoint:CGPointMake(KWIDTH -SJAdapter(20), SJAdapter(712))];


    XQButton *btn = [XQButton buttonWithFrame:CGRectMake(0, 0, SJAdapter(500), SJAdapter(88))];
    [btn setTitle:@"去开启授权" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = SJAdapter(44.0);
    [self.view addSubview:btn];

    @weakify(self);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.view.mas_width).multipliedBy(250.0f/375.0f);
        make.height.equalTo(btn.mas_width).multipliedBy(44.0f/250.0f);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(- SJAdapter(128));
    }];

    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([PermissionManager locationPermission] && [PermissionManager networkPermission]) {
            [XQLoginExample pushMainController];
        }else{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] ];
        }
    }];

    //每一秒执行一次,这里要加上释放信号,否则控制器推出后依旧会执行
    [[[RACSignal interval:2 onScheduler:[RACScheduler scheduler]]takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
        if ([PermissionManager locationPermission] && [PermissionManager networkPermission]) {
            [XQLoginExample pushMainController];
        }

    }];


}

- (void)itemWithIcon:(NSString *)img title:(NSString *)title subtitle:(NSString *)subTitle top:(CGFloat)top{
    UIImageView *imgV = [UIImageView new];
    [imgV setImage:[UIImage imageNamed:img]];
    [self.view addSubview:imgV];

    YYLabel *titleLabel = [YYLabel new];
    titleLabel.text = title;
    titleLabel.textColor = COLOR_666666;
    titleLabel.font = [UIFont adjustFont:15];
    [self.view addSubview:titleLabel];

    YYLabel *subtitleLabel = [YYLabel new];
    subtitleLabel.text = subTitle;
    subtitleLabel.textColor = COLOR_999999;
    subtitleLabel.font = [UIFont adjustFont:12];
    [self.view addSubview:subtitleLabel];

    @weakify(self);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(KWIDTH - SJAdapter(92));
        make.height.offset(SJAdapter(40));
        make.left.equalTo(self.view.mas_left).offset(SJAdapter(92));
        make.top.offset(top);
    }];

    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(KWIDTH - SJAdapter(92));
        make.height.offset(SJAdapter(30));
        make.left.equalTo(self.view.mas_left).offset(SJAdapter(92));
        make.top.equalTo(titleLabel.mas_bottom).offset(SJAdapter(8));
    }];

    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(SJAdapter(40));
        make.height.offset(SJAdapter(40));
        make.right.equalTo(titleLabel.mas_left).offset(- SJAdapter(26));
        make.top.equalTo(titleLabel.mas_top).offset(SJAdapter(10));
    }];
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
