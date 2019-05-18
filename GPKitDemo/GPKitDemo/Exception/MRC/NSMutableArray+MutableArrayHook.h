//
//  NSMutableArray+MutableArrayHook.h
//  GPException
//
//  Created by Liyanwei on 2018/7/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MutableArrayHook)

+ (void)gp_swizzleNSMutableArray;

@end
