//
//  GPDefaultHandler.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPDefaultHandler.h"
#import "GPWebView.h"

@implementation GPDefaultHandler

- (NSDictionary *)webview:(GPWebView *)webview
       processSyncMessage:(NSString *)message
                     args:(NSDictionary *)args
{
    return [self cantFindReceiverError];
}

- (void)        webview:(GPWebView *)webiew
    processAsyncMessage:(NSString *)message
                   args:(NSDictionary *)args
               callback:(void (^)(NSDictionary *ret))callback
{
    callback([self cantFindReceiverError]);
}

- (id)cantFindReceiverError
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"找不到接口"};
    NSError *err = [NSError errorWithDomain:kWebViewMessageErrorDomain code:-1 userInfo:userInfo];
    return err;
}

@end
