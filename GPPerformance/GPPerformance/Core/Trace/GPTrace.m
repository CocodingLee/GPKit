//
//  GPTrace.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPTrace.h"
#import "GPSystemKits.h"
#import "GPCallTraceTimeCostModel.h"
#import "GPLagDB.h"
#import "GPTraceCore.h"

@implementation GPTrace

+ (void)start
{
    gpCallTraceStart();
}

+ (void)startWithMaxDepth:(int)depth
{
    gpCallConfigMaxDepth(depth);
    [GPTrace start];
}

+ (void)startWithMinCost:(double)ms
{
    gpCallConfigMinTime(ms * 1000);
    [GPTrace start];
}

+ (void)startWithMaxDepth:(int)depth
                  minCost:(double)ms
{
    gpCallConfigMaxDepth(depth);
    gpCallConfigMinTime(ms * 1000);
    
    [GPTrace start];
}

+ (void)stop
{
    gpCallTraceStop();
}

+ (void)save
{
    NSMutableString *mStr = [NSMutableString new];
    NSArray<GPCallTraceTimeCostModel *> *arr = [self loadRecords];
    for (GPCallTraceTimeCostModel *model in arr) {
        //记录方法路径
        model.path = [NSString stringWithFormat:@"[%@ %@]",model.className,model.methodName];
        [self appendRecord:model to:mStr];
    }
}

+ (void)stopSaveAndClean
{
    [GPTrace stop];
    [GPTrace save];
    
    gpClearCallRecords();
}

+ (void)appendRecord:(GPCallTraceTimeCostModel *)cost
                  to:(NSMutableString *)mStr
{
    if (cost.subCosts.count < 1) {
        cost.lastCall = YES;
        //记录到数据库中
        [[GPLagDB shareInstance] addWithClsCallModel:cost];
    } else {
        for (GPCallTraceTimeCostModel *model in cost.subCosts) {
            if ([model.className isEqualToString:@"SMCallTrace"]) {
                break;
            }
            
            //记录方法的子方法的路径
            model.path = [NSString stringWithFormat:@"%@ - [%@ %@]",cost.path,model.className,model.methodName];
            [self appendRecord:model to:mStr];
        }
    }
}

+ (NSArray<GPCallTraceTimeCostModel *>*)loadRecords
{
    NSMutableArray<GPCallTraceTimeCostModel *> *arr = [NSMutableArray new];
    int num = 0;
    
    GPCallRecord *records = gpGetCallRecords(&num);
    for (int i = 0; i < num; ++i) {
        GPCallRecord *rd = &records[i];
        GPCallTraceTimeCostModel *model = [GPCallTraceTimeCostModel new];
        model.className = NSStringFromClass(rd->cls);
        model.methodName = NSStringFromSelector(rd->sel);
        model.isClassMethod = class_isMetaClass(rd->cls);
        model.timeCost = (double)rd->time / 1000000.0;
        model.callDepth = rd->depth;
        [arr addObject:model];
    }
    
    NSUInteger count = arr.count;
    for (NSUInteger i = 0; i < count; ++i) {
        GPCallTraceTimeCostModel *model = arr[i];
        if (model.callDepth > 0) {
            [arr removeObjectAtIndex:i];
            
            //Todo:不需要循环，直接设置下一个，然后判断好边界就行
            for (NSUInteger j = i; j < count - 1; ++j) {
                //下一个深度小的话就开始将后面的递归的往 sub array 里添加
                if (arr[j].callDepth + 1 == model.callDepth) {
                    NSMutableArray *sub = (NSMutableArray *)arr[j].subCosts;
                    if (!sub) {
                        sub = [NSMutableArray new];
                        arr[j].subCosts = sub;
                    }
                    [sub insertObject:model atIndex:0];
                }
            }
            
            --i;
            --count;
        }
    }
    return arr;
}

@end
