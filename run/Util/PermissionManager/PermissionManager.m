//
//  PermissionManager.m
//  proj
//
//  Created by asdasd on 2017/9/28.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import "PermissionManager.h"
@import AVFoundation;
@import CoreTelephony;
@import CoreLocation;
@import EventKit;

// _IPHONE_OS_VERSION_MIN_REQUIRED //要求最低的系统版本

//__IPHONE_OS_VERSION_MAX_ALLOWED //允许最高的系统版本



#if __IPHONE_9_0 >= __IPHONE_OS_VERSION_MAX_ALLOWED
#import <AddressBook/AddressBook.h>
#else
#import <Contacts/Contacts.h>
#endif


#if __IPHONE_8_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
#import <Photos/Photos.h>
#else 
#import <AssetsLibrary/AssetsLibrary.h>
#endif




@implementation PermissionManager

/**
 联网权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)networkPermission{
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    if (state == kCTCellularDataRestricted) {
        return NO;
    }else{
        return YES;
    }
}


/**
相册的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)photoPermission{

#if __IPHONE_8_0 > __IPHONE_OS_VERSION_MAX_ALLOWED
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if ( author == ALAuthorizationStatusDenied ) {
        return NO;
    }
    return YES;
#else
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        return NO;
    }
    return YES;
#endif

    return NO;
}

/**
 相机的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)cameraPermission{
     AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    if (AVstatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}


/**
 相机的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)microphonePermission{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//相机权限
    if (AVstatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
}

/**
 定位的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)locationPermission{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        return YES;
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        return NO;
    }
    return NO;
}


/**
 推送的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)pushPermission{
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (settings.types == UIUserNotificationTypeNone) {
        return NO;
    }
    return YES;
}


/**
 通讯录的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)addressBookPermission{
#if __IPHONE_9_0 > __IPHONE_OS_VERSION_MAX_ALLOWED
    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    if (ABstatus == kABAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
#else
    CNAuthorizationStatus  status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized) {
        return YES;
    }
    return NO;
#endif

    return NO;
}

/**
 日历的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)calendarPermission{
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if ( EKstatus == EKAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}

/**
 备忘录的权限

 @return YES 已开启 NO 未开启
 */
+ (BOOL)memoPermission{
    EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if ( EKstatus == EKAuthorizationStatusNotDetermined) {
        return NO;
    }
    return YES;
}



@end
