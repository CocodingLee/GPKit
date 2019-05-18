//
//  NSMutableArray+MutableArrayHook.m
//  GPException
//
//  Created by Liyanwei on 2018/7/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "NSMutableArray+MutableArrayHook.h"
#import "NSObject+SwizzleHook.h"
#import "GPExceptionProxy.h"
#import "GPExceptionMacros.h"

GPSYNTH_DUMMY_CLASS(NSMutableArray_MutableArrayHook)

@implementation NSMutableArray (MutableArrayHook)

+ (void)gp_swizzleNSMutableArray
{
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndex:), @selector(hookObjectAtIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(subarrayWithRange:), @selector(hookSubarrayWithRange:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(objectAtIndexedSubscript:), @selector(hookObjectAtIndexedSubscript:));
    
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:), @selector(hookAddObject:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(insertObject:atIndex:), @selector(hookInsertObject:atIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(removeObjectAtIndex:), @selector(hookRemoveObjectAtIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(replaceObjectAtIndex:withObject:), @selector(hookReplaceObjectAtIndex:withObject:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(setObject:atIndexedSubscript:), @selector(hookSetObject:atIndexedSubscript:));
    swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(removeObjectsInRange:), @selector(hookRemoveObjectsInRange:));
    
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(objectAtIndex:), @selector(hookObjectAtIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(subarrayWithRange:), @selector(hookSubarrayWithRange:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(objectAtIndexedSubscript:), @selector(hookObjectAtIndexedSubscript:));
    
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(addObject:), @selector(hookAddObject:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(insertObject:atIndex:), @selector(hookInsertObject:atIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(removeObjectAtIndex:), @selector(hookRemoveObjectAtIndex:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(replaceObjectAtIndex:withObject:), @selector(hookReplaceObjectAtIndex:withObject:));
    swizzleInstanceMethod(NSClassFromString(@"__NSCFArray"), @selector(removeObjectsInRange:), @selector(hookRemoveObjectsInRange:));
}

- (void) hookAddObject:(id)anObject
{
    if (anObject) {
        [self hookAddObject:anObject];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,@"NSMutableArray addObject nil object");
    }
}

- (id) hookObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndex:index];
    }
    
    handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray objectAtIndex invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (id) hookObjectAtIndexedSubscript:(NSInteger)index
{
    if (index < self.count) {
        return [self hookObjectAtIndexedSubscript:index];
    }
    handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray objectAtIndexedSubscript invalid index:%tu total:%tu",index,self.count]);
    return nil;
}

- (void) hookInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index <= self.count) {
        [self hookInsertObject:anObject atIndex:index];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray insertObject invalid index:%tu total:%tu insert object:%@",index,self.count,anObject]);
    }
}

- (void) hookRemoveObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        [self hookRemoveObjectAtIndex:index];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray removeObjectAtIndex invalid index:%tu total:%tu",index,self.count]);
    }
}

- (void) hookReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index < self.count && anObject) {
        [self hookReplaceObjectAtIndex:index withObject:anObject];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray replaceObjectAtIndex invalid index:%tu total:%tu replace object:%@",index,self.count,anObject]);
    }
}

- (void) hookSetObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    if (index < self.count && object) {
        [self hookSetObject:object atIndexedSubscript:index];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray setObject invalid object:%@ atIndexedSubscript:%tu total:%tu",object,index,self.count]);
    }
}

- (void) hookRemoveObjectsInRange:(NSRange)range
{
    if (range.location + range.length <= self.count) {
        [self hookRemoveObjectsInRange:range];
    }else{
        handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray removeObjectsInRange invalid range location:%tu length:%tu",range.location,range.length]);
    }
}

- (NSArray *)hookSubarrayWithRange:(NSRange)range
{
    if (range.location + range.length <= self.count){
        return [self hookSubarrayWithRange:range];
    }else if (range.location < self.count){
        return [self hookSubarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    handleCrashException(GPExceptionGuardArrayContainer,[NSString stringWithFormat:@"NSMutableArray subarrayWithRange invalid range location:%tu length:%tu",range.location,range.length]);
    return nil;
}

@end
