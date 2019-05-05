//
//  GPBarButtonItem.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, GPBarButtonItemStyle)
{
    // for future use
    GPBarButtonItemStyleDefault = 0,
    GPBarButtonItemStyleGray,
    GPBarButtonItemStyleYellow,
    GPBarButtonItemStyleOrange,
    GPBarButtonItemStyleBlack
};


@interface GPBarButtonItem : NSObject
@property (nonatomic, strong) UIView *view;
@property (nonatomic, copy) UIColor *tintColor;
@property (nonatomic, readonly) GPBarButtonItemStyle style;

@property (nonatomic, copy) void (^actionBlock)(id);
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

- (instancetype)initWithTitle:(NSString *)title
                        style:(GPBarButtonItemStyle)style
                      handler:(void (^)(id sender))action;

- (instancetype)initWithImage:(UIImage *)image
                        style:(GPBarButtonItemStyle)style
                      handler:(void (^)(id sender))action;

- (void)updateTitle:(NSString *)title;
@end
NS_ASSUME_NONNULL_END
