//
//  NSMutableDictionary+MutableDictionaryHook.m
//  GPException
//
//  Created by Liyanwei on 2018/7/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "NSMutableDictionary+MutableDictionaryHook.h"
#import "NSObject+SwizzleHook.h"
#import "GPExceptionProxy.h"
#import "GPExceptionMacros.h"

GPSYNTH_DUMMY_CLASS(NSMutableDictionary_MutableDictionaryHook)

@implementation NSMutableDictionary (MutableDictionaryHook)

+ (void)gp_swizzleNSMutableDictionary
{
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), @selector(hookSetObject:forKey:));
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(hookRemoveObjectForKey:));
    swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(hookSetObject:forKeyedSubscript:));
}

- (void) hookSetObject:(id)object forKey:(id)key
{
    if (object && key) {
        [self hookSetObject:object forKey:key];
    } else {
        handleCrashException(GPExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject invalid object:%@ and key:%@",object,key],self);
    }
}

- (void) hookRemoveObjectForKey:(id)key
{
    if (key) {
        [self hookRemoveObjectForKey:key];
    } else {
        handleCrashException(GPExceptionGuardDictionaryContainer,@"NSMutableDictionary removeObjectForKey nil key",self);
    }
}

- (void) hookSetObject:(id)object forKeyedSubscript:(id<NSCopying>)key
{
    if (object && key ) {
        [self hookSetObject:object forKeyedSubscript:key];
    } else {
        handleCrashException(GPExceptionGuardDictionaryContainer,[NSString stringWithFormat:@"NSMutableDictionary setObject object:%@ and forKeyedSubscript:%@",object,key],self);
    }
}

@end
