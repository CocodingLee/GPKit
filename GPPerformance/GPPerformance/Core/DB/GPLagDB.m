//
//  GPLagDB.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPLagDB.h"
#import <coobjc/coobjc.h>
#import <fmdb/FMDB.h>
#import <libextobjc/EXTScope.h>

@interface GPLagDB ()
@property (nonatomic, copy) NSString *clsCallDBPath;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@end

@implementation GPLagDB

+ (GPLagDB *)shareInstance
{
    static GPLagDB *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GPLagDB alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _clsCallDBPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"clsCall.sqlite"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_clsCallDBPath] == NO) {
            FMDatabase *db = [FMDatabase databaseWithPath:_clsCallDBPath];
            if ([db open]) {
                /* clsCall 表记录方法读取频次的表
                 cid: 主id
                 fid: 父id 暂时不用
                 cls: 类名
                 mtd: 方法名
                 path: 完整路径标识
                 timecost: 方法消耗时长
                 calldepth: 层级
                 frequency: 调用次数
                 lastcall: 是否是最后一个 call
                 */
                NSString *createSql = @"create table clscall (cid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, fid integer, cls text, mtd text, path text, timecost double, calldepth integer, frequency integer, lastcall integer)";
                [db executeUpdate:createSql];
                
                /* stack 表记录
                 sid: id
                 stackcontent: 堆栈内容
                 insertdate: 日期
                 */
                NSString *createStackSql = @"create table stack (sid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, stackcontent text,isstuck integer, insertdate double)";
                [db executeUpdate:createStackSql];
                
                /* 异常 表记录
                 sid: id
                 content: 堆栈内容
                 type: 错误类型
                 info: 添加信息
                 insertdate: 日期
                 */
                NSString *createExceptionSql = @"create table ocexception (oid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL, content text , type integer, info text , insertdate double)";
                [db executeUpdate:createExceptionSql];
            }
        }
        
        // 数据库操作队列
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:_clsCallDBPath];
    }
    return self;
}

#pragma mark - 卡顿和CPU超标堆栈

//添加 stack 表数据
- (COPromise *)increaseWithStackModel:(GPCallStackModel *)model
{
    SURE_ASYNC;
    
    @weakify(self);
    return  [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        @strongify(self);
        
        if ([model.stackStr containsString:@"+[GPCallStack callStackWithType:]"]
            || [model.stackStr containsString:@"-[GPLagMonitor updateCPUInfo]"]) {
            
            NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"stack string no msg"}];
            return reject(err);
        }
        
        [self.dbQueue inDatabase:^(FMDatabase *db){
            if ([db open]) {
                NSNumber *stuck = @0;
                if (model.isStuck) {
                    stuck = @1;
                }
                [db executeUpdate:@"insert into stack (stackcontent, isstuck, insertdate) values (?, ?, ?)",model.stackStr, stuck, [NSDate date]];
                [db close];
                
                fullfill(@(YES));
            }
        }];
    }];
}

//stack 分页查询
- (COPromise *) selectStackWithPage:(NSUInteger)page
{
    SURE_ASYNC;
    
    @weakify(self);
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        @strongify(self);
        
        FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"select * from stack order by sid desc limit ?, 50",@(page * 50)];
            NSUInteger count = 0;
            NSMutableArray *arr = [NSMutableArray array];
            
            while ([rs next]) {
                GPCallStackModel *model = [[GPCallStackModel alloc] init];
                model.stackStr = [rs stringForColumn:@"stackcontent"];
                model.isStuck = [rs boolForColumn:@"isstuck"];
                model.dateString = [rs doubleForColumn:@"insertdate"];
                [arr addObject:model];
                count++;
            }
            
            [db close];
            
            if (count >= 0) {
                fullfill(arr);
            } else {
                NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db no data"}];
                reject(err);
            }
            
        } else {
            NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db open failed"}];
            reject(err);
        }
    }];
}

//stack 表清除
- (void)clearStackData
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
    if ([db open]) {
        [db executeUpdate:@"delete from stack"];
        [db close];
    }
}

#pragma mark - ClsCall方法调用频次

