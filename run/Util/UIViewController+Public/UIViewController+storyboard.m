//
//  UIViewController+storyboard.m
//  proj
//
//  Created by asdasd on 2017/12/13.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIViewController+storyboard.h"

@implementation UIViewController (storyboard)


/**
 根据storyboard 获取指定viewCotroller

 @param name storyboard 名称
 @param Identifier 标识
 @return 视图控制器
 */
+ (instancetype)storyboardName:( NSString * _Nonnull  )name Identifier:(NSString * _Nonnull)Identifier
{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard
    *story = [UIStoryboard storyboardWithName:name bundle:[NSBundle
                                                           mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    UIViewController
    *myView = [story instantiateViewControllerWithIdentifier:Identifier];
    return myView;
}

+ (instancetype)viewControllerWithStoryBoardName:( NSString * _Nonnull )name{
    NSAssert(name.length != 0, @"如果崩溃在这里证明 name 是长度0 ");
    UIViewController *vc =  [self storyboardName:name Identifier:NSStringFromClass(self)];
    return vc;

}
@end
