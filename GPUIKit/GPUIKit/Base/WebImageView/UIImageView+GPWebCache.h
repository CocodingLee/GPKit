//
//  UIImageView+GPWebCache.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 缓存方式

typedef NS_OPTIONS(NSUInteger, GPWebImageOptions)
{
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    GPWebImageRetryFailed = 1 << 0,
    
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    GPWebImageLowPriority = 1 << 1,
    
    /**
     * This flag disables on-disk caching
     */
    GPWebImageCacheMemoryOnly = 1 << 2,
    
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    GPWebImageProgressiveDownload = 1 << 3,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of GPWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embedded cache busting parameter.
     */
    GPWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    GPWebImageContinueInBackground = 1 << 5,
    
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    GPWebImageHandleCookies = 1 << 6,
    
    /**
     * Enable to allow untrusted SSL certificates.
     * Useful for testing purposes. Use with caution in production.
     */
    GPWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, images are loaded in the order in which they were queued. This flag moves them to
     * the front of the queue.
     */
    GPWebImageHighPriority = 1 << 8,
    
    /**
     * By default, placeholder images are loaded while the image is loading. This flag will delay the loading
     * of the placeholder image until after the image has finished loading.
     */
    GPWebImageDelayPlaceholder = 1 << 9,
    
    /**
     * We usually don't call transformDownloadedImage delegate method on animated images,
     * as most transformation code would mangle it.
     * Use this flag to transform them anyway.
     */
    GPWebImageTransformAnimatedImage = 1 << 10,
    
    /**
     * By default, image is added to the imageView after download. But in some cases, we want to
     * have the hand before setting the image (apply a filter or add it with cross-fade animation for instance)
     * Use this flag if you want to manually set the image in the completion when success
     */
    GPWebImageAvoidAutoSetImage = 1 << 11
};

typedef NS_ENUM(NSInteger, GPImageCacheType)
{
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    GPImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    GPImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    GPImageCacheTypeMemory
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 加载完成

typedef void(^GPWebImageCompletionBlock)(  UIImage *image
                                         , NSError *error
                                         , GPImageCacheType cacheType
                                         , NSURL *imageURL);

typedef void(^GPWebImageCompletionWithFinishedBlock)(  UIImage *image
                                                     , NSError *error
                                                     , GPImageCacheType cacheType
                                                     , BOOL finished
                                                     , NSURL *imageURL);

typedef NSString *_Nullable(^GPWebImageCacheKeyFilterBlock)(NSURL *url);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIImageView (GPWebCache)

- (void)gp_setImageWithURL:(NSURL *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see agn_setImageWithURL:placeholderImage:options:
 */
- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see AGSWebImageOptions for the possible values.
 */
- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gp_setImageWithURL:(NSURL *)url
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see AGSWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)gp_setImageWithURL:(NSURL *)url
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 *  设置并缓存圆角图片
 *
 *  @param url            图片原始 URL， 缓存图片会根据设置的参数拼在 URL 上缓存
 *  @param viewSize       图片显示的大小，单位 pt
 *  @param cornerRadius   图片圆角
 *  @param placeholder    占位图
 */
- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
          placeholderImage:(UIImage *)placeholder;

/**
 *  设置并缓存圆角图片
 *
 *  @param url            图片原始 URL， 缓存图片会根据设置的参数拼在 URL 上缓存
 *  @param viewSize       图片显示的大小，单位 pt
 *  @param cornerRadius   图片圆角
 *  @param placeholder    占位图
 *  @param options        下载选项， 该选项对图片下载流程（SD 的流程）有效
 *  @param completedBlock 结束的回调
 */
- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 *  设置并缓存圆角图片
 *
 *  @param url            图片原始 URL， 缓存图片会根据设置的参数拼在 URL 上缓存
 *  @param viewSize       图片显示的大小，单位 pt
 *  @param cornerRadius   图片圆角
 *  @param borderColor    图片边框颜色， 默认白色
 *  @param borderWidth    图片边框宽度， 默认 0
 *  @param placeholder    占位图
 *  @param options        下载选项， 该选项对图片下载流程（SD 的流程）有效
 *  @param completedBlock 结束的回调
 */
- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
              cornerRadius:(CGFloat)cornerRadius
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 *  设置并缓存不同圆角
 *
 *  @param url                  图片原始 URL， 缓存图片会根据设置的参数拼在 URL 上缓存
 *  @param viewSize             图片显示的大小，单位 pt
 *  @param cornerRadiiInset     图片圆角，设置各个方向的圆角， 分别 leftTop、leftBottom、rightBottom、rightTop
 *  @param borderColor          图片边框颜色， 默认白色
 *  @param borderWidth          图片边框宽度， 默认 0
 *  @param placeholder          占位图
 *  @param options              下载选项， 该选项对图片下载流程（SD 的流程）有效
 *  @param completedBlock       结束的回调
 */
- (void)gp_setImageWithURL:(NSURL *)url
                  viewSize:(CGSize)viewSize
               cornerRadii:(UIEdgeInsets)cornerRadiiInset
               borderColor:(UIColor *)borderColor
               borderWidth:(CGFloat)borderWidth
          placeholderImage:(UIImage *)placeholder
                   options:(GPWebImageOptions)options
                 completed:(GPWebImageCompletionBlock)completedBlock;

/**
 取消当前下载
 */
- (void)gp_cancelCurrentImageLoad;

@end

NS_ASSUME_NONNULL_END
