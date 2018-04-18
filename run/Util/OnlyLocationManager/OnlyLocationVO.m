//
//  OnlyLocationVO.m
//  OnlyLocation
//
//  Created by Mr.S on 2016/12/22.
//  Copyright © 2016年 ST.MEDIA. All rights reserved.
//

#import "OnlyLocationVO.h"
#define UD_LastLocation @"ud_lastlocation"

@interface OnlyLocationVO ()

@end

@implementation OnlyLocationVO

#pragma mark Class Method
+(instancetype)getLastLocation
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* locationDic = [ud objectForKey:UD_LastLocation];
    return [self getLocationFromDic:locationDic];
}

+(void)removeLastLocation
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:UD_LastLocation];
    [ud synchronize];
}

+(instancetype)getLocationFromDic:(NSDictionary* )dic
{
    NSLog(@"getLocationFromDic: %@",dic);
    OnlyLocationVO* locationVO = [[OnlyLocationVO alloc]init];
    [locationVO setValuesForKeysWithDictionary:dic];
    return locationVO;
}

#pragma mark Object Method
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.addressComponent = [[OnlyLocationComponentVO alloc]init];
    }
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"location"]) {
        self.location = CLLocationCoordinate2DMake([value[@"lat"] doubleValue], [value[@"lng"] doubleValue]);
    }else if ([key isEqualToString:@"addressComponent"]) {
        [self.addressComponent setValuesForKeysWithDictionary:value];
    }else
    {
        [super setValue:value forKey:key];
    }
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)saveToUD
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[self toDic] forKey:UD_LastLocation];
    [ud synchronize];
}

-(NSDictionary* )toDic
{
    return [NetAndUDManager getObjectData:self];
}

- (NSString *)description
{
    return [self modelConverDescriptionStr];
}
@end

#pragma mark OnlyLocationComponentVO
@implementation OnlyLocationComponentVO

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
