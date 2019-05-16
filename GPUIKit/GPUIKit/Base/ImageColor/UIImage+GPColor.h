//
//  UIImage+GPColor.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GPColor)

/**
 获取一个纯色的image

 @param color 颜色
 @param rect 区域
 @return image
 */
+ (UIImage *)gp_createImageWithColor:(UIColor *)color frame:(CGRect)rect;

/**
 获取一个渐变色图片

 @param colors 颜色数组
 @param width 宽度
 @param height 高度
 @param startPoint 开始位置
 @param endPoint 结束为止
 @return 图片
 */
+ (UIImage *)gp_createImageWithColors:(NSArray *)colors
                                 width:(CGFloat)width
                                height:(CGFloat)height
                            startPoint:(CGPoint)startPoint
                              endPoint:(CGPoint)endPoint;
@end

typedef NS_ENUM(NSUInteger, GPImageCorner) {
    GPImageCornerNone     = 0,
    
    GPImageCornerTopLeft  = 1,
    GPImageCornerTopRight = 1 << 1,
    GPImageCornerBottomRight = 1 << 2,
    GPImageCornerBottomLeft  = 1 << 3,
    
    AGSImageCornerAll = GPImageCornerTopLeft|GPImageCornerTopRight|GPImageCornerBottomRight|GPImageCornerBottomLeft,
};

@interface UIImage (GPGrandientColor)

// 根据颜色、大小产生一个圆角渐变的图形
+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors
                                 imgSize:(CGSize)imgSize
                            cornerRadius:(CGFloat)cornerRadius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                             imageCorner:(GPImageCorner)imageCorner
                                gradient:(CGPoint)gradientPoint;

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors
                                 imgSize:(CGSize)imgSize
                            cornerRadius:(CGFloat)cornerRadius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor;

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors
                                 imgSize:(CGSize)imgSize
                                  corner:(BOOL)corner
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor;

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors
                                 imgSize:(CGSize)imgSize
                                  corner:(BOOL)corner;

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors
                                 imgSize:(CGSize)imgSize;

@end
