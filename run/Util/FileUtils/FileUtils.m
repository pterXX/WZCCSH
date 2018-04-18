//
//  FileUtils.m
//  city
//
//  Created by 3158 on 2017/8/2.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

/**
 判断文件是否存在

 @param filePath 文件路径
 @return YES 存在， NO 不存在
 */
+ (BOOL)isExists:(NSString *)filePath{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}


/**
 返回缓存根目录 "caches"

 @return 返回缓存根目录 "caches"
 */
+(NSString *)getCachesDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = [paths firstObject];
    return caches;
}


/**
 返回根目录路径 "document"

 @return 返回根目录路径 "document"
 */
+ (NSString *)getDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    return documentPath;
}


/**
 创建文件目录

 @param dirPath 文件路径
 @return 是否创建成功
 */
+(BOOL)creatDir:(NSString*)dirPath{
    if ([self isExists:dirPath])//判断dirPath路径文件夹是否已存在，此处dirPath为需要新建的文件夹的绝对路径
    {
        return NO;
    }
    else
    {
        return  [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    }
}


/**
 删除文件目录

 @param dirPath 文件目录
 @return 删除文件目录
 */
+(BOOL)deleteDir:(NSString*)dirPath{
    if([self isExists:dirPath])//如果存在临时文件的配置文件
    {
        NSError *error=nil;
        return [[NSFileManager defaultManager]  removeItemAtPath:dirPath error:&error];
    }

    return  NO;
}

/**
 移动文件夹

 @param srcPath 文件来源
 @param desPath 移动到某个文件路径
 @return 是否成功
 */
+(BOOL)moveDir:(NSString*)srcPath to:(NSString*)desPath{
    NSError *error=nil;
    if([[NSFileManager defaultManager] moveItemAtPath:srcPath toPath:desPath error:&error]!=YES)// prePath 为原路径、     cenPath 为目标路径
    {
        NSLog(@"移动文件失败");
        return NO;
    }
    else
    {
        NSLog(@"移动文件成功");
        return YES;
    }
}

/**
 创建文件

 @param filePath 文件路径
 @param data 文件的二进制数据
 @return 是否创建成功
 */
+ (BOOL)creatFile:(NSString*)filePath withData:(NSData*)data{
    return  [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}



/**
 读取文件

 @param filePath 文件路径
 @return 文件的二进制数据
 */
+(NSData*)readFile:(NSString *)filePath{
    return [NSData dataWithContentsOfFile:filePath options:0 error:NULL];
}

/**
 删除文件

 @param filePath 文件的指定路劲
 @return 是否删除成功
 */
+(BOOL)deleteFile:(NSString *)filePath{
    return [self deleteDir:filePath];
}


/**
 获取文件路劲

 @param fileName 文件名
 @return 文件名称
 */
+ (NSString *)getFilePath:(NSString *)fileName{
    NSString *dirPath = [[self getDocumentPath] stringByAppendingPathComponent:fileName];
    return dirPath;
}



/**
 写入文件

 @param fileName 文件名
 @param data 文件的二进制数据
 @return 是否写入成功
 */
+ (BOOL)writeDataToFile:(NSString*)fileName data:(NSData*)data{
    NSString *filePath=[self getFilePath:fileName];
    return [self creatFile:filePath withData:data];
}


/**
 读取指定文件的二进制数据

 @param fileName 文件名称
 @return 文件的二进制数据
 */
+ (NSData*)readDataFromFile:(NSString*)fileName{
    NSString *filePath=[self getFilePath:fileName];
    return [self readFile:filePath];
}




// 自定义删除文件功能，删除不包含名称的文件
+ (void)deleteNotContainNameOfSpecifiedFile:(NSString *)path{
    // 1.判断文件还是目录
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        // 2. 判断是不是目录
        if (isDir) {
            NSArray * dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString * subPath = nil;
            for (NSString * str in dirArray) {
                subPath  = [path stringByAppendingPathComponent:str];
                BOOL issubDir = NO;
                [fileManger fileExistsAtPath:subPath isDirectory:&issubDir];
                [self deleteNotContainNameOfSpecifiedFile:subPath];
            }
        }else{

            if ([path containsString:@"bbs_"] == NO) {
                //  删除所有非 bbs 的文件
                [self deleteFile:path];
            }
            NSLog(@"%@",path);
        }
    }else{
        NSLog(@"你打印的是目录或者不存在");
    }
}
@end
