//
//  ImagePickerCollectionImagePicker.h
//  city
//
//  Created by asdasd on 2017/10/16.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Xq_ImagePickerCollectionImagePicker : NSObject



#pragma 选择照片的方法
/**
 图片选择器选择图片

 @param maxImagesCount 最大可选择的图片数量
 @param didSelectedAssest 已选中的图片
 @param block 成功后的回调参数
 */
+(void)Xq_ImagePickerControllerWithMaxImagesCount:(NSInteger)maxImagesCount didSelectedAssest:(NSArray *)didSelectedAssest successBlock:(void(^)(NSArray<UIImage *> *photos, NSArray *assets,NSArray<NSString *> *imageSrcs))block;

/**
 上传图片
 @param imageArray 需要上传的图片
 @param block 成功后的回调
 */
+(void)uploadImageArrs:(NSArray<UIImage *> *)imageArray withSuccessBlock:(void(^)(NSArray <NSString *> *imgSrcs , NSArray<UIImage *> *imageArray))block;
@end


//   把单例方法定义为宏，使用起来更方便
#define ZXUPLOAD_IMAGE [ZXUploadImage shareUploadImage]
@interface ZXUploadImage : NSObject < UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic,copy) void (^imagePickerCallbackBlock)(UIImage *image);

//单例方法
+ (ZXUploadImage *)shareUploadImage;

@end
