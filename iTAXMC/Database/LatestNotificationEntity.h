//
//  LatestNotificationEntity.h
//  iTAXMC
//
//  Created by khuang on 14-7-9.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PeakSqlite.h"

//首页显示，新消息

@interface LatestNotificationEntity : PeakSqlite

//表单主键ID
@property (nonatomic) NSInteger ID;
//未读文件数
@property (nonatomic) NSInteger notread;
//最新文件标题
@property (nonatomic, strong) NSString *title;
//最新文件发布时间
@property (nonatomic, strong) NSDate *timestamp;
//类别标识
@property (nonatomic) NSInteger type;
//消息在Server的记录ID
@property (nonatomic, strong) NSString *msgID;


//返回字段名称
+(NSString *) ID_Col;
+(NSString *) notread_Col;
+(NSString *) title_Col;
+(NSString *) timestamp_Col;
+(NSString *) type_Col;
+(NSString *) msgid_Col;
@end
