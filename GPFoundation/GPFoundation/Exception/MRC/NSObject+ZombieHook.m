//
//  NSObject+Zombie.m
//  JJException
//
//  Created by Jezz on 2018/7/26.
//  Copyright © 2018年 Jezz. All rights reserved.
//

#import "NSObject+ZombieHook.h"
#import "NSObject+SwizzleHook.h"
#import <objc/runtime.h>
#import "GPExceptionProxy.h"

const NSInteger MAX_ARRAY_SIZE = 1024 * 1024 * 5;// MAX Memeory Size 5M

////////////////////////////////////////////////////////////////////////////////

@interface ZombieSelectorHandle : NSObject
@property(nonatomic,readwrite,assign)id fromObject;
@end


@implementation ZombieSelectorHandle

void unrecognizedSelectorZombie(ZombieSelectorHandle* self, SEL _cmd)
{
    // 添加数据
}

@end

@interface GPZombieSub : NSObject
@end

@implementation GPZombieSub

- (id)forwardingTargetForSelector:(SEL)selector
{
    NSMethodSignature* sign = [self methodSignatureForSelector:selector];
    if (!sign) {
        id stub = [[ZombieSelectorHandle new] autorelease];
        [stub setFromObject:self];
        class_addMethod([stub class], selector, (IMP)unrecognizedSelectorZombie, "v@:");
        return stub;
    }
    
    return [super forwardingTargetForSelector:selector];
}

@end

////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (ZombieHook)

+ (void)gp_swizzleZombie
{
    [self gp_swizzleInstanceMethod:@selector(dealloc) withSwizzleMethod:@selector(hookDealloc)];
}

- (void)hookDealloc
{
    Class currentClass = self.class;
    
    //Check black list
    if (![[[GPExceptionProxy shareExceptionProxy] blackClassesSet] containsObject:currentClass]) {
        [self hookDealloc];
        return;
    }
    
    //Check the array max size
    //TODO:Real remove less than MAX_ARRAY_SIZE
    if ([GPExceptionProxy shareExceptionProxy].currentClassSize > MAX_ARRAY_SIZE) {
        id object = [[GPExceptionProxy shareExceptionProxy] objectFromCurrentClassesSet];
        [[GPExceptionProxy shareExceptionProxy] removeCurrentZombieClass:object_getClass(object)];
        object?free(object):nil;
    }
    
    objc_destructInstance(self);
    object_setClass(self, [GPZombieSub class]);
    [[GPExceptionProxy shareExceptionProxy] addCurrentZombieClass:currentClass];
}

@end
