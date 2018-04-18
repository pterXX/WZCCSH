//
//  HomeViewController.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "HomeViewController.h"
#import "OorderListViewController.h"
#import "xq_BarButtonItem.h"
#import "UIBarButtonItem+badge.h"
#import "MessageViewController.h"
#import "ApplyViewController.h"
#import "HomeViewController.h"
#import "HomeViewModel.h"
#import "XQLoginExample.h"
@interface HomeViewController()<VTMagicViewDelegate,VTMagicViewDataSource>
@property (nonatomic, nonnull ,strong) VTMagicController *magicController;
@property (nonatomic, nonnull ,strong) ApplyViewController *applyViewController;
@property (nonatomic, nonnull ,strong) UIBarButtonItem *messageBarBtn ;
@property (nonatomic, nonnull ,strong) NSArray *menuList;
@end
@implementation HomeViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)xq_addSubViews{
    [self setIsExtendLayout:NO];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _menuList = @[@"待接单",@"待取货",@"配送中"];
    [_magicController.magicView reloadData];

    [self.magicController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self addChildViewController:self.applyViewController];
    [self.view addSubview:self.applyViewController.view];

    self.magicController.view.hidden = YES;
    self.applyViewController.view.hidden = YES;
}

- (void)xq_bindViewModel{
       @weakify(self);
    //  无网按钮点击通知
    [[XQNotificationCenter rac_addObserverForName:kApplyViewNoNetworingRefresNoteKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self xq_getNewData];
    }];

    //  切换的待接单页面
    [[XQNotificationCenter rac_addObserverForName:kPushOrderPageAndReloadUINotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
          @strongify(self);
        [self.magicController.magicView reloadDataToPage:0];
    }];

    //每30秒执行一次,这里要加上释放信号,否则控制器推出后依旧会执行,看具体需求吧
    [self requestMsgCount];
    [[[RACSignal interval:30 onScheduler:[RACScheduler scheduler]]takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self requestMsgCount];
    }];
}

- (void)displayView{
    if ([XQLoginExample lastIs_Run]) {
        [self setTitle:@"跑腿员接单"];
    }else{
        [self setTitle:@"跑腿员申请"];
    }
    if ([XQLoginExample lastIs_Run]) {
        self.magicController.view.hidden = NO;
        self.applyViewController.view.hidden = YES;
    }else{
        if ([XQLoginExample lastRunStatus] == 1) {
            self.magicController.view.hidden = NO;
            self.applyViewController.view.hidden = YES;
        }else if ([XQLoginExample lastRunStatus] == 2) {
            self.magicController.view.hidden = YES;
            self.applyViewController.view.hidden = NO;
        }else{
            self.magicController.view.hidden = YES;
            self.applyViewController.view.hidden = NO;
        }
    }
}

- (void)xq_getNewData{
    @weakify(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XQLoginExample runMainIndexServerSuccess:^(void) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self displayView];
    } failure:^(NSError *error) {
        @strongify(self);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self displayView];
    }];
}

- (void)requestMsgCount{
    @weakify(self);
    [MLHTTPRequest POSTWithURL:RUN_MESSAGE_COUNT parameters:nil success:^(MLHTTPRequestResult *result) {
        @strongify(self);
        if (result.errcode == 0) {
            int num = [result.data[@"order_count"] intValue] + [result.data[@"msg_count"] intValue];
            if (num <= 0) {
                self.messageBarBtn.badgeValue = nil;
            }else{
                self.messageBarBtn.badgeValue = [NSString stringWithFormat:@"%@",@(num)];
            }
        }

    } failure:^(NSError *error) {
        @strongify(self);
        self.messageBarBtn.badgeValue = nil;
    } isResponseCache:YES];
}

- (void)xq_layoutNavigation{
    if ([XQLoginExample lastIs_Run]) {
        [self setTitle:@"跑腿员接单"];
    }else{
        [self setTitle:@"跑腿员申请"];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0,100,40, button.currentImage.size.height);
    [button setTitleColor:COLOR_353535 forState:UIControlStateNormal];
    [button setTitle:@"消息" forState:UIControlStateNormal];

    @weakify(self);
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController pushViewController:[[MessageViewController alloc] init] animated:YES];
    }];

    // 添加角标
    UIBarButtonItem *navrightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    navrightButton.badgeValue = @"0";
    navrightButton.badgeOriginX = 35;
    navrightButton.badgeOriginY = KWIDTH == 320? -20:-4;
    MLLog(@"navrightButton.badgeOriginY %@",@(navrightButton.badgeOriginY));
    navrightButton.badgeBGColor = [UIColor redColor];
    navrightButton.badgeValue = nil;
    self.messageBarBtn = navrightButton;

    if (self.tabBarController) {
        self.tabBarController.navigationItem.rightBarButtonItem = self.messageBarBtn;
    }else{
        self.navigationItem.rightBarButtonItem = self.messageBarBtn;
    }
}

#pragma mark - LazyLoad
- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = COLOR_FF8803;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 40.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (ApplyViewController *)applyViewController
{
    if (!_applyViewController) {
        _applyViewController = [[ApplyViewController alloc] init];
    }
    return _applyViewController;
}


#pragma mark -
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:COLOR_666666 forState:UIControlStateNormal];
        [menuItem setTitleColor:COLOR_FF8803 forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    NSString *vtid = [NSString stringWithFormat:@"%@%@",NSStringFromClass([OorderListViewController class]),@(pageIndex)];
    OorderListViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:vtid];
    if (!gridViewController) {
        gridViewController = [[OorderListViewController alloc] init];
    }
    MenuInfo *menuInfo = [MenuInfo menuInfoWithTitl:self.menuList[pageIndex] menuId:[NSString stringWithFormat:@"%@",@(pageIndex)]];
    gridViewController.viewModel.menuInfo = menuInfo;
    return gridViewController;
}
@end
