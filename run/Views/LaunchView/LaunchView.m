//
//  LaunchView.m
//  run
//
//  Created by asdasd on 2018/4/18.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "LaunchView.h"

@implementation LaunchView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         [self showIntroWithCrossDissolve];
    }
    return self;
}
#pragma mark - Demo
- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.titleIconPositionY = 0;
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750-1334-1"]];
    imageView1.bounds = CGRectMake(0, 0, KWIDTH, KWIDTH * (940.0 / 750 ));
    page1.titleIconView =  imageView1;

    EAIntroPage *page2 = [EAIntroPage page];
    page2.titleIconPositionY = 0;
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750-1334-2"]];
    imageView2.bounds = CGRectMake(0, 0, KWIDTH, KWIDTH * (940.0 / 750 ));
    page2.titleIconView =  imageView2;

    EAIntroPage *page3 = [EAIntroPage page];
    page3.titleIconPositionY = 0;
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750-1334"]];
    imageView3.bounds = CGRectMake(0, 0, KWIDTH, KWIDTH * (940.0 / 750 ));
    page3.titleIconView =  imageView3;

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.bounds];
    intro.backgroundColor = [UIColor whiteColor];
    intro.skipButtonAlignment = EAViewAlignmentCenter;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(0, 0, SJAdapter(300), SJAdapter(80))];
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_FE9928 forState:UIControlStateNormal];
    btn.layer.borderWidth = 2.f;
    btn.layer.cornerRadius = SJAdapter(40);
    btn.layer.borderColor = COLOR_FE9928.CGColor;
    [btn addMHClickAction:^(UIButton *button) {
        [self hide];
    }];

    SMPageControl *pageControl = [[SMPageControl alloc] init];
    pageControl.pageIndicatorImage = [UIImage imageNamed:@"lau_icon_dot"];
    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"lau_icon"];
    [pageControl sizeToFit];
    // This is a hack - not recommended for Swift, more information: https://github.com/ealeksandrov/EAIntroView/issues/161
    intro.pageControl = (UIPageControl *)pageControl;
    intro.pageControlY = SJAdapter(110);

    // This is a hack - not recommended for Swift, more information: https://github.com/ealeksandrov/EAIntroView/issues/161
    intro.skipButton.hidden = YES;
    intro.pageControl = (UIPageControl *)pageControl;
    intro.pageControlY = iPhoneX ?SJAdapter(200):SJAdapter(100);
    [intro setDelegate:self];
    [intro setPages:@[page1,page2,page3]];
    [intro showInView:self animateDuration:0.3];

    [self addSubview:btn];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.size.sizeOffset(CGSizeMake(SJAdapter(300), SJAdapter(80)));
        make.bottom.equalTo(self.mas_bottom).offset( -(iPhoneX ?SJAdapter(450):SJAdapter(250)));
    }];
    btn.alpha = 0.f;
    btn.enabled = NO;

    page3.onPageDidDisappear = ^{
        btn.enabled = NO;
        intro.pageControl.enabled = YES;
        [UIView animateWithDuration:0.3f animations:^{
            btn.alpha = 0.f;
             intro.pageControl.alpha = 1.0;
        }];
    };
    page3.onPageDidAppear = ^{
        btn.enabled = YES;
        intro.pageControl.enabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            btn.alpha = 1.f;
            intro.pageControl.alpha = 0.0;
        }];
    };


}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {

    [self hide];
}

- (void)hide{
    if (self.viewWillHide) {
        self.viewWillHide();
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
@end
