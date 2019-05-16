//
//  UIImage+GPColor.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIImage+GPColor.h"

@implementation UIImage (GPColor)

+ (UIImage *)gp_createImageWithColor:(UIColor *)color frame:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)gp_createImageWithColors:(NSArray *)colors
                             width:(CGFloat)width
                            height:(CGFloat)height
                        startPoint:(CGPoint)startPoint
                          endPoint:(CGPoint)endPoint {
    CGSize size = CGSizeMake(width, height);
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.colors = colors;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    UIGraphicsBeginImageContext(size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end


@implementation UIImage (GPGrandientColor)

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize
{
    return [self gp_gradientImageFromColors:colors imgSize:imgSize corner:YES borderWidth:0 borderColor:nil];
}

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize corner:(BOOL)corner
{
    return [self gp_gradientImageFromColors:colors imgSize:imgSize corner:corner borderWidth:0 borderColor:nil];
}

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize corner:(BOOL)corner borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CGFloat cornerRadius = corner ? imgSize.height/2 : 0;
    return [self gp_gradientImageFromColors:colors imgSize:imgSize cornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor];
}

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    return [self gp_gradientImageFromColors:colors imgSize:imgSize cornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor imageCorner:AGSImageCornerAll gradient:(CGPoint){1.1, 1}];
}

+ (UIImage *)gp_gradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor imageCorner:(GPImageCorner)imageCorner gradient:(CGPoint)gradientPoint
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0);
    
    CGRect rect = (CGRect){0, 0, imgSize.width, imgSize.height};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = NULL;
    
    if (cornerRadius > 0.1)
    {
        // Create path
        CGFloat radius = cornerRadius;
        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect));
        if (GPImageCornerTopRight & imageCorner)
        {
            CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, 3 * M_PI / 2, 0, 0);
        }
        else
        {
            CGPathAddArc(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), 0, 0, 0, 0);
        }
        
        if (GPImageCornerBottomRight & imageCorner)
        {
            CGPathAddArc(path, NULL, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, M_PI / 2, 0);
        }
        else
        {
            CGPathAddArc(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), 0, 0, 0, 0);
        }
        
        if (GPImageCornerBottomLeft & imageCorner)
        {
            CGPathAddArc(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, M_PI / 2, M_PI, 0);
        }
        else
        {
            CGPathAddArc(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), 0, 0, 0, 0);
        }
        
        if (GPImageCornerTopLeft & imageCorner)
        {
            CGPathAddArc(path, NULL, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, M_PI, 3 * M_PI / 2, 0);
        }
        else
        {
            CGPathAddArc(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), 0, 0, 0, 0);
        }
        
        CGPathCloseSubpath(path);
        CGContextAddPath(context, path);
    }
    
    CGContextSaveGState(context);
    CGContextClip(context);
    
    // Draw gradient
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint startPoint = rect.origin;
    CGPoint endPoint = CGPointMake(rect.origin.x + gradientPoint.x * rect.size.width, rect.origin.y + gradientPoint.y * rect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    
    // Draw path
    if (borderWidth > 0 && nil != borderColor)
    {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        //        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextAddPath(context, path);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    // Create Image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGPathRelease(path);
//    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
