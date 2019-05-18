//
//  NSObject+UnrecognizedSelectorHook.h
//  GPException
//
//  Created by Liyanwei on 2018/7/11.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UnrecognizedSelectorHook)

+ (void)gp_swizzleUnrecognizedSelector;

@end
