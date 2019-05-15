//
//  GPCpuMonitor.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPCpuMonitor : NSObject
/**
 当前单例
 
 @return GPLagMonitor
 */
+ (instancetype)shareInstance;


/**
 更新CPU 数据
 */
- (void) updateData;
@end

NS_ASSUME_NONNULL_END
