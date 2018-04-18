//
//  RunOrderModel.h
//  city
//
//  Created by 3158 on 2018/2/25.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Property.h"

@interface RunOrderModel : NSObject

@property (nonatomic ,assign) NSInteger status; ///  订单状态 1待付款 2待接单 3待取货 4配送中 5已完成 6已取消
@property (nonatomic ,copy) NSString *aid;     ///  订单id
@property (nonatomic ,copy) NSString *order_id;   ///   订单编号
@property (nonatomic ,copy) NSString *start_address;   ///   起始地址
@property (nonatomic ,copy) NSString *end_address;   ///   终点地址
@property (nonatomic ,copy) NSString *remark;   ///   备注
@property (nonatomic ,copy) NSString *distance;   ///   距离
@property (nonatomic ,copy) NSString *arrive_time;   ///   要求送达时间
@property (nonatomic ,copy) NSString *income;    /// 本单收入
@property (nonatomic ,copy) NSString *start_addr;   ///    起始地址（详细）
@property (nonatomic ,copy) NSString *end_addr;     ///    终点地址（详细）
@property (nonatomic ,copy) NSString *delivery_time;    ///   预约取件时间
@property (nonatomic ,copy) NSString *delivery_dateline;    ///   预约取件时间

@property (nonatomic ,copy) NSString *start_lng;    ///   起始经度
@property (nonatomic ,copy) NSString *start_lat;    ///   起始纬度
@property (nonatomic ,copy) NSString *end_lat;    ///    终点纬度
@property (nonatomic ,copy) NSString *end_lng;    ///    终点经度

@property (nonatomic ,copy) NSString *combination;   /// 拼接类型+重量+备注

@end
