//
//  GPOcJsBridge.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GP_OCJS_WKBridge.h"

@implementation GP_OCJS_WKBridge

+ (instancetype)sharedInstance
{
    static GP_OCJS_WKBridge *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GP_OCJS_WKBridge alloc] init];
    });
    
    return _sharedInstance;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
@end
