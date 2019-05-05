//
//  AGNPresentAnimation.m
//  AGSUIKit
//
//  Created by Singro on 11/11/2016.
//  Copyright © 2016 NineGame. All rights reserved.
//

#import "GPPresentDismissAnimation.h"
#import <FrameAccessor/FrameAccessor.h>
#import "GPNavigationDefine.h"

@implementation GPPresentDismissAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    fromViewController.view.frame = CGRectMake(0, 0, GP_SCREEN_WIDTH, CGRectGetHeight(fromViewController.view.frame));
    toViewController.view.frame = CGRectMake(0, 0, GP_SCREEN_WIDTH, CGRectGetHeight(toViewController.view.frame));
    
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.top = GP_SCREEN_HEIGHT;
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
