//
//  xq_ImageView.h
//  proj
//
//  Created by asdasd on 2018/1/10.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xq_ImagePickerCollectionImagePicker.h"

IB_DESIGNABLE
@interface xq_ImageView : UIView

@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,strong) NSString *imageSrc;

//  增删改后回调
@property (nonatomic ,copy) void(^Xq_ImagePickerEdit)(UIImage *img,NSString *imageSrc);

- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)image;

//  绘制图片
- (void)layoutImage;
@end
