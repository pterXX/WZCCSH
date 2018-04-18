//
//  AppDelegate.h
//  proj
//
//  Created by asdasd on 2017/9/25.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQLoginExample.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) BMKMapManager * mapManager;

@end

