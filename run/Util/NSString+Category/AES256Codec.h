//
//  AES256Codec.h
//  zcm
//
//  Created by Wen Yunlong on 14-2-11.
//  Copyright (c) 2014年 Beijing Three Plus Five Software Techonolgy Co,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES256Codec : NSObject

+(NSString *)getAuthKey;

+(NSData *)encode:(id)object key:(NSString *)key;
+(id)decode:(NSData *)data key:(NSString *)key;

@end
