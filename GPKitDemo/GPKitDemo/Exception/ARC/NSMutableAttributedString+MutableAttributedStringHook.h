//
//  NSMutableAttributedString+MutableAttributedStringHook.h
//  GPFoundation
//
//  Created by Liyanwei on 2018/9/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (MutableAttributedStringHook)

+ (void)gp_swizzleNSMutableAttributedString;

@end
