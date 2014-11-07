//
//  ServyouDefines.m
//  iTAXMC
//
//  Created by khuang on 14-7-10.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ServyouDefines.h"
#import "FMDatabase.h"
#import "UserInfo.h"

#import "LatestNotificationEntity.h"
#import "AllNotificationEntity.h"
#import "ChannelCenterEntity.h"
#import <CommonCrypto/CommonCrypto.h>




@interface ServyouDefines()

@end


@implementation ServyouDefines

static NSArray* modules;
static FMDatabase *database;
static UserInfo *userInfo;

+(void) fillModules
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modules = @[
            @[@10000, @00000, @"消息",            @FALSE, @"", @"", @""]
            
            , @[@10100, @10000, @"消息",           @FALSE, @"", @"", @""]
            
            , @[@10101, @10100, @"代办事项",    @TRUE, @"", @"", @""]
            , @[@10102, @10100, @"涉税提醒",    @TRUE, @"", @"", @""]
            , @[@10103, @10100, @"通知公告",    @TRUE, @"", @"", @""]
            , @[@10104, @10100, @"最新政策",    @TRUE, @"", @"", @""]
 //=========================================================
            , @[@20000, @00000, @"涉税服务",@FALSE, @"", @"", @""]
            
            , @[@20100, @20000, @"发票管理",@TRUE, @"", @"", @""]
            , @[@20101, @20100, @"发票查验",@FALSE, @"", SERVER_PUBLIC_Invoice, @""]
           
            , @[@20200, @20000, @"查询预约",                           @FALSE, @"", @"", @""]
            , @[@20201, @20200, @"预约服务",@FALSE, @"", SERVER_PUBLIC_Service, @""]
            //modify by zgp 去掉申报结果查询
            //, @[@20202, @20200, @"申报结果查询",@TRUE, @"", SERVER_TAXSERVICE_SBJGCX, @""]
            , @[@20203, @20200, @"违法违章信息查询",@TRUE, @"", SERVER_Query_Illegal, @""]
            , @[@20204, @20200, @"申报情况查询",@TRUE, @"", SERVER_Query_DeclareInfo, @""]
            , @[@20205, @20200, @"缴款信息查询",@TRUE, @"", SERVER_Query_Paymentinformation, @""]
            , @[@20206, @20200, @"文书申请信息查询",@TRUE, @"", SERVER_Query_Paperwork, @""]
            
            , @[@20300, @20000, @"涉税申报",                          @FALSE, @"", @"", @""]
            , @[@20301, @20300, @"企业所得税月(季)度纳税申报(b类)",@TRUE, @"", SERVER_TAXSERVICE_QYSDS, @""]
            , @[@20302, @20300, @"消费税(金银首饰类)申报", @TRUE, @"", SERVER_TAXSERVICE_XFS, @""]
            , @[@20303, @20300, @"增值税小规模申报",      @TRUE, @"",SERVER_TAXSERVICE_ZZSXGMSB, @""]
            , @[@20304, @20300, @"网上缴款",             @TRUE, @"",SERVER_TAXSERVICE_WSJK, @""]
//=========================================================
            , @[@30000, @00000, @"公众服务",                           @FALSE, @"", @"", @""]
            
            , @[@30100, @30000, @"公众服务",                           @FALSE, @"", @"", @""]
            , @[@30101, @30100, @"办税指南",@FALSE, @"", SERVER_PUBLIC_TaxGuide, @""]
            , @[@30102, @30100, @"咨询留言",@FALSE, @"", SERVER_PUBLIC_CONSULT, @""]
            , @[@30103, @30100, @"办税地图",@FALSE, @"", SERVER_PUBLIC_TAXMAP, @""]
            , @[@30104, @30100, @"办税日历",@FALSE, @"", SERVER_PUBLIC_TAXCAL, @""]
            , @[@30105, @30100, @"纳税人学校",@FALSE, @"", SERVER_PUBLIC_NSRXX, @""]
            , @[@30106, @30100, @"咨询热点",@FALSE, @"", SERVER_PUBLIC_Hot, @""]
            , @[@30107, @30100, @"通知公告",@FALSE, @"",SERVER_Public_Notice, @""]
            , @[@30108, @30100, @"税宣专栏",@FALSE, @"", SERVER_Public_SXZL, @""]
        ];
    });
}

+(NSArray*) getModule:(NSNumber*) id
{
    [ServyouDefines fillModules];
    if (id)
    {
        for (NSArray* item in modules)
        {
            if ([item[Col_ID] isEqualToNumber:id])
                return item;
        }
    }
    return nil;
}

+(NSArray *) getModuleChildren:(NSNumber*) parentID
{
    [ServyouDefines fillModules];
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:10];
    for (NSArray* item in modules)
    {
        if ([item[Col_ParentID] isEqualToNumber:parentID])
        {
            [children addObject:item];
        }
    }
    return  [NSArray arrayWithArray:children];
}

