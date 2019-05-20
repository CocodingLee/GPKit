//
//  GPWebViewImpl.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKWebView;
@class GPWebView;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const kWebViewMessageErrorDomain;

////////////////////////////////////////////////////////////////////////////////
//
// protocol
//
@protocol GPWebViewUIDelegate <NSObject>

@optional
- (UIView *) gpProgressBarViewWithFrame:(CGRect)frame;
- (void)gpProgressBarWillStartLoad:(UIView *)progressBar;

- (void)gpProgressBar:(UIView *)progressBar
    loadedWithPrgress:(double)progress;

- (void)gpProgressBar:(UIView *)progressBar
fadeOutWithCompletion:(void (^)(void))completion;

- (UIView *)gpErrorStatusViewWithFrame:(CGRect)frame
                                 error:(NSError *)error;

@end

@protocol GPWebViewDelegate <NSObject>

@optional

/**
 是否开启请求

 @param webView 当前容器
 @param request http 请求
 @param navigationType 导航栏类型
 @return yes/no
 */
- (BOOL)            gpWebView:(GPWebView *)webView
   shouldStartLoadWithRequest:(NSURLRequest *)request
               navigationType:(UIWebViewNavigationType)navigationType;

- (void)gpWebViewDidStartLoad:(GPWebView *)webView;
- (void)gpWebViewDidFinishLoad:(GPWebView *)webView;

- (void)        gpWebView:(GPWebView *)webView
     didFailLoadWithError:(NSError *)error;

- (UIViewController *)containerController;

@end

////////////////////////////////////////////////////////////////////////////////

@interface GPWebView : UIView
@property (nonatomic, weak) id<GPWebViewUIDelegate> UIDelegate;
@property (nonatomic, weak) id<GPWebViewDelegate> delegate;
@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) WKWebView *webview;

//title和loadingProgress支持KVO
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double loadingProgress;

@property (nonatomic, readonly) NSArray<NSURL *> *historyList;

@property (nonatomic, copy) void (^titleDidChange)(NSString *title);
@property (nonatomic, copy) void (^loadingProgressDidChange)(double progress);

//会将自定义UA信息添加在系统UA信息之后
+ (void)appendCustomUserAgent:(NSString *)userAgent;
+ (NSString *)currentUserAgent;

//设置Cookie，可覆盖
+ (void)setCookieValue:(NSString *)cookieValue forKey:(NSString *)key;

//设置所有Cookie支持的Domain
+ (void)addCookieDomain:(NSString *)domain;

//为每个请求增加头部，用于添加vid等信息
+ (void)setAdditionHeader:(NSString *)header forKey:(NSString *)key;

/**
 以默认屏幕大小初始化WebView
 
 @return WebView实例
 */
- (instancetype)init;


/**
 按给定Frame初始化WebView
 
 @param frame 指定frame
 
 @return WebView实例
 */
- (instancetype)initWithFrame:(CGRect)frame;

//重新加载
- (void)reload;

//加载Request，会自动带上Cookie
- (void)loadRequest:(NSURLRequest*)request;

//是否能回退
- (BOOL)canGoBack;

//回退
- (void)goBack;

//是否正在加载
- (BOOL)isLoading;

//执行JS脚本
- (void)evaluateJavaScript:(NSString *)script completionHandler:(void (^)(id ret, NSError *error))completionHandler;

//向该WebView实例发送通知
- (void)postNotificationName:(NSString *)name data:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
