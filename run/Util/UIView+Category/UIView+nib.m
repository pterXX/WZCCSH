//
//  UIView+nib.m
//  proj
//
//  Created by asdasd on 2017/11/1.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "UIView+nib.h"

@implementation UIView (nib)
+ (UINib *)loadNib{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

+ (instancetype)currentView{
    return [[self loadNib] instantiateWithOwner:nil options:nil].firstObject;
}

@end
