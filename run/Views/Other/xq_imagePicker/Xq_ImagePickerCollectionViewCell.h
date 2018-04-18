//
//  ImagePickerCollectionViewCell.h
//  city
//
//  Created by asdasd on 2017/10/13.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "xq_CloseButton.h"
@interface Xq_ImagePickerCollectionViewCell : UICollectionViewCell
    
@property  (nonatomic ,strong) UIImageView *imageView; //  图片
@property  (nonatomic ,strong) xq_CloseButton *closeButton; //  是否按钮
@property  (nonatomic ,assign) BOOL isDel; //  是否删除
@property  (nonatomic ,assign) NSInteger index;
@property  (nonatomic ,copy) void(^deleteCurrentCell)(NSInteger index);


#pragma mark Sizes
+ (CGFloat)cell_fixedWidth;

+ (CGFloat)cell_fixedHeight;

+ (CGFloat)cell_minimumLineSpacing;

@end
