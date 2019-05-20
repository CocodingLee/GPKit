//
//  KOProgressHUDManager.h
//  KOProgressHUDManager
//
//  Created by liyanwei on 2018/8/28.
//  Copyright © 2018年 liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

// 封装 MBProgressHUD。没有通过添加 MBProgressHUD 分类来实现，是因为以后可能改为其他第三方 HUD，比如 SVProgressHUD 等
@interface GPProgressHUD : NSObject

#pragma mark - msg

+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message duration:(CGFloat)duration;
+ (void)showMessage:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration;

+ (void)showSuccess:(NSString *)message;
+ (void)showSuccess:(NSString *)message duration:(CGFloat)duration;
+ (void)showSuccess:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration;

+ (void)showError:(NSString *)message;
+ (void)showError:(NSString *)message duration:(CGFloat)duration;
+ (void)showError:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration;

+ (void)showWarning:(NSString *)message;
+ (void)showWarning:(NSString *)message duration:(CGFloat)duration;
+ (void)showWarning:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration;

#pragma mark - loading

/// 显示一个菊花，需要调用hideHUD消失
+ (void)showLoading:(NSString *)message;
+ (void)showLoading:(NSString *)message duration:(CGFloat)duration;
/// 显示一个菊花，需要调用hideHUDForView消失
+ (void)showLoading:(NSString *)message onView:(UIView *)view;
+ (void)showLoading:(NSString *)message onView:(UIView *)view duration:(CGFloat)duration;

#pragma mark - hide

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
