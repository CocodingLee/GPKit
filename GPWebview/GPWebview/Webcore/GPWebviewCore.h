//
//  GPWebviewCore.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPWebviewCore : NSObject

@property (nonatomic, readonly) WKProcessPool *processPool;
@property (nonatomic, readonly) WKUserContentController *userContentController;
@property (nonatomic, readonly) WKUserScript *cookieScript;
@property (nonatomic, readonly) NSDictionary *cookies;
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *additionHeader;
@property (nonatomic, copy) NSString *userAgent;

+ (instancetype)sharedCore;

- (void)addDomain:(NSString *)domain;
- (void)setCookiesKey:(NSString *)key value:(NSString *)value;
- (void)setAdditionHeader:(NSString *)header forKey:(NSString *)key;

- (NSString *)cookiesString;

@end

NS_ASSUME_NONNULL_END
