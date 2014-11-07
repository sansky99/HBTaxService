//
//  AllNotification.h
//  iTAXMC
//
//  Created by khuang on 14-7-9.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PeakSqlite.h"

//所有新闻政策的列表和详情

@interface AllNotificationEntity : PeakSqlite

//表单主键ID
@property (nonatomic) NSInteger ID;
//类别标识
@property (nonatomic) NSInteger type;
//在Server的记录ID
@property (nonatomic, strong) NSString *msgID;
//标题
@property (nonatomic, strong) NSString *title;
//小图片URL
@property (nonatomic, strong) NSString *iconURL;
//发布时间
@property (nonatomic, strong) NSDate *timestamp;
//摘要
@property (nonatomic, strong) NSString *remark;
//内容(爬取)
@property (nonatomic, strong) NSString *content;
//详情URL(网页原文)
@property (nonatomic, strong) NSString *detailURL;



//返回字段名称
+(NSString *) ID_Col;
+(NSString *) type_Col;
+(NSString *) msgid_Col;
+(NSString *) title_Col;
+(NSString *) iconurl_Col;
+(NSString *) timestamp_Col;
+(NSString *) remark_Col;
+(NSString *) content_Col;
+(NSString *) detailurl_Col;
@end
