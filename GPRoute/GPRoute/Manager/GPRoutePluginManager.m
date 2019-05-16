//
//  GPRoutePluginManager.m
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPRoutePluginManager.h"
#import "GPRouteDelegate.h"
#import <objc/runtime.h>

typedef NSString* DomainName;
typedef NSString* PathName;

@interface GPRoutePluginManager()
@property (nonatomic, strong) NSDictionary<DomainName, NSDictionary<PathName, Class> *> * plugins;
@end

@implementation GPRoutePluginManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self scanPlugins];
    }
    
    return self;
}

- (void)scanPlugins
{
    NSMutableDictionary *domain2Plugins = [NSMutableDictionary new];
    
    int numClasses;
    Class * classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        
        for (int i = 0; i < numClasses; ++i) {
            
            Class c = classes[i];            
            if (class_conformsToProtocol(c, @protocol(GPRouteDelegate))) {
                NSString *domain = [c supportedDomain] ?: @"";
                domain = [domain lowercaseString];
                NSMutableDictionary<PathName, Class> *path2Plugins = nil;
                if (domain2Plugins[domain]) {
                    path2Plugins = [domain2Plugins[domain] mutableCopy];
                } else {
                    path2Plugins = [NSMutableDictionary new];
                }
                
                NSArray<PathName> *supportedPaths = nil;
                if ([((id) c) respondsToSelector:@selector(supportedPath)]) {
                    supportedPaths = [c supportedPath] ?: @[];
                }
                
                if (supportedPaths.count == 0) {
                    path2Plugins[@"*"] = c;
                } else {
                    [supportedPaths enumerateObjectsUsingBlock:^(NSString * _Nonnull path, NSUInteger idx, BOOL * _Nonnull stop) {
                        path2Plugins[path] = c;
                    }];
                }
                
                domain2Plugins[domain] = path2Plugins;
            }
        }
        
        free(classes);
    }
    
    self.plugins = domain2Plugins;
    NSLog(@"AGSRoute plugins:%@", self.plugins);
    
}

- (Class)pluginWithDomain:(NSString *)domain path:(NSString *)path
{
    NSString *domainLowerCase = [domain lowercaseString];
    NSDictionary<PathName, Class> *domains = self.plugins[domainLowerCase];
    Class target = domains[path];
    if (!target) {
        target = domains[@"*"];
    }
    return target;
}
@end
