//
//  ImagePickerCollectionImagePicker.m
//  city
//
//  Created by asdasd on 2017/10/16.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "Xq_ImagePickerCollectionImagePicker.h"
#import "TZImagePickerController.h"


@implementation Xq_ImagePickerCollectionImagePicker

#pragma 拍照选择照片协议方法

/**
 图片选择器选择图片

 @param block 成功后的回调参数
 */
+(void)Xq_ImagePickerControllerWithMaxImagesCount:(NSInteger)maxImagesCount didSelectedAssest:(NSArray *)didSelectedAssest successBlock:(void(^)(NSArray<UIImage *> *photos, NSArray *assets,NSArray<NSString *> *imageSrcs))block{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    
    imagePickerVc.navigationBar.barStyle = UIBarStyleBlack;
    imagePickerVc.navigationBar.translucent = YES;
    
   
//    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;

    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.maxImagesCount = maxImagesCount;
    imagePickerVc.selectedAssets = didSelectedAssest;
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
//    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = YES;
    imagePickerVc.circleCropRadius = 100;

#pragma mark - 到这里为止

    __block TZImagePickerController *picker = imagePickerVc;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [picker hideProgressHUD];
        NSMutableArray *array = [NSMutableArray array];
        [self uploadImageArrs:photos withSuccessBlock:^(NSArray<NSString *> *imgSrcs, NSArray<UIImage *> *imageArray) {
            block(imageArray,assets,imgSrcs);
        } progressBlock:^(UIImage *image) {
            [array addObject:image];
            block(array,assets,[NSMutableArray arrayWithCapacity:array.count]);
        }];
    }];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - 图片回传协议方法
/**
 上传图片
 @param imageArray 需要上传的图片
 @param block 成功后的回调
 @param progressBlock 当前已完成图片的回调 ，这个方法会执行多次
 */
+(void)uploadImageArrs:(NSArray<UIImage *> *)imageArray withSuccessBlock:(void(^)(NSArray <NSString *> *imgSrcs , NSArray<UIImage *> *imageArray))block progressBlock:(void (^)(UIImage *image))progressBlock{

//    NSString *fileType = @"image/jpg";
//    NSData *data = UIImageJPEGRepresentation(image,0.5);
    [MBProgressHUD showHUDAddedTo:[self activityViewController].view animated:YES];
    [MLHTTPRequest uploadImageArray:imageArray progress:^(NSProgress *progress, UIImage *image) {
        //  当前这张图片上传完成
        if (progress.totalUnitCount -  progress.completedUnitCount == 0) {
            if (progressBlock) {
                progressBlock(image);
            }
        }
        MLLog(@"第%@张图片,上传进度 %@/%@",@([imageArray indexOfObject:image]),@(progress.completedUnitCount),@(progress.totalUnitCount));
    } success:^(NSArray *urls, NSArray *imgs) {
        [MBProgressHUD hideAllHUDsForView:[self activityViewController].view animated:YES];
        block(urls,imgs);
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[self activityViewController].view animated:YES];
        ML_MESSAGE_NETWORKING;
    }];
}

// 获取当前处于activity状态的view controller
+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }

    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];

        id nextResponder = [frontView nextResponder];

        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }

    return activityViewController;
}

@end


static ZXUploadImage *zxUploadImage = nil;
@implementation ZXUploadImage
+ (ZXUploadImage *)shareUploadImage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zxUploadImage = [[ZXUploadImage alloc] init];
    });
    return zxUploadImage;
}

#pragma mark - 头像(相机和从相册中选择)
- (void)createPhotoView {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
        imagePC.sourceType                = UIImagePickerControllerSourceTypeCamera;
        imagePC.delegate                  = self;
        imagePC.allowsEditing             = YES;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePC
                                            animated:YES
                                          completion:^{
                                          }];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备没有照相机" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"去确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }]];
        [[UIApplication sharedApplication].keyWindow.rootViewController.parentViewController presentViewController:alert animated:YES completion:nil];
    }
}

//图片库方法(从手机的图片库中查找图片)
- (void)fromPhotos {
    UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
    imagePC.sourceType                = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePC.delegate                  = self;
    imagePC.allowsEditing             = YES;
    [[UIApplication sharedApplication].keyWindow.rootViewController.parentViewController presentViewController:imagePC
                                        animated:YES
                                      completion:^{
                                      }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{

    }];

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.imagePickerCallbackBlock) {
        self.imagePickerCallbackBlock(image);
    }
}

@end
