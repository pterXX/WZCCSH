//
//  CallAddressViewController.h
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "XQBassViewController.h"

@interface CallAddressViewController : XQBassViewController
@property (nonatomic ,strong) NSString *latitude;
@property (nonatomic ,strong) NSString *longitude;
@property (nonatomic ,strong) NSString *city;

@property (nonatomic ,copy) void (^callBackBlock)(NSString *address,NSString *latitude,NSString *longitude,NSString *name);
@end
