//
//  NSMutableSet+MutableSetHook.m
//  GPFoundation
//
//  Created by Liyanwei on 2018/11/11.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "NSMutableSet+MutableSetHook.h"
#import "NSObject+SwizzleHook.h"
#import <objc/runtime.h>
#import "GPExceptionProxy.h"
#import "GPExceptionMacros.h"

GPSYNTH_DUMMY_CLASS(NSMutableSet_MutableSetHook)

@implementation NSMutableSet (MutableSetHook)

+ (void)gp_swizzleNSMutableSet{
    NSMutableSet* instanceObject = [NSMutableSet new];
    Class cls =  object_getClass(instanceObject);
    
    swizzleInstanceMethod(cls,@selector(addObject:), @selector(hookAddObject:));
    swizzleInstanceMethod(cls,@selector(removeObject:), @selector(hookRemoveObject:));
}

- (void) hookAddObject:(id)object {
    if (object) {
        [self hookAddObject:object];
    } else {
        handleCrashException(GPExceptionGuardArrayContainer,@"NSSet addObject nil object");
    }
}

- (void) hookRemoveObject:(id)object {
    if (object) {
        [self hookRemoveObject:object];
    } else {
        handleCrashException(GPExceptionGuardArrayContainer,@"NSSet removeObject nil object");
    }
}

@end
