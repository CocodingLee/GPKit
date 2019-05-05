//
//  UIViewController+GPTransition.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIViewController+GPTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (GPTransition)

@dynamic pushAnimation;
@dynamic popAnimation;

- (id<UIViewControllerAnimatedTransitioning>)popAnimation
{
    return objc_getAssociatedObject(self, @selector(popAnimation));
}

- (void)setPopAnimation:(id<UIViewControllerAnimatedTransitioning>)popAnimation
{
    objc_setAssociatedObject(self, @selector(popAnimation), popAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIViewControllerAnimatedTransitioning>)pushAnimation
{
    return objc_getAssociatedObject(self, @selector(pushAnimation));
}

- (void)setPushAnimation:(id<UIViewControllerAnimatedTransitioning>)pushAnimation
{
    objc_setAssociatedObject(self, @selector(pushAnimation), pushAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
