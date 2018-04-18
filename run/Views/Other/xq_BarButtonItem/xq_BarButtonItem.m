//
//  xq_BarButtonItem.m
//  proj
//
//  Created by asdasd on 2017/12/27.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "xq_BarButtonItem.h"
#import <objc/runtime.h>

//@interface xq_BarButtonItem (Event)
//
//@end
//
//@implementation xq_BarButtonItem (Event)
//
//@end

@implementation xq_BarButtonItem
- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.action = @selector(barButtonItemTouchUpInsid);
        self.image = image;
        self.target = self;
        self.style = UIBarButtonItemStylePlain;
    }
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.action = @selector(barButtonItemTouchUpInsid);
        self.title =  title;
        self.target = self;
        self.style = UIBarButtonItemStyleDone;
         self.tintColor = COLOR_353535;
    }
    return self;
}


#pragma mark - Event Methods
- (void)barButtonItemTouchUpInsid
{
   void (^block)(xq_BarButtonItem *barItem) = objc_getAssociatedObject(self, _cmd);
    if (block) {
        block(self);
    }
}


//  普通按钮
+ (instancetype)itemTitle:(NSString *)title TouchBlock:(void (^)(xq_BarButtonItem *barItem))block{
    xq_BarButtonItem *barItem  =
    [[xq_BarButtonItem alloc] initWithTitle:title];
    objc_setAssociatedObject(barItem, @selector(barButtonItemTouchUpInsid), block, OBJC_ASSOCIATION_COPY);
    return barItem;
}

//  搜索按钮
+ (instancetype)searchBtnWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block
{
   xq_BarButtonItem *searchBtn = [[xq_BarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_search_22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    objc_setAssociatedObject(searchBtn, @selector(barButtonItemTouchUpInsid), block, OBJC_ASSOCIATION_COPY);
    return searchBtn;
}

//  返回按钮
+ (instancetype)backItemWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block{
    xq_BarButtonItem *barItem = [[xq_BarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back_22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    objc_setAssociatedObject(barItem, @selector(barButtonItemTouchUpInsid), block, OBJC_ASSOCIATION_COPY);
    return barItem;
}

//  分享按钮
+ (instancetype)shareItemWithTouchBlock:(void (^)(xq_BarButtonItem *barItem))block{
    xq_BarButtonItem *barItem = [[xq_BarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_colon_22"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    objc_setAssociatedObject(barItem, @selector(barButtonItemTouchUpInsid), block, OBJC_ASSOCIATION_COPY);
    return barItem;
}
@end
