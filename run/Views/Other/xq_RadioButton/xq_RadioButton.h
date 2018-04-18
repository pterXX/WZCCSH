//
//  xq_RadioButton.h
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xq_RadioButton : UIView
//  多少列
@property (nonatomic ,assign) NSInteger column;
//  默认选中
@property (nonatomic ,assign) NSInteger defalutSelectedIndex;

//  当前选中的字符串
@property (nonatomic ,strong ,readonly) NSString *currentSelectedStr;
//  当前选中的下标
@property (nonatomic ,assign ,readonly) NSInteger currentSelectedIndex;



//  性别单选按钮
+ (instancetype)sexRadioWithSelectedBlock:(void (^) (NSInteger selecetedIndex, NSString *selecetedStr))block;
@end
