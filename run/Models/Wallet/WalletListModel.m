//
//  WalletListModel.m
//  run
//
//  Created by asdasd on 2018/4/10.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "WalletListModel.h"

@implementation WalletListModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"date":@"time",
             @"money":@"cash"};
}

@end
