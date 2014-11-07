//
//  MessageCenter.m
//  iTAXMC
//
//  Created by khuang on 14-7-10.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "MessageCenter.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "AllNotificationEntity.h"
#import "LatestNotificationEntity.h"

#define SERVER_RESULT_MAX_RECORDS   50      //查询列表时，Server约定每次只取50条记录

NSString *const kNewMessageNotification = @"NewMessageNotification";
NSString *const kNewMessageNotification_Type = @"NewMessageNotification_Type";
//NSString *

@implementation MessageCenter

static MessageCenter *messageCenter;
static NSMutableDictionary *monited;        //监测更新的

+(MessageCenter*) sharedMessageCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter = [[MessageCenter alloc] init];
        
        monited = [[NSMutableDictionary alloc] initWithCapacity:9];
        [monited setObject:[NSNull null] forKey:@20101];
        [monited setObject:[NSNull null] forKey:@20201];
    });
    return messageCenter;
}

-(void) refreshMessages
{
    @synchronized(monited)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:monited];
        for (NSNumber* moduleID in dict) {
            [self refreshMessage:moduleID];
        }
    }
}

-(void) refreshMessages:(NSArray*) moduleIDs
{
    @synchronized(monited)
    {
        for (NSNumber* moduleID in moduleIDs) {
            [self refreshMessage:moduleID];
        }
    }
}

-(void) refreshMessage:(NSNumber*) moduleID
{
    id request = [monited objectForKey:moduleID];
    if (nil==request || request != [NSNull null])
        return;
    
    NSArray *module = [ServyouDefines getModule:moduleID];
    if (module)
    {
        NSString *postTypeName = module[Col_URLType];
        [monited setObject:[[ASIFormDataRequest alloc] init] forKey:moduleID];      //占位，阻止下一个刷新
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            //更新前得到数据库内最新的记录ID
            AllNotificationEntity *entity = [[AllNotificationEntity alloc] initWithFMDB: [ServyouDefines sharedDatabase]];
            NSString *condition = [NSString stringWithFormat:@" AND %@ = ?", [AllNotificationEntity type_Col]];
            NSString *orderby = [NSString stringWithFormat:@" ORDER BY %@ DESC, %@ DESC", [AllNotificationEntity timestamp_Col], [AllNotificationEntity ID_Col]];
            BOOL bFind0 = [entity findOneWithCondition:condition parameters:@[moduleID] orderBy:orderby];
            NSString* limitID = entity.msgID;
            if (!bFind0)
                limitID = @"0";
            
            //循环从server获取记录，直至没有记录或记录ID等于limitID
            int offset = 0;
            BOOL bLoop = TRUE;
            
            while (bLoop) {

                NSString *strUrl = [NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, module[Col_URL]];
                ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
                [monited setObject:request forKey:moduleID];
                
                [request setTimeOutSeconds:20];
                
                [request setPostValue:postTypeName forKey:@"type"];
                [request setPostValue:[NSString stringWithFormat:@"%d", offset] forKey:@"offset"];
                [request setPostValue:@"Y" forKey:@"needPic"];
                [request setPostValue:@"Y" forKey:@"needRemark"];
                
                [request startSynchronous];
            
                if (0 == [request responseStatusCode])
                {
                    NSString *strJSON = [request responseString];
                    
                    bLoop = [self parserListResult:strJSON limitID:limitID];
                    offset += SERVER_RESULT_MAX_RECORDS;
                }
                else
                    bLoop = FALSE;
            }
            
           //更新后得到数据库内最新的记录ID
            bFind0 = [entity findOneWithCondition:condition parameters:@[moduleID] orderBy:orderby];
            //更新LatestNotificationEntity内未读消息数
            LatestNotificationEntity *latestEntity = [[LatestNotificationEntity alloc] initWithFMDB:[ServyouDefines sharedDatabase]];
            BOOL bFind = [latestEntity findOneWithCondition:[NSString stringWithFormat:@" AND %@ = ?", [LatestNotificationEntity type_Col] ]  parameters:@[moduleID] orderBy:nil];
           AllNotificationEntity *allEntity = [[AllNotificationEntity alloc] initWithFMDB: [ServyouDefines sharedDatabase]];
           if (bFind)
            {
                latestEntity.notread = [allEntity countWithCondition:@" AND type = ? AND timestamp > ?" parameters:@[moduleID, [PeakSqlite dateToValue: latestEntity.timestamp]] ];
                latestEntity.title = entity.title;
                latestEntity.timestamp = entity.timestamp;
                latestEntity.msgID = entity.msgID;
                [latestEntity update];
            }
            else
            {
                latestEntity.notread = [allEntity countWithCondition:@" AND type = ?" parameters:@[moduleID]];
                latestEntity.type = [moduleID integerValue];
                latestEntity.title = entity.title;
                latestEntity.timestamp = entity.timestamp;
                latestEntity.msgID = entity.msgID;
                [latestEntity insert];
            }

            //通知主页刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageNotification object:self userInfo:@{ kNewMessageNotification_Type : moduleID }];
            
            [monited setObject:[NSNull null] forKey:moduleID];
        });
    }
}

-(BOOL) parserListResult:(NSString*) json limitID:(NSString*) limitID
{   //将新的新闻政策的列表信息写入数据库AllNotificationEntity

    NSDictionary *result = [json objectFromJSONString];
    if ([ServyouDefines isServerResultSuccessed:result])
    {
        NSArray *items = [result objectForKey:@"body"];
        for (NSDictionary *item in items)
        {
            NSString * recID =[item objectForKey:@"id"];
            if ([recID isEqualToString:limitID])        //此记录本地数据库已存, 不再存入数据库
                return FALSE;
            
            AllNotificationEntity *entity = [[AllNotificationEntity alloc] initWithFMDB: [ServyouDefines sharedDatabase]];
            entity.msgID = recID;
            entity.title = [item objectForKey:@"title"];
            entity.iconURL = [item objectForKey:@"picUrl"];
            entity.remark = [item objectForKey:@"remark"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            entity.timestamp = [df dateFromString:[item objectForKey:@"publishDate"]];
            [entity insert];
        }
        return items.count == SERVER_RESULT_MAX_RECORDS;
    }
    return FALSE;
}
@end
