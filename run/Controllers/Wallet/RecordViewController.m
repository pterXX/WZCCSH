//
//  RecordViewController.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "RecordViewController.h"
#import "WalletCell.h"
#import "RecordViewModel.h"
#import "UIScrollView+DataEmptyView.h"

static NSString *const cell_id = @"WalletCell";

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) xq_TableView *tableView;
@property (nonatomic ,strong) RecordViewModel *viewModel;
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)xq_layoutNavigation{
    self.title = @"提现记录";
}

- (void)xq_addSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    @weakify(self);
    [self.tableView refresh:^{
        @strongify(self);
        [self.viewModel.refreshDataCommand execute:nil];
    } loadMore:^{
        @strongify(self);
        [self.viewModel.nextPageCommand execute:nil];
    }];

    [self.tableView setDataEmptyBtnTapedBlock:^{
        @strongify(self);
        if (DataEmptyViewTypeNoNetwork == self.tableView.emptyViewType) {
            [self.viewModel.refreshDataCommand execute:nil];
        }else{

        }
    }];
}

- (void)xq_bindViewModel{
    @weakify(self);

    [self.viewModel.refreshDataCommand execute:nil];

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
                NSString *title = @"暂无记录";
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

}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    WalletCell * recodCell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    recodCell.model = self.viewModel.dataSource[indexPath.section][indexPath.row];
    recodCell.selectionStyle=UITableViewCellSelectionStyleNone;//设置cell点击效果
    return recodCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SJAdapter(140);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *head_id = @"head_id";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:head_id];
    if (headView == nil) {
        headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:head_id];
    }

    UILabel *label =  [headView viewWithTag:101];
    if (label == nil) {
        label = [UILabel new];
        label.tag = 101;
        label.textColor = COLOR_999999;
        label.font = [UIFont adjustFont:16];
        [headView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(SJAdapter(20));
            make.right.offset(-SJAdapter(20));
            make.top.and.bottom.offset(0);
        }];
    }else{

    }
    label.text = self.viewModel.groupKeys[section];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SJAdapter(100);
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
        [_tableView registerNib:[UINib nibWithNibName:cell_id bundle:nil] forCellReuseIdentifier:cell_id];
    }
    return _tableView;
}


- (RecordViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[RecordViewModel alloc] init];
    }
    return _viewModel;
}

@end
