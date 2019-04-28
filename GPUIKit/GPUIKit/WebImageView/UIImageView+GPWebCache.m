//
//  UIImageView+GPWebCache.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIImageView+GPWebCache.h"
#import "UIImage+GPRounded.h"

#import <objc/runtime.h>
#import <libextobjc/EXTScope.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>

////////////////////////////////////////////////////////////////////////////
// 本次缓存连接

@interface UIImageView (InterCacheUrl)
@property (nonatomic, strong) NSString *gp_interURL;
@end

@implementation UIImageView (InterCacheUrl)
@dynamic gp_interURL;

- (NSString *) gp_interURL
{
    return objc_getAssociatedObject(self, @selector(gp_interURL));
}

- (void)setGp_interURL:(NSString *)gp_interURL
{
    objc_setAssociatedObject(self, @selector(gp_interURL), gp_interURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

////////////////////////////////////////////////////////////////////////////

@implementation UIImageView (GPWebCache)

- (void)gp_setImageWithURL:(NSURL *)url
{
    [self gp_setImageWithURL:url
            placeholderImage:nil
                     options:0
                   completed:nil];
}

- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
{
    [self gp_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                   completed:nil];
}

- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
{
    [self gp_setImageWithURL:url
            placeholderImage:placeholder
                     options:options
                   completed:nil];
}

- (void)gp_setImageWithURL:(NSURL *)url
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    [self gp_setImageWithURL:url
            placeholderImage:nil
                     options:0
                   completed:completedBlock];
}

- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    [self gp_setImageWithURL:url
            placeholderImage:placeholder
                     options:0
                   completed:completedBlock];
}

- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url
            placeholderImage:placeholder
                     options:(SDWebImageOptions)options
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (nil != image) {
                           if (image.images.count > 1) {
                               self.image = image.images.lastObject;
                               self.animationImages = image.images;
                               self.animationDuration = image.duration;
                               [self startAnimating];
                           } else {
                               self.image = image;
                               self.animationImages = nil;
                               [self stopAnimating];
                           }
                       } else {
                           self.image = placeholder;
                           self.animationImages = nil;
                           [self stopAnimating];
                       }
                       if (completedBlock) {
                           completedBlock(image, error, (GPImageCacheType)cacheType, imageURL);
                       }
                   }];
}

- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
          placeholderImage:(UIImage *)placeholder
{
    [self gp_setImageWithURL:url
                    viewSize:viewSize
                cornerRadius:cornerRadius
                 borderColor:nil
                 borderWidth:0
            placeholderImage:placeholder
                     options:0
                   completed:nil];
}

- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    [self gp_setImageWithURL:url
                    viewSize:viewSize
                cornerRadius:cornerRadius
                 borderColor:nil
                 borderWidth:0
            placeholderImage:placeholder
                     options:options
                   completed:completedBlock];
}

- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    UIEdgeInsets radii = UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius);
    [self gp_setImageWithURL:url
                    viewSize:viewSize
                 cornerRadii:radii
                 borderColor:borderColor
                 borderWidth:borderWidth
            placeholderImage:placeholder
                     options:options
                   completed:completedBlock];
}

- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
               cornerRadii:(UIEdgeInsets)cornerRadii
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock
{
    self.gp_interURL = url;
    NSString *placeholderKey = [NSString stringWithFormat:@"%p_%.fx%.f", placeholder.CGImage, viewSize.width, viewSize.height];
    NSString *imageKey = [self imageKeyWithURL:url.absoluteString
                                      viewSize:viewSize
                                   cornerRadii:cornerRadii
                                   borderColor:borderColor
                                   borderWidth:borderWidth];
    UIImage *cachedImage = [self roundedImageWithImage:nil
                                                   key:imageKey
                                              viewSize:viewSize
                                           cornerRadii:cornerRadii
                                           borderColor:borderColor
                                           borderWidth:borderWidth
                                              complete:nil];
    @weakify(self);
    void (^setImageBlock)(UIImage *) = ^(UIImage *blockImage) {
        @strongify(self);
        if (cachedImage.images.count > 1) {
            self.image = blockImage.images.lastObject;
            self.animationImages = blockImage.images;
            self.animationDuration = blockImage.duration;
            [self startAnimating];
        } else {
            self.image = blockImage;
            self.animationImages = nil;
            [self stopAnimating];
        }
    };
    
    if (nil != cachedImage) {
        setImageBlock(cachedImage);
    }
    
    [self roundedImageWithImage:placeholder
                            key:placeholderKey
                       viewSize:viewSize
                    cornerRadii:cornerRadii
                    borderColor:borderColor
                    borderWidth:borderWidth
                       complete:^(UIImage *roundedPlaceholderImage) {
                           @strongify(self);
                           [self sd_setImageWithURL:url
                                   placeholderImage:roundedPlaceholderImage
                                            options:options|SDWebImageAvoidAutoSetImage
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              @strongify(self);
                                              if (nil != image) {
                                                  [self roundedImageWithImage:image
                                                                          key:imageKey
                                                                     viewSize:viewSize
                                                                  cornerRadii:cornerRadii
                                                                  borderColor:borderColor
                                                                  borderWidth:borderWidth
                                                                     complete:^(UIImage *roundedImage) {
                                                                         if (![self.gp_interURL isEqual:url]) {
                                                                             return;
                                                                         }
                                                                         setImageBlock(roundedImage);
                                                                     }];
                                              } else {
                                                  self.image = roundedPlaceholderImage;
                                                  self.animationImages = nil;
                                                  [self stopAnimating];
                                              }
                                              if (completedBlock) {
                                                  completedBlock(image, error, (GPImageCacheType)cacheType, imageURL);
                                              }
                                          }];
                       }];
}

