//
//  GPLagDB.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <coobjc/coobjc.h>
#import <fmdb/FMDB.h>
#import <libextobjc/EXTScope.h>

#import "GPCallTraceTimeCostModel.h"
#import "GPCallStackModel.h"
#import "GPOCExceptionModel.h"


#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CPUMONITORRATE 20
#define STUCKMONITORRATE 88


NS_ASSUME_NONNULL_BEGIN

@interface GPLagDB : NSObject

+ (GPLagDB *)shareInstance;

/*------------卡顿和CPU超标堆栈---------------*/

- (COPromise *)increaseWithStackModel:(GPCallStackModel *)model CO_ASYNC;
- (COPromise *)selectStackWithPage:(NSUInteger)page CO_ASYNC;
- (void)clearStackData;

/*------------ClsCall方法调用频次-------------*/
//添加记录s
- (void)addWithClsCallModel:(GPCallTraceTimeCostModel *)model;
//分页查询
- (COPromise *)selectClsCallWithPage:(NSUInteger)page CO_ASYNC;
//清除数据
- (void)clearClsCallData;

/*------------OC 异常方法 记录-------------*/
//添加记录s
- (COPromise *)addWithOCExceptionModel:(GPOCExceptionModel *)model;
//分页查询
- (COPromise *)selectOCExceptionWithPage:(NSUInteger)page CO_ASYNC;
//清除数据
- (void)clearOCExceptionData;
@end

NS_ASSUME_NONNULL_END
