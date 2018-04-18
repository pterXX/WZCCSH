//
//  FileUtils.h
//  city
//
//  Created by 3158 on 2017/8/2.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject
/**
 判断文件是否存在

 @param filePath 文件路径
 @return YES 存在， NO 不存在
 */
+ (BOOL)isExists:(NSString *)filePath;


/**
 返回缓存根目录 "caches"

 @return 返回缓存根目录 "caches"
 */
+(NSString *)getCachesDirectory;


/**
 返回根目录路径 "document"

 @return 返回根目录路径 "document"
 */
+ (NSString *)getDocumentPath;


/**
 创建文件目录

 @param dirPath 文件路径
 @return 是否创建成功
 */
+(BOOL)creatDir:(NSString*)dirPath;

/**
 删除文件目录

 @param dirPath 文件目录
 @return 删除文件目录
 */
+(BOOL)deleteDir:(NSString*)dirPath;

/**
 移动文件夹

 @param srcPath 文件来源
 @param desPath 移动到某个文件路径
 @return 是否成功
 */
+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath;

/**
 创建文件

 @param filePath 文件路径
 @param data 文件的二进制数据
 @return 是否创建成功
 */
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data;

/**
 读取文件

 @param filePath 文件路径
 @return 文件的二进制数据
 */
+(NSData*)readFile:(NSString *)filePath;

/**
 删除文件

 @param filePath 文件的指定路劲
 @return 是否删除成功
 */
+(BOOL)deleteFile:(NSString *)filePath;

/**
 获取文件路劲

 @param fileName 文件名
 @return 文件名称
 */
+ (NSString *)getFilePath:(NSString *)fileName;

/**
 写入文件

 @param fileName 文件名
 @param data 文件的二进制数据
 @return 是否写入成功
 */
+ (BOOL)writeDataToFile:(NSString*)fileName data:(NSData*)data;

/**
 读取指定文件的二进制数据

 @param fileName 文件名称
 @return 文件的二进制数据
 */

+ (NSData*)readDataFromFile:(NSString*)fileName;

// 自定义删除文件功能，删除不包含名称的文件
+ (void)deleteNotContainNameOfSpecifiedFile:(NSString *)path;

@end
