//
//  UIImage+Blur.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GPColorImage)

/**
 获取半透明图片
 
 @param alpha 透明度
 @param image 被改变图片
 @return 半透明图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;


/**
 获取一个纯色的image
 
 @param color 颜色
 @param rect 区域
 @return image
 */
+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect;

/**
 获取一个渐变色图片
 
 @param colors 颜色数组
 @param width 宽度
 @param height 高度
 @param startPoint 开始位置
 @param endPoint 结束为止
 @return 图片
 */
+ (UIImage *)createImageWithColors:(NSArray *)colors
                             width:(CGFloat)width
                            height:(CGFloat)height
                        startPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIImage (GPBlur)
- (UIImage *)gp_applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(UIImage *)maskImage;
@end


NS_ASSUME_NONNULL_END
