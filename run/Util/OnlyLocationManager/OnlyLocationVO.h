//
//  OnlyLocationVO.h
//  OnlyLocation
//
//  Created by Mr.S on 2016/12/22.
//  Copyright © 2016年 ST.MEDIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NetAndUDManager.h"

@interface OnlyLocationComponentVO : NSObject

@property (nonatomic,copy) NSString* district;
@property (nonatomic,copy) NSString* city;
@property (nonatomic,copy) NSString* country;
@property (nonatomic,copy) NSString* adcode;
@property (nonatomic,copy) NSString* street;
@property (nonatomic,copy) NSString* distance;
@property (nonatomic,copy) NSString* street_number;
@property (nonatomic,copy) NSString* country_code;
@property (nonatomic,copy) NSString* direction;
@property (nonatomic,copy) NSString* province;

@end

@interface OnlyLocationVO : NSObject

@property CLLocationCoordinate2D location;
@property NSInteger cityCode;
@property (nonatomic) NSArray * pois;
@property (nonatomic) NSArray * poiRegions;
@property (nonatomic) NSArray * business;
@property (nonatomic) NSString* sematic_description;
@property (nonatomic) NSString* formatted_address;

@property (nonatomic) OnlyLocationComponentVO * addressComponent;

+(instancetype)getLocationFromDic:(NSDictionary* )dic;
-(void)saveToUD;
+(instancetype)getLastLocation;
+(void)removeLastLocation;

@end
