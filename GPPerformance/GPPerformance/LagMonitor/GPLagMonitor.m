//
//  GPLagMonitor.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPLagMonitor.h"

@interface GPLagMonitor ()

@end

@implementation GPLagMonitor

/**
 当前单例
 
 @return GPLagMonitor
 */
+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 开始监视卡顿
 */
- (void)beginMonitor
{
    
}

/**
 停止监视卡顿
 */
- (void)endMonitor
{
    
}
@end
