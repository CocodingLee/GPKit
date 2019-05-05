//
//  UIViewController+GPNavigationBar.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPNavigationRotationDelegate <NSObject>

- (BOOL) gp_shouldAutorotate;
- (UIInterfaceOrientationMask) gp_supportedInterfaceOrientations;

@end

////////////////////////////////////////////////////////////////////////

@class GPNavigationItem;

@interface UIViewController (GPNavigation)

@property (nonatomic, strong) GPNavigationItem *gp_navigationItem;
@property (nonatomic, strong) UIView *gp_navigationBar;
@property (nonatomic, strong) UIImage *gp_backButtonImage;
@property (nonatomic, assign) UIStatusBarStyle gp_statusBarStyle;

@property (nonatomic, assign) BOOL gp_notAutoCreateBackButtonItem;
@property (nonatomic, assign) BOOL gp_notAutoCreateNavigationBar;
@property (nonatomic, readonly) BOOL gp_shouldAnimatedPush;

@property(nonatomic, getter = gp_isNavigationBarHidden) BOOL gp_navigationBarHidden;
@property(nonatomic, getter = gp_isNavigationBarHiddenAll) BOOL gp_navigationBarHiddenAll;
@property (nonatomic, getter = gp_isNavigationBarNoNeedTransition) BOOL gp_navigationBarNoNeedTransition;

- (void)gp_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (UIView *)createNavigationBar;
@end

NS_ASSUME_NONNULL_END
