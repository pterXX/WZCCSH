//
//  xq_TableView.m
//  cssh_FXH
//
//  Created by 3158 on 2017/5/27.
//  Copyright © 2017年 XQS. All rights reserved.
//

#import "xq_TableView.h"
@interface xq_TableView() <UIViewControllerPreviewingDelegate>

@end
@implementation xq_TableView
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     delegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate
                      refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock
                     loadMore:(MJRefreshComponentRefreshingBlock)loadMoreBlock
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = delegate;
        self.dataSource = delegate;
        [self refresh:refreshingBlock loadMore:loadMoreBlock];
        
        
    }
    return self;
}


- (void)refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock
       loadMore:(MJRefreshComponentRefreshingBlock)loadMoreBlock{
    
    //  隐藏多余的cell
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorInset = UIEdgeInsetsMake(0, SJAdapter(20), 0, SJAdapter(20));
    
    __weak typeof(self) wkself = self;
    if (refreshingBlock) {
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            refreshingBlock();
        }];
        [header setEndRefreshingCompletionBlock:^{
            [wkself reloadData];
        }];
//        [header setTitle:@"放开立即刷新" forState:MJRefreshStatePulling];
//        [header setTitle:@"正在刷新数据" forState:MJRefreshStateRefreshing];
//        header.stateLabel.font = [UIFont systemFontOfSize:13];
//        header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
//        header.stateLabel.textColor = [UIColor blackColor];
//        header.lastUpdatedTimeLabel.textColor = [UIColor blackColor];
        self.mj_header = header;
    }

    if (loadMoreBlock) {
        MJRefreshBackFooter *footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            if (wkself.mj_header.state == MJRefreshStateRefreshing) {
                [wkself.mj_footer endRefreshing];
                return ;
            }

            loadMoreBlock();
        }];
        [footer setEndRefreshingCompletionBlock:^{
            [wkself reloadData];
        }];
//        [footer setTitle:@"暂无更多内容" forState:MJRefreshStateNoMoreData];
//        footer.refreshingTitleHidden = YES;
        footer.automaticallyHidden = YES;
        self.mj_footer = footer;
    }
}


- (void)endRefreshing:(NSArray *)array{
    [self.mj_header endRefreshing];
    if (array.count == 0) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer endRefreshing];
    }
    [self reloadData];
}

#pragma mark - 3d Touch
- (void)peekViewControllerBlock:(UIViewController *(^)(NSIndexPath *))peekBlock popBlock:(void (^)(UIViewController *))popBlock{
    self.peekViewControllerBlock = peekBlock;
    self.popViewControllerBlock = popBlock;
}

- (void)registerForPreviewingWithSourceView:(UITableViewCell *)cell{
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        NSLog(@"3D Touch  可用!");
        //给cell注册3DTouch的peek（预览）和pop功能
        [self.viewController registerForPreviewingWithDelegate:self sourceView:cell];
    } else {
        NSLog(@"3D Touch 无效");
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];

    if (self.peekViewControllerBlock) {
        UIViewController *vc = self.peekViewControllerBlock(indexPath);
        vc.preferredContentSize = CGSizeMake(0.0f,500.0f);

        //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
        CGRect rect = CGRectMake(0, 0, self.width,[previewingContext sourceView].height);
        previewingContext.sourceRect = rect;

        //返回预览界面
        return vc;
    }else{
        return nil;
    }

}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {

    if (self.popViewControllerBlock) {
        self.popViewControllerBlock(viewControllerToCommit);
    }
}



@end
