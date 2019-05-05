//
//  GPBarButtonItem.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPBarButtonItem.h"
#import "GPNavigationDefine.h"

@interface GPBarButtonItem ()

@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UILabel *badgeLabel;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, readwrite, assign) GPBarButtonItemStyle style;

@end

@implementation GPBarButtonItem

- (void)dealloc
{
    [_button removeTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_button removeTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_button removeTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside];
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                        style:(GPBarButtonItemStyle)style
                      handler:(void (^)(id sender))action
{
    if (self = [super init]) {
        self.enabled = YES;
        
        _style = style;
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button sizeToFit];
        CGRect frame = button.frame;
        frame.size.height = 44;
        frame.size.width += 30;
        frame.origin.y = (42 - frame.size.height/2);
        frame.origin.x = 0;
        button.frame = frame;
        self.view = button;
        
        switch (style) {
            case GPBarButtonItemStyleGray: {
                [button setTitleColor:kNavigationBarTintGrayColor forState:UIControlStateNormal];
                break;
            }
            case GPBarButtonItemStyleYellow: {
                [button setTitleColor:kNavigationBarTintYellowColor forState:UIControlStateNormal];
                break;
            }
            case GPBarButtonItemStyleOrange:{
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                break;
            }
            case GPBarButtonItemStyleBlack:{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            }
            default: {
                [button setTitleColor:kNavigationBarTintColor forState:UIControlStateNormal];
                break;
            }
        }
        
        self.actionBlock = action;
        
        [button addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside];
        
        self.button = button;
        
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
                        style:(GPBarButtonItemStyle)style
                      handler:(void (^)(id sender))action
{
    
    if (self = [super init]) {
        
        self.enabled = YES;
        self.buttonImage = image;
        
        UIButton *button = [[UIButton alloc] init];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button sizeToFit];
        
        CGRect frame = button.frame;
        frame.size.height = 44;
        frame.size.width += 30;
        frame.origin.y = (42 - frame.size.height/2);
        frame.origin.x = 0;
        button.frame = frame;
        self.view = button;
        
        self.actionBlock = action;
        
        [button addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventTouchDragOutside];
        
        self.button = button;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    if (enabled) {
        self.view.userInteractionEnabled = YES;
        
        if (self.style == GPBarButtonItemStyleOrange) {
            [self.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            self.view.alpha = 1.0;
            
        } else {
            self.view.alpha = 1.0;
        }
        
    } else {
        self.view.userInteractionEnabled = NO;
        
        if (self.style == GPBarButtonItemStyleOrange) {
            [self.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            self.view.alpha = 0.3;
        }
        else {
            self.view.alpha = 0.7;
        }
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    if (nil != self.buttonImage) {
        self.buttonImage = [self imageWithColor:tintColor image:self.buttonImage];
        self.button.tintColor = tintColor;
        [self.button setImage:self.buttonImage forState:UIControlStateNormal];
        [self.button setImage:self.buttonImage forState:UIControlStateHighlighted];
    } else {
        [self.button setTitleColor:tintColor forState:UIControlStateNormal];
    }
}

#pragma mark - Private Methods

- (void)handleTouchUpInside:(UIButton *)button
{
    self.actionBlock(button);
    [UIView animateWithDuration:0.2 animations:^{
        button.alpha = 1.0;
    }];
}

- (void)handleTouchDown:(UIButton *)button
{
    button.alpha = 0.7;
}

- (void)handleTouchUp:(UIButton *)button
{
    [UIView animateWithDuration:0.3 animations:^{
        button.alpha = 1.0;
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color image:(UIImage *)image
{
    UIImage *aImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return aImage;
}

- (void)updateTitle:(NSString *)title {
    
    if (!self.button) {
        return;
    }
    
    [self.button setTitle:title forState:UIControlStateNormal];
    [self.button sizeToFit];
    
    CGRect frame = self.button.frame;
    frame.size.height = 44;
    frame.size.width += 30;
    frame.origin.y = (42 - frame.size.height/2);
    frame.origin.x = 0;
    self.button.frame = frame;
}
@end
