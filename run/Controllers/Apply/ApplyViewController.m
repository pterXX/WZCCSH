//
//  ApplyViewController.m
//  running man
//
//  Created by asdasd on 2018/4/4.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "ApplyViewController.h"

#import "RunApplyViewController.h"
@interface ApplyViewController ()

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)xq_addSubViews{
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    @weakify(self);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

//    if ([MLNetWorkHelper isNetwork]) {
        [self.scrollView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeApply];
//    }else{
//        [self.scrollView setIsShowDataEmpty:YES emptyViewType:DataEmptyViewTypeNoNetwork];
//    }

    [self.scrollView setDataEmptyBtnTapedBlock:^{
         @strongify(self);
        if (self.scrollView.emptyViewType == DataEmptyViewTypeNoNetwork) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kApplyViewNoNetworingRefresNoteKey object:nil];
        }else{
            RunApplyViewController *vc = [[RunApplyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)xq_layoutNavigation{
    self.title = @"跑腿员申请";
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
