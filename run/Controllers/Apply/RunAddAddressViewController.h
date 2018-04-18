//
//  RunAddAddressViewController.h
//  city
//
//  Created by 3158 on 2018/2/7.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "XQBassViewController.h"

FOUNDATION_EXTERN NSString *const R_ADDRESS; //  地址
FOUNDATION_EXTERN NSString *const R_LATITUDE; //  经度
FOUNDATION_EXTERN NSString *const R_LONGITUDE; //  纬度
FOUNDATION_EXTERN NSString *const R_FLOOR; //  楼层
FOUNDATION_EXTERN NSString *const R_TEL; //  电话
FOUNDATION_EXTERN NSString *const R_CONSIGNEE; //   姓名
FOUNDATION_EXTERN NSString *const R_ID;  //  id
FOUNDATION_EXTERN NSString *const R_CITY;
FOUNDATION_EXTERN NSString *const R_DETAILNAME;

@interface RunAddAddressViewController : XQBassViewController
@property (nonatomic ,strong) NSString *latitude;
@property (nonatomic ,strong) NSString *longitude;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *detailedAddress;
@property (nonatomic ,strong) NSString *runAddress;
@property (nonatomic ,strong) NSMutableDictionary<NSString *,NSString *> *dict;

//  是否是发货人
@property (nonatomic ,assign) BOOL isConsignor;

@property (nonatomic ,copy) void (^callBackBlck)(NSDictionary *dict);
@end
