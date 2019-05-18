//
//  GPFoundation.h
//  GPFoundation
//
//  Created by Liyanwei on 2019/5/17.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

// base
#import <GPFoundation/NSData+GPGZIP.h>

// Exception

// main
#import <GPFoundation/GPExceptionMacros.h>
#import <GPFoundation/GPExceptionProxy.h>
#import <GPFoundation/GPException.h>

// swizzle
#import <GPFoundation/NSObject+SwizzleHook.h>

// arc
#import <GPFoundation/NSAttributedString+AttributedStringHook.h>
#import <GPFoundation/NSMutableAttributedString+MutableAttributedStringHook.h>
#import <GPFoundation/NSMutableSet+MutableSetHook.h>
#import <GPFoundation/NSMutableString+MutableStringHook.h>
#import <GPFoundation/NSNotificationCenter+ClearNotification.h>
#import <GPFoundation/NSSet+SetHook.h>
#import <GPFoundation/NSString+StringHook.h>
#import <GPFoundation/NSTimer+CleanTimer.h>

// mrc
#import <GPFoundation/NSArray+ArrayHook.h>
#import <GPFoundation/NSDictionary+DictionaryHook.h>
#import <GPFoundation/NSMutableArray+MutableArrayHook.h>
#import <GPFoundation/NSMutableDictionary+MutableDictionaryHook.h>
#import <GPFoundation/NSObject+KVOCrash.h>
#import <GPFoundation/NSObject+UnrecognizedSelectorHook.h>
#import <GPFoundation/NSObject+ZombieHook.h>

// dealloc
#import <GPFoundation/NSObject+DeallocBlock.h>

