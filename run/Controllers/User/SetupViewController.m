//
//  SetupViewController.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "SetupViewController.h"
#import "SetupViewModel.h"
#import <YYText.h>
#import "XQSetupExample.h"
#import "XQLoginExample.h"

@interface SetupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) XQButton *loginOutBtn;
@property (nonatomic ,strong) SetupViewModel *viewModel;
@end


static NSString *SetupTableView_Id = @"SetupTableView_Id";
@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.loginOutBtn layoutIfNeeded];
    self.loginOutBtn.layer.cornerRadius = self.loginOutBtn.height / 2.0;
    self.loginOutBtn.layer.masksToBounds = YES;
}

- (void)xq_addSubViews{
    [self.view addSubview:self.tableView];

    UIView *view = [UIView new];
    [view setFrame:CGRectMake(0, 0, KWIDTH, SJAdapter(440))];
    [view addSubview:self.loginOutBtn];
    _tableView.tableFooterView = view;
    
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [self.loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(view);
        make.width.equalTo(view.mas_width).multipliedBy(250.0/375.0);
        make.height.equalTo(self.loginOutBtn.mas_width).multipliedBy(44.0/250.0);
    }];
}

- (void)xq_bindViewModel{
        @weakify(self);
    [self.viewModel.reloadTableSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];

    [self.viewModel.cellClickSubject subscribeNext:^(ToolModel * _Nullable x) {
        @strongify(self);
        NSMutableAttributedString *attr = x.title;
        NSString *title = attr.string;

        if ([title isEqualToString:@"关于我们"]) {
            TGWebViewController *web =  [[TGWebViewController alloc] init];
            web.url =  RUN_ABOUDT;
            web.progressColor =  COLOR_MAIN;
            [self.navigationController pushViewController:web animated:YES];
        }
    }];

    ///  退出登录
    [[self.loginOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [MessageBox showConfirmWithTitle:@"确定要退出当前账户？" message:nil otherTitle:@"确定" block:^(NSInteger index) {
            if (index == 1) {
                [XQLoginExample exampleLoginOuted];
            }
        }];
    }];
}

- (void)xq_getNewData{

}

- (void)xq_layoutNavigation{
    self.title = @"设置";
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.toolModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.toolModels[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetupTableView_Id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SetupTableView_Id];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ToolModel *model = self.viewModel.toolModels[indexPath.section][indexPath.row];
    cell.textLabel.attributedText = model.title;

    if (model.detialTitle) {
        cell.detailTextLabel.attributedText = model.detialTitle;
    }else{
        cell.detailTextLabel.attributedText = nil;
        UISwitch *st = [[UISwitch alloc] init];
        st.on = [model.otherData boolValue];
//        if ([cell.textLabel.attributedText.string containsString:@"消息推送"]) {
            @weakify(self);
            [[st rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                [self.viewModel.switchBtnClickSubject sendNext:model];
            }];
//        }
        cell.accessoryView = st;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SJAdapter(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        static NSString *head_id  = @"head_id";
        UITableViewHeaderFooterView *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:head_id];
        if (head == nil) {
            head = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:head_id];
        }
        if ([head viewWithTag:1001] == nil) {
            YYLabel *label = [[YYLabel alloc]  init];
            label.frame = CGRectMake(SJAdapter(20), 0, SJAdapter(355), SJAdapter(100));
            label.tag = 1001;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"新任务提醒"];
            [attr yy_setFont:[UIFont adjustFont:16] range:attr.yy_rangeOfAll];
            [attr yy_setColor:COLOR_999999 range:attr.yy_rangeOfAll];
            [label setAttributedText:attr];
            [head addSubview:label];
        }
        return head;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0?SJAdapter(100):CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel.cellClickSubject sendNext:self.viewModel.toolModels[indexPath.section][indexPath.row]];
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

- (XQButton *)loginOutBtn{
    if (_loginOutBtn == nil) {
        _loginOutBtn = [XQButton buttonWithType:UIButtonTypeCustom];
        [_loginOutBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
    }
    return _loginOutBtn;
}



- (SetupViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[SetupViewModel alloc] initWithModel:[[SetupViewModel alloc] init] ];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
