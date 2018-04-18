//
//  AES256Codec.m
//  zcm
//
//  Created by Wen Yunlong on 14-2-11.
//  Copyright (c) 2014年 Beijing Three Plus Five Software Techonolgy Co,Ltd. All rights reserved.
//

#import "AES256Codec.h"
#import <CommonCrypto/CommonCryptor.h>
//#import "JSONKit.h"

static NSString *KEY_TABLE = @"asdhauihfug34-h79upihv-9ubpvaufc56re3fd,M]O08K7'56,L5L;6M7B23R08YWEFUBHAAVG8G2HJ30RMGV9-U0B8YTUEMPBQH'TW[7JPG7Q-BREBREUNIVMEV[UVBCDX76WFE7EWFWE0-FI58HGEORIGJIOERHGY89ERG789045-MNAV[OPHacgh699WQDTYOVafadfF";
static NSString *COV_TABLE = @"a[hfvpdhvygyf78GF98FNBPYdfpbvdstCVBNDSCKLH98HIUGasdgasdhasdhkjhgu3enjebfgfausdtofijv0d0)_(S^naskd09jaasdh82uGUYhuwfeh9ubigGH89gbDGYGhHgf89hahuashfiuashfuahgg8gYSGDUYGASYDGASGDUASHJDOU89EWHUDIAGiggfew7huiGFGFG7WGFEUBiudgeuwgda8fgiuhakufgyuf789[2-0k3r[pomklh78gas";

@implementation AES256Codec

+(NSString *)getAuthKey
{
    NSMutableString *key = [[NSMutableString alloc] init];
    int j = 0;
    for(int i=0;i<KEY_TABLE.length && key.length < 32;i+=7+j) {
        int ch = [KEY_TABLE characterAtIndex:i];
        ch ^= [COV_TABLE characterAtIndex:j];
        [key appendFormat:@"%02x", ch];
        
        j+=4;
    }
    return key;
}

+(NSData *)encode:(id)object key:(NSString *)key
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if(data == nil || error != nil) return nil;
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          data.bytes, data.length,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        free(buffer);
    }
    
    return result;
}

+(id)decode:(NSData *)data key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSASCIIStringEncoding];
    
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          data.bytes, data.length,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    id object = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        NSError *error = nil;
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    } else {
        free(buffer);
    }
    return object;
}

@end
