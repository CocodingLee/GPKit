//
//  GPOcJsBridge.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GP_OCJS_WKBridge : NSObject <WKScriptMessageHandler>
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
