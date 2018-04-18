//
//  xq_SegmentedControl.m
//  proj
//
//  Created by asdasd on 2017/12/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "xq_SegmentedControl.h"
#import  <objc/runtime.h>
@implementation xq_SegmentedControl


- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        self.tintColor = COLOR_MAIN;
        self.width = 204;
        [self setSelectedSegmentIndex:0];
        [self addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)segmentedValueChanged:(xq_SegmentedControl *)sender
{
    void(^block)(NSInteger index) =  objc_getAssociatedObject(self, _cmd);
    if (block) {
        block(sender.selectedSegmentIndex);
    }
}


+ (instancetype)items:(NSArray *)items
{
    return  [[xq_SegmentedControl alloc] initWithItems:items];
}



+ (instancetype)addVisitRecordEventValueChangedBlock:(void(^)(NSInteger index))block
{
    xq_SegmentedControl *control = [[xq_SegmentedControl alloc] initWithItems:@[@"面谈",@"电话",@"微信"]];
    CGRect frame = control.frame;
    frame.size.width = 180;
    frame.origin.x = SJAdapter(204);
    frame.origin.y = (SJAdapter(120) -  frame.size.height) / 2;
    control.frame = frame;
    objc_setAssociatedObject(control, @selector(segmentedValueChanged:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return control;
}

//  活动
+ (instancetype)activityEventValueChangedBlock:(void(^)(NSInteger index))block
{
    xq_SegmentedControl *control = [[xq_SegmentedControl alloc] initWithItems:@[@"活动营销",@"我的活动"]];
    CGRect frame = control.frame;
    frame.size.width = 204;
    control.frame = frame;
    objc_setAssociatedObject(control, @selector(segmentedValueChanged:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return control;
}

//  装修圈
+ (instancetype)circleEventValueChangedBlock:(void(^)(NSInteger index))block
{
    xq_SegmentedControl *control = [[xq_SegmentedControl alloc] initWithItems:@[@"装修圈",@"我的好友"]];
    CGRect frame = control.frame;
    frame.size.width = 204;
    control.frame = frame;
    objc_setAssociatedObject(control, @selector(segmentedValueChanged:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return control;
}

//  添加客户
+ (instancetype)addCustommerEventValueChangedBlock:(void(^)(NSInteger index))block
{
    xq_SegmentedControl *control = [[xq_SegmentedControl alloc] initWithItems:@[@"从通讯录选",@"手填"]];
    [control setWidth:100 forSegmentAtIndex:0];
    CGRect frame = control.frame;
    frame.size.width = 150;
    frame.origin.x = SJAdapter(204);
    frame.origin.y = (SJAdapter(100) -  frame.size.height) / 2;
    control.frame = frame;
//    [control setContentOffset:CGSizeMake(100, frame.size.height) forSegmentAtIndex:0];
    objc_setAssociatedObject(control, @selector(segmentedValueChanged:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return control;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
