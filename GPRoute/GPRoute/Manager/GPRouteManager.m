//
//  GPRouteManager.m
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPRouteManager.h"
#import "GPRouteRegManager.h"
#import "GPRouteRegTreeDelegate.h"

#import "GPRoutePluginManager.h"
#import "GPRouteDelegate.h"

#import <objc/runtime.h>
#import <objc/message.h>

NSString *const GPRouteURLScheme = @"GPRoute";
NSString *const GPRouteErrorDomain = @"GPRouteErrorDomain";
NSString *const GPRouteTargetKey = @"Target";
NSString *const GPRouteDomainKey = @"Domain";
NSString *const GPRoutePathKey = @"Path";
NSString *const GPRouteURLKey = @"URL";

typedef void (^PluginCompletion)(NSDictionary *, NSError *);

@interface GPRouteManager ()
@property (nonatomic, strong) GPRoutePluginManager *pluginManager;
@end

@implementation GPRouteManager
@synthesize regManager = _regManager;

+ (instancetype)sharedInstance
{
    static GPRouteManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[GPRouteManager alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self pluginManager];
    }
    
    return self;
}

- (GPRouteRegManager *)regManager
{
    if (!_regManager) {
       _regManager = [[GPRouteRegManager alloc] init];
    }
    
    return _regManager;
}

- (GPRoutePluginManager *)pluginManager
{
    if (!_pluginManager) {
        _pluginManager = [[GPRoutePluginManager alloc] init];
    }
    
    return _pluginManager;
}

- (void)openURL:(NSURL *)url
       addition:(NSDictionary *)addition
     completion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *scheme = url.scheme;
    NSString *host = url.host;
    NSMutableString *path = [url.path mutableCopy];
    if ([path hasPrefix:@"/"]) {
        [path replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSArray *queries = [url.query componentsSeparatedByString:@"&"];
    [queries enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *kv = [obj componentsSeparatedByString:@"="];
        if (kv.count < 2) {
            return;
        }
        
        params[[kv firstObject]] = [NSString stringWithFormat:@"%@", [kv lastObject]].stringByRemovingPercentEncoding;
    }];
    
    if (addition) {
        params[@"GP_openURLAddition"] = addition;
    }
    
    [self openScheme:scheme domain:host path:path params:params completion:completion];
}

- (void)openURL:(NSURL *)url
     completion:(void (^)(NSDictionary *, NSError *))completion
{
    [self openURL:url
         addition:nil
       completion:completion];
}

- (void)openDomain:(NSString *)domain
              path:(NSString *)path
            params:(NSDictionary *)params
        completion:(void (^)(NSDictionary *, NSError *))completion
{
    [self openScheme:nil domain:domain path:path params:params completion:completion];
}

- (void)openScheme:(NSString *)scheme
            domain:(NSString *)domain
              path:(NSString *)path
            params:(NSDictionary *)params
        completion:(void (^)(NSDictionary *, NSError *))completion
{
    id plugin = [self.pluginManager pluginWithDomain:domain path:path];
    if (!plugin) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:GPRouteErrorDomain code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"Cannot find plugin." }];
            completion(nil, error);
        }
        return;
    }
    
    void (^completionBlock)(GPRouteDecision, NSError *) = ^(GPRouteDecision decision, NSError *error) {
        switch (decision) {
            case GPRouteDecisionAllow:
            {
                [self performRequestWithPlugin:plugin scheme:scheme domain:domain path:path params:params completion:completion];
                break;
            }
            case GPRouteDecisionDeny:
            {
                if (completion) {
                    NSError *retError = nil;
                    if (error) {
                        retError = error;
                    } else {
                        retError = [NSError errorWithDomain:GPRouteErrorDomain code:-1
                                                   userInfo:@{ NSLocalizedDescriptionKey : @"Regulartion Deny." }];
                    }
                    completion(nil, error);
                }
                break;
            }
            default:
                break;
        }
    };
    
    [self.regManager checkRegsWithDomain:domain path:path params:params completion:completionBlock];
}

