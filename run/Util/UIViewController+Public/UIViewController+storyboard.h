//
//  UIViewController+storyboard.h
//  proj
//
//  Created by asdasd on 2017/12/13.
//  Copyright © 2017年 asdasd. All rights reserved.
//



#define KSIsEixts(name) [[NSBundle mainBundle] pathForResource:name ofType:@"storyboard"] ? YES:NO
#define KSMain @"Main"
#define KSStoryboard @"Storyboard"

NS_ASSUME_NONNULL_BEGIN
@interface UIViewController (storyboard)

/**
 根据storyboard 获取指定viewCotroller

 @param name storyboard 名称
 @param Identifier 标识
 @return 视图控制器
 */
+ (instancetype)storyboardName:( NSString * _Nonnull)name Identifier:(NSString * _Nonnull)Identifier;

+ (instancetype)viewControllerWithStoryBoardName:( NSString * _Nonnull )name;
@end
NS_ASSUME_NONNULL_END
