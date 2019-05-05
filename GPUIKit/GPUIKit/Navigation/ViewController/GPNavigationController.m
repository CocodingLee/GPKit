//
//  GPNavigationController.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPNavigationController.h"

#import "GPNavigationBar.h"
#import "GPNavigationItem.h"
#import "GPBarButtonItem.h"

#import "UIViewController+GPNavigation.h"
#import "UIViewController+GPTransition.h"

#import "GPGeneralPushAnimation.h"
#import "GPPresentDismissAnimation.h"

@interface GPNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL isTransiting;

@property (nonatomic, assign) UIViewController *lastViewController;
@property (nonatomic, strong) NSMutableArray *willPushViewControllers;

@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> pushAnimation;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@end

@implementation GPNavigationController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isTransiting = NO;
    self.navigationBarHidden = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
    super.delegate = self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    
    return YES;
}

- (void)resetDelegate
{
    self.interactivePopGestureRecognizer.delegate = self;
    super.delegate = self;
}

- (BOOL)shouldAutorotate
{
    id<GPNavigationRotationDelegate> delegate = (id<GPNavigationRotationDelegate>)self.viewControllers.lastObject;
    if (delegate && [delegate conformsToProtocol:@protocol(GPNavigationRotationDelegate)]) {
        return [delegate gp_shouldAutorotate];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    id<GPNavigationRotationDelegate> delegate = (id<GPNavigationRotationDelegate>)self.viewControllers.lastObject;
    if (delegate && [delegate conformsToProtocol:@protocol(GPNavigationRotationDelegate)]) {
        return [delegate gp_supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


#pragma mark - UINavigationDelegate

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    // forbid User VC to be NavigationController's delegate
}

#pragma mark - Push & Pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        UIImage *originalImage = [UIImage imageNamed:@"ng_navigationbar_back_icon"];
        viewController.gp_backButtonImage =[originalImage stretchableImageWithLeftCapWidth:originalImage.size.width/2 topCapHeight:originalImage.size.height/2];
    } else {
        viewController.gp_notAutoCreateBackButtonItem = YES;
    }
    
    self.isTransiting = YES;
    self.interactivePopGestureRecognizer.enabled = NO;
    
    if (![self.viewControllers containsObject:viewController]) {
        if (!viewController.gp_notAutoCreateNavigationBar) {
            [[self class] configureNavigationBarForViewController:viewController];
        }
        
        BOOL shouldAnimated = animated;
        if ([viewController respondsToSelector:@selector(gp_shouldAnimatedPush)]) {
            shouldAnimated = [viewController gp_shouldAnimatedPush];
        }
        
        [super pushViewController:viewController animated:shouldAnimated];
    }
#ifdef DEBUG
    else {
        
        NSString *message = [NSString stringWithFormat:@"VCs: %@, pusVC: %@", self.viewControllers, NSStringFromClass(viewController.class)];
        NSLog(@"PushSameVCMoreThanOnceException :%@", message);
        
    }
#endif
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    if (self.viewControllers.count <= 1) {
        self.interactivePopGestureRecognizer.delegate = self;
        return nil;
    }
    
    return [super popViewControllerAnimated:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if (self.viewControllers.count > 1) {
        self.interactivePopGestureRecognizer.enabled = YES;
    } else {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.isTransiting = NO;
}

// Animation
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop
        && navigationController.viewControllers.count >= 1) {
        
        if (nil != fromVC.popAnimation) {
            return fromVC.popAnimation;
        }
        
        // iOS10 以下，interactivePop 也会触发这个方法，加上判断返回 nil 调默认 pop 方法
        if (UIGestureRecognizerStateBegan == self.interactivePopGestureRecognizer.state ||
            UIGestureRecognizerStateChanged == self.interactivePopGestureRecognizer.state
            ) {
            return nil;
        }
        
    } else if (operation == UINavigationControllerOperationPush) {
        if (nil != toVC.pushAnimation) {
            return toVC.pushAnimation;
        }
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}

#pragma mark - Private Helper

+ (UIView *)configureNavigationBarForViewController:(UIViewController *)viewController
{
    if (!viewController.gp_navigationItem) {
        GPNavigationItem *navigationItem = [[GPNavigationItem alloc] init];
        [navigationItem setValue:viewController forKey:@"_gp_viewController"];
        viewController.gp_navigationItem = navigationItem;
    }
    
    if (!viewController.gp_navigationBar) {
        viewController.gp_navigationBar = [[GPNavigationBar alloc] init];
        
        [viewController.view addSubview:viewController.gp_navigationBar];
        
        id<GPNavigationRotationDelegate> delegate = (id<GPNavigationRotationDelegate>)viewController;
        if (delegate && [delegate conformsToProtocol:@protocol(GPNavigationRotationDelegate)]) {
            UIInterfaceOrientationMask mask = [delegate gp_supportedInterfaceOrientations];
            
            // 添加支持在横屏下弹出正确的竖屏界面
            if (UIInterfaceOrientationMaskPortrait == mask) {
                CGFloat width = MIN(viewController.view.frame.size.height, viewController.view.frame.size.width);
                CGRect frame = viewController.gp_navigationBar.frame;
                frame.size = (CGSize){width, 64};
                viewController.gp_navigationBar.frame = frame;
                viewController.gp_navigationItem.title = viewController.gp_navigationItem.title;
            }
        }
        
        if (!viewController.gp_navigationItem.leftBarButtonItem && !viewController.gp_notAutoCreateBackButtonItem) {
            __weak typeof(UIViewController) *weakViewController = viewController;
            if (viewController.gp_backButtonImage != nil) {
                viewController.gp_navigationItem.leftBarButtonItem = [[GPBarButtonItem alloc]initWithImage:viewController.gp_backButtonImage style:0 handler:^(id sender) {
                    __strong typeof(UIViewController) *strongViewController = weakViewController;
                    [strongViewController.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                
                // 默认黑色
                UIImage *originalImage = [UIImage imageNamed:@"ng_navigationbar_back_icon"];
                viewController.gp_navigationItem.leftBarButtonItem = [[GPBarButtonItem alloc]initWithImage:originalImage style:0 handler:^(id sender) {
                    __strong typeof(UIViewController) *vc = weakViewController;
                    //[strongViewController.navigationController popViewControllerAnimated:YES];
                    if (vc.presentingViewController) {
                        [vc dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [vc.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }
            
            viewController.gp_navigationItem.leftBarButtonItem.view.accessibilityLabel = @"Back";
        } else {
            viewController.gp_navigationItem.leftBarButtonItem = viewController.gp_navigationItem.leftBarButtonItem;
        }
        if (viewController.gp_isNavigationBarHidden) {
            viewController.gp_navigationItem.leftBarButtonItem.view.alpha = 0;
        }
        if (viewController.gp_isNavigationBarHiddenAll) {
            viewController.gp_navigationItem.leftBarButtonItem.view.alpha = 0;
            viewController.gp_navigationBar.hidden = YES;
        }
    }
    return viewController.gp_navigationBar;
}
@end
