//
//  GPWebMsgCenter.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPWebMsgCenterDelegate <NSObject>
- (void)gpWebViewNotifyByEventName:(NSString *)eventName
                              data:(NSDictionary *)data;

- (NSDictionary *)getEventParamWithEventName:(NSString *)eventName;
- (void)setEventParam:(NSDictionary *)param eventName:(NSString *)eventName;
@end

////////////////////////////////////////////////////////////////////////

@interface GPWebMsgCenter : NSObject
+ (instancetype)sharedCenter;

- (void)postEventWithName:(NSString *)eventName
                     data:(NSDictionary *)data;

- (void)registerEventWithName:(NSString *)eventName
                     observer:(id<GPWebMsgCenterDelegate>)observer
                   eventParam:(NSDictionary *)eventParam;

- (void)unregisterEventWithName:(NSString *)eventname
                       observer:(id<GPWebMsgCenterDelegate>)observer;
@end

NS_ASSUME_NONNULL_END
