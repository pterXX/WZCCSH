//
//  xq_BarButtonItem.h
//  proj
//
//  Created by asdasd on 2017/12/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xq_BarButtonItem : UIBarButtonItem
//  普通按钮
+ (instancetype)itemTitle:(NSString *)title TouchBlock:(void (^)(xq_BarButtonItem *barItem))block;

//  搜索按钮
+ (instancetype)searchBtnWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block;

//  返回按钮
+ (instancetype)backItemWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block;

//  分享按钮
+ (instancetype)shareItemWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block;

@end
