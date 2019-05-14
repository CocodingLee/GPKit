//
//  GPRouteRegManager.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPRouteDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GPRouteRegTreeDelegate;

@interface GPRouteRegManager : NSObject

/**
 添加规则
 
 @param reg    规则处理对象
 @param domain 域，用于规则分层
 @param path   路径，用于定位规则
 */
- (void)addReg:(id<GPRouteRegTreeDelegate>)reg
    withDomain:(NSString *)domain
          path:(NSString *)path;

/**
 规则匹配
 
 @param domain 支持的域名
 @param path 支持的业务分支
 @return 当前注册对象
 */
- (NSArray< id<GPRouteRegTreeDelegate> > *)matchRegsWithDomain:(NSString *)domain
                                                          path:(NSString *)path;


/**
 检测域名注册
 
 @param domain 支持的域名
 @param path 支持的业务分支
 @param params 参数
 @param completion 完成回调
 */
- (void)checkRegsWithDomain:(NSString *)domain
                       path:(NSString *)path
                     params:(NSDictionary *)params
                 completion:(void (^)(GPRouteDecision, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
