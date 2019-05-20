//
//  GPWebMsgAcceptor.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPWebMsgAcceptor.h"

static NSString *const GPMessagePrefix = @"GP";
static NSString *const GPMsgCommonPrefix = @"GPMsgCommon";

@implementation GPWebMsgAcceptor

+ (id<GPWebMsgDelegate>)acceptMessage:(NSString *)message
{
    NSArray *components = [message componentsSeparatedByString:@"_"];
    NSMutableString *receiverClassName = [NSMutableString new];
    [receiverClassName appendString:GPMessagePrefix];
    
    [components enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL * _Nonnull stop) {
        if (word.length == 0) {
            return;
        }
        NSMutableString *mutableWord = [word mutableCopy];
        [mutableWord replaceCharactersInRange:NSMakeRange(0, 1) withString:[[word capitalizedString] substringWithRange:NSMakeRange(0, 1)]];
        [receiverClassName appendString:mutableWord];
    }];
    
    NSString *lowwerString = [message lowercaseString];
    BOOL isAync = ![lowwerString hasSuffix:@"sync"];
    
    Class recClass = NSClassFromString(receiverClassName);
    if (!recClass
        //找不到实现协议的类
        || ![recClass conformsToProtocol:@protocol(GPWebMsgDelegate)]
        //异步消息，但是没有实现异步消息方法
        || (isAync && ![recClass instanceMethodForSelector:@selector(webview:processAsyncMessage:args:callback:)])
        //同步消息，但是没有实现同步消息方法
        || (!isAync && ![recClass instanceMethodForSelector:@selector(webview:processSyncMessage:args:)])) {
        recClass = NSClassFromString(@"GPDefaultHandler");
    }
    
    id<GPWebMsgDelegate> handler = [[recClass alloc] init];
    return handler;
}

+ (id<GPWebMsgDelegate>) acceptMessage:(NSString *)message isAync:(BOOL)isAync
{
    NSArray *components = [message componentsSeparatedByString:@"_"];
    NSMutableString *receiverClassName = [NSMutableString new];
    [receiverClassName appendString:GPMsgCommonPrefix];
    
    [components enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL * _Nonnull stop) {
        if (word.length == 0) {
            return;
        }
        NSMutableString *mutableWord = [word mutableCopy];
        [mutableWord replaceCharactersInRange:NSMakeRange(0, 1) withString:[[word capitalizedString] substringWithRange:NSMakeRange(0, 1)]];
        [receiverClassName appendString:mutableWord];
    }];
    
    if (!isAync) {
        [receiverClassName appendString:@"Sync"];
    }
    
    Class recClass = NSClassFromString(receiverClassName);
    
    if (!recClass
        //找不到实现协议的类
        || ![recClass conformsToProtocol:@protocol(GPWebMsgDelegate)]
        //异步消息，但是没有实现异步消息方法
        || (isAync && ![recClass instanceMethodForSelector:@selector(webview:processAsyncMessage:args:callback:)])
        //同步消息，但是没有实现同步消息方法
        || (!isAync && ![recClass instanceMethodForSelector:@selector(webview:processSyncMessage:args:)])) {
        recClass = NSClassFromString(@"GPDefaultHandler");
    }
    
    id<GPWebMsgDelegate> handler = [[recClass alloc] init];
    return handler;
}
@end
