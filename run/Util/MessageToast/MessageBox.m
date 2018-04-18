//
//  MessageBox.m
//  sjt
//
//  Created by sjw-mac on 15/4/17.
//  Copyright (c) 2015年 sjw. All rights reserved.
//

#import "MessageBox.h"

@interface MessageBox()

@property(nonatomic,strong) alert_block_t block;

@end


@implementation MessageBox

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message block:(alert_block_t)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(1);
    }]];

    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showConfirmWithTitle:(NSString *)title message:(NSString *)message otherTitle:(NSString *)otherTitle block:(alert_block_t)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        block(0);
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block(1);
    }]];

    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showSheetWithTitle:(NSString *)title message:(NSString *)message item:(NSArray *)itemArr block:(alert_block_t)block
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }]];

    for (int i = 0; i < itemArr.count ; i ++) {
        [alert addAction:[UIAlertAction actionWithTitle:itemArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(i);
        }]];
    }

    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}


@end
