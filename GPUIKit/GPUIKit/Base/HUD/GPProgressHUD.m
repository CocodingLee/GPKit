//
//  KOProgressHUDManager.m
//  KOProgressHUDManager
//
//  Created by liyanwei on 2018/8/28.
//  Copyright © 2018年 liyanwei. All rights reserved.
//

#import "GPProgressHUD.h"
#import "MBProgressHUD.h"

static const CGFloat kKOProgressHUDDuration = 1.75;
static const CGFloat kKOFastFutureDuration = -1;
static NSString *const kKOSuccessIconName = @"KOProgressHUDManager.bundle/success2";
static NSString *const kKOErrorIconName = @"KOProgressHUDManager.bundle/error2";
static NSString *const kKOWarningIconName = @"KOProgressHUDManager.bundle/warning";

@interface GPProgressHUD ()

@end

@implementation GPProgressHUD

#pragma mark - msg

+ (void)showMessage:(NSString *)message
{
    [self showText:message icon:nil onView:nil duration:kKOProgressHUDDuration];
}

+ (void)showMessage:(NSString *)message duration:(CGFloat)duration
{
    [self showText:message icon:nil onView:nil duration:duration];
}

+ (void)showMessage:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration
{
    [self showText:message icon:nil onView:view duration:duration];
}

#pragma mark success

+ (void)showSuccess:(NSString *)message
{
    UIImage *image = [UIImage imageNamed:kKOSuccessIconName];
    [self showText:message icon:image onView:nil duration:kKOProgressHUDDuration];
}

+ (void)showSuccess:(NSString *)message duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOSuccessIconName];
    [self showText:message icon:image onView:nil duration:duration];
}

+ (void)showSuccess:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOSuccessIconName];
    [self showText:message icon:image onView:view duration:duration];
}

#pragma mark error

+ (void)showError:(NSString *)message
{
    UIImage *image = [UIImage imageNamed:kKOErrorIconName];
    [self showText:message icon:image onView:nil duration:kKOProgressHUDDuration];
}

+ (void)showError:(NSString *)message duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOErrorIconName];
    [self showText:message icon:image onView:nil duration:duration];
}

+ (void)showError:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOErrorIconName];
    [self showText:message icon:image onView:view duration:duration];
}

#pragma mark warning

+ (void)showWarning:(NSString *)message
{
    UIImage *image = [UIImage imageNamed:kKOWarningIconName];
    [self showText:message icon:image onView:nil duration:kKOProgressHUDDuration];
}

+ (void)showWarning:(NSString *)message duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOWarningIconName];
    [self showText:message icon:image onView:nil duration:duration];
}

+ (void)showWarning:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration
{
    UIImage *image = [UIImage imageNamed:kKOWarningIconName];
    [self showText:message icon:image onView:view duration:duration];
}

#pragma mark - loading

+ (void)showLoading:(NSString *)message
{
    [self showText:message icon:nil mode:MBProgressHUDModeIndeterminate onView:nil duration:kKOFastFutureDuration];
}

+ (void)showLoading:(NSString *)message duration:(CGFloat)duration
{
    [self showText:message icon:nil mode:MBProgressHUDModeIndeterminate onView:nil duration:duration];
}

+ (void)showLoading:(NSString *)message onView:(UIView *)view
{
    [self showText:message icon:nil mode:MBProgressHUDModeIndeterminate onView:view duration:kKOFastFutureDuration];
}

+ (void)showLoading:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration
{
    [self showText:message icon:nil mode:MBProgressHUDModeIndeterminate onView:view duration:duration];
}

#pragma mark

+ (void)showText:(NSString *)text icon:(UIImage *)icon onView:(UIView *)view duration:(CGFloat)duration
{
    [self showText:text icon:icon mode:MBProgressHUDModeText onView:view duration:duration];
}

+ (void)showText:(NSString *)text icon:(UIImage *)icon mode:(MBProgressHUDMode)mode onView:(UIView *)view duration:(CGFloat)duration
{
    if (view == nil) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabel.text = text;
    if (mode != MBProgressHUDModeText) {
        hud.mode = mode;
    } else {
        if (icon == nil) {
            hud.mode = MBProgressHUDModeText;
        } else {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:icon];
        }
    }
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.removeFromSuperViewOnHide = YES;
    if (duration != kKOFastFutureDuration) {
        [hud hideAnimated:YES afterDelay:duration];
    }
    hud.margin = 10;
    [self setupHUDAppearance:hud];
}

+ (void)setupHUDAppearance:(MBProgressHUD *)hud
{
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
//        hud.detailsLabel.textColor = [UIColor whiteColor];
    //    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //    hud.bezelView.backgroundColor = [UIColor brownColor];
}

#pragma mark - hide

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end

