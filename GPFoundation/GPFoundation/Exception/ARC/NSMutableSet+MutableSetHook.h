//
//  NSMutableSet+MutableSetHook.h
//  GPFoundation
//
//  Created by Liyanwei on 2018/11/11.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet (MutableSetHook)

+ (void)gp_swizzleNSMutableSet;

@end

NS_ASSUME_NONNULL_END
