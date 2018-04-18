//
//  RumtimeLog.h
//  proj
//
//  Created by asdasd on 2017/12/19.
//  Copyright © 2017年 asdasd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RumtimeLog : NSObject

+ (void)LogAllMethodsFromClass:(id)obj;


+ (NSArray *)getAllProperties:(id)obj;
@end
