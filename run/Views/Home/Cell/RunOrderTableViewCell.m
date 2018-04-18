//
//  RunOrderTableViewCell.m
//  city
//
//  Created by 3158 on 2018/2/24.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "RunOrderTableViewCell.h"
#import "HomeViewController.h"
#import "RunOrderViewController.h"
#import "UIView+Category.h"
#import "OtherKitExample.h"
#import "CallGoodsPupView.h"
#import "xq_line.h"
#import <YYText.h>
//#import "TopUpPopView.h"
//#import "SurePopViewController.h"
//#import "RunOrderListMenuViewController.h"

@interface RunOrderTableViewCell()
@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) YYLabel *name;
@property (nonatomic ,strong) YYLabel *tel;
@property (nonatomic ,strong) YYLabel *price;
@property (nonatomic ,strong) YYLabel *distance;
@property (nonatomic ,strong) YYLabel *time;
@property (nonatomic ,strong) YYLabel *s_address;
@property (nonatomic ,strong) YYLabel *e_address;
@property (nonatomic ,strong) xq_line *line;

@property (nonatomic ,strong) XQButton *bigBtn; //  抢单
@property (nonatomic ,strong) UIButton *contactBtn; //  联系
@property (nonatomic ,strong) UIButton *pickGoodsBtn; //  已取货
@property (nonatomic ,strong) UIButton *deliveryBtn; //  已送达
@property (nonatomic ,strong) UIButton *checkBtn; //   查看详情
@property (nonatomic ,strong) UIView *btnSubView;
@end

#define ORGB(r,g,b) [UIColor colorWithRed:r green:g blue:b alpha:1.00f]
#define ORECT(x,y,w,h) CGRectMake(x,y,w,h)
@implementation RunOrderTableViewCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.iconView.layer.cornerRadius = self.iconView.height / 2.0;
}

