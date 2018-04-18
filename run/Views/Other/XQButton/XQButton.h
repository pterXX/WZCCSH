//
//  XQButton.h
//  proj
//
//  Created by asdasd on 2017/12/23.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XQButton;
@protocol XQButtonDelegate <NSObject>
/**
 *  动画开始回调
 *
 *  @param XQButton self
 */
-(void)XQButtonDidStartAnimation:(XQButton*)XQButton;

/**
 *  动画已经结束时回调
 *
 *  @param XQButton self
 */
-(void)XQButtonDidFinishAnimation:(XQButton *)XQButton;

/**
 *  动画将要结束时回调  即 结束动画未执行时
 *
 *  @param XQButton self
 */
-(void)XQButtonWillFinishAnimation:(XQButton *)XQButton;

@end

@interface XQButton : UIButton
//  是否自动禁用，用于表单必填项
@property (nonatomic ,assign) BOOL autoDisable;
//  需要监听的文本框名称,用于判断按钮是否可以使用
@property (nonatomic ,strong) NSArray<UITextField *> *disableTextFieldArray;
- (void)setAutoDisable:(BOOL)autoDisable disableTextFieldArray:(NSArray *)disableTextFieldArray;
- (void)buttonStyle;




/**
 *  创建对象
 *
 *  @param frame  大小
 *
 *  @return 对象
 */
+(instancetype)buttonWithFrame:(CGRect)frame;
/**
 *  边缘色
 */
-(void)setborderColor:(UIColor*)color;
/**
 *  边缘宽度

 */
-(void)setborderWidth:(CGFloat)width;
/**
 *  手动调用执行动画  一般在 button 的响应里调用  调用后会走代理进行回调
 */
-(void)startAnimation;
/**
 *  手动停止动画 停止前和停止后会走代理回调
 */
-(void)stopAnimation;
/**
 *  代理对象
 */
@property (nonatomic, weak) id <XQButtonDelegate> delegate;
@end
