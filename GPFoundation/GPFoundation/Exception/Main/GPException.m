//
//  GPException.m
//  GPException
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPException.h"
#import "GPExceptionProxy.h"

@implementation GPException

+ (BOOL)isGuardException {
    return [GPExceptionProxy shareExceptionProxy].isProtectException;
}

+ (BOOL)exceptionWhenTerminate{
    return [GPExceptionProxy shareExceptionProxy].exceptionWhenTerminate;
}

+ (void)setExceptionWhenTerminate:(BOOL)exceptionWhenTerminate{
    [GPExceptionProxy shareExceptionProxy].exceptionWhenTerminate = exceptionWhenTerminate;
}

+ (void)startGuardException{
    [GPExceptionProxy shareExceptionProxy].isProtectException = YES;
}

+ (void)stopGuardException{
    [GPExceptionProxy shareExceptionProxy].isProtectException = NO;
}

+ (void)configExceptionCategory:(GPExceptionGuardCategory)exceptionGuardCategory{
    [GPExceptionProxy shareExceptionProxy].exceptionGuardCategory = exceptionGuardCategory;
}

+ (void)registerExceptionHandle:(id<GPExceptionHandle>)exceptionHandle{
    [GPExceptionProxy shareExceptionProxy].delegate = exceptionHandle;
}

+ (void)addZombieObjectArray:(NSArray*)objects{
    [[GPExceptionProxy shareExceptionProxy] addZombieObjectArray:objects];
}

@end
