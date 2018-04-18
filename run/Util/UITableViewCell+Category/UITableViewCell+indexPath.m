//
//  UITableViewCell+indexPath.m
//  proj
//
//  Created by asdasd on 2018/1/2.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "UITableViewCell+indexPath.h"



@implementation UITableViewCell (indexPath)
- (UITableView *)xq_tableView
{
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;

    do {
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UITableView class]]) {
            return (UITableView *)next;
        }

        next = next.nextResponder;

    }while(next != nil);

    return nil;
}

- (NSIndexPath *)xq_indexPath
{
    return [self.xq_tableView indexPathForCell:self];
}

@end



@implementation UITableView (tableViewCell)


/**
 根据cell 的类名 自动获取cell的实例

 @param cellClass cell 的类名
 @return UITableViewCell 的实例
 */
- (UITableViewCell *)dequeueReusableCellWithCellClass:(NSString *)cellClass
{
    NSAssert(cellClass.length != 0, @"cellClass 不能为长度必须大于0");
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellClass];
    if (cell == nil)
    {
        if ([[NSBundle mainBundle] pathForResource:cellClass ofType:@"xib"]) {
            UINib *nib  = [UINib nibWithNibName:cellClass bundle:[NSBundle mainBundle]];
            if (nib) {
                [self registerNib:nib forCellReuseIdentifier:cellClass];
                cell = [self dequeueReusableCellWithIdentifier:cellClass];
            }
        }else
        {
            cell = [[NSClassFromString(cellClass) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClass];
        }
    }
    return cell;
}
@end

