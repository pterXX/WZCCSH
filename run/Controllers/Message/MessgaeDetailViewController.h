//
//  MessgaeDetailViewController.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQBassViewController.h"

@interface MessgaeDetailViewController : XQBassViewController
@property (nonatomic ,strong) NSString *aid;
@property (nonatomic ,strong) NSString *msg_type;  //      1订单消息 2系统消息
@end
