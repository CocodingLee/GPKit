//
//  GPCallStack.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
// mach-o 的一些头文件
#import "GPSystemKits.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GPCallStackType) {
    GPCallStackTypeAll,     //全部线程
    GPCallStackTypeMain,    //主线程
    GPCallStackTypeCurrent  //当前线程
};

@interface GPCallStack : NSObject

/**
 获取线程的调用栈

 @param type 线程类型
 @return 调用栈字符串
 */
+ (NSString *)callStackWithType:(GPCallStackType)type;

/**
 C函数

 @param thread 获取线程调用栈
 @return 调用栈字符串
 */
extern NSString *gpStackOfThread(thread_t thread);

@end

NS_ASSUME_NONNULL_END
