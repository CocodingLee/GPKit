//
//  GPRoutePluginManager.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPRoutePluginManager : NSObject
- (Class)pluginWithDomain:(NSString *)domain
                     path:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
