//
//  CityInfo.h
//  CityLife
//
//  Created by asdasd on 2017/5/8.
//  Copyright © 2017年 XQS. All rights reserved.
//

#import <Foundation/Foundation.h>


#define US_DEFAULTS     [NSUserDefaults standardUserDefaults]


static NSString *const  KEY_CITY_INFO  = @"key.city.info";
static NSString *const  KEY_CITY_NAME  = @"key.city.name";
static NSString *const  KEY_CITY_APPID = @"key.city.appId";
static NSString *const  KEY_CITY_IS_OEPN = @"key.city.isopen";



#define City_INFO [CityInfo CityInfo]
#define CITY_NAME [CityInfo CityName]
#define APP_ID    [CityInfo CityAPP_ID]
#define City_IS_OEPN [[CityInfo CityIs_Open] isEqualToString:@"1"]

#define APP_NAME  CITY_NAME?[NSString stringWithFormat:@"%@·城市生活",CITY_NAME]:@"城市生活"

@interface CityInfo : NSObject
+ (NSString *)CityInfo;
+ (NSString *)CityName;
+ (NSString *)CityAPP_ID;
+ (NSString *)CityIs_Open;


+ (void)setCItyInfo:(NSDictionary *)info;
+ (void)removeCityKey;
@end
