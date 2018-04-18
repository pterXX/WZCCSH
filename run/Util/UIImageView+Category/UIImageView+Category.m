//
//  UIImageView+Category.m
//  city
//
//  Created by asdasd on 2017/10/17.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "UIImageView+Category.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Category)
- (void)sj_setShowImgaeWithUrl:(NSURL *)url placeholder:(UIImage *)placeholder{
    self.backgroundColor = [UIColor hexString:@"eeeeee"];
    // 配置用户头像的的图片，以下操作是让图片0-1的渐现的动画
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            weakSelf.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
                weakSelf.alpha = 1.0;
            }];
        }
        else
        {
            weakSelf.alpha = 1.0;
        }

    }];
}

@end
