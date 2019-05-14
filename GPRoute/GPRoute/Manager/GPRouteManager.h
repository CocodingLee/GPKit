//
//  GPRouteManager.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPRouteDefine.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const GPRouteURLScheme;
FOUNDATION_EXTERN NSString *const GPRouteErrorDomain;
FOUNDATION_EXTERN NSString *const GPRouteTargetKey;

@class GPRouteRegManager;
@interface GPRouteManager : NSObject

@property (nonatomic, readonly) GPRouteRegManager *regManager;

/**
 单例

 @return 当前实例
 */
+ (instancetype)sharedInstance;

/**
 打开url

 @param url url
 @param completion 回调
 */
- (void)openURL:(NSURL *)url
     completion:(void (^)(NSDictionary *, NSError *))completion;


/**
 打开域名

 @param domain 域名
 @param path 业务路径
 @param params 参数
 @param completion 回调
 */
- (void)openDomain:(NSString *)domain
              path:(NSString *)path
            params:(NSDictionary *)params
        completion:(void (^)(NSDictionary * params, NSError * error))completion;

/**
 打开域名
 
 @param domain 域名
 @param path 业务路径
 @param params 参数
 @param completion 回调
 */
- (void)pingDomain:(NSString *)domain
              path:(NSString *)path
            params:(NSDictionary *)params
        completion:(void (^)(GPRouteDecision, NSError *))completion;


/**
 打开url

 @param url url
 @param addition 添加项目
 @param completion 回调
 */
- (void)openURL:(NSURL *)url
       addition:(NSDictionary *)addition
     completion:(void (^)(NSDictionary *, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
