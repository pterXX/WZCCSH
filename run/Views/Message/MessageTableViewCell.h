//
//  MessageTableViewCell.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQTableViewCell.h"
#import <YYText.h>
#import "MessageModel.h"
@interface MessageTableViewCell : XQTableViewCell
@property (nonatomic ,strong) YYLabel *titleLabel;
@property (nonatomic ,strong) YYLabel *timeLabel;
@property (nonatomic ,strong) YYLabel *mesgLabel;
@property (nonatomic ,strong) UIView  *redPoint;

@property (nonatomic ,strong)  MessageModel *model;
@end
