//
//  BaiDuMapViewViewController.h
//  city
//
//  Created by 3158 on 2017/9/6.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaiDuMapViewViewController : UIViewController
@property (nonatomic ,copy) NSString *addr; //  获取地址
@property (nonatomic ,copy) NSString *name; //  获取城市名称
@property (nonatomic ,copy) NSString *longitude; // 百度 经度
@property (nonatomic ,copy) NSString *latitude; //  百度 纬度
@property (nonatomic ,copy) NSString *tx_longitude; // 腾讯 经度
@property (nonatomic ,copy) NSString *tx_latitude; //  腾讯 纬度
@end
