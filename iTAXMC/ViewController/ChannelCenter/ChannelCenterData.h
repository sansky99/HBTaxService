//
//  ChannelCenterData.h
//  ZHTaxService
//
//  Created by mac on 14-9-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

//渠道中心 通知
extern NSString *const kChannelNotificationCenter;

typedef enum ChannelCenterEntityType
{
    EChannelCenterEntityType_TaxMeind,//待办事项
    
    EChannelCenterEntityType_TaxNotice,//涉税通知
    
    EChannelCenterEntityType_Announcement,//通知公告
    
    EChannelCenterEntityType_PolicyNewest //最新政策
    
}ChannelCenterEntityType;

@interface ChannelCenterData : NSObject

//最新信息
@property (nonatomic, strong) NSMutableArray *newestItems;

//未读消息数
@property (nonatomic, strong) NSMutableArray *unReadItems;

- (NSArray *)getChannelCenterItemsWithType:(ChannelCenterEntityType)aType;

- (void)cleanChannelCenterWithChannelCenterType:(ChannelCenterEntityType)channelCenterType;

- (void)cleanChannelCenterReadWithCenterType:(ChannelCenterEntityType)channelCenterType
                                  activityId:(NSString *)activityID;

- (void)loadData;

@end
