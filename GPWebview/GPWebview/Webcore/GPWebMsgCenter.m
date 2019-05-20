//
//  GPWebMsgCenter.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPWebMsgCenter.h"

typedef NSMutableDictionary<NSString *, NSHashTable<id<GPWebMsgCenterDelegate>> *> ObserverContainer;

@interface GPWebMsgCenter ()
@property (nonatomic, strong) ObserverContainer *observersDict;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation GPWebMsgCenter

+ (instancetype)sharedCenter
{
    static GPWebMsgCenter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GPWebMsgCenter alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lock = [[NSLock alloc] init];
    return self;
}

- (void)postEventWithName:(NSString *)eventName
                     data:(NSDictionary *)data
{
    if (!eventName || eventName.length == 0) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:eventName object:nil userInfo:data];
    
    NSHashTable<id<GPWebMsgCenterDelegate>> *observers = self.observersDict[eventName];
    if (observers.count == 0) {
        return;
    }
    
    NSArray<id<GPWebMsgCenterDelegate>> *observerArray = [observers allObjects];
    [observerArray enumerateObjectsUsingBlock:^(id<GPWebMsgCenterDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(gpWebViewNotifyByEventName:data:)]) {
            [obj gpWebViewNotifyByEventName:eventName data:data];
        }
    }];
}

- (void)registerEventWithName:(NSString *)eventName
                     observer:(id<GPWebMsgCenterDelegate>)observer
                   eventParam:(NSDictionary *)eventParam
{
    if (!eventName || eventName.length == 0) {
        return;
    }
    
    NSHashTable<id<GPWebMsgCenterDelegate>> *observers = self.observersDict[eventName];
    if (!observers) {
        observers = [NSHashTable weakObjectsHashTable];
        [self.lock lock];
        self.observersDict[eventName] = observers;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveFromNotificationCenter:)
                                                     name:eventName
                                                   object:nil];
        [self.lock unlock];
    }
    
    [self.lock lock];
    if (eventParam && [eventParam isKindOfClass:NSDictionary.class]) {
        SEL sel = NSSelectorFromString(@"setEventParam:eventName:");
        if ([observer respondsToSelector:sel]) {
            [observer setEventParam:eventParam eventName:eventName];
        }
    }
    
    [observers addObject:observer];
    [self.lock unlock];
}

- (void)receiveFromNotificationCenter:(NSNotification *)notification
{
    [self notifyWebViewWithName:notification.name data:notification.userInfo];
}

- (void)notifyWebViewWithName:(NSString *)eventName
                         data:(NSDictionary *)data
{
    if (!eventName || eventName.length == 0) {
        return;
    }
    
    NSHashTable<id<GPWebMsgCenterDelegate>> *observers = self.observersDict[eventName];
    if (observers.count == 0) {
        return;
    }
    
    NSArray<id<GPWebMsgCenterDelegate>> *observerArray = [observers allObjects];
    [observerArray enumerateObjectsUsingBlock:^(id<GPWebMsgCenterDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(gpWebViewNotifyByEventName:data:)]) {
            [obj gpWebViewNotifyByEventName:eventName data:data];
        }
    }];
}

- (void)unregisterEventWithName:(NSString *)eventName
                       observer:(id<GPWebMsgCenterDelegate>)observer;
{
    if (!eventName || eventName.length == 0) {
        return;
    }
    
    NSHashTable<id<GPWebMsgCenterDelegate>> *observers = self.observersDict[eventName];
    if (!observers) {
        return;
    }
    
    [self.lock lock];
    [observers removeObject:observer];
    if (observers.count == 0) {
        [self.observersDict removeObjectForKey:eventName];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:eventName object:nil];
    }
    [self.lock unlock];
}

- (ObserverContainer *)observersDict
{
    if (_observersDict) {
        return _observersDict;
    }
    
    _observersDict = [NSMutableDictionary new];
    return _observersDict;
}

@end
