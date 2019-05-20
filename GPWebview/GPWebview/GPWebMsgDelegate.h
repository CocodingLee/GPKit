//
//  GPWebMsgDelegate.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GPWebView;

@protocol GPWebMsgDelegate <NSObject>

@optional

/**
 处理异步消息

 @param webiew H5页面
 @param message 消息
 @param args 参数
 @param callback 回调
 */
- (void)    webview:(GPWebView *)webiew
processAsyncMessage:(NSString *)message
               args:(NSDictionary *)args
           callback:(void (^)(NSDictionary *ret))callback;

/**
 处理同步消息

 @param webview H5页面
 @param message 消息
 @param args 参数
 @return 返回值
 */
- (NSDictionary *)webview:(GPWebView *)webview
       processSyncMessage:(NSString *)message
                     args:(NSDictionary *)args;
@end

NS_ASSUME_NONNULL_END
