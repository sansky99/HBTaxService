//
//  NSData+Encryption.h
//  XJTaxService
//
//  Created by mac on 14-9-19.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
- (NSData *)DESEncryptWithKey:(NSString *)key;

/************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 **********************************************************/
- (NSData *)DESDecryptWithKey:(NSString *)key;

-(NSData *) encryptAboutPlainTexkey:(NSString *)key;

@end
