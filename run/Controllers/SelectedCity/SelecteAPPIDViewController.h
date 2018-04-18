//
//  SelecteAPPIDViewController.h
//  city
//
//  Created by asdasd on 2017/7/25.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import "XQBassViewController.h"

@interface SelecteAPPIDViewController : XQBassViewController



/**
 已选中城市
 */
@property (nonatomic, copy) void(^didCitySuccess)(void);

@end
