//
//  XQViewPtotocol.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSUInteger {
 XQHeaderRefresh_HasMoreData = 1,
 XQHeaderRefresh_HasNoMoreData,
 XQFooterRefresh_HasMoreData,
 XQFooterRefresh_HasNoMoreData,
 XQHeaderRefresh_HasLoadingData,
 XQRefreshNoIsWork,  //  没有开工的状态
 XQRefreshNoIsCheck, //   审核状态
 XQRefreshError,
 XQRefteshUI
} XQRefreshDataStatus;

@protocol XQViewModelProtocol;

@protocol XQViewProtocol<NSObject>
@optional
- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel;

- (void)xq_bindViewModel;

- (void)xq_setupViews;

- (void)xq_addRecturnKeyBoard;
@end
