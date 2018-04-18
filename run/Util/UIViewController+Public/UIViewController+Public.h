//
//  UIViewController+Public.h
//  proj
//
//  Created by asdasd on 2017/12/10.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Public)
@property (nonatomic ,strong,readonly) UIActivityIndicatorView *xq_activityIndicatorView;
@property (nonatomic ,assign,readonly) BOOL xq_isAnimating;


/**
 活动指示器开始动画

 @param isHideSubViews 是否隐藏子视图，只有第一次加载的时候才会隐藏所有子视图
 */
- (void)xq_startAnimatingWithIsHideSubViews:(BOOL)isHideSubViews;


/**
 停止动画，并显示全部子视图
 */
- (void)xq_stopAnimating;
@end
