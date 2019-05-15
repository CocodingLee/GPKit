//
//  GPCallStackModel.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPCallStackModel : NSObject

/**
 堆栈信息
 */
@property (nonatomic, copy) NSString *stackStr;

/**
 是否被卡住
 */
@property (nonatomic) BOOL isStuck;

/**
 可展示信息
 */
@property (nonatomic, assign) NSTimeInterval dateString;
@end

NS_ASSUME_NONNULL_END
