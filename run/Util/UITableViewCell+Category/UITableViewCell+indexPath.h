//
//  UITableViewCell+indexPath.h
//  proj
//
//  Created by asdasd on 2018/1/2.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (indexPath)
@property (nonatomic ,strong,readonly) NSIndexPath *xq_indexPath;
@property (nonatomic ,strong,readonly) UITableView *xq_tableView;
@end


@interface UITableView (tableViewCell)

//  根据class 获取cell
- (UITableViewCell *)dequeueReusableCellWithCellClass:(NSString *)cellClass;

@end
