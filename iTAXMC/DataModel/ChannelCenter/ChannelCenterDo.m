//
//  ChannelCenterDo.m
//  iTAXMC
//
//  Created by mac on 14-8-29.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ChannelCenterDo.h"

//甲方运用ID key
NSString *const kChannelCenterAppId = @"kChannelCenterAppId";
//操作类型代码 key
NSString *const kOpCode = @"kOpCode";
//业务规则 key
NSString *const kAppointment = @"kAppointment";

NSString *const KActivityName = @"KActivityName";
NSString *const KActivityDesc = @"KActivityDesc";
NSString *const KActivityId = @"KActivityId";
NSString *const KPublishTime = @"KPublishTime";
NSString *const KLargeCata = @"KLargeCata";
NSString *const KNsrsbh = @"KNsrsbh";

@implementation ChannelCenterDo
@synthesize activityDesc = _activityDesc ;
@synthesize activityName = _activityName;
@synthesize activityId = _activityId;
@synthesize appId = _appId;
@synthesize opCode = _opCode;
@synthesize appointment = _appointment;
@synthesize publishTime = _publishTime;
@synthesize largeCata = _largeCata;
@synthesize nsrsbh = _nsrsbh;

- (id)initWithDict:(NSDictionary *)aDict
{
    if (self = [super init])
    {
        self.appId = [self checkData:[aDict objectForKey:@"appId"]];
        self.activityDesc = [self checkData:[aDict objectForKey:@"activityDesc"]];
        self.activityId = [[NSString alloc] initWithFormat:@"%@", [self checkData:[aDict objectForKey:@"activityId"]]];
        self.activityName = [self checkData:[aDict objectForKey:@"activityName"]];
        self.appointment = [self checkData:[aDict objectForKey:@"appointment"]];
        self.publishTime = [self checkData:[aDict objectForKey:@"publishTime"]];
        self.opCode = [self checkData:[aDict objectForKey:@"opCode"]];
        self.largeCata = StringEmpty;//[self checkData:[aDict objectForKey:@"largeCata"]];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.activityDesc = [aDecoder decodeObjectForKey:KActivityDesc];
        self.activityId = [aDecoder decodeObjectForKey:KActivityId];
        self.activityName = [aDecoder decodeObjectForKey:KActivityName];
        self.appId = [aDecoder decodeObjectForKey:kChannelCenterAppId];
        self.opCode = [aDecoder decodeObjectForKey:kOpCode];
        self.appointment  = [aDecoder decodeObjectForKey:kAppointment];
        self.publishTime = [aDecoder decodeObjectForKey:KPublishTime];
        self.largeCata = [aDecoder decodeObjectForKey:KLargeCata];
        self.nsrsbh = [aDecoder decodeObjectForKey:KNsrsbh];

        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.activityDesc forKey:KActivityDesc];
    [aCoder encodeObject:self.activityId forKey:KActivityId];
    [aCoder encodeObject:self.activityName forKey:KActivityName];
    [aCoder encodeObject:self.appointment forKey:kAppointment];
    [aCoder encodeObject:self.appId forKey:kChannelCenterAppId];
    [aCoder encodeObject:self.opCode forKey:kOpCode];
    [aCoder encodeObject:self.publishTime forKey:KPublishTime];
    [aCoder encodeObject:self.largeCata forKey:KLargeCata];
    [aCoder encodeObject:self.nsrsbh forKey:KNsrsbh];
 
}

- (id)checkData:(id)aData
{
    return (aData == [NSNull null])?StringEmpty:aData;
}

@end
