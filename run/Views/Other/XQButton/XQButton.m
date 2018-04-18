//
//  XQButton.m
//  proj
//
//  Created by asdasd on 2017/12/23.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "XQButton.h"
#import "JMCircleAnimationView.h"

static NSTimeInterval startDuration = 0.3;
static NSTimeInterval endDuration = 0.5;
#define CORNERRADIUS SJAdapter(6)
@interface XQButton()

@property (nonatomic, strong) JMCircleAnimationView* circleView;
@property (nonatomic, assign) CGRect origionRect;
@end
@implementation XQButton

- (JMCircleAnimationView *)circleView
{
    if (!_circleView) {
        _circleView = [JMCircleAnimationView viewWithButton:self];
//        _circleView.borderColor = COLOR_MAIN;
        [self addSubview:_circleView];
    }
    return _circleView;
}

+(instancetype)buttonWithFrame:(CGRect)frame{
    XQButton* button = [XQButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;

    return button;
}


-(void)setborderColor:(UIColor *)color{
    self.layer.borderColor = color.CGColor;

}

-(void)setborderWidth:(CGFloat)width
{
    self.layer.borderWidth = width;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = self.frame;
}


-(void)startAnimation
{
    CGPoint center = self.center;
    CGFloat width = self.frame.size.height;
    CGFloat height = self.frame.size.height;
    CGRect desFrame = CGRectMake(center.x - width / 2, center.y - height / 2, width, height);
    self.origionRect = self.frame;
    self.userInteractionEnabled = NO;

    if ([self.delegate respondsToSelector:@selector(XQButtonDidStartAnimation:)]) {
        [self.delegate XQButtonDidStartAnimation:self];
    }

    [UIView animateWithDuration:startDuration animations:^{
        self.titleLabel.alpha = .0f;
        self.frame = desFrame;
        self.layer.cornerRadius = height / 2;
    } completion:^(BOOL finished) {

        [self.circleView startAnimation];
    }];
}

-(void)stopAnimation{
    self.userInteractionEnabled = YES;
    if ([self.delegate respondsToSelector:@selector(XQButtonWillFinishAnimation:)]) {
        [self.delegate XQButtonWillFinishAnimation:self];
    }

    [self.circleView removeFromSuperview];
    self.circleView = nil;
    [UIView animateWithDuration:endDuration animations:^{
        self.frame = self.origionRect;
        self.titleLabel.alpha = 1.0f;
        self.layer.cornerRadius = CORNERRADIUS;
    } completion:^(BOOL finished) {
        [self.circleView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(XQButtonDidFinishAnimation:)]) {
            [self.delegate XQButtonDidFinishAnimation:self];
        }
    }];

}



- (void)awakeFromNib
{
    [super awakeFromNib];
    [self buttonStyle];
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    XQButton *button = [super buttonWithType:buttonType];
    [button buttonStyle];
    return button;
}

//  判断输入框是否都不为空
- (void)_isAllTextFieldNotEmpty
{
    if (self.autoDisable)
    {
        //  判断文本框是否全部输入
        for (UITextField *tField in self.disableTextFieldArray)
        {
            if (tField.text.length > 0)
            {
                self.enabled = YES;
            }else
            {
                self.enabled = NO;
                return;
            }
        }
    }
}


- (void)setAutoDisable:(BOOL)autoDisable disableTextFieldArray:(NSArray *)disableTextFieldArray
{
    _autoDisable = autoDisable;
    _disableTextFieldArray = disableTextFieldArray;

    if (_autoDisable)
    {
        if ([[self xq_getAssociatedValueForKey:_cmd] boolValue] == NO) {
            [self xq_setAssignValue:@(YES) withKey:_cmd];
            for (UITextField *textField in disableTextFieldArray)
            {
                [textField addTarget:self action:@selector(textFieldChangeAction:)   forControlEvents:UIControlEventEditingChanged];

            }
        }
        [self _isAllTextFieldNotEmpty];
    }else
    {
        self.enabled = YES;
    }
}


#pragma mark - Action Methods
- (void)textFieldChangeAction:(UITextField *)textField
{
    [self _isAllTextFieldNotEmpty];
}


#pragma mark - Public metods
- (void)buttonStyle
{
    UIColor *whiteColor = [UIColor whiteColor];
    [self.layer setCornerRadius:CORNERRADIUS];
    [self.layer setMasksToBounds:YES];
//    self.clipsToBounds = YES;
    self.layer.borderWidth = CGColorEqualToColor(self.currentTitleColor.CGColor, whiteColor.CGColor)? 0:0.5;
    self.layer.borderColor = self.currentTitleColor.CGColor;

    [self setBackgroundImage:[UIImage imageWithColor:COLOR_FFE1AA withSize:CGSizeMake(200, 200)] forState:UIControlStateDisabled];
    [self setBackgroundImage:[UIImage imageWithColor:(CGColorEqualToColor(self.currentTitleColor.CGColor, whiteColor.CGColor) ? COLOR_FE9928:whiteColor) withSize:CGSizeMake(200, 200)] forState:UIControlStateNormal];

    [self setTitleColor:whiteColor forState:UIControlStateDisabled];
}

#pragma mark - Getter


@end
