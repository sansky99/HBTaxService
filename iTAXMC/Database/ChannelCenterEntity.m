//
//  ChannelCenterEntity.m
//  XJTaxService
//
//  Created by mac on 14-9-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ChannelCenterEntity.h"
#import "ChannelCenterDo.h"

@implementation ChannelCenterEntity

-(id) initWithFMDB:(FMDatabase *)database tableType:(ChannelCenterEntityType)aTableType{
    self = [super initWithFMDB:database];
    if(self){
        //给表名赋值
        self.tableName = [ChannelCenterEntity getTableNameWithChannelCenterType:aTableType];
        //字段列表
        self.fields = @[
                        [ChannelCenterEntity appId_Col],
                        [ChannelCenterEntity opCode_Col],
                        [ChannelCenterEntity activityName_Col],
                        [ChannelCenterEntity activityDesc_Col],
                        [ChannelCenterEntity activityId_Col],
                        [ChannelCenterEntity publishTime_Col],
                        [ChannelCenterEntity appointment_Col],
                        [ChannelCenterEntity isRead_Col],
                        [ChannelCenterEntity largeCata_Col],
                        [ChannelCenterEntity nsrsbh_Col]];
        //主键的ID
        self.primaryField = @"activityId";
        [self setDefault];
    }
    return self;
}

//设置默认数据
-(void) setDefault{
    //清除数据
    self.appId = nil;
    self.opCode = nil;
    self.activityName = nil ;
    self.activityDesc = nil;
    self.activityId = nil;
    self.publishTime = nil;
    self.appointment = nil;
    self.isRead = nil;
    self.largeCata = nil;
    self.nsrsbh = nil;
}

//获取所有字段存到数据库的值
-(NSArray *) insertParameters{
    return @[[PeakSqlite nilFilter:self.opCode]
             , [PeakSqlite nilFilter:self.activityName]
             , [PeakSqlite nilFilter:self.activityDesc]
             , [PeakSqlite nilFilter:self.activityId]
             , [PeakSqlite nilFilter:self.publishTime]
             , [PeakSqlite nilFilter:self.appointment]
             , [PeakSqlite nilFilter:self.isRead]
             , [PeakSqlite nilFilter:self.largeCata]
             , [PeakSqlite nilFilter:self.nsrsbh]];
}
-(NSArray *) updateParameters{
    return @[[PeakSqlite nilFilter:self.opCode]
             , [PeakSqlite nilFilter:self.activityName]
             , [PeakSqlite nilFilter:self.activityDesc]
             , [PeakSqlite nilFilter:self.appId]
             , [PeakSqlite nilFilter:self.publishTime]
             , [PeakSqlite nilFilter:self.appointment]
             , [PeakSqlite nilFilter:self.isRead]
             , [PeakSqlite nilFilter:self.largeCata]
             , [PeakSqlite nilFilter:self.nsrsbh]
             , [PeakSqlite nilFilter:self.activityId]];
    
}
-(NSArray *) parameters{
    return @[[PeakSqlite nilFilter:self.opCode]
             , [PeakSqlite nilFilter:self.activityName]
             , [PeakSqlite nilFilter:self.activityDesc]
             , [PeakSqlite nilFilter:self.appId]
             , [PeakSqlite nilFilter:self.publishTime]
             , [PeakSqlite nilFilter:self.appointment]
             , [PeakSqlite nilFilter:self.isRead]
             , [PeakSqlite nilFilter:self.largeCata]
             , [PeakSqlite nilFilter:self.activityId]
             , [PeakSqlite nilFilter:self.nsrsbh]];
}

