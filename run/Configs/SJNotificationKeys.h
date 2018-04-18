//
//  SJNotificationKeys.h
//  run
//
//  Created by asdasd on 2018/4/12.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SJNotificationKeys_h
#define SJNotificationKeys_h

//  获取通知中心
#define XQNotificationCenter [NSNotificationCenter defaultCenter]


///  推送订单列表首页的时候刷新页面的通知key
#define kPushOrderPageAndReloadUINotificationKey @"kPushOrderPageAndReloadUINotificationKey"

///  是否开工的通知key
#define kIsWorkingNotificationKey @"kIsWorkingNotificationKey"

///  收工状态的通知key
#define kWorkingStatuseNotificationKey @"kWorkingStatuseNotificationKey"
#endif /* SJOtherUtil_h */
