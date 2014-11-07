//
//  LatestNotification.m
//  iTAXMC
//
//  Created by khuang on 14-7-9.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "LatestNotificationEntity.h"

//根据条件查询，条件要在前面加上" AND"
//NSString *cond = @" AND id < 8";

//self.datas = [entity findWithCondition:cond parameters:nil orderBy:nil];
//分页查询，先根据条件查出分页数据，然后把startIndex和endIndex交给findWithCondition查询
//PeakPagination pag = [entity paginationWithCondition:cond parameters:nil pageIndex:2 pageSize:3];
//self.datas = [entity findWithCondition:cond parameters:nil orderBy:orderBy startIndex:pag.startIndex endIndex:pag.endIndex];


@implementation LatestNotificationEntity

-(id) initWithFMDB:(FMDatabase *)database{
    self = [super initWithFMDB:database];
    if(self){
        //给表名赋值
        self.tableName = @"LatestNotification";
        //字段列表
        self.fields = @[
                            [LatestNotificationEntity notread_Col],
                            [LatestNotificationEntity title_Col],
                            [LatestNotificationEntity timestamp_Col],
                            [LatestNotificationEntity type_Col],
                            [LatestNotificationEntity msgid_Col],
                            [LatestNotificationEntity ID_Col]];
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
    self.notread = 0;
    self.title = nil;
    self.timestamp = 0;
    self.msgID = nil;
}

//获取所有字段存到数据库的值
-(NSArray *) insertParameters{
    return @[[NSNumber numberWithLong: self.notread]
             , [PeakSqlite nilFilter:self.title]
             , [PeakSqlite dateToValue: self.timestamp]
             , [PeakSqlite nilFilter: self.msgID]
             , [NSNumber numberWithLong:self.type]];
}
-(NSArray *) updateParameters{
    return @[[NSNumber numberWithLong: self.notread]
             , [PeakSqlite nilFilter:self.title]
             , [PeakSqlite dateToValue: self.timestamp]
             , [PeakSqlite nilFilter: self.msgID]
             , [NSNumber numberWithLong:self.type]];
}
-(NSArray *) parameters{
    return @[[NSNumber numberWithLong: self.notread]
             , [PeakSqlite nilFilter:self.title]
             , [PeakSqlite dateToValue: self.timestamp]
             , [PeakSqlite nilFilter: self.msgID]
             , [NSNumber numberWithLong:self.type]
             , [NSNumber numberWithLong: self.ID]];
}

//插入数据
-(NSInteger)insert{
    NSString *sql = @"INSERT INTO %@(%@) VALUES (%@)";
    NSString *insertFields = @"notread, title, timestamp, msgid, type";
    NSString *insertValues = @"?,?,?,?,?";
//    //没有指定ID
//    if(self.ID != NSNotFound){
//        insertFields = [insertFields stringByAppendingString: @", id"];
//        insertValues = [insertValues stringByAppendingString: @", ?"];
//    }
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
    NSString *sql = [NSString stringWithFormat: @"UPDATE %@ SET notread = ?, title = ?, timestamp = ?, msgid = ? WHERE type = ?", self.tableName];
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
    self.notread = [[data objectForKey:@"notread"] intValue];
    self.ID = [[data objectForKey:@"id"] intValue];
    self.timestamp = [PeakSqlite valueToDate: [data objectForKey:@"timestamp"]];
    self.title  = [PeakSqlite valueToString: [data objectForKey:@"title"]];
    self.type  = [[data objectForKey:@"type"] intValue];
    self.msgID = [PeakSqlite valueToString: [data objectForKey:@"msgid"]];
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

-(NSArray *) findAllWithOrderBy: (NSString *) orderBy
{
    NSArray *i= nil;
    @synchronized(self.database)
    {
        i = [super findAllWithOrderBy:orderBy];
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
    return @"LatestNotification";
}

+(NSString*)ID_Col{
    return @"id";
}
+(NSString*)notread_Col{
    return @"notread";
}
+(NSString*)title_Col{
    return @"title";
}
+(NSString*)timestamp_Col{
    return @"timestamp";
}
+(NSString*)type_Col{
    return @"type";
}
+(NSString*)msgid_Col{
    return @"msgid";
}

//创建数据库的sql语句
+(NSString *) sqlForCreateTable{
    //注意，日期类型在sqlite中不支持，所以日期类型会被转换为INTEGER类型,精确到秒
    return @"CREATE TABLE if not exists LatestNotification(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, notread INTEGER, title TEXT, timestamp INTEGER, type INTEGER, msgid TEXT)";
}
@end