//插入数据
-(NSInteger)insert{
    NSString *sql = @"INSERT INTO %@(%@) VALUES (%@)";
    NSString *insertFields = @"opCode, activityName, activityDesc, activityId, publishTime, appointment, isRead, largeCata, nsrsbh";
    NSString *insertValues = @"?,?,?,?,?,?,?,?,?";
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
    NSString *sql = [NSString stringWithFormat: @"UPDATE %@ SET opCode = ?, activityName = ?, activityDesc = ?, appId = ? ,publishTime = ?, appointment = ?, isRead = ?, largeCata = ?,nsrsbh = ? WHERE activityId = ?", self.tableName];
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
    self.opCode = [data objectForKey:@"opCode"];
    self.activityName = [data objectForKey:@"activityName"];
    self.activityDesc = [data objectForKey:@"activityDesc"];
    self.activityId  = [PeakSqlite valueToString: [data objectForKey:@"activityId"]];
    self.publishTime  = [data objectForKey:@"publishTime"] ;
    self.appointment = [PeakSqlite valueToString: [data objectForKey:@"appointment"]];
    self.isRead = [data objectForKey:@"isRead"];
    self.appId = [data objectForKey:@"appId"];
    self.largeCata = [data objectForKey:@"largeCata"];
    self.nsrsbh = [data objectForKey:@"nsrsbh"];
}

- (void)parseFromCenterDo:(ChannelCenterDo *)aCenterDo
{
    self.opCode = aCenterDo.opCode;
    self.activityDesc = aCenterDo.activityDesc;
    self.activityName = aCenterDo.activityName  ;
    self.activityId = aCenterDo.activityId;
    self.publishTime = aCenterDo.publishTime;
    self.appointment = aCenterDo.appointment;
    self.isRead = @"NO";
    self.appId = aCenterDo.appId;
    self.largeCata = aCenterDo.largeCata;
    self.nsrsbh = aCenterDo.nsrsbh;
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


//返回字段名称
+(NSString *) appId_Col
{
    return @"appId";
}

+(NSString *) opCode_Col
{
    return @"opCode";
}

+(NSString *) activityName_Col
{
    return @"activityName";
}

+(NSString *) activityDesc_Col
{
    return @"activityDesc";
}

+(NSString *) publishTime_Col
{
    return @"publishTime";
}

+(NSString *) activityId_Col
{
    return @"activityId";
}

+(NSString *) appointment_Col
{
    return @"appointment";
}

+(NSString *) isRead_Col
{
    return @"isRead";
}

+(NSString *)largeCata_Col
{
    return @"largeCata";
}

+ (NSString *)nsrsbh_Col
{
    return @"nsrsbh";
}

+ (NSString *)getTableNameWithChannelCenterType:(ChannelCenterEntityType)aTableType
{
    NSString *tempTableName = @"EChannelCenterEntityType_TaxMeind";
    if (aTableType == EChannelCenterEntityType_Announcement)
    {
        tempTableName = @"EChannelCenterEntityType_Announcement";
    }
    else if (aTableType == EChannelCenterEntityType_PolicyNewest)
    {
        tempTableName = @"EChannelCenterEntityType_PolicyNewest";
    }
    else if (aTableType == EChannelCenterEntityType_TaxMeind)
    {
        tempTableName = @"EChannelCenterEntityType_TaxMeind";
    }
    else if (aTableType == EChannelCenterEntityType_TaxNotice)
    {
        tempTableName = @"EChannelCenterEntityType_TaxNotice";
    }
    //UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    //tempTableName = [[NSString alloc] initWithFormat:@"%@%@",tempTableName,userInfo.nsrsbhStr];
    return tempTableName;
}

#if 0
+(NSString *) sqlForCreateTable{
    //注意，日期类型在sqlite中不支持，所以日期类型会被转换为INTEGER类型,精确到秒
    
    return @"CREATE TABLE if not exists EChannelCenterEntityType_TaxMeind(activityId TEXT NOT NULL PRIMARY KEY AUTOINCREMENT, appId TEXT, opCode TEXT, activityName TEXT, activityDesc TEXT, publishTime TEXT, appointment TEXT, isRead TEXT, largeCata TEXT)";
}
#endif

+ (NSString *) sqlForCreateTable:(ChannelCenterEntityType )tableType;
{
    NSString *tableName = [ChannelCenterEntity getTableNameWithChannelCenterType:tableType];
   
    NSString *sql = [[NSString alloc] initWithFormat:@"CREATE TABLE if not exists %@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,activityId TEXT, appId TEXT, opCode TEXT, activityName TEXT, activityDesc TEXT, publishTime TEXT, appointment TEXT, isRead TEXT, largeCata TEXT,nsrsbh TEXT)",tableName];
    return sql;
}

@end