- (void)xq_setupViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.tel];
    [self.contentView addSubview:self.price];
    [self.contentView addSubview:self.distance];

    UIImageView *home_icon_time = [self imageWithInitRect:ORECT(10.00f,89.00f,14.00f,14.00f) imgName:@"home_icon_time"];
    [self.contentView addSubview:home_icon_time];

    UIImageView *home_icon_start = [self imageWithInitRect:ORECT(10.00f,119.00f,14.00f,18.00f) imgName:@"home_icon_start"];
    [self.contentView addSubview:home_icon_start];

    UIImageView *home_icon_end = [self imageWithInitRect:ORECT(10.00f,149.00f,14.00f,18.00f) imgName:@"home_icon_end"];
    [self.contentView addSubview:home_icon_end];

     [self.contentView addSubview:self.time];
     [self.contentView addSubview:self.s_address];
     [self.contentView addSubview:self.e_address];
     [self.contentView addSubview:self.bigBtn];
     [self.contentView addSubview:self.btnSubView];


    self.contactBtn = [self bigBtnInitRect:ORECT(0, 0, 0,0) nor:@"联系发件人" sel:@"联系收件人" action:@selector(contactBtnAction:)];
    [self.btnSubView addSubview:self.contactBtn];

    self.deliveryBtn = [self bigBtnInitRect:ORECT(0, 0, 0,0) nor:@"我已送达" sel:@"我已送达" action:@selector(deliveryBtnAction:)];
    [self.btnSubView addSubview:self.deliveryBtn];

    self.pickGoodsBtn = [self btnInitRect:ORECT(0, 0, 0,0) nor:@"我已取货" sel:@"我已取货" action:@selector(pickGoodsBtnAction:)];
    [self.btnSubView addSubview:self.pickGoodsBtn];

    self.checkBtn = [self btnInitRect:ORECT(280.00f, 12.00f, 75.00f,25.00f) nor:@"查看详情" sel:@"查看详情" action:@selector(checkAction:)];
    [self.btnSubView addSubview:self.checkBtn];

    UIView *speView = [[UIView alloc] initWithFrame:CGRectMake(0, SJAdapter(460), KWIDTH, SJAdapter(20))];
    [speView setBackgroundColor:[UIColor hexString:@"f5f5f5"]];
    [self.contentView addSubview:speView];

    @weakify(self);
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.offset(SJAdapter(20.0f));
        make.top.offset(SJAdapter(30.0f));
        make.width.equalTo(self.contentView.mas_width).multipliedBy(60.0f/375.0f);
        make.height.equalTo(self.iconView.mas_width).multipliedBy(1.0);
    }];

    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconView.mas_right).offset(SJAdapter(40.0f));
        make.top.offset(SJAdapter(44.0f));
        make.width.equalTo(self.contentView.mas_width).multipliedBy(200.0f/375.0f);
        make.height.offset(SJAdapter(35.0f));
    }];

    [self.tel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.name.mas_left);
        make.top.equalTo(self.name.mas_bottom).offset(SJAdapter(26.0f));
        make.width.equalTo(self.name);
        make.height.offset(SJAdapter(24.0f));
    }];

    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.contentView.mas_right).offset(- SJAdapter(20));
        make.top.equalTo(self.name);
        make.width.equalTo(self.contentView).offset(100.0f);
        make.height.equalTo(self.name);
    }];

    [self.distance mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.price);
        make.top.equalTo(self.tel);
        make.width.equalTo(self.price);
        make.height.equalTo(self.tel);
    }];

    [@[home_icon_time,home_icon_start,home_icon_end] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);;
        make.width.offset(SJAdapter(28));
        make.height.offset(SJAdapter(36));
    }];

    [home_icon_time mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.offset(SJAdapter(28));
        make.centerY.equalTo(self.time.mas_centerY);
    }];

    [home_icon_start mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.s_address.mas_centerY);
    }];

    [home_icon_end mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.offset(SJAdapter(28));
        make.centerY.equalTo(self.e_address.mas_centerY);
    }];

    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconView.mas_bottom).offset(SJAdapter(30));
        make.left.equalTo(home_icon_time.mas_right).offset(SJAdapter(30));
        make.right.equalTo(self.contentView.mas_right).offset(SJAdapter(20));
        make.height.offset(SJAdapter(30));
    }];

    [self.s_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_bottom).offset(SJAdapter(30));
        make.left.right.equalTo(self.time);
        make.height.offset(SJAdapter(30));
    }];

    [self.e_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.s_address.mas_bottom).offset(SJAdapter(30));
        make.left.right.equalTo(self.time);
        make.height.offset(SJAdapter(30));
    }];

    [self.bigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.e_address.mas_bottom).offset(SJAdapter(30)).priorityHigh();
        make.width.equalTo(self.contentView.mas_width).multipliedBy(355.0f/375.0f);
        make.height.equalTo(self.bigBtn.mas_width).multipliedBy(44.0f/355.0f);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];

    [self.btnSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.top.centerX.equalTo(self.bigBtn);
        make.bottom.equalTo(speView.mas_top).offset(0);
    }];

    [@[self.contactBtn,self.deliveryBtn,self.pickGoodsBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(self.btnSubView.mas_width).multipliedBy(0.5);
        make.top.and.bottom.offset(0);
    }];

    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.btnSubView.mas_left).offset(0);
    }];

   [@[self.deliveryBtn,self.pickGoodsBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
       @strongify(self);
        make.right.equalTo(self.btnSubView.mas_right).offset(0);
    }];

    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(90.0/375.0);
        make.height.equalTo(self.checkBtn.mas_width).multipliedBy(35.0/90.0);
        make.right.equalTo(self.btnSubView.mas_right);
        make.centerY.equalTo(self.btnSubView.mas_centerY);
    }];

    [speView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.contentView);
        make.height.offset(10);
        make.top.equalTo(self.bigBtn.mas_bottom).offset(SJAdapter(30)).priorityHigh();
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    xq_line *line1 =  [[xq_line alloc] init];
    [self.contactBtn addSubview:line1];

    xq_line *line2 =  [[xq_line alloc] init];
    [self.btnSubView addSubview:line2];

    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.offset(1);
        make.right.top.bottom.equalTo(self.contactBtn).offset(0);
    }];

    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.offset(1);
        make.right.top.left.equalTo(self.btnSubView).offset(0);
    }];

    XQViewBorderRadius(self.checkBtn,SJAdapter(6) , 0.5,[UIColor hexString:@"bbbbbb"]);
}


- (YYLabel *)yyLableWithInit:(CGFloat)fontSize textColor:(UIColor *)color rect:(CGRect)rect{

    YYLabel *label = [YYLabel new];
    label.textColor = color;
    label.font = [UIFont adjustFont:fontSize];
    label.frame = rect;
    label.numberOfLines = 1;
    return label;
}

- (UIImageView *)imageWithInitRect:(CGRect)rect imgName:(NSString *)imgName
{
    UIImageView *imV = [[UIImageView alloc]init];
    imV.frame = rect;
    imV.userInteractionEnabled = NO;
    imV.image = [UIImage imageNamed:imgName];
    return imV;
}

