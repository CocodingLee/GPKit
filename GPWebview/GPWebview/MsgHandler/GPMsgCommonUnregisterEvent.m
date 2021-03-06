//
//  GPMsgCommonRegisterEvent.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPMsgCommonUnregisterEvent.h"
#import "GPWebMsgCenter.h"

@implementation GPMsgCommonUnregisterEvent

- (void)        webview:(GPWebView *)webiew
    processAsyncMessage:(NSString *)message
                   args:(NSDictionary *)args
               callback:(void (^)(NSDictionary *ret))callback
{
    NSString *eventName = args[@"type"];
    if (!eventName) {
        return;
    }
    
    [[GPWebMsgCenter sharedCenter] unregisterEventWithName:eventName
                                                  observer:(id<GPWebMsgCenterDelegate>)webiew];
}
@end
