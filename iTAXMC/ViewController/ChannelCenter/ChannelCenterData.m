//
//  ChannelCenterData.m
//  ZHTaxService
//
//  Created by mac on 14-9-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ChannelCenterData.h"
#import "SevryouChannelCenter.h"
#import "ChannelCenterDo.h"

//通知中心 KEY
NSString *const kChannelNotificationCenter = @"kChannelNotificationCenter";


@interface ChannelCenterData ()
{
    SevryouChannelCenter *channelCenter;
}

@end

@implementation ChannelCenterData
@synthesize newestItems = _newestItems;
@synthesize unReadItems = _unReadItems;

- (id)init
{
    if (self = [super init])
    {
        channelCenter = [[SevryouChannelCenter alloc] init];
        _newestItems = [[NSMutableArray alloc] init];
        _unReadItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)loadData
{
    NSArray *item1 = [channelCenter getFirstOneWithType:EChannelCenterEntityType_TaxMeind];
    NSArray *item2 = [channelCenter getFirstOneWithType:EChannelCenterEntityType_TaxNotice];
    NSArray *item3 = [channelCenter getFirstOneWithType:EChannelCenterEntityType_Announcement];
    NSArray *item4 = [channelCenter getFirstOneWithType:EChannelCenterEntityType_PolicyNewest];
    
    
    if (item1.count>0)
    {
        NSDictionary *TaxNoticeDict = [item1 lastObject];
        ChannelCenterDo *centerDo = [self activityParse:TaxNoticeDict];
        [_newestItems addObject:centerDo];
    }
    
    if (item2.count>0)
    {
        NSDictionary *AnnouncementDict = [item2 lastObject];
        ChannelCenterDo *centerDo = [self activityParse:AnnouncementDict];
        [_newestItems addObject:centerDo];
    }

    if (item3.count>0)
    {
        NSDictionary *PolicyNewestDict = [item3 lastObject];
        ChannelCenterDo *centerDo = [self activityParse:PolicyNewestDict];
        [_newestItems addObject:centerDo];
    }
    
    if (item4.count>0)
    {
        NSDictionary *TaxMeindDict = [item4 lastObject];
        ChannelCenterDo *centerDo = [self activityParse:TaxMeindDict];
        [_newestItems addObject:centerDo];
    }
    
//    self.newestItems = [self sortWithArray:self.newestItems];
    ChannelCenterEntityType centerType = EChannelCenterEntityType_TaxMeind;
    
    for (ChannelCenterDo *center in self.newestItems)
    {
        if ([center.opCode isEqualToString:@"wsdc"])
        {
            centerType = EChannelCenterEntityType_TaxMeind;
            
        }
        else if ([center.opCode isEqualToString:@"tzgg"])
        {
            if ([center.largeCata isEqualToString:@"40"]) {//政策解读
                centerType = EChannelCenterEntityType_PolicyNewest;
            }
            else if ([center.largeCata isEqualToString:@"10"])//通知公告
            {
                centerType = EChannelCenterEntityType_Announcement ;
            }
            else if ([center.largeCata isEqualToString:@"20"])//办税提醒
            {
                centerType = EChannelCenterEntityType_TaxNotice;
            }
            
        }
        NSInteger unreadNumber = [channelCenter getUnreadNumberWithChannelCenterType:centerType];
        NSNumber *unRead = [NSNumber numberWithInteger:unreadNumber];
        [self.unReadItems addObject:unRead];
    }

}


- (NSArray *)getChannelCenterItemsWithType:(ChannelCenterEntityType)aType
{
    NSArray *items = [channelCenter getAllItemsWithChannelCenterType:aType];
    if (items)
    {
        return items;
    }
    return nil;
}

//清楚未读消息
- (void)cleanChannelCenterWithChannelCenterType:(ChannelCenterEntityType)channelCenterType
{
    [channelCenter cleanChannelCenterWithChannelCenterType:channelCenterType];
}

- (void)cleanChannelCenterReadWithCenterType:(ChannelCenterEntityType)channelCenterType
                                  activityId:(NSString *)activityID
{
    [channelCenter cleanChannelCenterReadWithCenterType:channelCenterType
                                             activityId:activityID];
}


- (ChannelCenterDo *)activityParse:(NSDictionary *)tempDict
{
    ChannelCenterDo *centerDo = [[ChannelCenterDo alloc] init];
    NSString *activityDesc = [tempDict objectForKey:@"activityDesc"];
    id activityId = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"activityId"]];
    id activityName = [tempDict objectForKey:@"activityName"];
    id appointment = [tempDict objectForKey:@"appointment"];
    NSString *opCode = [tempDict objectForKey:@"opCode"];
    NSString *appId = [tempDict objectForKey:@"appId"];
    NSString *publishTime = [[NSString alloc] initWithFormat:@"%@",[tempDict objectForKey:@"publishTime"]];
    centerDo.activityDesc = activityDesc==[NSNull null]?StringEmpty:activityDesc;
    centerDo.activityId = activityId==[NSNull null]?StringEmpty:activityId;
    centerDo.activityName = activityName==[NSNull null]?StringEmpty:activityName;
    centerDo.appointment = appointment==[NSNull null]?StringEmpty:appointment;
    centerDo.publishTime = publishTime == [NSNull null]?StringEmpty:publishTime;
    centerDo.opCode = ((id)opCode==[NSNull null])?StringEmpty:opCode;
    centerDo.appId = ((id)appId==[NSNull null])?StringEmpty:appId;
    centerDo.largeCata = [tempDict objectForKey:@"largeCata"];
    centerDo.nsrsbh = [tempDict objectForKey:@"nsrsbh"];
    return centerDo;
}


- (NSMutableArray *)sortWithArray:(NSMutableArray *)items
{
    NSInteger count = items.count;
    
    int low = 0;
    int high = count -1;
    ChannelCenterDo *tempCenter;
    while (low < high)
    {
        for (int index = low; index < high; index ++)
        {
            ChannelCenterDo *center1 = items[index];
            ChannelCenterDo *center2 = items[index+1];
            if ([center1.publishTime compare:center2.publishTime] == NSOrderedAscending)
            {
                tempCenter = items[index];
                items[index]=items[index+1];
                items[index+1] = tempCenter;
            }
        }
        --high;
        
    }
    return items;
}

@end
