//
//  ChannelCenterEntity.h
//  XJTaxService
//
//  Created by mac on 14-9-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeakSqlite.h"
#import "ChannelCenterData.h"
@class ChannelCenterDo;


@interface ChannelCenterEntity : PeakSqlite

@property (nonatomic, strong) NSString *appId;

@property (nonatomic, strong) NSString *opCode;

//活动名称
@property (nonatomic, strong) NSString *activityName;
//活动描述
@property (nonatomic, strong) NSString *activityDesc;
//活动ID
@property (nonatomic, strong) NSString *activityId;

//发布时间
@property (nonatomic, strong) NSString *publishTime;

//业务规则 可能是内容
@property (nonatomic, strong) NSString *appointment;//url链接

@property (nonatomic, strong) NSString *isRead;

@property (nonatomic, strong) NSString *largeCata;

@property (nonatomic, strong) NSString *nsrsbh;

//返回字段名称
+(NSString *) appId_Col;
+(NSString *) opCode_Col;
+(NSString *) activityName_Col;
+(NSString *) activityDesc_Col;
+(NSString *) publishTime_Col;
+(NSString *) activityId_Col;
+(NSString *) appointment_Col;
+(NSString *) isRead_Col;
+(NSString *)largeCata_Col;
+ (NSString *)nsrsbh_Col;
+ (NSString *) sqlForCreateTable:(ChannelCenterEntityType)tableType;

-(id) initWithFMDB:(FMDatabase *)database tableType:(ChannelCenterEntityType)aTableType;
- (void)parseFromCenterDo:(ChannelCenterDo *)aCenterDo;


@end
