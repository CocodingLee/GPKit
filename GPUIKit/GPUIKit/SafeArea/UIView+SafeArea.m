//
//  UIView+SafeArea.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIView+SafeArea.h"

@implementation UIView (GPSafeArea)

- (UIEdgeInsets) gp_safeAreaInsets
{
    UIEdgeInsets rt = UIEdgeInsetsZero;
    
    SEL selector = NSSelectorFromString(@"safeAreaInsets");
    if ([self respondsToSelector:selector]) {
        
        NSMethodSignature* meth = [[self class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:meth];
        [invocation setSelector:selector];
        [invocation setTarget:self];
        [invocation invoke];
        [invocation getReturnValue:&rt];
    }
    
    // 没刘海增加 status 高度
    if (rt.top < 1)
    {
        rt.top = 20;
    }
    
    return rt;
}

@end

UIEdgeInsets gpSafeArea()
{
    return [[UIApplication sharedApplication].keyWindow gp_safeAreaInsets];
}
