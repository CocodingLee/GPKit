//
//  UIButton+Expand.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIButton+Expand.h"
#import <objc/runtime.h>

@implementation UIButton (Expand)

- (void) setGp_expandInsets:(UIEdgeInsets)gp_expandInsets
{
    id tmp =  [NSValue valueWithUIEdgeInsets:gp_expandInsets];
    objc_setAssociatedObject(self, @selector(gp_expandInsets), tmp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets) gp_expandInsets
{
    id insetObject = objc_getAssociatedObject(self, @selector(gp_expandInsets));
    if ([insetObject respondsToSelector:@selector(UIEdgeInsetsValue)]) {
        return [insetObject UIEdgeInsetsValue];
    }
    
    return UIEdgeInsetsZero;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.hidden || self.alpha < 0.01) {
        
        //
        // 注释：是扩大点击反馈，因此这里是 减号
        //
        CGRect extendedFrame = CGRectMake(  0 - self.gp_expandInsets.left
                                          , 0 - self.gp_expandInsets.top
                                          , self.bounds.size.width + (self.gp_expandInsets.left + self.gp_expandInsets.right)
                                          , self.bounds.size.height + (self.gp_expandInsets.top + self.gp_expandInsets.bottom));
        
        return (CGRectContainsPoint(extendedFrame , point) == 1) ? self : nil;
    }
    
    // 如果子类没有处理到，直接丢给父类处理
    return [super hitTest:point withEvent:event];
}

@end
