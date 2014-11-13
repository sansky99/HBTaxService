//
//  UserInfo.h
//  iTAXMC
//
//  Created by khuang on 14-7-15.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    FontSize_Big
,   FontSize_Normal
,   FontSize_Small
};

@interface UserInfo : NSObject

//@property (nonatomic) BOOL bLogin;
@property (nonatomic, strong) NSString *password;         //
@property (nonatomic, strong) NSString *userID;             //用户名
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *userName;       //纳税人名称
//@property (nonatomic, strong) NSString *orgCode;         //登陆者税务机关代码
@property (nonatomic, strong) NSString *orgName;         //税务机关名称
//@property (nonatomic, strong) NSString *regDate;           //注册日期
@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, strong) NSString *tag;

@property (nonatomic) NSInteger fontSize;

//YES 代表需要进行网厅二次验证，NO不需要
@property (nonatomic) BOOL wtLoginUnable;

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *nsrsbhStr;//纳税人识别号
//登陆状态，YES已登陆，NO未登陆
@property (nonatomic, strong) NSString *loginStatus;

@property (nonatomic, strong) NSString *token;

-(void) load;
-(void) save;
-(void) clear;

-(void) loadFontSize;
-(void) saveFontSize;

+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

@end
