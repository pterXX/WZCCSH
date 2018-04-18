//
//  UIImageView+Category.h
//  city
//
//  Created by asdasd on 2017/10/17.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)
// 以下操作是让图片0-1的渐现的动画 
- (void)sj_setShowImgaeWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder;
@end
