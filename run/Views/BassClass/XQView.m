//
//  XQView.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQView.h"

@implementation XQView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xq_setupViews];
        [self xq_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<XQViewModelProtocol>)viewModel
{
    self = [super init];
    if (self) {
        [self xq_setupViews];
        [self xq_bindViewModel];
    }
    return self;
}

- (void)xq_bindViewModel{

}

- (void)xq_setupViews{

}

- (void)xq_addRecturnKeyBoard{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
    }];
    [self addGestureRecognizer:tap];
}


- (void)xq_showHUD{
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
}

- (void)xq_hideHUD{
    [MBProgressHUD hideAllHUDsForView:self.viewController.view animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
