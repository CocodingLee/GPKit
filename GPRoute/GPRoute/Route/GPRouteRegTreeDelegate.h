//
//  GPRouteRegTreeDelegate.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPRouteDefine.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPRouteRegTreeDelegate <NSObject>

- (void)regWithDomain:(NSString *)domain path:(NSString *)path
               params:(NSDictionary *)params
           completion:(void (^)(GPRouteDecision, NSError *))completion;
@end

NS_ASSUME_NONNULL_END
