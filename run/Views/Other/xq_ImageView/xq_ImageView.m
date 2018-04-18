//
//  xq_ImageView.m
//  proj
//
//  Created by asdasd on 2018/1/10.
//  Copyright © 2018年 asdasd. All rights reserved.
//

#import "xq_ImageView.h"


#define XQIMG xq_ImageView


@interface xq_ImageView()

@property (nonatomic ,strong) id didSelectedAssest;

@end


@implementation xq_ImageView

#pragma mark Cache
static UIColor* _bgColor = nil;
static UIColor* _addColor = nil;
static UIColor* _textColor = nil;
static UIImage *_photo_icon = nil;

#pragma mark Initialization
+ (void)initialize
{
    // Colors Initialization
    _bgColor = [UIColor colorWithRed: 0.941 green: 0.941 blue: 0.969 alpha: 1];
    _addColor = [UIColor colorWithRed: 0.737 green: 0.737 blue: 0.769 alpha: 1];
    _textColor = [UIColor colorWithRed: 0.737 green: 0.737 blue: 0.769 alpha: 1];
    _photo_icon = [UIImage imageNamed:@"photo_icon_20"];
}

#pragma mark Colors
+ (UIColor*)bgColor { return _bgColor; }
+ (UIColor*)addColor { return _addColor; }
+ (UIColor*)textColor { return _textColor; }

#pragma mark Images
+ (UIImage *)photo_icon { return _photo_icon; }


- (void)layoutImage{
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}


- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholder
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.0), ^{

        // 获得Caches文件夹
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        // 获得文件名
        NSString *filename = [url lastPathComponent];
        // 获取文件全路径
        NSString *file = [cachesPath stringByAppendingPathComponent:filename];
        // 加载沙盒的文件数据
        NSData *data = [NSData dataWithContentsOfFile:file];
        if (data) {// 直接利用沙盒中图片
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                self.imageSrc =  url.absoluteString;
                [self layoutImage];
            });
        }else {// 没有的话就下载图片
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            [imageData writeToFile:file atomically:NO];
            UIImage *dataImage = [UIImage imageWithData:imageData];
            if (dataImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = dataImage;
                     self.imageSrc =  url.absoluteString;
                    [self layoutImage];
                });

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = placeholder;
                    [self layoutImage];
                });
            }
        }

    });
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self layoutImage];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //// Resize to Target Frame
    CGContextSaveGState(context);
    CGRect resizedFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextTranslateCTM(context, resizedFrame.origin.x, resizedFrame.origin.y);


    //// 矩形 10 Drawing
    UIBezierPath* _10Path = [UIBezierPath bezierPath];
    [_10Path moveToPoint: CGPointMake(0, 0)];
    [_10Path addLineToPoint: CGPointMake(self.width, 0)];
    [_10Path addLineToPoint: CGPointMake(self.width, self.height)];
    [_10Path addLineToPoint: CGPointMake(0, self.height)];
    [_10Path addLineToPoint: CGPointMake(0, 0)];
    [_10Path closePath];
    [XQIMG.bgColor setFill];
    [_10Path fill];


    [self.image drawInRect:rect];

    CGFloat imageSizeWidth = SJAdapter(40);
    CGFloat imageSizeHeight = SJAdapter(40);
    CGFloat imageOrginLeft =  SJAdapter(132);
    CGFloat imageOrginTop =  SJAdapter(132);

    //    //  图片
    UIBezierPath* _4Path = [UIBezierPath bezierPathWithRect: CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];
    CGContextSaveGState(context);
    [_4Path addClip];
    CGContextScaleCTM(context, 1, -1);
    // 图片
    CGContextDrawTiledImage(context, CGRectMake(imageOrginLeft, - imageOrginTop, imageSizeWidth, imageSizeHeight), XQIMG.photo_icon.CGImage);

    CGContextRestoreGState(context);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //  获取本地的图片
    __weak typeof(self) weakSelf = self;
    [Xq_ImagePickerCollectionImagePicker  Xq_ImagePickerControllerWithMaxImagesCount:1 didSelectedAssest:nil successBlock:^(NSArray<UIImage *> *photos, NSArray *assets, NSArray<NSString *> *imageSrcs) {
//        if (imageSrcs.count > 0) {
            weakSelf.image = photos.firstObject;
            weakSelf.imageSrc = imageSrcs.firstObject;
            weakSelf.didSelectedAssest = assets;
            
            if (weakSelf.Xq_ImagePickerEdit) {
                weakSelf.Xq_ImagePickerEdit(weakSelf.image,weakSelf.imageSrc);
            }
//        }
    }];
}



@end