- (void)gp_cancelCurrentImageLoad
{
    [self sd_cancelCurrentImageLoad];
}

#pragma mark - Cache

- (UIImage *)roundedImageWithImage:(UIImage *)originalImage
                               key:(NSString *)imageKey
                          viewSize:(CGSize)viewSize
                       cornerRadii:(UIEdgeInsets)cornerRadii
                       borderColor:(UIColor *)borderColor
                       borderWidth:(CGFloat)borderWidth
                          complete:(void (^)(UIImage *roundedImage))complete
{
    __block UIImage *roundedImg = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:imageKey];
    if (roundedImg) {
        if (complete) {
            complete(roundedImg);
        }
        return roundedImg;
    }
    
    if (nil == originalImage) {
        if (complete) {
            complete(nil);
        }
        return nil;
    }
    
    UIViewContentMode contentMode = self.contentMode;
    UIColor *backgroundColor = self.backgroundColor;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        if (originalImage.images.count > 1) {
            NSMutableArray *roundedImages = [NSMutableArray new];
            for (UIImage *aFrameImage in originalImage.images) {
                UIImage *aFrameRoundedImage = [aFrameImage gp_imageWithBackgroundColor:backgroundColor
                                                                              viewSize:viewSize
                                                                           contentMode:contentMode
                                                                           cornerRadii:cornerRadii
                                                                           borderColor:borderColor
                                                                           borderWidth:borderWidth];
                if (nil != aFrameRoundedImage) {
                    [roundedImages addObject:aFrameRoundedImage];
                }
            }
            roundedImg = [UIImage animatedImageWithImages:roundedImages duration:originalImage.duration];
        } else {
            roundedImg = [originalImage gp_imageWithBackgroundColor:backgroundColor
                                                           viewSize:viewSize
                                                        contentMode:contentMode
                                                        cornerRadii:cornerRadii
                                                        borderColor:borderColor
                                                        borderWidth:borderWidth];
        }
        [[SDWebImageManager sharedManager].imageCache storeImage:roundedImg forKey:imageKey toDisk:NO completion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(roundedImg);
            }
        });
    });
    
    return nil;
}

#pragma mark - Helper

- (NSString *)imageKeyWithURL:(NSString *)url
                     viewSize:(CGSize)viewSize
                  cornerRadii:(UIEdgeInsets)cornerRadii
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)borderWidth
{
    NSString *radiiKey = [NSString stringWithFormat:@"%.1f_%.1f_%.1f_%.1f", cornerRadii.top, cornerRadii.left, cornerRadii.bottom, cornerRadii.right];
    NSString *imageKey = [NSString stringWithFormat:@"%@#%@_%.1f_%@_%.f_%.f", url, [self gp_stringFromColor:borderColor], borderWidth, radiiKey, viewSize.width, viewSize.height];
    return imageKey;
}

- (NSString *)gp_stringFromColor:(UIColor *)color
{
    if (nil == color) {
        return @"";
    }
    
    const size_t totalComponents = CGColorGetNumberOfComponents(color.CGColor);
    const CGFloat * components = CGColorGetComponents(color.CGColor);
    return [NSString stringWithFormat:@"%02X%02X%02X",
            (int)(255 * components[MIN(0,totalComponents-2)]),
            (int)(255 * components[MIN(1,totalComponents-2)]),
            (int)(255 * components[MIN(2,totalComponents-2)])];
}

@end
