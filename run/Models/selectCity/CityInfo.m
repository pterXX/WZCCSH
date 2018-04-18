//
//  CityInfo.m
//  CityLife
//
//  Created by asdasd on 2017/5/8.
//  Copyright © 2017年 XQS. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo


+ (void)setCityKey:(NSString *)key object:(id)object{
    if (object) {
        [US_DEFAULTS setObject:object forKey:key];
    }
}

+ (void)removeCityKey
{
     [US_DEFAULTS removeObjectForKey:KEY_CITY_INFO];
}


+ (NSString *)objctForKey:(NSString *)key
{
    NSDictionary *dict = [US_DEFAULTS objectForKey:KEY_CITY_INFO];
    if (dict.count >0 && dict) {
         return  [dict objectForKey:key];
    }
    return nil;
}

+ (NSString *)CityInfo
{
    return [US_DEFAULTS objectForKey:KEY_CITY_INFO];
}

+ (void)setCItyInfo:(NSDictionary *)info
{
     [self setCityKey:KEY_CITY_INFO object:info];
     [US_DEFAULTS synchronize];
}

+ (NSString *)CityName{
    
    NSString *cityName = [self objctForKey:@"cityname"];
    
    NSString *name = nil;
    if ([cityName hasSuffix:@"省"]) {
        name = @"省";
    }
    if ([cityName hasSuffix:@"市"]) {
        name = @"市";
    }
    else if ([cityName hasSuffix:@"区"])
    {
        name = @"区";
    }
    else if ([cityName hasSuffix:@"县"])
    {
        name = @"县";
    }

    
    NSString *city = nil;
    if (name) {
        city =  [cityName substringToIndex:cityName.length - 1];
    }else{
        city = cityName;
    }
    
    if ([city hasSuffix:@"自治"]) {
        city =  [city substringToIndex:cityName.length - 2];
    }else if ([city hasSuffix:@"特别行政"])
    {
        city =  [city substringToIndex:cityName.length - 4];
    }


    return  city;
}

+ (NSString *)CityAPP_ID
{
     return  [self objctForKey:@"app_id"];
}

+ (NSString *)CityIs_Open
{
    return  [self objctForKey:@"isopen"];
}


@end
