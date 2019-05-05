//
//  AGNPresentAnimation.m
//  AGSUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPPresentAnimation.h"
#import <FrameAccessor/FrameAccessor.h>
#import "GPNavigationDefine.h"

@implementation GPPresentAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    fromViewController.view.frame = CGRectMake(0, 0, GP_SCREEN_WIDTH, CGRectGetHeight(fromViewController.view.frame));
    toViewController.view.frame = CGRectMake(0, GP_SCREEN_HEIGHT, GP_SCREEN_WIDTH, CGRectGetHeight(toViewController.view.frame));
    
    
    [UIView animateWithDuration:duration animations:^{
        //        fromViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        toViewController.view.top = 0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        fromViewController.view.transform = CGAffineTransformIdentity;
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
