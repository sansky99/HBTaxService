//
//  SevryouChannelCenter.m
//  iTAXMC
//
//  Created by mac on 14-8-28.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "SevryouChannelCenter.h"
#import "JSON.h"
#import "UserInfo.h"
#import "ServyouDefines.h"
#import "ChannelCenterDo.h"
#import "ASIHTTPRequest.h"
#import "NSData+Encryption.h"
#import "ChannelCenterEntity.h"

NSString *const KOffset = @"KOffset";

@interface SevryouChannelCenter ()
{
    //request 对象
    ASIHTTPRequest *httpRequest;
    //请求地址
    NSString *reuestURL;
}

@end

@implementation SevryouChannelCenter
@synthesize offset = _offset;

- (id)init
{
    if (self = [super init])
    {
        NSString *offset = [[NSUserDefaults standardUserDefaults] objectForKey:KOffset];
        if ([offset isEqualToString:@"<null>"]||!offset)
        {
            self.offset = @"1";
        }
        else
        {
            self.offset = offset;
        }
        
        NSString *userID = /*@"440402787917911";//*/[self getNsrsbh];
        reuestURL = [[NSString alloc] initWithFormat:SERVER_CHANNEL_URL,userID,self.offset];
    
    }
    return self;
}



//纳税人识别号
- (NSString *)getNsrsbh
{
    UserInfo *user = [ServyouDefines sharedUserInfo];
    if ([user isLogin])
    {
        return user.nsrsbhStr;
    }
    return StringEmpty;
}

- (void)sendChannelCenterHttpRequest
{
    httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString: reuestURL]];
    httpRequest.delegate = self;
    httpRequest.requestMethod = @"GET";
    [httpRequest addRequestHeader:@"user_auth" value:[self getHeaderStr]];
    [httpRequest startAsynchronous];
}

//取消网络请求
- (void)cancelChannelCenterHttpRequest
{
    [httpRequest cancel];
}

- (void)dealloc
{

    [self cancelChannelCenterHttpRequest];
}


- (NSString *)getHeaderStr
{
    NSString *nsrsbh = [self getNsrsbh];
    NSDictionary *tokenDict = @{@"nsrsbh":nsrsbh};
    NSString *tokenStr = [tokenDict JSONRepresentation];
    NSData *tokenData = [tokenStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *key = ChannelCenter_Encryption_Key;
    NSData *tokenEncode = [tokenData AES256EncryptWithKey:key];
    
    NSString *encodeTokenStr = [ServyouDefines hexStringFromData:tokenEncode];//[self hexStringFromData:tokenEncode];
    encodeTokenStr = [encodeTokenStr uppercaseString];
    
    NSDictionary *checkDict = @{@"authType":@"2",@"token":encodeTokenStr};
    NSString *checkStr = [checkDict JSONRepresentation];
    return checkStr;
}

#if 0
- (NSString *)hexStringFromData:(NSData *)aData{
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

#endif
- (void)wsdcDataParseWithChenterDo:(ChannelCenterDo *)centerDo
{
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:EChannelCenterEntityType_TaxMeind];
    entity.activityId = centerDo.activityId;
    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity activityId_Col]];
    BOOL isOK = [entity findOneWithCondition:condition parameters:@[entity.activityId] orderBy:nil];
    
    [entity parseFromCenterDo:centerDo];
    if (isOK)
    {
        [entity update];
    }
    else
    {
        [entity insert];
    }
    
}

