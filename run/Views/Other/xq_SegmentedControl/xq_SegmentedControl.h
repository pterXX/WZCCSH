//
//  xq_SegmentedControl.h
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xq_SegmentedControl : UISegmentedControl


+ (instancetype)items:(NSArray *)items;


//  添加拜访记录
+ (instancetype)addVisitRecordEventValueChangedBlock:(void(^)(NSInteger index))block;

//  活动
+ (instancetype)activityEventValueChangedBlock:(void(^)(NSInteger index))block;

//  装修圈
+ (instancetype)circleEventValueChangedBlock:(void(^)(NSInteger index))block;


//  添加客户
+ (instancetype)addCustommerEventValueChangedBlock:(void(^)(NSInteger index))block;

@end
