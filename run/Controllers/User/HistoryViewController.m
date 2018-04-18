//
//  HistoryViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "HistoryViewController.h"
#import "xq_CustomSegmented.h"
#import "RunOrderListModel.h"
#import "RunOrderTableViewCell.h"
#import "UIScrollView+DataEmptyView.h"
#import "OorderListViewModel.h"
#import "RunOrderViewController.h"
@interface HistoryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) xq_CustomSegmented *segmented;
@property (nonatomic ,strong) xq_TableView *tableView;
@property (nonatomic ,strong) NSMutableArray<RunOrderListModel *> *dataSource;

@property (nonatomic ,strong) OorderListViewModel *viewModel;
@end


static NSString * const runList_id = @"RunOrderTableViewCell";
#define String_Number(num) [NSString stringWithFormat:@"%@",@(num)]

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.viewModel.refreshDataCommand execute:nil];
}




-(void)xq_addSubViews{
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.segmented];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.segmented];

    [self.segmented  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.offset(0);
        make.height.offset(40);
    }];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];

    @weakify(self);
    [self.segmented setSegmentedBlock:^(NSInteger index) {
        @strongify(self)
        self.viewModel.selectedId =  index == 0 ?@"3":@"4";;
    }];

    ///  获取当前选中的Index
    self.viewModel.selectedId = (self.segmented.currentSelectedIndex == 0 ?@"3":@"4");
}

- (void)xq_layoutNavigation{
    self.title = @"历史订单";
}

- (void)xq_bindViewModel{
    @weakify(self);

    [self.viewModel.refreshUISubject subscribeNext:^(id x) {

        @strongify(self);
        [self.tableView reloadEmptyDataSet];
    }];

    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);

        [self.tableView reloadData];
        [self.tableView stopLoadingAnimation];

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
                NSString *title = @"你还没有订单记录";
                NSDictionary *attributes = @{
                                             NSFontAttributeName:[UIFont adjustFont:12],
                                             NSForegroundColorAttributeName:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
                                             };
                [self.tableView setTitleText:[[NSMutableAttributedString alloc] initWithString:title attributes:attributes]];
                [self.tableView setDescriptionText:nil];
                [self.tableView reloadEmptyDataSet];
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
            }
                break;
            case XQRefreshError: {
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoNetwork];
            }
                break;

            default:
                break;
        }
    }];

    [self.viewModel.cellClickSubject subscribeNext:^(RunOrderListModel *  _Nullable x) {
        @strongify(self);
        RunOrderViewController *vc =    [[RunOrderViewController alloc] init];
        vc.viewModel.aid = x.aid;
         vc.viewModel.isGrabSingle = x.order_status.intValue == 0;
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [RACObserve(self.viewModel, selectedId) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.viewModel.refreshDataCommand execute:nil];
    }];
}


#pragma mark - system
- (void)updateViewConstraints{
    @weakify(self);

    [self.segmented  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.offset(0);
        make.height.offset(40);
    }];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.with.insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];

    [super updateViewConstraints];
}



#pragma mark - Private

- (void)dataEmptyBtnTaped{
    switch (_tableView.emptyViewType) {
        case DataEmptyViewTypeStarts:  //  显示开工视图的时候才可以点击
            ML_MESSAGE;
            break;

        default:
            break;
    }

}

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


    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SJAdapter(480);
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


- (xq_CustomSegmented *)segmented{
    if (_segmented == nil) {
        _segmented = [[xq_CustomSegmented alloc] initWithTitles:@[@"已完成",@"已取消"]];
    }
    return _segmented;
}

- (OorderListViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[OorderListViewModel alloc] init];
    }
    return _viewModel;
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
