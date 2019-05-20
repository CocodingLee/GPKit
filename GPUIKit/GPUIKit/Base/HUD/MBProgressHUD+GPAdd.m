//
//  MBProgressHUD+NHAdd.m
//  GPUIKit
//
//  Created by liyanwei on 2017/6/11.
//  Copyright © 2017年 liyanwei. All rights reserved.
//

#import "MBProgressHUD+GPAdd.h"
#import "MBProgressHUD_GPExtend.h"
#import <objc/message.h>


CGFloat const delayTime = 1.2;
#define kLoadImage(name) [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", (name)]]


@implementation MBProgressHUD (GPAdd)
static char cancelationKey;

NS_INLINE MBProgressHUD *createNew(UIView *view) {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    return [MBProgressHUD showHUDAddedTo:view animated:YES];
}

NS_INLINE MBProgressHUD *settHUD(UIView *view, NSString *title, BOOL autoHidden) {
    MBProgressHUD *hud = createNew(view);
    //文字
    hud.label.text = title;
    //支持多行
    hud.label.numberOfLines = 0;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    //设置默认风格
    if (NHDefaultHudStyle == 1) {
        hud.hudContentStyle(GPHUDContentBlackStyle);
        
    } else if (NHDefaultHudStyle == 2) {
        hud.hudContentStyle(GPHUDContentCustomStyle);
    }
    
    if (autoHidden) {
        // x秒之后消失
        [hud hideAnimated:YES afterDelay:delayTime];
    }
    
    return hud;
}


+ (MBProgressHUD *)showOnlyLoadToView:(UIView *)view {
    return settHUD(view, nil, NO);
}

+ (void)showOnlyTextToView:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
}

+ (void)showOnlyTextToView:(UIView *)view title:(NSString *)title detail:(NSString *)detail {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, success, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:kLoadImage(@"success.png")];
}


+ (void)showError:(NSString *)error toView:(UIView *)view {
    MBProgressHUD *hud = settHUD(view, error, YES);
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:kLoadImage(@"error.png")];
}


+ (void)showTitleToView:(UIView *)view postion:(GPHUDPostion)postion title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

//纯标题 + 详情 + 自定背景风格 - 自动消失
+ (void)showDetailToView:(UIView *)view
                 postion:(GPHUDPostion)postion
                   title:(NSString *)title
                  detail:(NSString *)detail {
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.detailsLabel.text = detail;
    hud.mode = MBProgressHUDModeText;
    hud.hudPostion(postion);
}

+ (void)showTitleToView:(UIView *)view
                postion:(GPHUDPostion)postion
           contentStyle:(GPHUDContentStyle)contentStyle
                  title:(NSString *)title {
    
    MBProgressHUD *hud = settHUD(view, title, YES);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    hud.hudPostion(postion);
}


+ (MBProgressHUD *)showLoadToView:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}


+ (void)showTitleToView:(UIView *)view
           contentStyle:(GPHUDContentStyle)contentStyle
                  title:(NSString *)title
             afterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    [hud hideAnimated:YES afterDelay:delay];
}

+ (MBProgressHUD *)showTitleToView:(UIView *)view
           contentStyle:(GPHUDContentStyle)contentStyle
                  title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeText;
    hud.hudContentStyle(contentStyle);
    return hud;
}