- (void)pingDomain:(NSString *)domain
              path:(NSString *)path
            params:(NSDictionary *)params
        completion:(void (^)(GPRouteDecision, NSError *))completion
{
    void (^completionBlock)(GPRouteDecision, NSError *) = ^(GPRouteDecision decision, NSError *error) {
        switch (decision) {
            case GPRouteDecisionAllow:
            {
                if (completion) {
                    completion(decision, error);
                }
                break;
            }
            case GPRouteDecisionDeny:
            {
                if (completion) {
                    NSError *retError = nil;
                    if (error) {
                        retError = error;
                    } else {
                        retError = [NSError errorWithDomain:GPRouteErrorDomain code:-1
                                                   userInfo:@{ NSLocalizedDescriptionKey : @"Regulartion Deny." }];
                    }
                    completion(GPRouteDecisionDeny, retError);
                }
                break;
            }
            default:
                break;
        }
    };
    
    [self.regManager checkRegsWithDomain:domain path:path params:params completion:completionBlock];
}


- (void)performRequestWithPlugin:(Class)plugin scheme:(NSString *)scheme domain:(NSString *)domain path:(NSString *)path
                          params:(NSDictionary *)params completion:(void (^)(NSDictionary *, NSError *))completion
{
    NSString *routeString = [NSString stringWithFormat:@"%@://%@/%@", scheme ?: GPRouteURLScheme, domain, path];
    NSURL *routeURL = [NSURL URLWithString:routeString];
    
    NSString *toPathSelString = [NSString stringWithFormat:@"route%@WithURL:params:completion:",[self parsePathToSignature:path]];
    SEL toPathSel = NSSelectorFromString(toPathSelString);
    
    NSString *fromPathSelString = [NSString stringWithFormat:@"routeFromURL:path:params:completion:"];
    SEL fromPathSel = NSSelectorFromString(fromPathSelString);
    
    PluginCompletion pluginCompletion = ^(NSDictionary *ret, NSError *error) {
        if (completion) {
            completion(ret, error);
        }
    };
    
    if (class_getClassMethod(plugin, toPathSel)) {
        ((void (*)(id, SEL, NSURL *, NSDictionary *, PluginCompletion))objc_msgSend)(plugin, toPathSel, routeURL, params, pluginCompletion);
    } else if (class_getClassMethod(plugin, fromPathSel)) {
        ((void (*)(id, SEL, NSURL *, NSString *, NSDictionary *, PluginCompletion))objc_msgSend)(plugin, fromPathSel, routeURL,
                                                                                                 path, params, pluginCompletion);
    } else if ([plugin instancesRespondToSelector:@selector(initWithParams:)]){
        SEL init = NSSelectorFromString(@"initWithParams:");
        id instance = [plugin alloc];
        
        NSMutableDictionary *initParams = params ? [params mutableCopy] : [NSMutableDictionary new];
        if (domain) {
            initParams[GPRouteDomainKey] = domain;
        }
        if (path) {
            initParams[GPRoutePathKey] = path;
        }
        initParams[GPRouteURLKey] = routeURL;
        
        instance = ((id (*)(id, SEL, NSDictionary *))objc_msgSend)(instance, init, initParams);
        pluginCompletion(@{ GPRouteTargetKey : instance }, nil);
    } else {
        if (completion) {
            NSString *msg = [NSString stringWithFormat:@"Plugin not implemented method:%@", toPathSelString];
            NSError *error = [NSError errorWithDomain:GPRouteErrorDomain code:-1 userInfo:@{ NSLocalizedDescriptionKey : msg }];
            completion(nil, error);
        }
    }
}

- (NSString *)parsePathToSignature:(NSString *)path
{
    if (![path respondsToSelector:@selector(length)] || path.length == 0) {
        return nil;
    }
    NSArray *components = [path componentsSeparatedByString:@"."];
    NSMutableString *signature = [NSMutableString new];
    [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signature appendString:[NSString stringWithFormat:@"%@%@",[[obj substringToIndex:1] uppercaseString],[obj substringFromIndex:1] ]];
    }];
    
    return signature;
}

@end
