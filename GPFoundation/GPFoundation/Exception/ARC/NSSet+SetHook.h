//
//  NSSet+SetHook.h
//  GPFoundation
//
//  Created by Liyanwei on 2018/11/11.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet (SetHook)

+ (void)gp_swizzleNSSet;

@end

NS_ASSUME_NONNULL_END
