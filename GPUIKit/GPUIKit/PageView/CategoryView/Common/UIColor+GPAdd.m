//
//  UIColor+GPAdd.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/21.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "UIColor+GPAdd.h"

@implementation UIColor (GPAdd)

- (CGFloat)jx_red {
    CGFloat r = 0, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)jx_green {
    CGFloat r, g = 0, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)jx_blue {
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

- (CGFloat)jx_alpha {
    return CGColorGetAlpha(self.CGColor);
}

@end
