//
//  NSObject+Property.h
//  RuntimeDemo
//
//  Created by LeeJay on 16/8/9.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import <Foundation/Foundation.h>

@protocol KeyValue <NSObject>

@optional
/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)objectClassInArray;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)replacedKeyFromPropertyName;

@end

@interface NSObject (Property) <KeyValue>

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;


///  对象转字典
- (id)dictWithObject;

/// 获取对象的所有属性
- (NSArray *)getAllProperties;

- (NSString *)modelConverDescriptionStr;


/// model 转JSONString
- (NSString *)modelConverJSONString;
@end


@interface NSArray(Property)
///  JSONString  转数组
+ (NSArray *)arrayToJsonString:(NSString *)jsonString;
@end


@interface NSDictionary(Property)
///  JSONString 转字典
+ (NSDictionary *)dictionaryToJsonString:(NSString *)jsonString;
@end

@interface NSString (Property)
///  数组转JSONString
+ (NSString *)arrayToJSONString:(NSArray *)array;
///  字典转JSONString
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dict;
@end
