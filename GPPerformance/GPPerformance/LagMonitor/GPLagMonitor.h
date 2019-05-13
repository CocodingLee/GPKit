//
//  GPLagMonitor.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPLagMonitor : NSObject

/**
 是否正在监控
 */
@property (nonatomic , assign) BOOL isMonitoring;

/**
 当前单例

 @return GPLagMonitor
 */
+ (instancetype)shareInstance;

/**
 开始监视卡顿
 */
- (void)beginMonitor;

/**
 停止监视卡顿
 */
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
