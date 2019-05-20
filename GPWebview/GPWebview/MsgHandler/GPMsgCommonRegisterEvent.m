//
//  GPMsgCommonRegisterEvent.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPMsgCommonRegisterEvent.h"
#import "GPWebMsgCenter.h"

@implementation GPMsgCommonRegisterEvent

- (void)        webview:(GPWebView *)webiew
    processAsyncMessage:(NSString *)message
                   args:(NSDictionary *)args
               callback:(void (^)(NSDictionary *ret))callback
{
    NSString *eventName = args[@"type"];
    if (!eventName) {
        return;
    }
    
    NSDictionary *eventParam = args[@"params"]?:@{};
    [[GPWebMsgCenter sharedCenter] registerEventWithName:eventName
                                                observer:(id<GPWebMsgCenterDelegate>)webiew
                                              eventParam:eventParam];
}
@end