- (void)tzggDataParseWithChenterDo:(ChannelCenterDo *)centerDo
{
    NSString *appointment = centerDo.appointment;
    NSDictionary *appointmentDict = [appointment JSONValue];
    NSString *largeCata = [[NSString alloc] initWithFormat:@"%@",[appointmentDict objectForKey:@"largeCata"]];
    ChannelCenterEntityType entityType;
    if ([largeCata isEqualToString:@"40"]) {//政策解读
        entityType = EChannelCenterEntityType_PolicyNewest;
    }
    else if ([largeCata isEqualToString:@"10"])//通知公告
    {
        entityType = EChannelCenterEntityType_Announcement ;
    }
    else if ([largeCata isEqualToString:@"20"])//办税提醒
    {
        entityType = EChannelCenterEntityType_TaxNotice;
    }
    else
    {
        return;
    }
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:entityType];
    
    entity.activityId = centerDo.activityId;
    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity activityId_Col]];
    BOOL isOK = [entity findOneWithCondition:condition parameters:@[entity.activityId] orderBy:@""];
    
    [entity parseFromCenterDo:centerDo];
    entity.largeCata = largeCata;

    if (isOK)
    {
        [entity update];
    }
    else
    {
        [entity insert];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIHTTPRequestDelegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);

}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString JSONValue];
    NSString *status = [[result objectForKey:@"head"] objectForKey:@"code"];
    if ([status isEqualToString:@"00000000"])
    {        //解析包内容
        NSArray *package = [[result objectForKey:@"body"] objectForKey:@"package"];
        NSString *offset = [[NSString alloc] initWithFormat:@"%@",[[result objectForKey:@"body"] objectForKey:@"offset"]];
        for (NSDictionary *tempDict in package)
        {
            ChannelCenterDo *centerDo = [[ChannelCenterDo alloc] initWithDict:tempDict];
            centerDo.nsrsbh = userInfo.nsrsbhStr;
            if ([centerDo.opCode isEqualToString:@"wsdc"])
            {
                [self wsdcDataParseWithChenterDo:centerDo];
            }
            else if ([centerDo.opCode isEqualToString:@"tzgg"])
            {
                [self tzggDataParseWithChenterDo:centerDo];
            }
        }
        if ([package count] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:offset forKey:KOffset];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kChannelNotificationCenter
                                                            object:nil];
    }
}


#pragma mark - 数据
- (NSArray *)getUnreadNumberWithType:(ChannelCenterEntityType)channelCenterType
                           condition:(NSString *)condition
                          parameters:(NSArray *)parameters
                             orderBy:(NSString *)orderBy
{
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:channelCenterType];
    
    NSArray *items = [entity findWithCondition:condition
                                    parameters:parameters
                                       orderBy:orderBy];
    return items;
}

- (NSArray *)getFirstOneWithType:(ChannelCenterEntityType)channelCenterType
{
    return [NSArray array];
    //河北暂时移除
//    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
//                                                                  tableType:channelCenterType];
//    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity nsrsbh_Col]];
//    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
//    NSArray *nsrshbItems = @[userInfo.nsrsbhStr];
//    NSArray *items = [entity findWithCondition:condition parameters:nsrshbItems orderBy:nil startIndex:0 endIndex:NSIntegerMax];
//    return items;
}

- (NSInteger)getUnreadNumberWithChannelCenterType:(ChannelCenterEntityType)channelCenterType
{
    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity isRead_Col]];
    
    NSArray *items = [self getUnreadNumberWithType:channelCenterType
                                         condition:condition
                                        parameters:@[@"NO"]
                                           orderBy:StringEmpty];
    
    return [items count];
}

- (NSArray *)getAllItemsWithChannelCenterType:(ChannelCenterEntityType)channelCenterType
{
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:channelCenterType];
    NSString *orderBy = [NSString stringWithFormat: @" ORDER BY %@ DESC", [ChannelCenterEntity publishTime_Col]];
    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity nsrsbh_Col]];
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    NSArray *nsrshbItems = @[userInfo.nsrsbhStr];
    NSArray *items = [entity findWithCondition:condition parameters:nsrshbItems orderBy:orderBy startIndex:0 endIndex:NSIntegerMax];
    //NSArray *items = [entity findAllWithOrderBy:orderBy];
    return items;
}


- (void)cleanChannelCenterWithChannelCenterType:(ChannelCenterEntityType)channelCenterType
{
    NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [ChannelCenterEntity isRead_Col]];
    
    NSArray *items = [self getUnreadNumberWithType:channelCenterType
                                         condition:condition
                                        parameters:@[@"NO"]
                                           orderBy:StringEmpty];
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:channelCenterType];
    
    for (NSDictionary *tempDict in items)
    {
        [entity parseFromDictionary:tempDict];
        entity.isRead = @"YES";
        [entity update];
    }
}

- (void)cleanChannelCenterReadWithCenterType:(ChannelCenterEntityType)channelCenterType
                                  activityId:(NSString *)activityID
{
    ChannelCenterEntity *entity = [[ChannelCenterEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]
                                                                  tableType:channelCenterType];
    NSString *condition = [NSString stringWithFormat:@"AND %@ = ?",[ChannelCenterEntity activityId_Col]];
    NSArray *items = [entity findWithCondition:condition
                                    parameters:@[activityID]
                                       orderBy:StringEmpty];
    for (NSDictionary *tempDict in items)
    {
        [entity parseFromDictionary:tempDict];
        entity.isRead = @"YES";
        [entity update];
    }
    
}

@end
