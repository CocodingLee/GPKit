//
//  UIImageView+GPRounded.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GPRounded)

- (UIImage *)gp_imageWithBackgroundColor:(UIColor *)color
                                viewSize:(CGSize)viewSize
                             contentMode:(UIViewContentMode)mode
                            cornerRadius:(CGFloat)cornerRadius
                             borderColor:(UIColor *)borderColor
                             borderWidth:(CGFloat)borderWidth;

// 设置各个方向的圆角， 分别 leftTop、leftBottom、rightBottom、rightTop
- (UIImage *)gp_imageWithBackgroundColor:(UIColor *)color
                                viewSize:(CGSize)viewSize
                             contentMode:(UIViewContentMode)mode
                             cornerRadii:(UIEdgeInsets)cornerRadii
                             borderColor:(UIColor *)borderColor
                             borderWidth:(CGFloat)borderWidth;
@end

NS_ASSUME_NONNULL_END
