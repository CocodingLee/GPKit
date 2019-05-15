//
//  GPCategoryFactory.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryFactory.h"
#import "UIColor+GPAdd.h"

@implementation GPCategoryFactory

+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent
{
    percent = MAX(0, MIN(1, percent));
    return from + (to - from)*percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent
{
    CGFloat red = [self interpolationFrom:fromColor.jx_red to:toColor.jx_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.jx_green to:toColor.jx_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.jx_blue to:toColor.jx_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.jx_alpha to:toColor.jx_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
