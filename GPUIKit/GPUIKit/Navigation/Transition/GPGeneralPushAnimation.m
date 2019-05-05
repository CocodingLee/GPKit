//
//  GPGeneralPushAnimation.m
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPGeneralPushAnimation.h"
#import <FrameAccessor/FrameAccessor.h>
#import "GPNavigationDefine.h"

static CGFloat const kInitWhiteHeight = 1;

@interface GPGeneralPushAnimation ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentWhiteView;
@property (nonatomic, assign) CGRect contentFrame;
@end


@implementation GPGeneralPushAnimation


- (instancetype)init
{
    return [self initWithContentFrame:(CGRect){0, GP_SCREEN_HEIGHT/2 - kInitWhiteHeight/2, GP_SCREEN_WIDTH, kInitWhiteHeight}];
}

- (instancetype)initWithContentFrame:(CGRect)contentFrame
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _contentFrame = contentFrame;
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _backgroundView = backgroundView;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    _contentWhiteView = contentView;

    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = (UIViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
 
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];

    [containerView addSubview:fromViewController.view];
    [containerView addSubview:self.backgroundView];
    [containerView addSubview:self.contentWhiteView];
    [containerView addSubview:toViewController.view];
    
    fromViewController.view.frame = CGRectMake(0, 0, GP_SCREEN_WIDTH, CGRectGetHeight(fromViewController.view.frame));
    self.backgroundView.frame = (CGRect){0, 0, GP_SCREEN_WIDTH, GP_SCREEN_HEIGHT};
    self.contentWhiteView.frame = self.contentFrame;
    toViewController.view.frame = CGRectMake(0, 0, GP_SCREEN_WIDTH, CGRectGetHeight(toViewController.view.frame));
    toViewController.view.alpha = 0;
    self.backgroundView.alpha = 0;
    
    CGFloat sizeDuration = (GP_SCREEN_WIDTH - CGRectGetWidth(self.contentFrame)) / GP_SCREEN_WIDTH * 0.1;
    
    [UIView animateWithDuration:sizeDuration animations:^{
        CGRect firstAnimationRect = self.contentFrame;
        firstAnimationRect.size.width = GP_SCREEN_WIDTH;
        firstAnimationRect.origin.x = 0;
        self.contentWhiteView.frame = firstAnimationRect;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.backgroundView.alpha = 1;
            self.contentWhiteView.frame = (CGRect){0, 0, GP_SCREEN_WIDTH, GP_SCREEN_HEIGHT};
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

            [UIView animateWithDuration:0.2 animations:^{
                toViewController.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                // 要释放掉。。。。
                [self.backgroundView removeFromSuperview];
                [self.contentWhiteView removeFromSuperview];
            }];
            
            fromViewController.view.transform = CGAffineTransformIdentity;

        }];
    }];
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
