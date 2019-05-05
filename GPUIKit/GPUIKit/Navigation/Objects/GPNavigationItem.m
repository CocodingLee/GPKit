//
//  GPNavigationItem.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPNavigationItem.h"
#import "GPNavigationBar.h"
#import "UIViewController+GPNavigation.h"
#import "UIView+SafeArea.h"
#import "GPBarButtonItem.h"
#import "GPNavigationDefine.h"

@interface GPNavigationItem()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) UIViewController *gp_viewController;
@end

@implementation GPNavigationItem

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [_gp_viewController.gp_navigationBar addSubview:_titleLabel];
    }
    
    CGFloat width = _gp_viewController.gp_navigationBar.frame.size.width;
    
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    
    NSUInteger otherButtonWidth = self.leftBarButtonItem.view.frame.size.width + self.rightBarButtonItem.view.frame.size.width;
    CGRect frame = _titleLabel.frame;
    frame.size.width = width - otherButtonWidth - 20;
    frame.origin.x = (width - frame.size.width)/2;
    UIEdgeInsets safeArea = UIApplication.sharedApplication.keyWindow.gp_safeAreaInsets;
    frame.origin.y = (kGPNavigationBarHeight - 22 - frame.size.height/2 + safeArea.top);
    
    if (self.titleInsetLeft > 0) {
        frame.origin.x += self.titleInsetLeft;
        frame.size.width -= self.titleInsetLeft;
    }
    
    if (self.titleInsetRight > 0) {
        frame.size.width += self.titleInsetRight;
    }
    
    _titleLabel.frame = frame;
    
    if (self.tintColor) {
        self.titleLabel.textColor = self.tintColor;
    }
}

- (void)setLeftBarButtonItem:(GPBarButtonItem *)leftBarButtonItem
{
    if (_gp_viewController) {
        [_leftBarButtonItem.view removeFromSuperview];
        CGRect frame = leftBarButtonItem.view.frame;
        frame.origin.x = 0;
        
        UIEdgeInsets safeArea = UIApplication.sharedApplication.keyWindow.gp_safeAreaInsets;
        frame.origin.y = (kGPNavigationBarHeight - 22 - frame.size.height/2 + safeArea.top);
        
        leftBarButtonItem.view.frame = frame;
        [_gp_viewController.gp_navigationBar addSubview:leftBarButtonItem.view];
    }
    
    _leftBarButtonItem = leftBarButtonItem;
    
    if (self.tintColor) {
        leftBarButtonItem.tintColor = self.tintColor;
    }
}

- (void)setRightBarButtonItem:(GPBarButtonItem *)rightBarButtonItem
{
    
    if (_gp_viewController) {
        [_rightBarButtonItem.view removeFromSuperview];

        CGFloat width = _gp_viewController.gp_navigationBar.frame.size.width;
        CGRect frame = rightBarButtonItem.view.frame;
        frame.origin.x = width - rightBarButtonItem.view.frame.size.width;

        UIEdgeInsets safeArea = UIApplication.sharedApplication.keyWindow.gp_safeAreaInsets;
        frame.origin.y = (kGPNavigationBarHeight - 22 - frame.size.height/2 + safeArea.top);

        rightBarButtonItem.view.frame = frame;
        [_gp_viewController.gp_navigationBar addSubview:rightBarButtonItem.view];
    }
    
    _rightBarButtonItem = rightBarButtonItem;
    
    if (self.tintColor) {
        rightBarButtonItem.tintColor = self.tintColor;
    }
}

- (UILabel *)titleLabel
{
    return _titleLabel;
}

@end
