//
//  GPExceptionHeads.h
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/18.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#ifndef GPExceptionHeads_h
#define GPExceptionHeads_h

// Exception

// main
#import "GPExceptionMacros.h"
#import "GPExceptionProxy.h"
#import "GPException.h"

// swizzle
#import "NSObject+SwizzleHook.h"

// arc
#import "NSAttributedString+AttributedStringHook.h"
#import "NSMutableAttributedString+MutableAttributedStringHook.h"
#import "NSMutableSet+MutableSetHook.h"
#import "NSMutableString+MutableStringHook.h"
#import "NSNotificationCenter+ClearNotification.h"
#import "NSSet+SetHook.h"
#import "NSString+StringHook.h"
#import "NSTimer+CleanTimer.h"

// mrc
#import "NSArray+ArrayHook.h"
#import "NSDictionary+DictionaryHook.h"
#import "NSMutableArray+MutableArrayHook.h"
#import "NSMutableDictionary+MutableDictionaryHook.h"
#import "NSObject+KVOCrash.h"
#import "NSObject+UnrecognizedSelectorHook.h"
#import "NSObject+ZombieHook.h"

// dealloc
#import "NSObject+DeallocBlock.h"

#endif /* GPExceptionHeads_h */
