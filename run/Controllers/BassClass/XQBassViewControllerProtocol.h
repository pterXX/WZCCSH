//
//  XQBassViewControllerProtocol.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XQViewModel;

@protocol XQBassViewControllerProtocol <NSObject>
@optional
-(instancetype)initWithViewModel:(id<XQViewProtocol>)viewModel;

#pragma mark - RAC

/**
 添加控件
 */
- (void)xq_addSubViews;

/**
 绑定
 */
- (void)xq_bindViewModel;

/**
 设置Navigation
 */
- (void)xq_layoutNavigation;

/**
 初次获得数据
 */
- (void)xq_getNewData;
@end
