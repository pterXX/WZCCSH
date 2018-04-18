//
//  MessageBox.h
//  sjt
//
//  Created by sjw-mac on 15/4/17.
//  Copyright (c) 2015年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^alert_block_t)(NSInteger index);

@interface MessageBox : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message block:(alert_block_t)block;

+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message otherTitle:(NSString *)otherTitle block:(alert_block_t)block;

+ (void)showSheetWithTitle:(NSString *)title message:(NSString *)message item:(NSArray *)itemArr block:(alert_block_t)block;
@end
