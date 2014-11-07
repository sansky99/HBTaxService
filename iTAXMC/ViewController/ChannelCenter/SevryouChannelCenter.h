//
//  SevryouChannelCenter.h
//  iTAXMC
//
//  Created by mac on 14-8-28.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelCenterData.h"

@class ChannelCenterDo;


@interface SevryouChannelCenter : NSObject/*<ExprotRebateHTMLRequestDelegate>*/

//最大偏移量 本次获取的最大偏移量
@property (nonatomic, strong) NSString *offset;


//渠道中心数据请求
- (void)sendChannelCenterHttpRequest;

//取消渠道中心网络请求
- (void)cancelChannelCenterHttpRequest;

- (NSInteger)getUnreadNumberWithChannelCenterType:(ChannelCenterEntityType)channelCenterType;

- (NSArray *)getAllItemsWithChannelCenterType:(ChannelCenterEntityType)channelCenterType;

- (void)cleanChannelCenterWithChannelCenterType:(ChannelCenterEntityType)channelCenterType;

- (NSArray *)getFirstOneWithType:(ChannelCenterEntityType)channelCenterType;

- (void)cleanChannelCenterReadWithCenterType:(ChannelCenterEntityType)channelCenterType
                                  activityId:(NSString *)activityID;
@end