+(FMDatabase*) sharedDatabase
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        path = [path stringByAppendingString:@"/global.db"];
        
        database = [[FMDatabase alloc] initWithPath:path];
        database.traceExecution = YES;
        
        //建表
        [database open];
        [database executeUpdate: [LatestNotificationEntity sqlForCreateTable]];
        [database executeUpdate: [AllNotificationEntity sqlForCreateTable]];
        [database executeUpdate: [ChannelCenterEntity sqlForCreateTable:EChannelCenterEntityType_TaxMeind]];
        [database executeUpdate: [ChannelCenterEntity sqlForCreateTable:EChannelCenterEntityType_TaxNotice]];
        [database executeUpdate: [ChannelCenterEntity sqlForCreateTable:EChannelCenterEntityType_Announcement]];
        [database executeUpdate: [ChannelCenterEntity sqlForCreateTable:EChannelCenterEntityType_PolicyNewest]];
        [database close];
    });

    return database;
}

+(UserInfo*) sharedUserInfo
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[UserInfo alloc] init];
        [userInfo load];
    });
    return userInfo;
}

+(BOOL) isServerResultSuccessed: (NSDictionary*) result
{
    NSDictionary *head = [result objectForKey:@"head"];
    if (nil != head)
    {
        NSString *code = [head valueForKey:@"code"];
        if (nil != code)
        {
            return (0 == [code integerValue]);
        }
    }
    return FALSE;
}

+(NSString*) getServerResultMsg: (NSDictionary*) result
{
    NSString *msg = nil;
    NSDictionary *head = [result objectForKey:@"head"];
    if (nil != head)
    {
        msg = [head valueForKey:@"msg"];
    }
    return msg;
}

+ (NSString *)getCurrencyFormatValue:(double)doubleValue
{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init] ;
    
    [numberFormatter setPositiveFormat:@"###,##0.00"];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:doubleValue]];
    
    return formattedNumberString;
}

+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidatePhone:(NSString *)phone {
    NSString *phoneRegex = @"[0-9][0-9 -]+[0-9]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (NSString *)hexStringFromData:(NSData *)aData{
    Byte *bytes = (Byte *)[aData bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[aData length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)dateStringFormDateWithFormat:(NSString *)format date:(NSDate *)aDate
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:format];//设定时间格式
    
    NSString *dateString = [dateFormat stringFromDate:aDate]; //求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    return dateString;
}

+ (NSDate *)dateFormDateStringWithFormat:(NSString *)format dateStr:(NSString *)aDataStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:format];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate *date =[dateFormat dateFromString:aDataStr];
    return date;
}

@end


@implementation ServyouDefinesUI

//+(UIColor*) ColorGreen
//{
//    static UIColor * color;
//    if (nil == color)
//        color = [UIColor colorWithRed:92/255.0 green:193/255.0 blue:97/255.0 alpha:1];
//    return color;
//}
+(UIColor*) ColorOrange
{
    static UIColor * color;
    if (nil == color)
        color = [UIColor colorWithRed:255/255.0 green:107/255.0 blue:00/255.0 alpha:1];
    return color;
}
+(UIColor*) ColorBlue
{
    static UIColor * color;
    if (nil == color)
        color = [UIColor colorWithRed:29/255.0 green:129/255.0 blue:229/255.0 alpha:1];
//        color = [UIColor colorWithRed:43/255.0 green:152/255.0 blue:236/255.0 alpha:1];
    return color;
}
+(UIColor*) ColorGray
{
    static UIColor * color;
    if (nil == color)
        color = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    return color;
}
+(UIColor*) ColorDarkGray
{
    static UIColor * color;
    if (nil == color)
        color = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    return color;
}
+(UIImage*) buttonBG
{
    static UIImage *bg=nil;
    if (bg == nil)
    {
        UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
        bg = [[UIImage imageNamed:@"greenBtnBG"] resizableImageWithCapInsets:insets];
    }
    return bg;
}

+(UIImage*) comboxBG
{
    static UIImage *bg=nil;
    if (bg == nil)
    {
        UIEdgeInsets insets = UIEdgeInsetsMake(5, 25, 30, 40);
         bg = [[UIImage imageNamed:@"comboxBGwithArrow"] resizableImageWithCapInsets:insets];
    }
    return bg;
}

+(UIImage*) editBG
{
    static UIImage *bg=nil;
    if (bg == nil)
    {
        UIEdgeInsets insets = UIEdgeInsetsMake(5, 25, 30, 40);
        bg = [[UIImage imageNamed:@"comboxBGnoArrow"] resizableImageWithCapInsets:insets];
    }
    return bg;
}
@end
