//
//  GPInspector.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPInspectorToolItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPInspector : NSObject
/*
 *在状态栏显示入口
 */
+ (void)showOnStatusBar;
+ (BOOL)isShow;
/*
 *打开inspector
 */
+ (void)show;
/*
 *关闭inspector
 */
+ (void)hide;
/*
 *设置业务类代码前缀
 */
+ (void)setClassPrefixName:(NSString* )name;
/*
 *是否要记录crash日志
 */
+ (void)setShouldHandleCrash:(BOOL)b;
/**
 *是否要hook异常
 */
+ (void)setShouldHookException:(BOOL)b;
+ (BOOL) isHookException;
/**
 *是否要hook网络请求
 */
+ (void)setShouldHookNetworkRequest:(BOOL)b;
/**
 * 设置log数量限制
 */
+ (void)setLogNumbers:(NSUInteger)num;
/*
 *注入要观察的全局信息
 */
+ (void)addObserveCallback:(NSString* (^)(void)) callback;
/**
 *  注入自定义插件
 */
+ (void)addToolItem:(GPInspectorToolItem *)toolItem;
/*
 *  返回所有注册的自定义插件
 */
+ (NSArray *)additionTools;
@end

NS_ASSUME_NONNULL_END
