//
//  GPMsgCommonRegisterEvent.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPMsgCommonTriggerEvent.h"
#import "GPWebMsgCenter.h"

@implementation GPMsgCommonTriggerEvent

- (void)        webview:(GPWebView *)webiew
    processAsyncMessage:(NSString *)message
                   args:(NSDictionary *)args
               callback:(void (^)(NSDictionary *ret))callback
{
    NSString *eventName = args[@"type"];
    if (!eventName) {
        return;
    }
    
    NSDictionary *data = args[@"data"];
    [[GPWebMsgCenter sharedCenter] postEventWithName:eventName data:data];
}
@end
