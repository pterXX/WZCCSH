//
//  KeyChainStore.h
//  city
//
//  Created by 3158 on 17/1/17.
//  Copyright © 2017年 sjw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
