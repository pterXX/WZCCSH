//
//  CustomTabBarViewController.h
//  proj
//
//  Created by asdasd on 2017/9/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarViewController : UITabBarController
+ (id)tabbarItem:(UIImage *)itemImg selectImg:(UIImage *)selectImg vcClass:(Class)vcClass title:(NSString *)title;
@end
