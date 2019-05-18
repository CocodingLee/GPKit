//
//  NSAttributedString+AttributedStringHook.h
//  GPFoundation
//
//  Created by Liyanwei on 2018/9/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (AttributedStringHook)

+ (void)gp_swizzleNSAttributedString;

@end
