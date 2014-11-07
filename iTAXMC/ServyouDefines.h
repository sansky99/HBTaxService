//
//  ServyouDefines.h
//  iTAXMC
//
//  Created by khuang on 14-7-10.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class UserInfo;

#define kNotifySettingTouchUpInside     @"kNotifySettingTouchUpInside"

enum MyModuleColumn{
    Col_ID  = 0
,   Col_ParentID
,   Col_Name                        //UI上显示的名称
,   Col_NeedLogin               //是否需要登录
,   Col_Image                       //图标文件名
,   Col_URL                          //请求数据时URL
,   Col_URLType                //请求数据时post的type参数标识
};

@interface ServyouDefines : NSObject

//根据模块ID查询模块
+(NSArray*) getModule:(NSNumber*) id;                    //[ID, parentID, Name, ...]

//根据模块ID查询子模块
+(NSArray*) getModuleChildren:(NSNumber*) parentID;     //[ [ID, parentID, ...], [ID, parentID, ...], ...]

//数据库
+(FMDatabase*) sharedDatabase;

//用户信息
+(UserInfo*) sharedUserInfo;

//判断server返回JSON字符串是否指示成功
+(BOOL) isServerResultSuccessed: (NSDictionary*) result;
+(NSString*) getServerResultMsg: (NSDictionary*) result;


//货币格式化
+ (NSString *)getCurrencyFormatValue:(double)doubleValue;

+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidatePhone:(NSString *)phone;
//NSData 转换成16进制数
+ (NSString *)hexStringFromData:(NSData *)aData;
//MD5加密
+ (NSString *)md5:(NSString *)str;

//NSDate 转化成 NSString
+ (NSString *)dateStringFormDateWithFormat:(NSString *)format date:(NSDate *)aDate;

//NSString 转化成 NSDate
+ (NSDate *)dateFormDateStringWithFormat:(NSString *)format dateStr:(NSString *)aDataStr;

@end



@interface ServyouDefinesUI : NSObject 

+(UIColor*) ColorOrange;
+(UIColor*) ColorBlue;
+(UIColor*) ColorGray;
+(UIColor*) ColorDarkGray;

+(UIImage*) buttonBG;
+(UIImage*) comboxBG;
+(UIImage*) editBG;
@end

