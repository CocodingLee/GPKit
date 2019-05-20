//
//  GPWebviewCore.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPWebviewCore.h"
#import "GPSafariUAController.h"
#import "GP_OCJS_WKBridge.h"

static dispatch_once_t gs_userAgentInitToken;
static NSString *gs_userAgent;

@interface GPWebviewCore ()
@property (nonatomic, strong) NSMutableSet *cookieDomains;
@property (nonatomic, strong) NSMutableDictionary *mutableCookie;
@property (nonatomic, strong) NSMutableDictionary *mutableAdditionHeader;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation GPWebviewCore
@synthesize processPool = _processPool;
@synthesize userAgent = _userAgent;

+ (instancetype)sharedCore
{
    static GPWebviewCore *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GPWebviewCore alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lock = [NSLock new];
    return self;
}

- (NSMutableSet *)cookieDomains
{
    if (_cookieDomains) {
        return _cookieDomains;
    }
    
    _cookieDomains = [NSMutableSet new];
    return _cookieDomains;
}

- (NSDictionary *)cookies
{
    return [self.mutableCookie copy];
}

- (NSDictionary<NSString *,NSString *> *)additionHeader
{
    return [self.mutableAdditionHeader copy];
}

- (NSMutableDictionary *)mutableCookie
{
    if (_mutableCookie) {
        return _mutableCookie;
    }
    
    _mutableCookie = [NSMutableDictionary new];
    return _mutableCookie;
}

- (NSMutableDictionary *)mutableAdditionHeader
{
    if (_mutableAdditionHeader) {
        return _mutableAdditionHeader;
    }
    
    _mutableAdditionHeader = [NSMutableDictionary new];
    return _mutableAdditionHeader;
}

- (WKProcessPool *)processPool
{
    if (_processPool) {
        return _processPool;
    }
    
    _processPool = [[WKProcessPool alloc] init];
    return _processPool;
}

- (WKUserContentController *)userContentController
{
    //为了保证每次都能拿到最新的cookie，这里每次都新建一个对象
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:[GP_OCJS_WKBridge sharedInstance] name:@"WKWebViewCore"];
    if (self.cookies) {
        [userContentController addUserScript:[self cookieScript]];
    }
    
    return userContentController;
}

- (WKUserScript *)cookieScript
{
    WKUserScript *ret = nil;
    if (self.cookies) {
        NSString *cookieScript = [self cookiesString];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:cookieScript
                                                      injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                   forMainFrameOnly:NO];
        ret = script;
    }
    return ret;
    
}

- (void)addDomain:(NSString *)domain
{
    if ([domain respondsToSelector:@selector(length)] && domain.length > 0) {
        [self.lock lock];
        [self.cookieDomains addObject:domain];
        [self.lock unlock];
    }
}

- (void)setCookiesKey:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieName] = key ?: @"";
    cookieProperties[NSHTTPCookieValue] = value ?: @"";
    cookieProperties[NSHTTPCookiePath] = @"/";
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    [cookieStorage setCookie:cookie];
    
    [self.lock lock];
    self.mutableCookie[key] = value;
    [self.lock unlock];
}

- (void)setAdditionHeader:(NSString *)header
                   forKey:(NSString *)key
{
    if (!key || ([key respondsToSelector:@selector(length)] && key.length == 0)) {
        return;
    }
    
    [self.lock lock];
    self.mutableAdditionHeader[key] = header;
    [self.lock unlock];
}

- (NSString *)cookiesString
{
    NSDictionary *dict = self.cookies;
    if (!self.cookieDomains || self.cookieDomains.count == 0) {
        return @"";
    }
    
    NSMutableString *string = [NSMutableString new];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        if (self.cookieDomains.count == 0) {
            [string appendFormat:@"document.cookie=\"%@=%@; path='/'; max-age=86400; \" ;", key, value];
        } else {
            [self.cookieDomains enumerateObjectsUsingBlock:^(NSString *domain, BOOL * _Nonnull stop) {
                [string appendFormat:@"document.cookie=\"%@=%@; path='/'; max-age=86400; domain=%@; \" ;", key, value, domain];
            }];
        }
    }];
    
    return string;
}

- (void)setUserAgent:(NSString *)userAgent
{
    dispatch_once(&gs_userAgentInitToken, ^{
        gs_userAgent = [GPSafariUAController sharedInstance].safariUAString;
    });
    
    NSString *defaultUA = gs_userAgent;
    NSMutableString *ua = [[NSMutableString alloc] init];
    if (defaultUA.length > 0) {
        [ua appendString:defaultUA];
    }
    
    if ([userAgent respondsToSelector:@selector(length)] && userAgent.length > 0) {
        [ua appendString:@" "];
        [ua appendString:userAgent];
    }
    
    _userAgent = ua;
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent" : _userAgent ?: @"" }];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userAgent
{
    dispatch_once(&gs_userAgentInitToken, ^{
        gs_userAgent = [GPSafariUAController sharedInstance].safariUAString;
    });
    
    NSString *ret = _userAgent;
    if (ret.length == 0) {
        ret = gs_userAgent;
    }
    
    return ret;
}
@end
