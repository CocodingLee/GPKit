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

#import "GPCallTraceTimeCostModel.h"
#import "GPCallStackModel.h"

#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define CPUMONITORRATE 80
#define STUCKMONITORRATE 88


NS_ASSUME_NONNULL_BEGIN

@interface GPLagDB : NSObject

+ (GPLagDB *)shareInstance;
//
///*------------卡顿和CPU超标堆栈---------------*/
//- (RACSignal *)increaseWithStackModel:(GPCallStackModel *)model;
//- (RACSignal *)selectStackWithPage:(NSUInteger)page;
//- (void)clearStackData;
//
///*------------ClsCall方法调用频次-------------*/
////添加记录s
//- (void)addWithClsCallModel:(SMCallTraceTimeCostModel *)model;
////分页查询
//- (RACSignal *)selectClsCallWithPage:(NSUInteger)page;
////清除数据
//- (void)clearClsCallData;

@end

NS_ASSUME_NONNULL_END
