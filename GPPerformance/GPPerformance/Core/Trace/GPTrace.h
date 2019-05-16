//
//  GPTrace.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPTrace : NSObject

/**
 开始记录
 */
+ (void)start;
+ (void)startWithMaxDepth:(int)depth;
+ (void)startWithMinCost:(double)ms;
+ (void)startWithMaxDepth:(int)depth minCost:(double)ms;

/**
 停止记录
 */
+ (void)stop;

/**
  保存和打印记录，如果不是短时间 stop 的话使用 saveAndClean
 */
+ (void)save;


/**
 停止保存打印并进行内存清理
 */
+ (void)stopSaveAndClean;
@end

NS_ASSUME_NONNULL_END