- (UIButton *)btnInitRect:(CGRect)rect nor:(NSString *)nor sel:(NSString *)sel action:(SEL)action
{
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setTitle:nor forState:UIControlStateNormal];
    [btn setTitle:sel forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor hexString:@"333333"] forState:UIControlStateNormal];
    btn.titleLabel.font  = [UIFont adjustFont:14.0f];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)bigBtnInitRect:(CGRect)rect nor:(NSString *)nor sel:(NSString *)sel action:(SEL)action{
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setTitle:nor forState:UIControlStateNormal];
    [btn setTitle:sel forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor hexString:@"333333"] forState:UIControlStateNormal];
    btn.titleLabel.font  = [UIFont adjustFont:14.0f];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}


- (UIImageView *)iconView{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc]init];
        _iconView .frame = ORECT(10.00f,15.00f,60.00f,60.00f);
        _iconView .userInteractionEnabled = NO;
        _iconView .layer.masksToBounds = YES;
    }
    return _iconView;
}


- (YYLabel *)name{
    if (_name == nil) {
        _name = [self yyLableWithInit:15 textColor:ORGB(0.26f, 0.26f, 0.26f) rect:ORECT(90.00f,22.00f,63.00f,19.00f)];
    }
    return _name;
}


- (YYLabel *)tel{
    if (_tel == nil) {
        _tel = [self yyLableWithInit:12 textColor:ORGB(0.48f, 0.48f, 0.48f) rect:ORECT(90.00f,49.00f,100.00f,15.00f)];
    }
    return _tel;
}

- (YYLabel *)time{
    if (_time == nil) {
        _time = [self yyLableWithInit:14 textColor:[UIColor blackColor] rect:ORECT(37.00f,89.00f,200.00f,15.00f)];
    }
    return _time;
}

- (YYLabel *)price{
    if (_price == nil) {
        _price = [self yyLableWithInit:17 textColor:ORGB(1.00f, 0.34f, 0.34f) rect:ORECT(285.00f,25.00f,70.00f,17.00f)];
        _price.textAlignment = NSTextAlignmentRight;
    }
    return _price;
}

- (YYLabel *)distance{
    if (_distance == nil) {
        _distance = [self yyLableWithInit:12 textColor:ORGB(0.66f, 0.66f, 0.66f) rect:ORECT(285.00f,49.00f,70.00f,12.00f)];
        _distance.textAlignment = NSTextAlignmentRight;
    }
    return _distance;
}

- (YYLabel *)s_address{
    if (_s_address == nil) {
        _s_address = [self yyLableWithInit:14 textColor:[UIColor blackColor] rect:ORECT(37.00f,119.00f,98.00f,15.00f)];
    }
    return _s_address;
}

- (YYLabel *)e_address{
    if (_e_address == nil) {
        _e_address = [self yyLableWithInit:14 textColor:[UIColor blackColor] rect:ORECT(37.00f,150.00f,187.00f,15.00f)];
    }
    return _e_address;
}

- (XQButton *)bigBtn{
    if (_bigBtn == nil) {
        _bigBtn = [XQButton buttonWithFrame:ORECT(10.00f, 180.00f, 355.00f,44.00f)];
        [_bigBtn setTitle:@"抢单" forState:UIControlStateNormal];
        [_bigBtn addTarget:self action:@selector(bigBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigBtn;
}

- (UIView *)btnSubView{
    if (_btnSubView == nil) {
        _btnSubView = [[UIView alloc] initWithFrame:CGRectMake(10.00f, 180.00f, 355.00f,44.00f)];

    }
    return _btnSubView;
}

/*
 status    Y        订单状态（1抢单2取件完成3跑腿员确认送达4取消订单5删除订单）
 id    Y        订单ID
 code    Y        收货码，当转台为3时必填
 */
- (void)editOrderWithStatus:(NSString *)status code:(NSString *)code success:(void (^)(BOOL issuccess ,MLHTTPRequestResult *result))successBlock{
    __weak typeof(self) wkself = self;

    NSDictionary *dic = @{@"status":status,
                          @"id":self.model.aid?:@"",
                          @"code":code?:@"" };
    [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    [MLHTTPRequest POSTWithURL:RUN_ORDER_EDITSTATUS parameters:dic success:^(MLHTTPRequestResult *result) {
        [MBProgressHUD hideAllHUDsForView:kWindow animated:YES];
        if (result.errcode == 0) {
            //  刷新列表
            successBlock(YES,result);
        }else{
            successBlock(NO,result);
        }

        !wkself.refreshTableViewBlock?:wkself.refreshTableViewBlock();
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.viewController.view animated:YES];
        ML_MESSAGE_NETWORKING;
    }];
}

//  抢单
- (void)bigBtnAction:(UIButton *)sender
{
    __weak typeof(self) wkself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认抢单" message:@"请仔细查看订单信息,抢单成功后请务必按照平台规定完成配送" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"我再看看" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"确认抢单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self editOrderWithStatus:@"1" code:nil success:^(BOOL issuccess,MLHTTPRequestResult *result) {
            if (issuccess) {
                UIViewController *vc = [self getRunMenuViewController];
                if ([vc isKindOfClass:[HomeViewController class]])
                {
                    HomeViewController * menuVc = (HomeViewController *)vc;
                    //  抢单成功后自动跳转到待取货页面
                    [menuVc.magicController.magicView switchToPage:1 animated:YES];
                }
                [self alert:nil message:result.errmsg sureBlock:^{

                }];
            }else
            {
                [self alert:nil message:result.errmsg  sureBlock:^{

                }];
            }
        }];
    }]];

    [self.viewController presentViewController:alert animated:YES completion:nil];
}



