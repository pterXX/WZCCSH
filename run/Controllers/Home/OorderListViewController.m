//
//  OorderListViewController.m
//  running man
//
//  Created by asdasd on 2018/3/29.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "OorderListViewController.h"
#import "xq_TableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "RunOrderTableViewCell.h"
#import "UIButton+Layout.h"
#import <YYText.h>
#import "UIScrollView+DataEmptyView.h"
#import "XQLoginExample.h"
#import "RunOrderViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface OorderListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) xq_TableView *tableView;
@property (nonatomic ,strong) UIButton *refreshBtn;

@end

static NSString * const runList_id = @"RunOrderTableViewCell";
#define String_Number(num) [NSString stringWithFormat:@"%@",@(num)]

@implementation OorderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)xq_addSubViews{
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.refreshBtn];

    @weakify(self);
    //  刷新和上拉刷新
    [self.tableView refresh:^{
        @strongify(self);
        [self.viewModel.refreshDataCommand execute:nil];
    } loadMore:^{
        @strongify(self);
        [self.viewModel.nextPageCommand execute:nil];
    }];

    //  刷新按钮的点击
    [[self.refreshBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
         //  设置刷新状态
        if (self.viewModel.dataSource.count == 0) {
            [self.viewModel.refreshEndSubject sendNext:@(XQHeaderRefresh_HasLoadingData)];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        [self.viewModel.refreshDataCommand execute:nil];
    }];

    [self.tableView setDataEmptyBtnTapedBlock:^{
        @strongify(self);
        if (self.tableView.emptyViewType == DataEmptyViewTypeNoNetwork) {
            [self.viewModel.refreshDataCommand execute:nil];
        }else if (self.tableView.emptyViewType == DataEmptyViewTypeStarts){
            // 开工
            [self.viewModel.startBtnAndEndBtnCommand execute:nil];
        }
    }];

    //  3d touch 的回调
    [self.tableView peekViewControllerBlock:^UIViewController *(NSIndexPath *indexPath) {
        RunOrderListModel *model = self.viewModel.dataSource[indexPath.row];
        RunOrderViewController *vc = [[RunOrderViewController alloc] init];
        vc.viewModel.aid = model.aid;
        vc.viewModel.isGrabSingle = model.order_status.intValue == 0;
        return vc;
    } popBlock:^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


#pragma mark - system
- (void)updateViewConstraints{
    @weakify(self);

    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(iPhoneX ? -20:0);
        make.height.with.offset(SJAdapter(98));
    }];
    [super updateViewConstraints];
}

- (void)xq_bindViewModel{
    @weakify(self);

    //  切换的待接单页面
    [[XQNotificationCenter rac_addObserverForName:kPushOrderPageAndReloadUINotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.viewModel.refreshDataCommand execute:nil];
    }];

    //  个人中心开工和收工按钮点击后当前页面的状态切换
    [[XQNotificationCenter rac_addObserverForName:kWorkingStatuseNotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        //  切换状态前将数据清空
        [self.viewModel.refreshDataCommand execute:nil];
    }];


    [self.viewModel.refreshUISubject subscribeNext:^(id x) {

        @strongify(self);
        [self.tableView reloadEmptyDataSet];
    }];

    //  刷新结束后的相应状态
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);

        if (self.viewModel.menuInfo.menuId.intValue == 0) {
            self.refreshBtn.hidden = NO;
        }

        [self.tableView reloadData];
        [self.tableView stopLoadingAnimation];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        switch ([x integerValue]) {
            case XQHeaderRefresh_HasMoreData: {

                [self.tableView.mj_header endRefreshing];

                if (self.tableView.mj_footer == nil) {

                    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
                        @strongify(self);
                        [self.viewModel.nextPageCommand execute:nil];
                    }];
                }
            }
                break;
            case XQHeaderRefresh_HasNoMoreData: {
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer = nil;
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoOrderData];
            }
                break;
            case XQFooterRefresh_HasMoreData: {

                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer resetNoMoreData];
                [self.tableView.mj_footer endRefreshing];
            }
                break;
            case XQFooterRefresh_HasNoMoreData: {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
                break;
            case XQHeaderRefresh_HasLoadingData:{
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeLoading];
                self.refreshBtn.hidden = YES;
            }
                break;
            case XQRefreshNoIsWork: {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeStarts];
                self.refreshBtn.hidden = YES;
            }
                break;
            case XQRefreshNoIsCheck: {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeCheck];
                self.refreshBtn.hidden = YES;
            }
                break;
            case XQRefreshError: {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoNetwork];
                self.refreshBtn.hidden = YES;
            }
                break;

            default:
                break;
        }
    }];


    [self.viewModel.cellClickSubject subscribeNext:^(RunOrderListModel *  _Nullable x) {
        RunOrderViewController *vc = [[RunOrderViewController alloc] init];
        vc.viewModel.aid = x.aid;
        vc.viewModel.isGrabSingle = x.order_status.intValue == 0;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Private
#pragma mark - TableView DataSource
- (NSString *)distanceStr:(float)edis {
    NSString *estr = edis>= 1000.0?[NSString stringWithFormat:@"距离%.2fkm",edis / 1000.0]:[NSString stringWithFormat:@"距离%@m",@(edis)];
    return estr;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RunOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:runList_id];
    RunOrderListModel *model = self.viewModel.dataSource[indexPath.row];
    cell.model = model;
    [cell setRefreshTableViewBlock:^{
        [self.viewModel.refreshDataCommand execute:nil];
    }];

    //  使用3D touch
    [self.tableView registerForPreviewingWithSourceView:cell];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return[tableView fd_heightForCellWithIdentifier:runList_id  configuration:^(RunOrderTableViewCell *cell) {
        cell.model = self.viewModel.dataSource[indexPath.row];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.cellClickSubject sendNext:self.viewModel.dataSource[indexPath.row]];
}


#pragma mark - LazyLoad
- (xq_TableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[xq_TableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, SJAdapter(98), 0);
        [_tableView registerClass:[RunOrderTableViewCell class]  forCellReuseIdentifier:runList_id];
    }
    return _tableView;
}


- (UIButton *)refreshBtn{
    if (_refreshBtn == nil) {
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreshBtn.frame = CGRectMake(0.00f, 617.00f,SJAdapter(375),SJAdapter(98));
        [_refreshBtn setTitle:@"刷新列表" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor colorWithRed:0.26f green:0.26f blue:0.26f alpha:1.00f] forState:UIControlStateNormal];
        [_refreshBtn setImage:[UIImage imageNamed:@"home_icon_refresh"] forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font  = [UIFont adjustFont:17];
        _refreshBtn.backgroundColor  =[UIColor whiteColor];;

        CGFloat imgSizeWidth = SJAdapter(36);
        CGFloat imgSizeHeight = SJAdapter(32);
        CGFloat titleSizeWidth = [_refreshBtn.currentTitle sizeWithFont:_refreshBtn.titleLabel.font maxSize:CGSizeMake(KWIDTH, imgSizeHeight)].width;
        CGFloat imageOrginX = (KWIDTH - imgSizeWidth - titleSizeWidth - 8) / 2.0;
        CGFloat imgTop = SJAdapter(33);
        [_refreshBtn setImageRect:CGRectMake(imageOrginX, imgTop, imgSizeWidth,imgSizeHeight)];
        [_refreshBtn setTitleRect:CGRectMake(imageOrginX + imgSizeWidth + 8, imgTop, titleSizeWidth, imgSizeHeight)];
    }
    return _refreshBtn;
}


- (OorderListViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[OorderListViewModel alloc] init];
    }
    return _viewModel;
}

@end
