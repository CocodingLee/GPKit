//
//  GPException.h
//  GPException
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Before start GPException,must config the GPExceptionGuardCategory
 
 - GPExceptionGuardNone: Do not guard normal crash exception
 - GPExceptionGuardUnrecognizedSelector: Unrecognized Selector Exception
 - GPExceptionGuardDictionaryContainer: NSDictionary,NSMutableDictionary
 - GPExceptionGuardArrayContainer: NSArray,NSMutableArray
 - GPExceptionGuardZombie: Zombie
 - GPExceptionGuardKVOCrash: KVO exception
 - GPExceptionGuardNSTimer: NSTimer
 - GPExceptionGuardNSNotificationCenter: NSNotificationCenter
 - GPExceptionGuardNSStringContainer:NSString,NSMutableString,NSAttributedString,NSMutableAttributedString
 - GPExceptionGuardAllExceptZombie:Above All except Zombie
 - GPExceptionGuardAll: Above All
 */
typedef NS_OPTIONS(NSInteger,GPExceptionGuardCategory){
    GPExceptionGuardNone = 0,
    GPExceptionGuardUnrecognizedSelector = 1 << 1,
    GPExceptionGuardDictionaryContainer = 1 << 2,
    GPExceptionGuardArrayContainer = 1 << 3,
    GPExceptionGuardZombie = 1 << 4,
    GPExceptionGuardKVOCrash = 1 << 5,
    GPExceptionGuardNSTimer = 1 << 6,
    GPExceptionGuardNSNotificationCenter = 1 << 7,
    GPExceptionGuardNSStringContainer = 1 << 8,
    GPExceptionGuardAllExceptZombie = GPExceptionGuardUnrecognizedSelector | GPExceptionGuardDictionaryContainer | GPExceptionGuardArrayContainer | GPExceptionGuardKVOCrash | GPExceptionGuardNSTimer | GPExceptionGuardNSNotificationCenter | GPExceptionGuardNSStringContainer,
    GPExceptionGuardAll = GPExceptionGuardUnrecognizedSelector | GPExceptionGuardDictionaryContainer | GPExceptionGuardArrayContainer | GPExceptionGuardZombie | GPExceptionGuardKVOCrash | GPExceptionGuardNSTimer | GPExceptionGuardNSNotificationCenter | GPExceptionGuardNSStringContainer,
};

/**
 Exception interface
 */
@protocol GPExceptionHandle<NSObject>

/**
 Crash message and extra info from current thread
 
 @param exceptionMessage crash message
 @param info extraInfo,key and value
 */
- (void)handleCrashException:(NSString*)exceptionMessage extraInfo:(nullable NSDictionary*)info;

@optional

/**
 Crash message,exceptionCategory, extra info from current thread
 
 @param exceptionMessage crash message
 @param exceptionCategory GPExceptionGuardCategory
 @param info extra info
 */
- (void)handleCrashException:(NSString*)exceptionMessage exceptionCategory:(GPExceptionGuardCategory)exceptionCategory extraInfo:(nullable NSDictionary*)info;

@end

/**
 Exception main
 */
@interface GPException : NSObject


/**
 If exceptionWhenTerminate YES,the exception will stop application
 If exceptionWhenTerminate NO,the exception only show log on the console, will not stop the application
 Default value:NO
 */
@property(class,nonatomic,readwrite,assign)BOOL exceptionWhenTerminate;

/**
 GPException guard exception status,default is NO
 */
@property(class,nonatomic,readonly,assign)BOOL isGuardException;

/**
 Config the guard exception category,default:GPExceptionGuardNone
 
 @param exceptionGuardCategory GPExceptionGuardCategory
 */
+ (void)configExceptionCategory:(GPExceptionGuardCategory)exceptionGuardCategory;

/**
 Start the exception protect
 */
+ (void)startGuardException;

/**
 Stop the exception protect
 
 * Why deprecated this method:
 * https://github.com/jezzmemo/GPException/issues/54
 */
+ (void)stopGuardException __attribute__((deprecated("Stop invoke this method,If invoke this,Maybe occur the infinite loop and then CRASH")));

/**
 Register exception interface

 @param exceptionHandle GPExceptionHandle
 */
+ (void)registerExceptionHandle:(id<GPExceptionHandle>)exceptionHandle;

/**
 Only handle the black list zombie object
 
 Sample Code:
 
    [GPException addZombieObjectArray:@[TestZombie.class]];

 @param objects Class Array
 */
+ (void)addZombieObjectArray:(NSArray*)objects;

@end

NS_ASSUME_NONNULL_END
