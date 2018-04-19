//
//  LaunchView.h
//  run
//
//  Created by asdasd on 2018/4/18.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EAIntroView/EAIntroView.h>
#import <SMPageControl/SMPageControl.h>
@interface LaunchView : UIView<EAIntroDelegate>


@property (nonatomic ,copy) void (^viewWillHide)(void);
@end
