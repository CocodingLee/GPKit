//
//  NSSet+SetHook.m
//  GPFoundation
//
//  Created by Liyanwei on 2018/11/11.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "NSSet+SetHook.h"
#import "NSObject+SwizzleHook.h"
#import "GPExceptionProxy.h"
#import "GPExceptionMacros.h"

GPSYNTH_DUMMY_CLASS(NSSet_SetHook)

@implementation NSSet (SetHook)

+ (void)gp_swizzleNSSet{
    [NSSet gp_swizzleClassMethod:@selector(setWithObject:) withSwizzleMethod:@selector(hookSetWithObject:)];
}

+ (instancetype)hookSetWithObject:(id)object{
    if (object){
        return [self hookSetWithObject:object];
    }
    handleCrashException(GPExceptionGuardArrayContainer,@"NSSet setWithObject nil object");
    return nil;
}

@end
