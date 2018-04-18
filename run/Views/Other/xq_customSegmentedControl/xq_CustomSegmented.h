//
//  xq_CustomSegmented.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xq_CustomSegmented : UIView
@property (nonatomic ,copy) void(^segmentedBlock)(NSInteger);
- (instancetype)initWithTitles:(NSArray *)titles;
- (NSInteger)currentSelectedIndex;

@end
