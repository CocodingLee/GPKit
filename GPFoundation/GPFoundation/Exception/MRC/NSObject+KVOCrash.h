//
//  NSObject+KVOCrash.h
//  GPException
//
//  Created by Liyanwei on 2018/8/29.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVOCrash)

+ (void)gp_swizzleKVOCrash;

@end
