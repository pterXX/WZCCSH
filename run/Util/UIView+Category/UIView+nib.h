//
//  UIView+nib.h
//  proj
//
//  Created by asdasd on 2017/11/1.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (nib)
+ (UINib *)loadNib;
+ (instancetype)currentView;
@end
