//
//  XQViewModelProtocol.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XQRequestErrorCode) {
    XQRequestErrorCode_UnknownError,
    XQRequestErrorCode_LoginError,
    XQRequestErrorCode_FailedError,
};


@protocol XQViewModelProtocol <NSObject>
@optional
- (instancetype)initWithModel:(id)model;
@property (strong ,nonatomic) MLHTTPRequest *request;


/**
 初始化
 */
- (void)xq_initialize;
@end
