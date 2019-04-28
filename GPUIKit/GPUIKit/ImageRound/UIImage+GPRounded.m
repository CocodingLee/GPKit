//
//  UIImageView+GPRounded.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIImage+GPRounded.h"

@implementation UIImage (GPRounded)

- (UIImage *)gp_imageWithBackgroundColor:(UIColor *)color
                                viewSize:(CGSize)viewSize
                             contentMode:(UIViewContentMode)mode
                            cornerRadius:(CGFloat)cornerRadius
                             borderColor:(UIColor *)borderColor
                             borderWidth:(CGFloat)borderWidth
{
    UIColor *backgroundColor = color;
    UIImage *image = self;
    
    if (image) {
        image = [image gp_scaleToSize:CGSizeMake(viewSize.width, viewSize.height) contentMode:mode backgroundColor:backgroundColor];
        backgroundColor = [UIColor colorWithPatternImage:image];
    } else if (!color){
        backgroundColor = [UIColor whiteColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, UIScreen.mainScreen.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGRect rect = CGRectMake(borderWidth, borderWidth, viewSize.width - 2 * borderWidth, viewSize.height - 2 * borderWidth);
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CGPathRef path = rounded.CGPath;
    CGContextAddPath(context, path);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

- (UIImage *)gp_imageWithBackgroundColor:(UIColor *)color
                                viewSize:(CGSize)viewSize
                             contentMode:(UIViewContentMode)mode
                             cornerRadii:(UIEdgeInsets)cornerRadii
                             borderColor:(UIColor *)borderColor
                             borderWidth:(CGFloat)borderWidth
{
    UIColor *backgroundColor = color;
    UIImage *image = self;
    if (image) {
        image = [image gp_scaleToSize:CGSizeMake(viewSize.width, viewSize.height) contentMode:mode backgroundColor:backgroundColor];
        backgroundColor = [UIColor colorWithPatternImage:image];
    } else if (!color){
        backgroundColor = [UIColor whiteColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, UIScreen.mainScreen.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    CGFloat radiusLeftTop = cornerRadii.left;
    CGFloat radiusLeftBottom = cornerRadii.bottom;
    CGFloat radiusRightBottom = cornerRadii.right;
    CGFloat radiusRightTop = cornerRadii.top;
    
    // Create path
    CGRect rect = CGRectMake(borderWidth, borderWidth, viewSize.width - 2 * borderWidth, viewSize.height - 2 * borderWidth);
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    UIBezierPath *rounded = [UIBezierPath bezierPath];
    
    // TopLeft
    [rounded moveToPoint:CGPointMake(radiusLeftTop, height)];
    [rounded addArcWithCenter:CGPointMake(radiusLeftTop, height - radiusLeftTop) radius:radiusLeftTop startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    
    // BottomLeft
    [rounded addLineToPoint:CGPointMake(0, radiusLeftBottom)];
    [rounded addArcWithCenter:CGPointMake(radiusLeftBottom, radiusLeftBottom) radius:radiusLeftBottom startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    
    // BottomRight
    [rounded addLineToPoint:CGPointMake(width - radiusRightBottom, 0)];
    [rounded addArcWithCenter:CGPointMake(width - radiusRightBottom, radiusRightBottom) radius:radiusRightBottom startAngle:M_PI_2 * 3 endAngle:0 clockwise:YES];
    
    // TopRight
    [rounded addLineToPoint:CGPointMake(width, height - radiusRightTop)];
    [rounded addArcWithCenter:CGPointMake(width - radiusRightTop, height - radiusRightTop) radius:radiusRightTop startAngle:0 endAngle:M_PI_2 clockwise:YES];
    
    // close
    [rounded addLineToPoint:CGPointMake(radiusLeftTop, height)];
    
    
    CGPathRef path = rounded.CGPath;
    CGContextAddPath(context, path);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

- (UIImage *)gp_scaleToSize:(CGSize)size contentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    if (backgroundColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    [self drawInRect:[self gp_drawInRectWithRect:CGRectMake(0.0f, 0.0f, size.width, size.height) contentMode:contentMode]];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGRect)gp_drawInRectWithRect:(CGRect)rect contentMode:(UIViewContentMode)mode
{
    CGSize size = self.size;
    rect = CGRectStandardize(rect);
    size.width = size.width < 0 ? -size.width : size.width;
    size.height = size.height < 0 ? -size.height : size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    switch (mode) {
        case UIViewContentModeRedraw:
        case UIViewContentModeScaleAspectFit:
        case UIViewContentModeScaleAspectFill: {
            if (rect.size.width < 0.01 || rect.size.height < 0.01 ||
                size.width < 0.01 || size.height < 0.01) {
                rect.origin = center;
                rect.size = CGSizeZero;
            } else {
                CGFloat scale;
                if (mode == UIViewContentModeScaleAspectFill) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width;
                    } else {
                        scale = rect.size.height / size.height;
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height;
                    } else {
                        scale = rect.size.width / size.width;
                    }
                }
                size.width *= scale;
                size.height *= scale;
                rect.size = size;
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
            }
        } break;
        case UIViewContentModeCenter: {
            rect.size = size;
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
        } break;
        case UIViewContentModeTop: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeBottom: {
            rect.origin.x = center.x - size.width * 0.5;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeLeft: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.size = size;
        } break;
        case UIViewContentModeRight: {
            rect.origin.y = center.y - size.height * 0.5;
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeTopLeft: {
            rect.size = size;
        } break;
        case UIViewContentModeTopRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.size = size;
        } break;
        case UIViewContentModeBottomLeft: {
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeBottomRight: {
            rect.origin.x += rect.size.width - size.width;
            rect.origin.y += rect.size.height - size.height;
            rect.size = size;
        } break;
        case UIViewContentModeScaleToFill:
        default: {
            rect = rect;
        }
    }
    return rect;
}
@end
