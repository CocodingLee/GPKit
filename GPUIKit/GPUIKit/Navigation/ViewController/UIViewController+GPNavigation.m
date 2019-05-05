//
//  UIViewController+GPNavigationBar.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIViewController+GPNavigation.h"
#import <objc/runtime.h>

#import "GPNavigationItem.h"
#import "GPNavigationController.h"


@interface GPNavigationController (Private)
+ (UIView *)configureNavigationBarForViewController:(UIViewController *)viewController;
@end


@implementation UIViewController (GPNavigation)

@dynamic gp_navigationItem;
@dynamic gp_navigationBar;
@dynamic gp_navigationBarHidden;
@dynamic gp_navigationBarHiddenAll;
@dynamic gp_navigationBarNoNeedTransition;
@dynamic gp_notAutoCreateBackButtonItem, gp_notAutoCreateNavigationBar;
@dynamic gp_shouldAnimatedPush;
@dynamic gp_statusBarStyle;


// gp_isNavigationBarHidden

- (BOOL)gp_isNavigationBarHidden
{
    return [objc_getAssociatedObject(self, @selector(gp_isNavigationBarHidden)) boolValue];
}

- (void)setGp_navigationBarHidden:(BOOL)gp_navigationBarHidden
{
    if (gp_navigationBarHidden) {
        CGRect frame = self.gp_navigationBar.frame;
        frame.origin.y = -43;
        self.gp_navigationBar.frame = frame;
        for (UIView *view in self.gp_navigationBar.subviews) {
            view.alpha = 0.0;
        }
    } else {
        CGRect frame = self.gp_navigationBar.frame;
        frame.origin.y = 0;
        self.gp_navigationBar.frame = frame;
        for (UIView *view in self.gp_navigationBar.subviews) {
            view.alpha = 1.0;
        }
    }
    
    objc_setAssociatedObject(self, @selector(gp_isNavigationBarHidden), @(gp_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
}

// gp_isNavigationBarHiddenAll

- (BOOL)gp_isNavigationBarHiddenAll
{
    return [objc_getAssociatedObject(self, @selector(gp_isNavigationBarHiddenAll)) boolValue];
}

- (void)setGp_navigationBarHiddenAll:(BOOL)gp_navigationBarHiddenAll
{
    if (gp_navigationBarHiddenAll) {
        self.gp_navigationBar.hidden = YES;
    } else {
        CGRect frame = self.gp_navigationBar.frame;
        frame.origin.y = 0;
        self.gp_navigationBar.frame = frame;
        for (UIView *view in self.gp_navigationBar.subviews) {
            view.alpha = 1.0;
        }
    }
    objc_setAssociatedObject(self, @selector(gp_isNavigationBarHiddenAll), @(gp_navigationBarHiddenAll), OBJC_ASSOCIATION_ASSIGN);
}

// gp_isNavigationBarNoNeedTransition

- (BOOL)gp_isNavigationBarNoNeedTransition
{
    return [objc_getAssociatedObject(self, @selector(gp_isNavigationBarNoNeedTransition)) boolValue];
}

- (void)setGp_navigationBarNoNeedTransition:(BOOL)gp_navigationBarNoNeedTransition
{
    objc_setAssociatedObject(self, @selector(gp_isNavigationBarNoNeedTransition), @(gp_navigationBarNoNeedTransition), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gp_notAutoCreateBackButtonItem
{
    return [objc_getAssociatedObject(self, @selector(gp_notAutoCreateBackButtonItem)) boolValue];
}

- (void)setGp_notAutoCreateBackButtonItem:(BOOL)gp_notAutoCreateBackButtonItem
{
    objc_setAssociatedObject(self, @selector(gp_notAutoCreateBackButtonItem), @(gp_notAutoCreateBackButtonItem), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)gp_notAutoCreateNavigationBar
{
    return [objc_getAssociatedObject(self, @selector(gp_notAutoCreateNavigationBar)) boolValue];
}

- (void)setGp_notAutoCreateNavigationBar:(BOOL)gp_notAutoCreateNavigationBar
{
    objc_setAssociatedObject(self, @selector(gp_notAutoCreateNavigationBar), @(gp_notAutoCreateNavigationBar), OBJC_ASSOCIATION_ASSIGN);
}

- (void)gp_setNavigationBarHidden:(BOOL)hidden
                         animated:(BOOL)animated
{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.gp_navigationBar.frame;
            frame.origin.y = -43;
            self.gp_navigationBar.frame = frame;
            for (UIView *view in self.gp_navigationBar.subviews) {
                view.alpha = 0.0;
            }
        } completion:^(BOOL finished) {
            self.gp_navigationBarHidden = YES;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.gp_navigationBar.frame;
            frame.origin.y = 0;
            self.gp_navigationBar.frame = frame;
            for (UIView *view in self.gp_navigationBar.subviews) {
                view.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            self.gp_navigationBarHidden = NO;
        }];
    }
}

// gp_navigationItem

- (GPNavigationItem *)gp_navigationItem
{
    return objc_getAssociatedObject(self, @selector(gp_navigationItem));
}

- (void)setGp_navigationItem:(GPNavigationItem *)gp_navigationItem {
    objc_setAssociatedObject(self, @selector(gp_navigationItem), gp_navigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// gp_navigationBar

- (UIView *)gp_navigationBar
{
    return objc_getAssociatedObject(self, @selector(gp_navigationBar));
}

- (void)setGp_navigationBar:(UIView *)gp_navigationBar
{
    objc_setAssociatedObject(self, @selector(gp_navigationBar), gp_navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// gp_backButtonImage

- (UIImage *)gp_backButtonImage
{
    return objc_getAssociatedObject(self, @selector(gp_backButtonImage));
}

- (void)setGp_backButtonImage:(UIImage *)gp_backButtonImage
{
    objc_setAssociatedObject(self, @selector(gp_backButtonImage), gp_backButtonImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)createNavigationBar
{
    return [GPNavigationController configureNavigationBarForViewController:self];
}

// gp_statusBarStyle

- (UIStatusBarStyle)gp_statusBarStyle
{
    return [objc_getAssociatedObject(self, @selector(gp_statusBarStyle)) boolValue];
}

- (void)setGp_statusBarStyle:(UIStatusBarStyle)gp_statusBarStyle
{
    objc_setAssociatedObject(self, @selector(gp_statusBarStyle), @(gp_statusBarStyle), OBJC_ASSOCIATION_ASSIGN);
}

@end
