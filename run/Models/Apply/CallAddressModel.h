//
//  CallAddressModel.h
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface CallAddressModel : NSObject
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *subTitle;
@property (nonatomic ,strong) BMKPoiInfo *bmInfo; //   地址信息


+ (NSArray <CallAddressModel *>*)modelsConversionBaiduInfoModel:(NSArray <BMKPoiInfo *> *)poiInfoArray;
+ (CallAddressModel *)modelConversionBMKPoiInfo:(BMKPoiInfo *)poiInfomodel;


- (CGFloat)title_height;
- (CGFloat)cell_height;
@end
