//
//  XQViewModel.m
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQViewModel.h"

@implementation XQViewModel
@synthesize request = _request;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    XQViewModel *vm = [super allocWithZone:zone];
    if (vm) {
        [vm xq_initialize];
    }
    return vm;
}

- (instancetype)initWithModel:(id)model
{
    self = [super init];
    if (self) {

    }
    return self;
}


- (MLHTTPRequest *)request{
    if (!_request) {
        _request = [[MLHTTPRequest alloc] init];
    }
    return _request;
}

/**
 初始化
 */
- (void)xq_initialize{

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
