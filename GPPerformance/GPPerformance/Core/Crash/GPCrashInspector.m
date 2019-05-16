//
//  GPCrashInspector.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPCrashInspector.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

@implementation GPCrashInspector
{
    BOOL            _isInstalled;
    NSString*       _crashLogPath;
    NSMutableArray* _plist;
}

+ (instancetype)sharedInstance
{
    static GPCrashInspector* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GPCrashInspector new];
    });
    return instance;
}

const int maxCrashLogNum  = 20;

//handle exception

void gpHandleException(NSException *exception)
{
    [[GPCrashInspector sharedInstance] saveException:exception];
    [exception raise];
}

void gpSignalHandler(int sig)
{
    [[GPCrashInspector sharedInstance]saveSignal:sig];
    
    signal(sig, SIG_DFL);
    raise(sig);
}

+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (int i = 0;i < 32;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* sandBoxPath  = [paths objectAtIndex:0];
        
    
        _crashLogPath = [sandBoxPath stringByAppendingPathComponent:@"GPCrashLog"];
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:_crashLogPath] ) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_crashLogPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:NULL];
        }
        
        //creat plist
        if (YES == [[NSFileManager defaultManager] fileExistsAtPath:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]]) {
            _plist = [[NSMutableArray arrayWithContentsOfFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"]] mutableCopy];
        }
        else {
            _plist = [NSMutableArray new];
        }
    }
    
    return self;
}

- (NSDictionary* )crashForKey:(NSString *)key
{
    NSString* filePath = [[_crashLogPath stringByAppendingPathComponent:key] stringByAppendingString:@".plist"];
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    return dict;
}

- (NSArray* )crashPlist
{
    return [_plist copy];
}

- (NSArray* )crashLogs
{
    NSMutableArray* ret = [NSMutableArray new];
    for (NSString* key in _plist) {
        
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        NSString* path = [filePath stringByAppendingString:@".plist"];
        NSDictionary* log = [NSDictionary dictionaryWithContentsOfFile:path];
        [ret addObject:log];
    }
    
    return [ret copy];
}


- (NSDictionary* )crashReport
{
    for (NSString* key in _plist) {
        
        NSString* filePath = [_crashLogPath stringByAppendingPathComponent:key];
        
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        return dict;
    }
    
    return nil;
}

- (void)install
{
    if (!_isInstalled) {
        
        //注册回调函数
        NSSetUncaughtExceptionHandler(&gpHandleException);
        signal(SIGABRT, gpSignalHandler);
        signal(SIGILL, gpSignalHandler);
        signal(SIGSEGV, gpSignalHandler);
        signal(SIGFPE, gpSignalHandler);
        signal(SIGBUS, gpSignalHandler);
        signal(SIGPIPE, gpSignalHandler);
    }
}

- (void)dealloc
{
    signal( SIGABRT,	SIG_DFL );
    signal( SIGBUS,		SIG_DFL );
    signal( SIGFPE,		SIG_DFL );
    signal( SIGILL,		SIG_DFL );
    signal( SIGPIPE,	SIG_DFL );
    signal( SIGSEGV,	SIG_DFL );
}

- (void)saveException:(NSException*)exception
{
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    if ( exception.name ) {
        [detail setObject:exception.name forKey:@"name"];
    }
    
    if ( exception.reason ) {
        [detail setObject:exception.reason forKey:@"reason"];
    }
    
    if ( exception.userInfo ) {
        [detail setObject:exception.userInfo forKey:@"userInfo"];
    }
    
    if ( exception.callStackSymbols ) {
        [detail setObject:exception.callStackSymbols forKey:@"callStack"];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:@"exception" forKey:@"type"];
    [dict setObject:detail forKey:@"info"];
    
    [self saveToFile:dict];
    
}

- (void)saveSignal:(int) signal
{
    NSMutableDictionary * detail = [NSMutableDictionary dictionary];
    [detail setObject:@(signal) forKey:@"signal type"];
    [self saveToFile:detail];
}

- (void)saveToFile:(NSMutableDictionary*)dict
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    
    //add date
    [dict setObject:dateString forKey:@"date"];
    
    //save path
    NSString* savePath = [[_crashLogPath stringByAppendingPathComponent:dateString] stringByAppendingString:@".plist"];
    
    //save to disk
    BOOL succeed = [ dict writeToFile:savePath atomically:YES];
    if ( NO == succeed ) {
        NSLog(@"GPInspector:Save crash report failed!");
    } else {
        NSLog(@"GPInspector:save crash report succeed!");
    }
    
    [_plist insertObject:dateString atIndex:0];
    
    if (_plist.count > maxCrashLogNum) {
        [[NSFileManager defaultManager] removeItemAtPath:[_crashLogPath stringByAppendingPathComponent:_plist[0]] error:nil];
        [_plist removeObjectAtIndex:0];
    }
    
    [_plist writeToFile:[_crashLogPath stringByAppendingPathComponent:@"crashLog.plist"] atomically:YES];
}

@end
