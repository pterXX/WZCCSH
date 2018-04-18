//
//  NSString+Encryption.m
//  city
//
//  Created by 3158 on 2017/9/8.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "NSString+Category.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

#define IS_NULL(x) [x isEqual:[NSNull null]]
@implementation NSString (Encryption)

/**
 MD5  加密

 @return 返回一个加密后的字符串
 */
- (NSString *)md5{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}


/**
 将普通字符串编码晨base64的字符串

 @return 编码后的base64字符串
 */
- (NSString*)encodeBase64{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


/**
 将base64字符串解码成普通字符串

 @return 解码后的普通字符串
 */
- (NSString*)decodeBase64 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}



/**
 将data 编码成base字符串

 @param data 当前需要编码的字符串
 @return 编码后的base字符串
 */
+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


/**
 将data解码为字符串

 @param data 当前需要解码的data
 @return 解码后的字符串
 */
+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}


- (NSString *)sha1
{
    // see http://www.makebetterthings.com/iphone/how-to-get-md5-and-sha1-in-objective-c-ios-sdk/
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end






@implementation NSString (Path)

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

- (NSString *)appendDocumentPath
{
    return [[NSString documentPath] stringByAppendingPathComponent:self];
}

- (NSString *)appendCachePath
{
    return [[NSString cachePath] stringByAppendingPathComponent:self];
}

- (NSString *)appendTempPath
{
    return [[NSString tempPath] stringByAppendingPathComponent:self];
}

@end






@implementation NSString (TimeString)
//利用时间戳计算一个时间点到现在的时间差
- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateStyle:NSDateFormatterMediumStyle];
    [date setTimeStyle:NSDateFormatterShortStyle];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate doubleValue]+28800];
    NSTimeInterval late=[d timeIntervalSince1970];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0+28800];
    NSTimeInterval now=[dat timeIntervalSince1970];
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (IS_NULL(theDate)||[theDate isEqualToString:@""]) {
        return @"";
    }else{
        if (cha/60<1) {
            timeString = [NSString stringWithFormat:@"%f", cha];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@秒前", timeString];
        }
        if (cha/3600<1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@分前", timeString];
        }
        if (cha/3600>1&&cha/86400<1) {
            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        }
        if (cha/86400>1)
        {
            timeString = [NSString stringWithFormat:@"%f", cha/86400];
            timeString = [timeString substringToIndex:timeString.length-7];
            timeString=[NSString stringWithFormat:@"%@天前", timeString];
            
        }
        if (cha/432000>1)
        {
            timeString = [NSString stringWithFormat:@"%@", d];
            timeString = [timeString substringToIndex:timeString.length-6];
        }
        return timeString;
        
    }
}


/*! 转换时间戳 */
+ (NSString *)TimeStamp:(NSString *)strTime{
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[dateFormatter dateFromString:strTime]];
    //输出格式为：2010-10-27 10:22:13
    //alloc后对不使用的对象别忘了release
    return currentDateStr;
}

/*! 转换时间戳 */
+ (NSString *)timeStamp:(NSString *)strTime format:(NSString *)formatStr{

    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[strTime integerValue]];
    //实例化一个NSDateFormatter对象

    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];

    //设定时间格式,这里可以设置成自己需要的格式

    [dateFormatter setDateFormat:formatStr];

    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}

@end




@implementation NSString (QRCode)
/**
 *返回当前字符串对应的二维码图像
 *二维码的实现就是将字符串传递给滤镜，滤镜直接转换生成二维码图片
 **/
- (UIImage *)createRRcode
{
    return [self createRRcodeWithSize:150];
}

- (UIImage *)createRRcodeWithSize:(CGFloat)size
{
    CIImage *outputImage = [self createQRImage];
    
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
    qrImage = [self imageBlackToTransparent:qrImage withRed:0 andGreen:0 andBlue:0];
    
    return qrImage;
}

- (CIImage *)createQRImage {
    
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 设置filter的默认值
    // 因为之前如果使用过滤镜，输入有可能会被保留，因此，在使用滤镜之前，最好恢复默认设置
    [qrFilter setDefaults];
    
    // 设置内容和纠错级别
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // 将传入的字符串转换为NSData
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //3.将NSData传递给滤镜（通过KVC的方式，设置inputMessage
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    // 返回CIImage
    return qrFilter.outputImage;
}

//因为生成的二维码是一个CIImage，我们直接转换成UIImage的话大小不好控制，所以使用下面方法返回需要大小的UIImage：
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

//因为生成的二维码是黑白的，所以还要对二维码进行颜色填充，并转换为透明背景，使用遍历图片像素来更改图片颜色，因为使用的是CGContext，速度非常快：
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


/*! 隐藏中间几位电话号码 */
+ (NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation lenght:(NSInteger)lenght{
    NSString *newStr = originalStr;
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
    
}

@end



@implementation NSString(Other)



/**
 改变字符串的中的字符的样式

 @param string 当前需要改变的字符
 @param subFontColor 字体颜色
 @param font 字体大小
 @return 富文本
 */
- (NSMutableAttributedString *)changeString:(NSString *)string   subFontColor:(UIColor *)subFontColor subFont:(UIFont *)font {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:string];
    [attrStr addAttribute:NSFontAttributeName value:font range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName value:subFontColor range:range];
    return attrStr;
}

/**
 用星号替换字符串
 
 @param startLocation 开始位置
 @param lenght 长度
 @return 字符串
 */
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation lenght:(NSInteger)lenght{
    NSString *newStr = self;
    if (self.length == 0) {
        return nil;
    }
    
    for (int i = 0; i < lenght; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
        
    }
    
    return newStr;
}



- (CGFloat )sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    NSDictionary *dic = @{NSFontAttributeName:font};  //指定字号
    /*计算宽度时要确定高度*/
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/*  
* 设置行间距和字间距
*
*  @param lineSpace 行间距
*  @param kern      字间距
*
*  @return 富文本
 */
- (NSMutableAttributedString*)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern {
    NSMutableParagraphStyle*paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= lineSpace;
    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@(kern)};
    NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:attriDict];

    return attributedString;
}

/* 
* 获取富文本的高度
*
*  @param string    文字
*  @param lineSpace 行间距
*  @param font      字体大小
*  @param width     文本宽度
*
*  @return size
 */
- (CGSize)getAttributionHeightWithString:(NSString *)string lineSpace:(CGFloat)lineSpace font:(UIFont *)font width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *dict = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:dict
                                       context:nil].size;
    return size;
}

@end

