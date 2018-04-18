//
//  MessageViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "MessageViewController.h"
#import "xq_CustomSegmented.h"
#import "MessageViewModel.h"
#import "MessageTableViewCell.h"
#import "UIScrollView+DataEmptyView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MessgaeDetailViewController.h"
@interface MessageViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) xq_CustomSegmented *segmented;
@property (nonatomic ,strong) xq_TableView *tableView;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) NSMutableArray *touteSearchDelegate;
@end


static NSString * const megList_id = @"MessageTableViewCell";
#define String_Number(num) [NSString stringWithFormat:@"%@",@(num)]

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isExtendLayout = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ///  获取当前选中的Index,并且请求数据
    self.viewModel.isSystem = self.segmented.currentSelectedIndex;
}

- (void)xq_addSubViews{
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
        self.viewModel.isSystem =  index;
    }];
}

- (void)xq_layoutNavigation{
    self.title = @"消息中心";
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
                [self.tableView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNotMsg];
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

    [self.viewModel.cellClickSubject subscribeNext:^(MessageModel *  _Nullable x) {
        @strongify(self);
        MessgaeDetailViewController *vc = [[MessgaeDetailViewController alloc] init];
        vc.aid = x.aid;
        vc.msg_type = self.segmented.currentSelectedIndex == 0?@"1":@"2";
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - Setter

#pragma mark - Private


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableView DataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:megList_id];
    cell.model = self.viewModel.dataSource[indexPath.row];

    [self.tableView registerForPreviewingWithSourceView:cell];

    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:megList_id  configuration:^(MessageTableViewCell *cell) {
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
        self.tableView = [[xq_TableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 0;
        self.tableView.sectionFooterHeight = 0;
        self.tableView.sectionHeaderHeight = 0;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, SJAdapter(98), 0);

        [self.tableView registerClass:[MessageTableViewCell class]  forCellReuseIdentifier:megList_id];

        @weakify(self);
        [self.tableView refresh:^{
            @strongify(self);
            [self.viewModel.refreshDataCommand execute:nil];
        } loadMore:^{
            @strongify(self);
            [self.viewModel.nextPageCommand execute:nil];
        }];

        ///  NOTE:  设置显示空数据占位图  和 显示暂位图的类型
        [_tableView setDataEmptyBtnTapedBlock:^{
            if (self.tableView.emptyViewType == DataEmptyViewTypeNoNetwork) {
                @strongify(self);
                [self.viewModel.refreshDataCommand execute:nil];
            }
        }];

        //  NOTE 设置3d touch
        [_tableView peekViewControllerBlock:^UIViewController *(NSIndexPath *indexPath) {
            @strongify(self);
            MessgaeDetailViewController *vc = [[MessgaeDetailViewController alloc] init];
            vc.aid = self.viewModel.dataSource[indexPath.row].aid;
            vc.msg_type = self.segmented.currentSelectedIndex == 0?@"1":@"2";
            vc.preferredContentSize = CGSizeMake(0.0f,500.0f);
            return vc;
        } popBlock:^(UIViewController *vc) {
            @strongify(self);
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _tableView;
}

- (xq_CustomSegmented *)segmented{
    if (_segmented == nil) {
        _segmented = [[xq_CustomSegmented alloc] initWithTitles:@[@"订单消息",@"系统消息"]];
    }
    return _segmented;
}

- (MessageViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[MessageViewModel alloc] init];
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
