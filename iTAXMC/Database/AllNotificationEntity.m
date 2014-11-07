//
//  AllNotificationEntity.m
//  iTAXMC
//
//  Created by khuang on 14-7-9.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "AllNotificationEntity.h"

@implementation AllNotificationEntity

-(id) initWithFMDB:(FMDatabase *)database{
    self = [super initWithFMDB:database];
    if(self){
        //给表名赋值
        self.tableName = @"AllNotification";
        //字段列表
        self.fields = @[
                        [AllNotificationEntity type_Col],
                        [AllNotificationEntity msgid_Col],
                        [AllNotificationEntity title_Col],
                        [AllNotificationEntity iconurl_Col],
                        [AllNotificationEntity timestamp_Col],
                        [AllNotificationEntity remark_Col],
                        [AllNotificationEntity content_Col],
                        [AllNotificationEntity detailurl_Col],
                        [AllNotificationEntity ID_Col]];
        //主键的ID
        self.primaryField = @"id";
        [self setDefault];
    }
    return self;
}

//设置默认数据
-(void) setDefault{
    //清除数据
    self.ID = NSNotFound;
    self.type = 0;
    self.msgID = nil;
    self.title = nil;
    self.iconURL = nil;
    self.timestamp = 0;
    self.remark = nil;
    self.content = nil;
    self.detailURL = nil;
}

//获取所有字段存到数据库的值
-(NSArray *) insertParameters{
    return @[
               [NSNumber numberWithLong: self.type]
             , [PeakSqlite nilFilter:self.msgID]
             , [PeakSqlite nilFilter:self.title]
             , [PeakSqlite nilFilter:self.iconURL]
             , [PeakSqlite dateToValue: self.timestamp]
             , [PeakSqlite nilFilter:self.remark]
             ];
}
-(NSArray *) updateParameters{
    return @[
               [PeakSqlite nilFilter:self.content]
             , [PeakSqlite nilFilter:self.detailURL]
             , [PeakSqlite nilFilter:self.msgID]];
}
-(NSArray *) parameters{
    return @[
               [NSNumber numberWithLong: self.type]
             , [PeakSqlite nilFilter:self.msgID]
             , [PeakSqlite nilFilter:self.title]
             , [PeakSqlite nilFilter:self.iconURL]
             , [PeakSqlite dateToValue: self.timestamp]
             , [PeakSqlite nilFilter:self.remark]
             , [PeakSqlite nilFilter:self.content]
             , [PeakSqlite nilFilter:self.detailURL]
             , [NSNumber numberWithLong: self.ID]];
}

//插入数据
-(NSInteger)insert{
    NSString *sql = @"INSERT INTO %@(%@) VALUES (%@)";
    NSString *insertFields = @"type, msgid, title, picurl, timestamp, remark";
    NSString *insertValues = @"?,?,?,?,?,?";
    sql = [NSString stringWithFormat: sql, self.tableName, insertFields, insertValues];
    NSInteger i = 0;
    @synchronized(self.database)
    {
        i = [self insertWithSql:sql parameters: [self insertParameters]];
    }
    return i;
}

//更新数据
-(BOOL)update{
    NSString *sql = [NSString stringWithFormat: @"UPDATE %@ SET content = ?, detailurl = ? WHERE msgid = ?", self.tableName];
    BOOL result = FALSE;
    @synchronized(self.database)
    {
        [self.database open];
        result = [self.database executeUpdate:sql withArgumentsInArray: [self updateParameters]];
        [self.database close];
    }
    return result;
}

//转换字典到当前实例
-(void)parseFromDictionary: (NSDictionary *) data{
    self.data = data;
    self.ID = [[data objectForKey:@"id"] intValue];
    self.type  = [[data objectForKey:@"type"] intValue];
    self.msgID = [PeakSqlite valueToString: [data objectForKey:@"msgid"]];
    self.title  = [PeakSqlite valueToString: [data objectForKey:@"title"]];
    self.iconURL  = [PeakSqlite valueToString: [data objectForKey:@"iconurl"]];
    self.timestamp = [PeakSqlite valueToDate: [data objectForKey:@"timestamp"]];
    self.remark  = [PeakSqlite valueToString: [data objectForKey:@"remark"]];
    self.content  = [PeakSqlite valueToString: [data objectForKey:@"content"]];
    self.detailURL  = [PeakSqlite valueToString: [data objectForKey:@"detailurl"]];
}

//获取一条数据
-(BOOL) findOneWithCondition:(NSString *)cond parameters:(NSArray *)params orderBy:(NSString *)orderBy{
    BOOL result = FALSE;
    @synchronized(self.database)
    {
        result = [super findOneWithCondition:cond parameters:params orderBy:orderBy];
    }
    //将数据填充到属性
    if(result){
        [self parseFromDictionary: self.data];
    }else{
        //没有找到数据，还原为初始值
        [self setDefault];
    }
    return result;
}

-(NSInteger) countWithCondition:(NSString *)cond parameters:(NSArray *)params
{
    NSInteger i= 0;
    @synchronized(self.database)
    {
        i = [super countWithCondition:cond parameters:params];
    }
    return i;
}
//==================获取字段名及表名==================
////获取所有的字段名称
//+(NSArray *) fields{
//    return @[@"id", @"todo", @"timestamp", @"done"];
//}

//获取表名
+(NSString*)tableName{
    return @"AllNotification";
}

+(NSString *) ID_Col{
    return @"id";
}
+(NSString *) type_Col{
    return @"type";
}
+(NSString *) msgid_Col{
    return @"msgid";
}
+(NSString *) title_Col{
    return @"title";
}
+(NSString *) iconurl_Col{
    return @"iconurl";
}
+(NSString *) timestamp_Col{
    return @"timestamp";
}
+(NSString *) remark_Col{
    return @"remark";
}
+(NSString *) content_Col{
    return @"content";
}
+(NSString *) detailurl_Col{
    return @"detailurl";
}


//创建数据库的sql语句
+(NSString *) sqlForCreateTable{
    //注意，日期类型在sqlite中不支持，所以日期类型会被转换为INTEGER类型,精确到秒
    return @"CREATE TABLE if not exists AllNotification(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, type INTEGER, msgid TEXT, title TEXT, iconurl TEXT, timestamp INTEGER, remark TEXT, content TEXT, detailurl TEXT)";
}

@end
