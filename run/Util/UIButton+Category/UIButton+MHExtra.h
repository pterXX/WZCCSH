//
//  UIButton+MHExtra.h
//  proj
//
//  Created by asdasd on 2017/12/20.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MHButtonActionCallBack)(UIButton *button);

@interface UIButton (MHExtra)


/**
 *  @brief replace the method 'addTarget:forControlEvents:'
 */
- (void)addMHCallBackAction:(MHButtonActionCallBack)callBack forControlEvents:(UIControlEvents)controlEvents;

/**
 *  @brief replace the method 'addTarget:forControlEvents:UIControlEventTouchUpInside'
 *  the property 'alpha' being 0.5 while 'UIControlEventTouchUpInside'
 */
- (void)addMHClickAction:(MHButtonActionCallBack)callBack;

@end
