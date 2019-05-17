//
//  GPExceptionMacros.h
//  GPFoundation
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#ifndef GPExceptionMacros_h
#define GPExceptionMacros_h

/**
 Add this macro before each category implementation, so we don't have to use
 -all_load or -force_load to load object files from static libraries that only
 contain categories and no classes.
 *******************************************************************************
 Example:
 GPSYNTH_DUMMY_CLASS(NSObject_DeallocBlock)
 */
#ifndef GPSYNTH_DUMMY_CLASS
#define GPSYNTH_DUMMY_CLASS(_name_) \
@interface GPSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation GPSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

#endif /* GPExceptionMacros_h */
