//
//  NSString+Encryption.h
//  city
//
//  Created by 3158 on 2017/9/8.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - 加密
@interface NSString (Encryption)
/**
 MD5  加密
 
 @return 返回一个加密后的字符串
 */
- (NSString *)md5;



/**
 将普通字符串编码晨base64的字符串
 
 @return 编码后的base64字符串
 */
- (NSString*)encodeBase64;


/**
 将base64字符串解码成普通字符串
 
 @return 解码后的普通字符串
 */
- (NSString*)decodeBase64;


/**
 将data 编码成base字符串
 
 @param data 当前需要编码的字符串
 @return 编码后的base字符串
 */
+ (NSString*)encodeBase64Data:(NSData *)data;

/**
 将data解码为字符串
 
 @param data 当前需要解码的data
 @return 解码后的字符串
 */
+ (NSString*)decodeBase64Data:(NSData *)data;


/**
 * Creates a SHA1 (hash) representation of NSString.
 *
 * @return NSString
 */
- (NSString *)sha1;
@end






#pragma mark - 路径
@interface NSString (Path)

/** 文档目录 */
+ (NSString *)documentPath;
/** 缓存目录 */
+ (NSString *)cachePath;
/** 临时目录 */
+ (NSString *)tempPath;

/**
 *  添加文档路径
 */
- (NSString *)appendDocumentPath;
/**
 *  添加缓存路径
 */
- (NSString *)appendCachePath;
/**
 *  添加临时路径
 */
- (NSString *)appendTempPath;

@end






#pragma mark - 时间
@interface NSString (TimeString)
//利用时间戳计算一个时间点到现在的时间差
- (NSString *)intervalSinceNow: (NSString *) theDate;

/*! 转换时间戳 */
+ (NSString *)TimeStamp:(NSString *)strTime;
/*! 转换时间戳 */
+ (NSString *)timeStamp:(NSString *)strTime format:(NSString *)formatStr;

@end






#pragma mark - 二维码
@interface NSString (QRCode)


/**
 * 返回当前字符串对应的二维码图像
 *
 * 二维码的实现是将字符串传递给滤镜，滤镜直接转换生成二维码图片
 */
- (UIImage *)createRRcode;
@end




#pragma mark - 其他
@interface NSString (Other)
/**
 改变字符串的中的字符的样式

 @param string 当前需要改变的字符
 @param subFontColor 字体颜色
 @param font 字体大小
 @return 富文本
 */
- (NSMutableAttributedString *)changeString:(NSString *)string   subFontColor:(UIColor *)subFontColor subFont:(UIFont *)font;


/**
 用星号替换字符串
 
 @param startLocation 开始位置
 @param lenght 长度
 @return 字符串
 */
- (NSString *)replaceStringWithAsteriskStartLocation:(NSInteger)startLocation lenght:(NSInteger)lenght;

- (CGFloat )sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;


/*
* 设置行间距和字间距
*
*  @param lineSpace 行间距
*  @param kern      字间距
*
*  @return 富文本
*/
- (NSMutableAttributedString*)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;

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
- (CGSize)getAttributionHeightWithString:(NSString *)string lineSpace:(CGFloat)lineSpace font:(UIFont *)font width:(CGFloat)width;
@end


