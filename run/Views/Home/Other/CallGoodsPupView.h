//
//  CallGoodsPupView.h
//  city
//
//  Created by 3158 on 2018/2/5.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CallGoodsPupView;
typedef void (^CallGoodsCallBack)(NSString *password,CallGoodsPupView *callGoodsView);
@interface CallGoodsPupView : UIView
@property (nonatomic ,strong) UILabel *title;
@property (nonatomic ,strong) NSString *password;
@property (nonatomic ,copy) CallGoodsCallBack sureBtnBlcok;
@property (nonatomic ,copy) CallGoodsCallBack cacanlBtnBlcok;

//  显示弹框
+ (void)showPasswordWithSureBlock:(CallGoodsCallBack)sureBlock
                      cecanlBlock:(CallGoodsCallBack)cecanBlock;

+ (void)dismss;
@end

@class YNTextField;

@protocol YNTextFieldDelegate <NSObject>

- (void)ynTextFieldDeleteBackward:(YNTextField *)textField;

@end


@interface YNTextField : UITextField

@property (nonatomic, assign) id <YNTextFieldDelegate> yn_delegate;

@end
