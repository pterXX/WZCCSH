//
//  xq_TableView.h
//  cssh_FXH
//
//  Created by 3158 on 2017/5/27.
//  Copyright © 2017年 XQS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface xq_TableView : UITableView

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                     delegate:(id<UITableViewDelegate,UITableViewDataSource>)delegate
                      refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock
                     loadMore:(MJRefreshComponentRefreshingBlock)loadMoreBlock;


- (void)refresh:(MJRefreshComponentRefreshingBlock)refreshingBlock
       loadMore:(MJRefreshComponentRefreshingBlock)loadMoreBlock;


- (void)endRefreshing:(NSArray *)array;





#pragma mark - 3d touch
@property (nonatomic ,copy) UIViewController *(^peekViewControllerBlock)(NSIndexPath *indexPath);

@property (nonatomic ,copy) void (^popViewControllerBlock)(UIViewController *vc);

- (void)registerForPreviewingWithSourceView:(UITableViewCell *)cell;

- (void)peekViewControllerBlock:(UIViewController *(^)(NSIndexPath *indexPath))peekBlock popBlock:(void(^)(UIViewController *vc))popBlock;
@end
