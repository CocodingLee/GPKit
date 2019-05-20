//
//  GPOcJsBridge.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPOcJsBridge.h"

@implementation GPOcJsBridge

+ (instancetype)sharedInstance
{
    static GPOcJsBridge *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GPOcJsBridge alloc] init];
    });
    
    return _sharedInstance;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
@end
