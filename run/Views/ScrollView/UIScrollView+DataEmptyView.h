//
//  UIScrollView+DataEmptyView.h
//  running man
//
//  Created by asdasd on 2018/3/30.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "UIView+Loading.h"
typedef NS_ENUM(NSUInteger, DataEmptyViewType) {
    DataEmptyViewTypeNone = 0, //  无图
    DataEmptyViewTypeNoOrderData, //  无订单数据
    DataEmptyViewTypeCheck,    //  审核状态
    DataEmptyViewTypeStarts,   //  开工
    DataEmptyViewTypeApply,   //   申请成为跑腿员
    DataEmptyViewTypeWeChat,   //  微信提现
    DataEmptyViewTypeSuccess,   // 成功
    DataEmptyViewTypeFail,   //  失败
    DataEmptyViewTypeNotMsg,   //  没有消息
    DataEmptyViewTypeNoNetwork, //  无网
    DataEmptyViewTypeLoading, //  加载中
    DataEmptyViewTypeOhter,    //   其他
};

@interface UIScrollView (DataEmptyView) <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>


@property (nonatomic ,assign) BOOL isShowDataEmpty;
@property (nonatomic ,assign) DataEmptyViewType emptyViewType;
- (void)setIsShowDataEmpty:(BOOL)isShowDataEmpty emptyViewType:(DataEmptyViewType)emptyViewTyp;

@property (nonatomic ,strong) UIImage *emptyImg;
@property (nonatomic ,strong) UIImage *btnImg;
@property (nonatomic ,strong) NSMutableAttributedString *titleText;
@property (nonatomic ,strong) NSMutableAttributedString *descriptionText;
@property (nonatomic ,strong) NSMutableAttributedString *buttonTitle;
@property (nonatomic ,assign) CGFloat verticalOffset;
@property (nonatomic ,strong) UIView *customView;

//  当视图上有按钮时才能被点击
@property (nonatomic ,copy) void (^dataEmptyBtnTapedBlock)(void);

/**
 等待开工的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeStartsCustomView;

/**
 申请成为跑腿员自定义视图
 */
- (UIView *)dataEmptyViewTypeApplyCustomView;


/**
 微信提现的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeWeChatCustomView;

/**
 微信提现的图片自定义视图
 */
- (UIView *)dataEmptyViewTypeNoNotworkView;

/**
 加载动画的自定义视图
 */
- (UIView *)dataEmptyViewTypeLoadingView;

///  停止加载动画  这个只有存在加载动画的时候才有效
- (void)stopLoadingAnimation;

- (NSMutableAttributedString *)attributedStringWithString:(NSString *)str;

- (NSMutableAttributedString *)buttonAttributedStringWithString:(NSString *)str;

- (NSMutableAttributedString *)titleAttributedStringWithString:(NSString *)str;
@end
