//
//  CallAddressModel.m
//  city
//
//  Created by 3158 on 2018/2/2.
//  Copyright © 2018年 sjw. All rights reserved.
//

#import "CallAddressModel.h"

@implementation CallAddressModel

+ (NSArray <CallAddressModel *>*)modelsConversionBaiduInfoModel:(NSArray <BMKPoiInfo *> *)poiInfoArray
{
    NSMutableArray *array = [NSMutableArray array];
    [poiInfoArray enumerateObjectsUsingBlock:^(BMKPoiInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[CallAddressModel modelConversionBMKPoiInfo:obj]];
    }];
    return array;
}

+ (CallAddressModel *)modelConversionBMKPoiInfo:(BMKPoiInfo *)poiInfomodel
{
    CallAddressModel *model = [[CallAddressModel alloc] init];
    model.title = poiInfomodel.name;
    model.subTitle = poiInfomodel.address;
    model.bmInfo = poiInfomodel;
    return model;
}


- (CGFloat)title_height
{
    return [self.title sizeWithFont:[UIFont adjustFont:28] maxWidth:SJAdapter(620.0f)];
}

- (CGFloat)cell_height
{
    return self.title_height + SJAdapter(70);
}
@end
