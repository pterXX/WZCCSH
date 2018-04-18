//
//  UserViewController.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "UserViewController.h"
#import "UIButton+Layout.h"
#import "ToolModel.h"
#import "UserCenterViewModel.h"
#import "WalletViewController.h"
#import "UserDataViewController.h"
#import "SetupViewController.h"
#import "HistoryViewController.h"
#import "ShortcutItemManage.h"

#define UserTabeleView_ID @"UserTabeleView_ID"
@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *headView;

@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UIButton *more;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *end_btn;
@property (weak, nonatomic) IBOutlet UIButton *start_btn;
@property (strong ,nonatomic) UserCenterViewModel *viewModel;

@end

@implementation UserViewController

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel.dataViewModel.getUserInfoCommand execute:nil];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.end_btn setImgePosition:UIButtonImagePositionLeft spacer:10];
    [self.start_btn setImgePosition:UIButtonImagePositionLeft spacer:10];
    self.headView.layer.cornerRadius = self.headView.height / 2.0;
    self.headView.layer.masksToBounds = YES;
}


- (void)navPushVC:(UIViewController *)vc {
    UINavigationController *nav  = (UINavigationController *) self.sideMenuViewController.contentViewController;
    if (nav && vc) {
        if (nav.sideMenuViewController) {
            [nav.sideMenuViewController hideMenuViewController];
        }
        [nav pushViewController:vc animated:YES];
    }
}

#pragma mark - XQBassViewControllerProtocol
- (void)xq_addSubViews{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = COLOR_FFFFFF;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UserTabeleView_ID];

    @weakify(self);
    [[self.headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.userDataClickSubject sendNext:nil];
    }];

    [[self.more rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.userDataClickSubject sendNext:nil];
    }];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    self.nickname.userInteractionEnabled = YES;
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self.viewModel.userDataClickSubject sendNext:nil];
    }];
    [self.nickname addGestureRecognizer:tap];

    [[self.start_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
        [self.viewModel.startBtnAndEndBtnCommand execute:nil];
    }];

    [[self.end_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.startBtnAndEndBtnCommand execute:nil];
    }];
}

- (void)xq_bindViewModel{
     @weakify(self);
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNumber *  _Nullable x) {
         @strongify(self);
          NSArray<Class> *array = @[[WalletViewController class],[HistoryViewController class],[SetupViewController class]];
        Class class = array[x.intValue];
        UIViewController *vc = [[class alloc] init];
        [self navPushVC:vc];
    }];

    [[RACObserve(self.viewModel.dataViewModel,model) distinctUntilChanged] subscribeNext:^(UserDataModel  *_Nullable x) {
        @strongify(self);
        [self.headView sd_setBackgroundImageWithURL:[NSURL URLWithString:x.tx_pic] forState:UIControlStateNormal placeholderImage:Img([x.sex isEqualToString:@"男" ]?@"user_icon_head1":@"user_icon_head2")];
        [self.nickname setText:x.user_account];
        [[NSNotificationCenter defaultCenter] postNotificationName:KChangeEadPoretraitIconNoteKey object:x.tx_pic];
    }];

    [RACObserve(self.viewModel,is_work) subscribeNext:^(UserDataModel  *_Nullable x) {
        @strongify(self);
        self.start_btn.enabled = !self.viewModel.is_work;
        self.end_btn.enabled = self.viewModel.is_work;
        [self setupShortItem];
    }];


    [[self.viewModel.userDataClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
         @strongify(self);
        UserDataViewController *vc = [[UserDataViewController alloc] init];
        vc.viewModel = self.viewModel.dataViewModel;
        [self navPushVC:vc];
    }];
}

- (void)xq_getNewData{

}

- (void)setupShortItem{
    NSString *str = self.viewModel.is_work?@"收工":@"开工";
    if (@available(iOS 9.1, *)) {
        UIApplicationShortcutItem *shoreItem2 = [[UIApplicationShortcutItem alloc] initWithType:KWorkItemTypekey localizedTitle:str localizedSubtitle:nil icon:[UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeFavorite] userInfo:nil];
        [[ShortcutItemManage shareManager] updateItem:shoreItem2];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UserTabeleView_ID];
    cell.imageView.image = Img(self.viewModel.toolModels[indexPath.row].iconImage);
    cell.textLabel.text = self.viewModel.toolModels[indexPath.row].title;
    cell.textLabel.textColor = COLOR_353535;
    cell.textLabel.font = [UIFont adjustFont:18];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
 }

 - (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.self.viewModel.toolModels.count;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:@(indexPath.row)];
}

#pragma mark - LazyLoad
- (UserCenterViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[UserCenterViewModel alloc] init];
    }
    return _viewModel;
}

@end
