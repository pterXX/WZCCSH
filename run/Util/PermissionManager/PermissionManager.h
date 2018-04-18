//
//  PermissionManager.h
//  proj
//
//  Created by asdasd on 2017/9/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivacyPermission.h"
@interface PermissionManager : NSObject
/**
 联网权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)networkPermission;


/**
 相册的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)photoPermission;

/**
 相机的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)cameraPermission;


/**
 相机的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)microphonePermission;

/**
 定位的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)locationPermission;

/**
 推送的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)pushPermission;

/**
 通讯录的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)addressBookPermission;

/**
 日历的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)calendarPermission;

/**
 备忘录的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)memoPermission;
@end
