//
//  GPOCExceptionModel.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/19.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPOCExceptionModel : NSObject

/**
 调用栈信息
 */
@property (nonatomic , copy) NSString* callStackStr;
@property (nonatomic , assign) long exceptionType;
@property (nonatomic , strong)  NSString* exceptionInfo;
@property (nonatomic , assign) NSTimeInterval dateInterval;
@end

NS_ASSUME_NONNULL_END