//  联系联系人
- (void)contactBtnAction:(UIButton *)sender
{
    NSString *moblie = self.model.order_status.integerValue == 2?self.model.get_mobile:self.model.mobile;
    [self alert:@"拨打电话" message:moblie sureBlock:^{
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",moblie];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        }
    }];
}

//  确认收货
- (void)deliveryBtnAction:(UIButton *)sender
{
    [CallGoodsPupView showPasswordWithSureBlock:^(NSString *password, CallGoodsPupView *callGoodsView) {
        [self editOrderWithStatus:@"3" code:password success:^(BOOL issuccess,MLHTTPRequestResult *res) {
            if (issuccess) {
                [CallGoodsPupView dismss];
            }else{
                callGoodsView.title.text = @"收货码错误";
                callGoodsView.title.textColor = [UIColor hexString:@"f10000"];
            }
        }];
    } cecanlBlock:^(NSString *password, CallGoodsPupView *callGoodsView) {
        
    }];
}

// 确认取货
- (void)pickGoodsBtnAction:(UIButton *)sender
{
    __weak typeof(self) wkself = self;
    [self alert:nil message:@"是否确认取货？" sureBlock:^{
        [wkself editOrderWithStatus:@"2" code:nil success:^(BOOL issuccess,MLHTTPRequestResult *res) {
            
        }];
    }];
}

// 查看详情
- (void)checkAction:(UIButton *)sender
{
    __weak typeof(self) wkself = self;
    if (self.model.order_status.intValue == 3 || self.model.order_status.intValue == 4) {
        RunOrderViewController *vc = [[RunOrderViewController alloc] init];
        vc.viewModel.aid = wkself.model.aid;
        vc.viewModel.isGrabSingle = NO;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alert:(NSString *)title message:(NSString *)message sureBlock:(void(^)(void))sureBlock{
    __weak typeof(self) wkself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureBlock();
    }]];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}


- (void)setModel:(RunOrderListModel *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.tx_pic]];
    self.name.text = model.user_name;
    self.tel.text = [model.mobile replaceStringWithAsteriskStartLocation:3 lenght:4];
    self.price.text = [NSString stringWithFormat:@"￥%@",model.total_money];
    self.distance.text = [NSString stringWithFormat:@"%0.2fkm",(model.distance.floatValue / 1000.0)];
    self.time.text = model.order_dateline;
    self.s_address.text = model.start_address;
    self.e_address.text = model.end_address;
    self.bigBtn.hidden = model.order_status.intValue != 0;
    self.btnSubView.hidden = model.order_status.intValue == 0;
    if (model.order_status.integerValue == 1) {
        //  待取货
        self.contactBtn.selected = NO;
        self.contactBtn.hidden = NO;
        self.pickGoodsBtn.hidden = NO;
        self.deliveryBtn.hidden = YES;
        self.checkBtn.hidden = YES;
    }else if (model.order_status.integerValue == 2)
    {
        //  配送中
        self.contactBtn.selected = YES;
        self.contactBtn.hidden = NO;
        self.pickGoodsBtn.hidden = YES;
        self.deliveryBtn.hidden = NO;
        self.checkBtn.hidden = YES;
    }else{
        //  已完成 已取消
        self.contactBtn.selected = YES;
        self.contactBtn.hidden = YES;
        self.pickGoodsBtn.hidden = YES;
        self.deliveryBtn.hidden = YES;
        self.checkBtn.hidden = NO;
    }

    self.s_address.width = [model.start_address sizeWithFont:self.s_address.font
                                                     maxSize:CGSizeMake(SJAdapter(650), self.s_address.height)].width;
    self.e_address.width = [model.end_address sizeWithFont:self.s_address.font
                                                   maxSize:CGSizeMake(SJAdapter(650), self.s_address.height)].width;
    ;
}

- (UIViewController *)getRunMenuViewController{
    UIViewController *vc = self.viewController.parentViewController;
    MLLog(@"vc %@",NSStringFromClass([vc class]));
    return vc;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
