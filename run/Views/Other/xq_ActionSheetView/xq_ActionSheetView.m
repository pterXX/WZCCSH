//
//  xq_ActionSheetView.m
//  JHTDoctor
//
//  Created by yangxq_ on 2017/5/23.
//  Copyright © 2017年 yangxq_. All rights reserved.
//

#import "xq_ActionSheetView.h"

#define Margin  6
#define ButtonHeight  50
#define TitleHeight   30
#define LineHeight    0.5

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface xq_ActionSheetView ()

@property (nonatomic, strong) UIToolbar *containerToolBar;
@property (nonatomic, assign) CGFloat toolbarH;
@end

@implementation xq_ActionSheetView


- (void)layoutSubviews{
    [super layoutSubviews];
    //  解决ios11  tool bar 不能正常点击的问题
    NSArray *subViewArray = [self.containerToolBar subviews];
    for (id view in subViewArray) {
        if ([view isKindOfClass:(NSClassFromString(@"_UIToolbarContentView"))]) {
            UIView *testView = view;
            testView.userInteractionEnabled = NO;
        }
    }
}

- (id)initWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(xq_ActionSheetView *, NSInteger))block
{
    if (self = [super init])
    {
        
       NSMutableArray *array =  buttons.mutableCopy;
        if ([buttons containsObject:@"取消"] == NO) {
            [array addObject:@"取消"];
        }
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _toolbarH = array.count*(ButtonHeight+LineHeight)+(array.count>1?Margin:0)+(title.length?TitleHeight:0);

        _containerToolBar = [[UIToolbar alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),_toolbarH}];
        _containerToolBar.clipsToBounds = YES;


        CGFloat buttonMinY = 0;

        if (title.length)
        {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = [UIColor grayColor];
            label.text = title;
            [_containerToolBar addSubview:label];
            buttonMinY = TitleHeight;
        }

        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {

             UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

             button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
             [button setTitle:obj forState:UIControlStateNormal];
             if ([obj containsString:@"删除"])
             {
                 [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
             }else
             {
                 [button setTitleColor:[UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
             }

             [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
             button.tag = 100 + idx;
             [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];

             if (idx == array.count -1 && array.count > 1)
             {
                 button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin,CGRectGetWidth(self.frame),ButtonHeight};
             }else
             {
                 button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
             }

             [_containerToolBar addSubview:button];

             if (idx<array.count-2)
             {
                 UIView *view= [UIView new];
                 view.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
                 [_containerToolBar addSubview:view];
                 view.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame), LineHeight);
             }
         }];

        self.buttonClick = block;
    }

    return self;

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissView];
}

- (void)buttonTouch:(UIButton *)button
{
    if (self.buttonClick && [button.currentTitle isEqualToString:@"取消"] == NO)
    {
        self.buttonClick(self, button.tag-100);
    }
    [self dismissView];

}


- (void)showView
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:_containerToolBar];

    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformMakeTranslation(0, -_toolbarH);
        self.alpha = 1;

    } completion:^(BOOL finished)
     {

     }];

}

- (void)dismissView
{
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformIdentity;
        self.alpha = 0;
    } completion:^(BOOL finished)
     {
         [self removeFromSuperview];
         [_containerToolBar removeFromSuperview];
     }];
}

+ (void)showSheetWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(xq_ActionSheetView *, NSInteger))block
{
    
    xq_ActionSheetView *view = [[xq_ActionSheetView alloc] initWithTitle:title buttons:buttons buttonClick:block];
    [view showView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
