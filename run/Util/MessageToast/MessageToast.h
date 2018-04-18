//
//  MessageToast.h
//  cyb
//
//  Created by sjw-mac on 15/4/21.
//  Copyright (c) 2015年 sjw-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageBox.h"
@interface MessageToast : UILabel
/*!
 *  @brief 显示提示信息的方法
 *  @param message  需要显示的信息
 */
+ (void)showMessage:(NSString *)message;


@end

@interface AlertMessage:NSObject
+ (void)showMessage:(NSString *)msg;
@end
