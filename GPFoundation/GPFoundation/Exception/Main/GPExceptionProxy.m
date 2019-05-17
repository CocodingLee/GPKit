//
//  JJExceptionProxy.m
//  GPFoundation
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPExceptionProxy.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>

__attribute__((overloadable)) void handleCrashException(NSString* exceptionMessage){
    [[GPExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage extraInfo:@{}];
}

__attribute__((overloadable)) void handleCrashException(NSString* exceptionMessage,NSDictionary* extraInfo){
    [[GPExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage extraInfo:extraInfo];
}

__attribute__((overloadable)) void handleCrashException(GPExceptionGuardCategory exceptionCategory, NSString* exceptionMessage,NSDictionary* extraInfo){
    [[GPExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:extraInfo];
}

__attribute__((overloadable)) void handleCrashException(GPExceptionGuardCategory exceptionCategory, NSString* exceptionMessage){
    [[GPExceptionProxy shareExceptionProxy] handleCrashException:exceptionMessage exceptionCategory:exceptionCategory extraInfo:nil];
}

/**
 Get application base address,the application different base address after started
 
 @return base address
 */
uintptr_t get_load_address(void) {
    const struct mach_header *exe_header = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            exe_header = header;
            break;
        }
    }
    return (uintptr_t)exe_header;
}

/**
 Address Offset

 @return slide address
 */
uintptr_t get_slide_address(void) {
    uintptr_t vmaddr_slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE) {
            vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    
    return (uintptr_t)vmaddr_slide;
}

@interface GPExceptionProxy()
{
    NSMutableSet* _currentClassesSet;
    NSMutableSet* _blackClassesSet;
    NSInteger _currentClassSize;
    dispatch_semaphore_t _classArrayLock;//Protect _blackClassesSet and _currentClassesSet atomic
    dispatch_semaphore_t _swizzleLock;//Protect swizzle atomic
}

@end

@implementation GPExceptionProxy

+(instancetype)shareExceptionProxy
{
    static dispatch_once_t onceToken;
    static id exceptionProxy;
    dispatch_once(&onceToken, ^{
        exceptionProxy = [[self alloc] init];
    });
    return exceptionProxy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _blackClassesSet = [NSMutableSet new];
        _currentClassesSet = [NSMutableSet new];
        _currentClassSize = 0;
        _classArrayLock = dispatch_semaphore_create(1);
        _swizzleLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)handleCrashException:(NSString *)exceptionMessage
           exceptionCategory:(GPExceptionGuardCategory)exceptionCategory
                   extraInfo:(NSDictionary *)info
{
    if (!exceptionMessage) {
        return;
    }
    
    NSArray* callStack = [NSThread callStackSymbols];
    NSString* callStackString = [NSString stringWithFormat:@"%@",callStack];
    
    uintptr_t loadAddress =  get_load_address();
    uintptr_t slideAddress =  get_slide_address();
    
    NSString* exceptionResult = [NSString stringWithFormat:@"%ld\n%ld\n%@\n%@",loadAddress,slideAddress,exceptionMessage,callStackString];
    
    
    if ([self.delegate respondsToSelector:@selector(handleCrashException:extraInfo:)]){
        [self.delegate handleCrashException:exceptionResult extraInfo:info];
    }
    
    if ([self.delegate respondsToSelector:@selector(handleCrashException:exceptionCategory:extraInfo:)]) {
        [self.delegate handleCrashException:exceptionResult exceptionCategory:exceptionCategory extraInfo:info];
    }
    
#ifdef DEBUG
    NSLog(@"================================GPException Start==================================");
    NSLog(@"GPException Type:%ld",(long)exceptionCategory);
    NSLog(@"GPException Description:%@",exceptionMessage);
    NSLog(@"GPException Extra info:%@",info);
    NSLog(@"GPException CallStack:%@",callStack);
    NSLog(@"================================GPException End====================================");
    if (self.exceptionWhenTerminate) {
        NSAssert(NO, @"");
    }
#endif
}

- (void)handleCrashException:(NSString *)exceptionMessage
                   extraInfo:(nullable NSDictionary *)info
{
    [self handleCrashException:exceptionMessage exceptionCategory:GPExceptionGuardNone extraInfo:info];
}

- (void)setIsProtectException:(BOOL)isProtectException
{
    dispatch_semaphore_wait(_swizzleLock, DISPATCH_TIME_FOREVER);
    if (_isProtectException != isProtectException) {
        _isProtectException = isProtectException;
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        
        if(self.exceptionGuardCategory & GPExceptionGuardArrayContainer){
            [NSArray performSelector:@selector(gp_swizzleNSArray)];
            [NSMutableArray performSelector:@selector(gp_swizzleNSMutableArray)];
            [NSSet performSelector:@selector(gp_swizzleNSSet)];
            [NSMutableSet performSelector:@selector(gp_swizzleNSMutableSet)];
        }
        if(self.exceptionGuardCategory & GPExceptionGuardDictionaryContainer){
            [NSDictionary performSelector:@selector(gp_swizzleNSDictionary)];
            [NSMutableDictionary performSelector:@selector(gp_swizzleNSMutableDictionary)];
        }
        if(self.exceptionGuardCategory & GPExceptionGuardUnrecognizedSelector){
            [NSObject performSelector:@selector(gp_swizzleUnrecognizedSelector)];
        }
        
        if (self.exceptionGuardCategory & GPExceptionGuardZombie) {
            [NSObject performSelector:@selector(gp_swizzleZombie)];
        }
        
        if (self.exceptionGuardCategory & GPExceptionGuardKVOCrash) {
            [NSObject performSelector:@selector(gp_swizzleKVOCrash)];
        }
        
        if (self.exceptionGuardCategory & GPExceptionGuardNSTimer) {
            [NSTimer performSelector:@selector(gp_swizzleNSTimer)];
        }
        
        if (self.exceptionGuardCategory & GPExceptionGuardNSNotificationCenter) {
            [NSNotificationCenter performSelector:@selector(gp_swizzleNSNotificationCenter)];
        }
        
        if (self.exceptionGuardCategory & GPExceptionGuardNSStringContainer) {
            [NSString performSelector:@selector(gp_swizzleNSString)];
            [NSMutableString performSelector:@selector(gp_swizzleNSMutableString)];
            [NSAttributedString performSelector:@selector(gp_swizzleNSAttributedString)];
            [NSMutableAttributedString performSelector:@selector(gp_swizzleNSMutableAttributedString)];
        }
        #pragma clang diagnostic pop
    }
    dispatch_semaphore_signal(_swizzleLock);
}

- (void)setExceptionGuardCategory:(GPExceptionGuardCategory)exceptionGuardCategory{
    if (_exceptionGuardCategory != exceptionGuardCategory) {
        _exceptionGuardCategory = exceptionGuardCategory;
    }
}



- (void)addZombieObjectArray:(NSArray*)objects{
    if (!objects) {
        return;
    }
    dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
    [_blackClassesSet addObjectsFromArray:objects];
    dispatch_semaphore_signal(_classArrayLock);
}

- (NSSet*)blackClassesSet{
    return _blackClassesSet;
}

- (void)addCurrentZombieClass:(Class)object
{
    if (object) {
        dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
        _currentClassSize = _currentClassSize + class_getInstanceSize(object);
        [_currentClassesSet addObject:object];
        dispatch_semaphore_signal(_classArrayLock);
    }
}

- (void)removeCurrentZombieClass:(Class)object
{
    if (object) {
        dispatch_semaphore_wait(_classArrayLock, DISPATCH_TIME_FOREVER);
        _currentClassSize = _currentClassSize - class_getInstanceSize(object);
        [_currentClassesSet removeObject:object];
        dispatch_semaphore_signal(_classArrayLock);
    }
}

- (NSSet*)currentClassesSet
{
    return _currentClassesSet;
}

- (NSInteger)currentClassSize
{
    return _currentClassSize;
}

- (nullable id)objectFromCurrentClassesSet
{
    NSEnumerator* objectEnum = [_currentClassesSet objectEnumerator];
    for (id object in objectEnum) {
        return object;
    }
    return nil;
}

@end
