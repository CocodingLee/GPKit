//
//  NSDictionary+DictionaryHook.h
//  GPException
//
//  Created by Jezz on 2018/7/15.
//  Copyright © 2018年 Jezz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DictionaryHook)

+ (void)gp_swizzleNSDictionary;

@end