//添加记录
- (void)addWithClsCallModel:(GPCallTraceTimeCostModel *)model
{
    if ([model.methodName isEqualToString:@"clsCallInsertToViewWillAppear"]
        || [model.methodName isEqualToString:@"clsCallInsertToViewWillDisappear"]) {
        return;
    }
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            //添加白名单
            FMResultSet *rsl = [db executeQuery:@"select cid,frequency from clscall where path = ?", model.path];
            if ([rsl next]) {
                //有相同路径就更新路径访问频率
                int fq = [rsl intForColumn:@"frequency"] + 1;
                int cid = [rsl intForColumn:@"cid"];
                [db executeUpdate:@"update clscall set frequency = ? where cid = ?", @(fq), @(cid)];
            } else {
                //没有就添加一条记录
                NSNumber *lastCall = @0;
                if (model.lastCall) {
                    lastCall = @1;
                }
                [db executeUpdate:@"insert into clscall (cls, mtd, path, timecost, calldepth, frequency, lastcall) values (?, ?, ?, ?, ?, ?, ?)", model.className, model.methodName, model.path, @(model.timeCost), @(model.callDepth), @1, lastCall];
            }
            [db close];
        }
    }];
}

//分页查询
- (COPromise *)selectClsCallWithPage:(NSUInteger)page
{
    SURE_ASYNC;
    
    @weakify(self);
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"select * from clscall where lastcall=? order by frequency desc limit ?, 50",@1, @(page * 50)];
            NSUInteger count = 0;
            NSMutableArray *arr = [NSMutableArray array];
            
            while ([rs next]) {
                GPCallTraceTimeCostModel *model = [self clsCallModelFromResultSet:rs];
                [arr addObject:model];
                count ++;
            }
            
            if (count > 0) {
                fullfill(arr);
            } else {
                NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db no data"}];
                reject(err);
            }
            
            [db close];
        } else {
            NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db open failed"}];
            reject(err);
        }
    }];
}

//清除数据
- (void)clearClsCallData
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
    if ([db open]) {
        [db executeUpdate:@"delete from clscall"];
        [db close];
    }
}

//结果封装成 model
- (GPCallTraceTimeCostModel *)clsCallModelFromResultSet:(FMResultSet *)rs
{
    GPCallTraceTimeCostModel *model = [[GPCallTraceTimeCostModel alloc] init];
    model.className = [rs stringForColumn:@"cls"];
    model.methodName = [rs stringForColumn:@"mtd"];
    model.path = [rs stringForColumn:@"path"];
    model.timeCost = [rs doubleForColumn:@"timecost"];
    model.callDepth = [rs intForColumn:@"calldepth"];
    model.frequency = [rs intForColumn:@"frequency"];
    model.lastCall = [rs boolForColumn:@"lastcall"];
    return model;
}

/*------------OC 异常方法 记录-------------*/
//添加记录s
- (COPromise* ) addWithOCExceptionModel:(GPOCExceptionModel *)model
{
    SURE_ASYNC;
    
    @weakify(self);
    return  [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        @strongify(self);
        
        [self.dbQueue inDatabase:^(FMDatabase *db){
            if ([db open]) {
                [db executeUpdate:@"insert into ocexception (content , type , info , insertdate) values (?, ?, ? , ?)",model.callStackStr?:@"", @(model.exceptionType) , model.exceptionInfo?:@"", [NSDate date]];
                [db close];
                
                fullfill(@(YES));
            } else {
                NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db open failed"}];
                reject(err);
            }
        }];
    }];
}
//分页查询
- (COPromise *)selectOCExceptionWithPage:(NSUInteger)page CO_ASYNC
{
    SURE_ASYNC;
    
    @weakify(self);
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        @strongify(self);
        FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
        if ([db open]) {
            FMResultSet *rs = [db executeQuery:@"select * from ocexception order by oid desc limit ?, 50" , @(page*50)];
            //FMResultSet *rs = [db executeQuery:@"select * from ocexception"];
            NSUInteger count = 0;
            NSMutableArray *arr = [NSMutableArray array];
            
            while ([rs next]) {
                GPOCExceptionModel *model = [self ocExceptionModelFromResultSet:rs];
                [arr addObject:model];
                count ++;
            }
            
            if (count > 0) {
                fullfill(arr);
            } else {
                NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db no data"}];
                reject(err);
            }
            
            [db close];
        } else {
            NSError* err = [NSError errorWithDomain:@"GPPerformance" code:-1 userInfo:@{@"msg":@"db open failed"}];
            reject(err);
        }
    }];
}

//结果封装成 model
- (GPOCExceptionModel *) ocExceptionModelFromResultSet:(FMResultSet *)rs
{
    GPOCExceptionModel *model = [[GPOCExceptionModel alloc] init];
    model.callStackStr = [rs stringForColumn:@"content"];
    model.exceptionType = [rs longForColumn:@"type"];
    model.exceptionInfo = [rs stringForColumn:@"info"];
    model.dateInterval = [rs doubleForColumn:@"insertdate"];
    return model;
}

//清除数据
- (void)clearOCExceptionData
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.clsCallDBPath];
    if ([db open]) {
        [db executeUpdate:@"delete from ocexception"];
        [db close];
    }
}

@end
