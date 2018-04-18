//
//  RunOrderTableViewCell.h
//  city
//
//  Created by 3158 on 2018/2/24.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQTableViewCell.h"
#import "RunOrderListModel.h"
@interface RunOrderTableViewCell : XQTableViewCell

@property (nonatomic ,strong) RunOrderListModel *model;

//  刷新列表
@property (nonatomic ,copy) void (^refreshTableViewBlock)(void);
@end
