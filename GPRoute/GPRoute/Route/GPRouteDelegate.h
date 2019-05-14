//
//  GPRouteDelegate.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////

FOUNDATION_EXTERN NSString *const GPRouteDomainKey;
FOUNDATION_EXTERN NSString *const GPRoutePathKey;
FOUNDATION_EXTERN NSString *const GPRouteURLKey;

typedef void (^GPRouteCompletion)(NSDictionary *, NSError *);

// 快速定义跳转
#define GPRouteToPath(path, url, params, completion)    \
                                                        \
+ (void)route##path ## WithURL:(NSURL *)url             \
params:(NSDictionary *)params                           \
completion:(GPRouteCompletion)completion

// 快速定义跳转
#define GPRouteFrom(url, path, params, completion)      \
                                                        \
+ (void)routeFromURL:(NSURL *)url                       \
path:(NSString *)path                                   \
params:(NSDictionary *)params                           \
completion:(GPRouteCompletion)completion

////////////////////////////////////////////////////////////////

@protocol GPRouteDelegate <NSObject>

/**
 业务域

 @return 当前名称
 */
+ (NSString *)supportedDomain;

@optional

/**
 支持从别名转换到路径，用于一个类复用多个路径、别名时候的转换

 @param alias 别名
 @return 别名到路径
 */
+ (NSString *)pathWithAlias:(NSString *)alias;

/**
 如果不实现这个方法，则默认添加一个Path为*的插件，
 当某个跳转的path未能命中该domain下的任一个插件时，会寻找*插件

 @return 当前支持的路径，业务分支
 */
+ (NSArray *)supportedPath;

/**
 初始化

 @param params 参数
 @return 当前实例
 */
- (instancetype)initWithParams:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
