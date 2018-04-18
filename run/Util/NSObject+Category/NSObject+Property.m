//
//  NSObject+Property.m
//  RuntimeDemo
//
//  Created by LeeJay on 16/8/9.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    id obj = [[self alloc] init];

    // 获取所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);

    for (unsigned int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];

        // 取出的成员变量，去掉下划线
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];

        //        NSLog(@"[dictionary allKeys] %@ key  %@",[dictionary allKeys],key);
        id value = nil;
        //        if ([[dictionary allKeys] containsObject:key]) {
        value = dictionary[key];
        //        }

        // 当这个值为空时，判断一下是否执行了replacedKeyFromPropertyName协议，如果执行了替换原来的key查值
        if (!value)
        {
            if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)])
            {
                NSString *replaceKey = [self replacedKeyFromPropertyName][key];
                value = dictionary[replaceKey];
            }
        }

        // 字典嵌套字典
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);

            if (modelClass)
            {
                value = [modelClass objectWithDictionary:value];
            }
        }

        // 字典嵌套数组
        if ([value isKindOfClass:[NSArray class]])
        {
            if ([self respondsToSelector:@selector(objectClassInArray)])
            {
                NSMutableArray *models = [NSMutableArray array];

                id type = [self objectClassInArray][key];
                if (type) {
                    //  判断是否是字符串
                    Class classModel = [type isKindOfClass:[NSString class]]?NSClassFromString(type):type;
                    if (classModel) {
                        for (NSDictionary *dict in value)
                        {
                            id model = [classModel objectWithDictionary:dict];
                            [models addObject:model];
                        }
                    }

                    value = models;
                }
            }
        }

        if (value)
        {
            [obj setValue:value forKey:key];
        }
    }

    // 释放ivars
    free(ivars);

    return obj;
}

//  对象转字典
- (id)dictWithObject
{
    NSMutableDictionary  *obj = [NSMutableDictionary dictionary];

    // 获取所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList([self class], &count);

    for (unsigned int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];

        // 取出的成员变量，去掉下划线
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];
        id value = nil;
        {
            value = [self valueForKeyPath:key];
            NSLog(@"%@ = %@",key,value);
        }

        //        // 当这个值为空时，判断一下是否执行了replacedKeyFromPropertyName协议，如果执行了替换原来的key查值
        if ([[self class] respondsToSelector:@selector(replacedKeyFromPropertyName)])
        {
            BOOL isContains = [[[[self class]replacedKeyFromPropertyName] allKeys] containsObject:key];
            if (isContains) {
                //  查找原来的key
                key = [[self class]replacedKeyFromPropertyName][key];
            }
        }

        // 嵌套数组
        if ([value isKindOfClass:[NSArray class]])
        {
            if ([self respondsToSelector:@selector(objectClassInArray)])
            {
                NSMutableArray *models = [NSMutableArray array];
                NSString *type = [[self class]objectClassInArray][key];
                if (type) {
                    for (id object in value)
                    {
                        id model = [object dictWithObject];
                        [models addObject:model];
                    }
                    value = models.copy;
                }
            }
        }


        // 判断是自己定义的类还是系统类
        if ([NSBundle bundleForClass:[value class]] == NO)
        {
            value = [value dictWithObject];
        }

        if (value)
        {
            [obj setValue:value forKey:key];
        }else{
            [obj setValue:@"" forKey:key];
        }
    }
    // 释放ivars
    free(ivars);
    return obj.copy;
}


//获取对象的所有属性
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSString *)modelConverDescriptionStr
{
    //声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    NSArray *array = [self getAllProperties];
    int count = (int)array.count;
    //循环并用KVC得到每个属性的值
    for (int i = 0; i< count; i++)
    {
        NSString *name = array[i];
        id value = [self valueForKey:name]?:@"nil";//默认值为nil字符串
        [dictionary setObject:value forKey:name];//装载到字典里
    }

    //return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
}

/// model 转JSONString
- (NSString *)modelConverJSONString{
    return [NSString dictionaryToJSONString:[self dictWithObject]];
}

@end

@implementation NSArray(Property)

+ (NSArray *)arrayToJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

@end

///  数组转JSONString
@implementation NSDictionary(Property)
+ (NSDictionary *)dictionaryToJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

@implementation NSString (Property)
///  数组转JSONString
+ (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&err];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonString;
}
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dict
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}


@end
