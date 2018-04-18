//
//  MessageModel.h
//  running man
//
//  Created by asdasd on 2018/4/2.
//  Copyright © 2018年 城市生活. All rights reserved.
//

#import "XQModel.h"
#import "NSObject+Property.h"
@interface MessageModel : XQModel
@property (nonatomic,strong) NSString *aid;
@property (nonatomic,strong) NSString *title;   //标题
@property (nonatomic,strong) NSString *content;   //内容
@property (nonatomic,strong) NSString *dateline;
@property (nonatomic,assign) NSInteger is_read;   // 1已读 2未读
@end
