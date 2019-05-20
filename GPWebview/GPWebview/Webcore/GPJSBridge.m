//
//  GPJSBridge.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPJSBridge.h"

////////////////////////////////////////////////////////

@implementation GPJSBridgeMessageModel

+ (instancetype)messageModelWithDictionary:(NSDictionary *)value
{
    GPJSBridgeMessageModel *model = [[GPJSBridgeMessageModel alloc] init];
    model.type = [@([value[@"type"] longLongValue]) integerValue];
    model.message = value[@"message"];
    if (!model.message || model.message.length <= 0) {
        if ([value[@"method"] isKindOfClass:NSString.class]) {
            model.message = value[@"method"];
        }
    }
    model.args = value[@"args"];
    model.callbackId = value[@"callbackId"];
    
    if (!model.callbackId && model.args[@"callbackId"]) {
        model.callbackId = model.args[@"callbackId"];
    }
    
    return model;
}

@end

////////////////////////////////////////////////////////

@implementation GPJSBridge

- (void)                        webView:(WKWebView *)webView
  runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt
                            defaultText:(nullable NSString *)defaultText
                       initiatedByFrame:(WKFrameInfo *)frame
                      completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    NSMutableArray<GPJSBridgeMessageModel *> *messages = [NSMutableArray new];
    
    NSData *msgData = [prompt dataUsingEncoding:NSUTF8StringEncoding];
    id msg = [NSJSONSerialization JSONObjectWithData:msgData options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
    if ([msg isKindOfClass:[NSDictionary class]]) {
        GPJSBridgeMessageModel *model = [GPJSBridgeMessageModel messageModelWithDictionary:msg];
        [messages addObject:model];
    } else if ([msg isKindOfClass:[NSArray class]]) {
        [((NSArray *)msg) enumerateObjectsUsingBlock:^(NSDictionary *msgDict, NSUInteger idx, BOOL * _Nonnull stop) {
            GPJSBridgeMessageModel *model = [GPJSBridgeMessageModel messageModelWithDictionary:msgDict];
            [messages addObject:model];
        }];
    }
    
    NSMutableArray<NSDictionary *> *ret = [NSMutableArray new];
    [messages enumerateObjectsUsingBlock:^(GPJSBridgeMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(bridge:didReciveMessage:)]) {
            NSDictionary *singleRet = [self.delegate bridge:self didReciveMessage:obj];
            [ret addObject:singleRet ?: @{}];
        }
    }];
    
    NSData *retData = [NSJSONSerialization dataWithJSONObject:ret options:0 error:nil];
    NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    completionHandler(retStr);
}

- (WKWebView *)         webView:(WKWebView *)webView
 createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
            forNavigationAction:(WKNavigationAction *)navigationAction
                 windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}
@end