+ (MBProgressHUD *)showDownToView:(UIView *)view
                    progressStyle:(GPHUDProgressStyle)progressStyle
                            title:(NSString *)title
                         progress:(GPCurrentHud)progress {
    MBProgressHUD *hud = settHUD(view, title, NO);
    if (progressStyle == GPHUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
    } else if (progressStyle == GPHUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
        
    } else if (progressStyle == GPHUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    if (progress) {
        progress(hud);
    }
    return hud;
}

+ (MBProgressHUD *)showDownToView:(UIView *)view
                    progressStyle:(GPHUDProgressStyle)progressStyle
                            title:(NSString *)title
                      cancelTitle:(NSString *)cancelTitle
                         progress:(GPCurrentHud)progress
                      cancelation:(GPCancelation)cancelation {
    
    MBProgressHUD *hud = settHUD(view, title, NO);
    
    if (progressStyle == GPHUDProgressDeterminateHorizontalBar) {
        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
        
    } else if (progressStyle == GPHUDProgressDeterminate) {
        hud.mode = MBProgressHUDModeDeterminate;
        
    } else if (progressStyle == GPHUDProgressAnnularDeterminate) {
        hud.mode = MBProgressHUDModeAnnularDeterminate;
    }
    
    [hud.button setTitle:cancelTitle ?: NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
    [hud.button addTarget:hud action:@selector(didClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    hud.cancelation = cancelation;
    if (progress) {
        progress(hud);
    }
    return hud;
}


+ (void)showCustomView:(UIImage *)image toView:(UIView *)toView title:(NSString *)title {
    
    MBProgressHUD *hud = settHUD(toView, title, YES);
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
}


+ (MBProgressHUD *)showModelSwitchToView:(UIView *)toView
                                   title:(NSString *)title
                               configHud:(GPCurrentHud)configHud {
    MBProgressHUD *hud = settHUD(toView, title, NO);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}


+ (MBProgressHUD *)showDownNSProgressToView:(UIView *)view title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.mode = MBProgressHUDModeDeterminate;
    return hud;
}


+ (MBProgressHUD *)showDownWithNSProgress:(NSProgress *)Progress
                                   toView:(UIView *)view title:(NSString *)title
                                configHud:(GPCurrentHud)configHud {
    MBProgressHUD *hud = settHUD(view, title, NO);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}


+ (MBProgressHUD *)showLoadToView:(UIView *)view
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = backgroundColor;
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                            title:(NSString *)title {
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    return hud;
}

+ (MBProgressHUD *)showLoadToView:(UIView *)view
                     contentColor:(UIColor *)contentColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.contentColor = contentColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}


+ (MBProgressHUD *)showLoadToView:(UIView *)view
                       titleColor:(UIColor *)titleColor
                   bezelViewColor:(UIColor *)bezelViewColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title {
    
    MBProgressHUD *hud = settHUD(view, title, NO);
    hud.label.textColor = titleColor;
    hud.bezelView.backgroundColor = bezelViewColor;
    hud.backgroundView.color = backgroundColor;
    return hud;
}

+ (MBProgressHUD *)createHudToView:(UIView *)view title:(NSString *)title configHud:(GPCurrentHud)configHud {
    MBProgressHUD *hud = settHUD(view, title, YES);
    if (configHud) {
        configHud(hud);
    }
    return hud;
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
}


+ (void)hideHUD {
    [self hideHUDForView:nil];
}


#pragma mark -- sett // gett
- (void)didClickCancelButton {
    if (self.cancelation) {
        self.cancelation(self);
    }
}

- (void)setCancelation:(GPCancelation)cancelation {
    objc_setAssociatedObject(self, &cancelationKey, cancelation, OBJC_ASSOCIATION_COPY);
}

- (GPCancelation)cancelation {
    return objc_getAssociatedObject(self, &cancelationKey);
}

- (MBProgressHUD *(^)(UIColor *))hudBackgroundColor {
    return ^(UIColor *hudBackgroundColor) {
        self.backgroundView.color = hudBackgroundColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIView *))toView {
    return ^(UIView *view){
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))title {
    return ^(NSString *title){
        self.label.text = title;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))details {
    return ^(NSString *details){
        self.detailsLabel.text = details;
        return self;
    };
}

- (MBProgressHUD *(^)(NSString *))customIcon {
    return ^(NSString *customIcon) {
        self.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:customIcon]];
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))titleColor {
    return ^(UIColor *titleColor){
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))progressColor {
    return ^(UIColor *progressColor) {
        UIColor *titleColor = self.label.textColor;
        self.contentColor = progressColor;
        self.label.textColor = titleColor;
        self.detailsLabel.textColor = titleColor;
        return self;
    };
}

- (MBProgressHUD *(^)(UIColor *))allContentColors {
    return ^(UIColor *allContentColors) {
        self.contentColor = allContentColors;
        return self;
    };
}


- (MBProgressHUD *(^)(UIColor *))bezelBackgroundColor {
    return ^(UIColor *bezelViewColor){
        self.bezelView.backgroundColor = bezelViewColor;
        return self;
    };
}


- (MBProgressHUD *(^)(GPHUDContentStyle))hudContentStyle {
    return ^(GPHUDContentStyle hudContentStyle){
        if (hudContentStyle == GPHUDContentBlackStyle) {
            self.contentColor = [UIColor whiteColor];
            self.bezelView.backgroundColor = [UIColor blackColor];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        } else if (hudContentStyle == GPHUDContentCustomStyle) {
            self.contentColor = NHCustomHudStyleContentColor;
            self.bezelView.backgroundColor = NHCustomHudStyleBackgrandColor;
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        } else if (hudContentStyle == GPHUDContentDefaultStyle){
            self.contentColor = [UIColor blackColor];
            self.bezelView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
            self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            
        }
        return self;
    };
}


- (MBProgressHUD *(^)(GPHUDPostion))hudPostion {
    return ^(GPHUDPostion hudPostion){
        if (hudPostion == GPHUDPostionTop) {
            self.offset = CGPointMake(0.f, -MBProgressMaxOffset);
        } else if (hudPostion == GPHUDPostionCenten) {
            self.offset = CGPointMake(0.f, 0.f);
        } else {
            self.offset = CGPointMake(0.f, MBProgressMaxOffset);
        }
        return self;
    };
}

- (MBProgressHUD *(^)(GPHUDProgressStyle))hudProgressStyle {
    return ^(GPHUDProgressStyle hudProgressStyle){
        if (hudProgressStyle == GPHUDProgressDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
            
        } else if (hudProgressStyle == GPHUDProgressAnnularDeterminate) {
            self.mode = MBProgressHUDModeAnnularDeterminate;
            
        } else if (hudProgressStyle == GPHUDProgressCancelationDeterminate) {
            self.mode = MBProgressHUDModeDeterminate;
            
        } else if (hudProgressStyle == GPHUDProgressDeterminateHorizontalBar) {
            self.mode = MBProgressHUDModeDeterminateHorizontalBar;
            
        }
        return self;
    };
}
@end
