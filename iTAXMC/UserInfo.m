//
//  UserInfo.m
//  iTAXMC
//
//  Created by khuang on 14-7-15.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UserInfo.h"
#import <CommonCrypto/CommonCryptor.h>

NSString * const kDesKey = @"DesKey09";

NSString * const kUserID = @"kUserID";
NSString * const kGroupID = @"kGroupID";
NSString * const kGroupName = @"kGroupName";
//NSString * const kOrgCode = @"kOrgCode";
//NSString * const kOrgName = @"kOrgName";
//NSString * const kRegDate = @"kRegDate";
NSString * const kUserPassword = @"kUserPwd";
NSString * const kUserTag = @"kUserTag";

NSString * const KFontSize = @"KFontSize";

NSString *const KKey = @"KUserKey";
NSString *const KNsrsbhStr = @"KNsrsbhStr";
NSString *const KToken = @"KToken";

@implementation UserInfo

//@synthesize bLogin;
@synthesize password, userID, groupID, groupName/*, orgCode, orgName, regDate*/, tag ;
@synthesize fontSize;
@synthesize wtLoginUnable = _wtLoginUnable;
@synthesize key = _key;
@synthesize nsrsbhStr = _nsrsbhStr;
@synthesize loginStatus = _loginStatus;
@synthesize token = _token;

-(id) init
{
    if (self = [super init])
    {
        self.userID = self.groupID = self.groupName/* = self.orgCode = self.orgName = self.regDate*/ = self.password = self.tag = @"";
        self.fontSize = 1;
        self.wtLoginUnable = NO;
        self.key = StringEmpty;
        self.nsrsbhStr = StringEmpty;
        self.loginStatus = StringEmpty;
        self.token = StringEmpty;
    }
    return self;
}

-(BOOL) isLogin
{
    if ([self.loginStatus isEqualToString:@"YES"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    //return [self.userID length] > 0;
}

//-(NSString*) passwordBase64
//{
//    NSData * data = [self.password dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *strBase64 = [data base64EncodedStringWithOptions:0];
//
//    return strBase64;
//}

-(void) load
{
    self.userID = [[NSUserDefaults standardUserDefaults] stringForKey:kUserID];
    self.groupID =[[NSUserDefaults standardUserDefaults] stringForKey:kGroupID];
    self.groupName = [[NSUserDefaults standardUserDefaults] stringForKey:kGroupName];
//    self.orgCode = [[NSUserDefaults standardUserDefaults] stringForKey:kOrgCode];
//    self.orgName = [[NSUserDefaults standardUserDefaults] stringForKey:kOrgName];
//    self.regDate = [[NSUserDefaults standardUserDefaults] stringForKey:kRegDate];
    self.tag = [[NSUserDefaults standardUserDefaults] stringForKey:kUserTag];
    self.key = [[NSUserDefaults standardUserDefaults] stringForKey:KKey];
    self.nsrsbhStr = [[NSUserDefaults standardUserDefaults] stringForKey:KNsrsbhStr];
    self.token = [[NSUserDefaults standardUserDefaults] stringForKey:KToken];
    
    
    NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:kUserPassword];
    if ([pwd length] > 0)
    {
        if (IOS_7)
        {
            NSData *dec = [UserInfo DESDecrypt:[[NSData alloc] initWithBase64EncodedString:pwd options:0] WithKey:kDesKey];
            self.password = [[NSString alloc ] initWithData:dec encoding:NSUTF8StringEncoding];
        }
        else
            self.password = pwd;
    }
}

-(void) save
{
    [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] setObject:self.groupID forKey:kGroupID];
    [[NSUserDefaults standardUserDefaults] setObject:self.groupName forKey:kGroupName];
    [[NSUserDefaults standardUserDefaults] setObject:self.tag forKey:kUserTag];
    [[NSUserDefaults standardUserDefaults] setObject:self.key forKey:KKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.nsrsbhStr forKey:KNsrsbhStr];
    [[NSUserDefaults standardUserDefaults] setObject:self.token forKey:KToken];
//    [[NSUserDefaults standardUserDefaults] setObject:self.orgCode forKey:kOrgCode];
//    [[NSUserDefaults standardUserDefaults] setObject:self.orgName forKey:kOrgName];
//    [[NSUserDefaults standardUserDefaults] setObject:self.regDate forKey:kRegDate];

    if ([self.password length]  > 0)
    {
        if (IOS_7)
        {
            NSData *data = [self.password dataUsingEncoding:NSUTF8StringEncoding];
            NSData *enc = [UserInfo DESEncrypt:data WithKey:kDesKey];
//            NSString *base64=[enc base64EncodedStringWithOptions:0];
            [[NSUserDefaults standardUserDefaults] setObject:[enc base64EncodedStringWithOptions:0] forKey:kUserPassword];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:kUserPassword];
        }
    }
    else
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) clear
{
    self.groupID = self.groupName/* = self.orgCode = self.orgName = self.regDate*/ = self.password = self.tag = @"";
    self.key = StringEmpty;
    self.nsrsbhStr = StringEmpty;
    self.loginStatus = StringEmpty;
    self.token = StringEmpty;
    [self save];
}

-(void) loadFontSize
{
    NSString *fs = [[NSUserDefaults standardUserDefaults] stringForKey:KFontSize];
    if (nil != fs)
        self.fontSize = [fs integerValue];
}

-(void) saveFontSize
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", self.fontSize]  forKey:KFontSize];
}
/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeDES,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}
@end
