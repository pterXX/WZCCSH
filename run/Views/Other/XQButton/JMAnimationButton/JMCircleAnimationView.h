//
//  JMCircleAnimationView.h
//  AnimationButton
//
//  Created by Jimmy on 16/6/15.
//  Copyright © 2016年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMCircleAnimationView : UIView
@property (nonatomic, strong) UIColor* borderColor;
+(instancetype)viewWithButton:(UIButton*)button;
-(void)startAnimation;
@end
