//
//  xq_ActionSheetView.h
//  JHTDoctor
//
//  Created by yangsq on 2017/5/23.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XQ_SHEETVIEW_BUTTONS(title,btns,block) [xq_ActionSheetView showSheetWithTitle:title buttons:btns buttonClick:^(xq_ActionSheetView *sheetView, NSInteger buttonIndex) {\
{block;}\
\
}];
@interface xq_ActionSheetView : UIView

@property (nonatomic, copy) void(^buttonClick)(xq_ActionSheetView *sheetView,NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title
            buttons:(NSArray <NSString *>*)buttons
        buttonClick:(void(^)(xq_ActionSheetView *sheetView,NSInteger buttonIndex))block;

- (void)showView;


+ (void)showSheetWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(xq_ActionSheetView *, NSInteger))block;
@end
