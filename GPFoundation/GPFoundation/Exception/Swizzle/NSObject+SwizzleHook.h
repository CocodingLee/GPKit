//
//  NSObject+SwizzleHook.h
//  GPException
//
//  Created by Liyanwei on 2018/7/10.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * GPSwizzledIMPBlock assist variable
 */
typedef void (*GPSwizzleOriginalIMP)(void /* id, SEL, ... */ );

////////////////////////////////////////////////////////////////////////////////
@class GPSwizzleObject;

/*
 * GPSwizzledIMPBlock assist variable
 */
typedef id (^GPSwizzledIMPBlock)(GPSwizzleObject* swizzleInfo);

/**
 * Swizzle Class Method
 
 @param cls Class
 @param originSelector originSelector
 @param swizzleSelector swizzleSelector
 */
void swizzleClassMethod(Class cls, SEL originSelector, SEL swizzleSelector);

/**
 * Swizzle Instance Class Method
 
 @param cls Class
 @param originSelector originSelector
 @param swizzleSelector swizzleSelector
 */
void swizzleInstanceMethod(Class cls, SEL originSelector, SEL swizzleSelector);

/**
 * Only swizzle the current class,not swizzle all class
 * perform gp_cleanKVO selector before the origin dealloc
 
 @param class Class
 */
void gp_swizzleDeallocIfNeeded(Class class);

////////////////////////////////////////////////////////////////////////////////
//
// Swizzle
//

@interface GPSwizzleObject : NSObject
@property (nonatomic,readonly,assign) SEL selector;
- (GPSwizzleOriginalIMP)getOriginalImplementation;
@end

////////////////////////////////////////////////////////////////////////////////
//
// NSObject Swizzle
//

/**
 Swizzle the NSObject Extension
 */
@interface NSObject (SwizzleHook)

/**
 Swizzle Class Method
 
 @param originSelector originSelector
 @param swizzleSelector swizzleSelector
 */
+ (void)gp_swizzleClassMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

/**
 Swizzle Instance Method
 
 @param originSelector originSelector
 @param swizzleSelector swizzleSelector
 */
- (void)gp_swizzleInstanceMethod:(SEL)originSelector withSwizzleMethod:(SEL)swizzleSelector;

/**
 Swizzle instance method to the block target
 
 @param originSelector originSelector
 @param swizzledBlock block
 */
- (void)gp_swizzleInstanceMethod:(SEL)originSelector withSwizzledBlock:(GPSwizzledIMPBlock)swizzledBlock;

@end
