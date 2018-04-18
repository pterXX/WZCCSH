//
//  XQView.h
//  running man
//
//  Created by asdasd on 2018/3/28.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQViewPtotocol.h"
@interface XQView : UIView <XQViewProtocol>
- (void)xq_showHUD;

- (void)xq_hideHUD;
@end
