//
//  ImagePickerCollectionView.h
//  city
//
//  Created by asdasd on 2017/10/13.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Xq_ImagePickerCollectionViewCell.h"
#import "Xq_ImagePickerCollectionImagePicker.h"
@interface Xq_ImagePickerCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong ,readonly) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic ,strong) NSMutableArray<UIImage *> *ImgDataSource; //  图片的数组
@property (nonatomic ,strong) NSMutableArray<NSString *> *ImgSrcDataSource; //  图片的链接数组
@property (nonatomic ,assign) NSInteger subItemCount;

//  判断是不是必填项
@property (nonatomic ,assign) BOOL isMandatory;
//  输入框的回调字段，用于一次性获取全部参数
@property (nonatomic ,strong) NSString *callbackField;

//  cell增删改后回调
@property (nonatomic ,copy) void(^Xq_ImagePickerEdit)(NSMutableArray<UIImage *> *ImgDataSource,NSMutableArray<NSString *> *ImgSrcDataSource);

//  更新个数
@property (nonatomic,copy) void(^Xq_imagePickerUpdateCount)(NSInteger itemCount);


+ (instancetype)collectionViewWIthFrame:(CGRect)frame maxItemCount:(NSInteger)itemCount;
@end



@interface Xq_ImagePickerCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
