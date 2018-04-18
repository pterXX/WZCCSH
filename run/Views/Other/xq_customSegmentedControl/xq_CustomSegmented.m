//
//  xq_CustomSegmented.m
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "xq_CustomSegmented.h"

@interface xq_CustomSegmented()
@property (nonatomic ,strong) NSMutableArray<UIButton *> *array;
@property (nonatomic ,strong) UIView *bottmLine;
@end
@implementation xq_CustomSegmented

- (instancetype)initWithTitles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        self.height = 40;
        self.width = KWIDTH;
        self.backgroundColor = [UIColor whiteColor];
        self.array = [NSMutableArray array];
        for (NSString *title in titles) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateSelected];
            [btn setTitleColor:COLOR_666666 forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_FF8803 forState:UIControlStateSelected];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btn addTarget:self action:@selector(btnTapAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.array addObject:btn];
        }
        [self.array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:0 tailSpacing:0];
        __weak typeof(self) wkself = self;
        [self.array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(wkself);
            make.top.offset(0);
        }];

        for (UIButton *btn in self.array) {
            if (self.array.lastObject != btn) {
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = COLOR_FF8803;
                [self addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(20);
                    make.width.offset(0.5);
                     make.left.equalTo(btn.mas_right).offset(0.25);
                    make.centerY.equalTo(wkself);

                }];
            }
        }
        if (_array.count) {
            CGFloat w = [((NSString *) titles.firstObject) sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KWIDTH, 40)].width;
            UIView *bottomLine = [[UIView alloc] init];
            bottomLine.backgroundColor = COLOR_FF8803;
            [self addSubview:bottomLine];
            [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(39);
                make.bottom.offset(0);
                make.centerX.equalTo(self.array.firstObject.mas_centerX);
                make.width.offset(w);
            }];
            self.bottmLine = bottomLine;

            self.array.firstObject.selected = YES;
        }
    }
    return self;
}

- (void)btnTapAction:(UIButton *)sender{
    CGFloat w = [sender.currentTitle sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(KWIDTH, 40)].width;
    [self.array enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj == sender;
    }];

    if (self.segmentedBlock) {
        self.segmentedBlock([self.array indexOfObject:sender]);
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.bottmLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(39);
            make.bottom.offset(0);
            make.centerX.equalTo(sender.mas_centerX);
            make.width.offset(w);
        }];
    }];
}

- (NSInteger)currentSelectedIndex{
    for (UIButton *btn in self.array) {
        if (btn.selected == YES ) {
            return [self.array indexOfObject:btn];
        }
    }
    return 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
