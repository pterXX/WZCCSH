//
//  xq_RadioButton.m
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "xq_RadioButton.h"
#import "UIButton+Layout.h"
#import <objc/runtime.h>

@interface xq_RadioButton ()
@property (nonatomic ,strong) NSArray *items;
@end

@implementation xq_RadioButton
static NSInteger _column = 1;
- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = items;
        for (NSString *str in items)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.selected = [items indexOfObject:str] == 0;
            [button setFrame:CGRectMake(0, 0, 100, 30)];
            [button.titleLabel setFont:[UIFont adjustFont:30]];
            [button setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f  blue:102.0f/255.0f  alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f  blue:102.0f/255.0f  alpha:1.0] forState:UIControlStateSelected];
            [button setImage:[UIImage imageNamed:@"radio_icon_20"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"radio_sel_icon_20"] forState:UIControlStateSelected];
            [button setTitle:str forState:UIControlStateNormal];
            [button setTitle:str forState:UIControlStateSelected];

            CGFloat imageSizeWidth = 20;
            CGFloat imageSizeHeight = 20;
            CGSize titleSize = [button titleSize];
            CGFloat titleSizeWidth = titleSize.width;
            CGFloat titleSizeHeight = titleSize.height;
            // 在左边
            CGFloat imageOrginTop =5;
            CGFloat imageOrginLeft = 0;
            [button setImageRect:CGRectMake(imageOrginLeft, imageOrginTop, imageSizeWidth, imageSizeHeight)];
            CGFloat titleOrginTop = (30 - titleSizeHeight) / 2;
            CGFloat titleOrginLeft = imageOrginLeft + imageSizeWidth + 6;
            [button setTitleRect:CGRectMake(titleOrginLeft, titleOrginTop, titleSizeWidth, titleSizeHeight)];

            [button addTarget:self action:@selector(buttonTouchUpinsid:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            CGRect frame  = button.frame;
            frame.size.width = imageSizeWidth + titleSizeWidth + 6;
            button.frame = frame;

            CGRect viewframe  = self.frame;
            viewframe.size.width = button.frame.origin.x + button.frame.size.width;
            self.frame = viewframe;
        }
    }
    return self;
}

- (void)radioBtn{
    
}


#pragma mark - Private Methods
- (void)setColumn:(NSInteger)column
{
    _column = column;
    CGFloat minY = 0;
    CGFloat minX = 0;
    for (UIButton *btn in self.subviews)
    {
        CGRect frame  = btn.frame;
        NSInteger index = [self.subviews indexOfObject:btn];
        if (index / column  > 0)
        {
            minY += frame.size.height;
        }

        if (index % column > 0) {
            minX += frame.size.width + 30;
        }else{
            minX = 0;
        }
        frame.origin.y =  minY;
        frame.origin.x = minX;
        btn.frame = frame;

        CGRect viewframe  = self.frame;
        viewframe.size.width = minX + btn.frame.size.width;
        viewframe.size.height = minY + btn.size.height;
        self.frame = viewframe;
    }
}

- (NSInteger)column
{
    return _column;
}

- (NSInteger)currentSelectedIndex
{
    for (UIButton *btn in self.subviews) {
        if (btn.isSelected) {
            return [self.subviews indexOfObject:btn];
        }
    }
    return -1;
}

- (NSString *)currentSelectedStr
{
    for (UIButton *btn in self.subviews) {
        if (btn.isSelected) {
            return btn.currentTitle;
        }
    }
    return nil;
}

//  设置默认选中
- (void)setDefalutSelectedIndex:(NSInteger)defalutSelectedIndex
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if (idx == defalutSelectedIndex) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }];
}

#pragma mark - Event Method
- (void)buttonTouchUpinsid:(UIButton *)sender
{
    NSInteger index =  [self.subviews indexOfObject:sender];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = obj;
        if (idx == index) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }];

    void (^block) (NSInteger selecetedIndex, NSString *selecetedStr) = objc_getAssociatedObject(self, _cmd);
    if (block) {
        block([self.subviews indexOfObject:sender],sender.currentTitle);
    }
}


#pragma mark - Public Method
//  性别单选按钮
+ (instancetype)sexRadioWithSelectedBlock:(void (^) (NSInteger selecetedIndex, NSString *selecetedStr))block
{
    xq_RadioButton *radio = [[xq_RadioButton alloc] initWithFrame:CGRectMake(SJAdapter(240), (SJAdapter(100) -  30 ) / 2, KWIDTH / 2, 30) Items:@[@"男",@"女"]];
    radio.column = 2;
    radio.defalutSelectedIndex = 0;
    objc_setAssociatedObject(radio, @selector(buttonTouchUpinsid:), block, OBJC_ASSOCIATION_COPY);
    return radio;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
