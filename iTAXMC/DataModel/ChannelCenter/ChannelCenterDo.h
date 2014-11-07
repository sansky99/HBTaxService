//
//  ChannelCenterDo.h
//  iTAXMC
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelCenterDo : NSObject<NSCoding>

//甲方应用ID
@property (nonatomic, strong) NSString *appId;

//appID+opCode来定义具体的业务操作
@property (nonatomic, strong) NSString *opCode;

//业务规则 可能是内容
@property (nonatomic, strong) NSString *appointment;//url链接

//活动名称
@property (nonatomic, strong) NSString *activityName;
//活动描述
@property (nonatomic, strong) NSString *activityDesc;
//活动ID
@property (nonatomic, strong) NSString *activityId;

//发布时间
@property (nonatomic, strong) NSString *publishTime;

@property (nonatomic, strong) NSString *largeCata;

@property (nonatomic, strong) NSString *nsrsbh;

- (id)initWithDict:(NSDictionary *)aDict;

@end
