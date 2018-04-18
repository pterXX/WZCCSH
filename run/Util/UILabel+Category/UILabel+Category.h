//
//  UILabel+Category.h
//  city
//
//  Created by asdasd on 2017/10/18.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)
//给UILabel设置行间距和字间距
-(void)setLabelSpace:(CGFloat )labelSpace kernSpace:(CGFloat )kernSpace withValue:(NSString*)str;

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeightWithlabelSpace:(CGFloat )labelSpace kernSpace:(CGFloat )kernSpace;
@end
