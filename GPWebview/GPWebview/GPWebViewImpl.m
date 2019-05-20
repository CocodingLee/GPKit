//
//  GPWebViewImpl.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPWebViewImpl.h"

#import "GPJSBridge.h"
#import "GPWebViewCore.h"
#import "GPWebMsgDelegate.h"
#import "GPWebMsgAcceptor.h"
#import "GPWebMsgCenter.h"
#import "GPSafariUAController.h"

#import <objc/message.h>
#import <WebKit/WebKit.h>

static float const kWebViewScrollDecelerationRate = 2.f;
NSString *const kWebViewMessageErrorDomain = @"kWebViewMessageErrorDomain";

static NSString *const kWebViewCookieChangeNotification = @"kWebViewCookieChangeNotification";

@interface GPWebViewImpl () <GPJSBridgeDelegate, WKNavigationDelegate, GPWebMsgCenterDelegate>
@property (nonatomic, readwrite) WKWebView *webview;
@property (nonatomic, strong) GPJSBridge *bridge;

@property (nonatomic, strong) UIView *progressBar;
@property (nonatomic, strong) UIView *errorStatusView;

@property (nonatomic, assign) NSInteger nonMainFrameRequestCount;
@property (nonatomic, assign) BOOL _loading;

@property (nonatomic, copy) NSURLRequest *initialRequest;

@property (nonatomic, strong) NSMutableArray           *urlStack;
@property (nonatomic, copy)   NSString                 *urlStackDescription;

@property (nonatomic, strong) NSMutableDictionary<NSString *,NSDictionary *> *eventParam;
@end

@implementation GPWebViewImpl

+ (void)appendCustomUserAgent:(NSString *)userAgent;
{
    [GPWebViewCore sharedCore].userAgent = userAgent;
}

+ (NSString *)currentUserAgent
{
    return [GPWebViewCore sharedCore].userAgent;
}

+ (void)setCookieValue:(NSString *)cookieValue forKey:(NSString *)key
{
    [[GPWebViewCore sharedCore] setCookiesKey:key value:cookieValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:kWebViewCookieChangeNotification object:nil];
}

+ (void)addCookieDomain:(NSString *)domain
{
    [[GPWebViewCore sharedCore] addDomain:domain];
}

+ (void)setAdditionHeader:(NSString *)header forKey:(NSString *)key
{
    [[GPWebViewCore sharedCore] setAdditionHeader:header forKey:key];
}

- (void)dealloc
{
    [_webview.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [_webview removeObserver:self forKeyPath:@"title"];
    [_webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cookieChanged:) name:kWebViewCookieChangeNotification object:nil];
    [self setupWebView];
    return self;
}

- (void)setupWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.processPool = [GPWebViewCore sharedCore].processPool;
    config.userContentController = [GPWebViewCore sharedCore].userContentController;
    
    WKWebView * webview = [[WKWebView alloc] initWithFrame:self.bounds configuration:config];
    webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webview.navigationDelegate = self;
    
    if ([GPWebViewCore sharedCore].userAgent && [webview respondsToSelector:@selector(setCustomUserAgent:)]) {
        if (@available(iOS 9.0, *)) {
            webview.customUserAgent = [GPWebViewCore sharedCore].userAgent;
        }
    }
    
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [webview.scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state"
                                                 options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew
                                                 context:nil];
    
    self.webview = webview;
    
    GPJSBridge *bridge = [[GPJSBridge alloc] init];
    bridge.delegate = self;
    
    self.bridge = bridge;
    self.webview.UIDelegate = bridge;
    
    [self addSubview:self.webview];
    
    //[self _prepareForNoCrashes];
}

- (void)cookieChanged:(NSNotification *)notification
{
    NSDictionary *cookies = [GPWebViewCore sharedCore].cookies;
    [self.webview.configuration.userContentController removeAllUserScripts];
    [self.webview.configuration.userContentController addUserScript:[[GPWebViewCore sharedCore] cookieScript]];
    if (cookies) {
        NSString *cookieScript = [[GPWebViewCore sharedCore] cookiesString];
        [self.webview evaluateJavaScript:cookieScript completionHandler:^(id ret, NSError *error) {
            
        }];
    }
}

- (NSArray *)historyList
{
    NSMutableArray *historyList = [NSMutableArray new];
    [self.webview.backForwardList.backList enumerateObjectsUsingBlock:^(WKBackForwardListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [historyList addObject:obj.URL];
    }];
    return historyList;
}

- (void)loadRequest:(NSURLRequest *)request
{
    //需要对Request的header里面插入cookie
    NSMutableURLRequest *requestWithCookie = [request mutableCopy];
    NSDictionary *cookies = [GPWebViewCore sharedCore].cookies;
    if (cookies && [cookies allKeys].count > 0) {
        NSMutableString *cookieStr = [NSMutableString new];
        [cookies enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [cookieStr appendFormat:@"%@=%@;", key, obj];
        }];
        [requestWithCookie addValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    
    if ([GPWebViewCore sharedCore].additionHeader) {
        [[GPWebViewCore sharedCore].additionHeader enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            [requestWithCookie addValue:obj forHTTPHeaderField:key];
        }];
    }
    
    [self.webview loadRequest:requestWithCookie];
    
    self.initialRequest = requestWithCookie;
}

- (BOOL)isLoading
{
    return self.webview.isLoading;
}

- (UIScrollView *)scrollView
{
    return self.webview.scrollView;
}

- (WKWebView *)webview
{
    return _webview;
}

- (void)goBack
{
    [self.webview goBack];
}

- (BOOL)canGoBack
{
    return [self.webview canGoBack];
}

- (void)reload
{
    if (!self.webview.URL && self.initialRequest) {
        [self.webview loadRequest:self.initialRequest];
    } else {
        [self.webview reload];
    }
}

- (void)evaluateJavaScript:(NSString *)script completionHandler:(void (^)(id, NSError *))completionHandler
{
    [self.webview evaluateJavaScript:script completionHandler:completionHandler];
}

- (void)postNotificationName:(NSString *)name data:(NSDictionary *)data
{
    [self onEvent:name data:data];
}


- (id<GPWebMsgDelegate>)findReceiverWithMessage:(GPJSBridgeMessageModel *)message
{
    if (message.args[@"async"]) {
        id<GPWebMsgDelegate> ret = [GPWebMsgAcceptor acceptMessage:message.message isAync:[message.args[@"async"] boolValue]];
        return ret;
    }
    else {
        id<GPWebMsgDelegate> ret = [GPWebMsgAcceptor acceptMessage:message.message];
        return ret;
    }
    
    
}
/**
 协议返回给H5的格式如下：
 {
 "error" : {
 "message" : "message",
 "code" : -1
 },
 "data" : {
 
 }
 }
 */
#pragma mark - JSBridgeDelegate

- (NSDictionary *)bridge:(GPJSBridge *)bridge didReciveMessage:(GPJSBridgeMessageModel *)message
{
    id<GPWebMsgDelegate> receiver = [self findReceiverWithMessage:message];
    
    NSString *lowwerString = [message.message lowercaseString];
    BOOL isAync = ![lowwerString hasSuffix:@"sync"];
    
    if (message.args[@"async"]) {
        isAync = [message.args[@"async"] boolValue];
    }
    
    NSDictionary *ret = nil;
    if (isAync) {
        //异步方法处理
        ret = @{};
        dispatch_async(dispatch_get_main_queue(), ^{
            [self asyncMessage:message sendToReceiver:receiver];
        });
    } else {
        //同步方法处理
        ret = [self syncMessage:message sendToReceiver:receiver] ?: @{};
    }
    
    return ret;
}

- (NSDictionary *)syncMessage:(GPJSBridgeMessageModel *)message
               sendToReceiver:(id<GPWebMsgDelegate>)receiver
{
    id msgRet = [receiver webview:self processSyncMessage:message.message args:message.args];
    NSMutableDictionary *ret = [NSMutableDictionary new];
    
    if ([msgRet isKindOfClass:[NSError class]]) {
        NSError *err = msgRet;
        ret[@"error"] = [self payloadWithError:err];
    } else {
        ret[@"data"] = msgRet ?: @{};
    }
    
    return ret;
}

- (void)asyncMessage:(GPJSBridgeMessageModel *)message
      sendToReceiver:(id<GPWebMsgDelegate>)receiver
{
    id callBackId = message.callbackId;
    [receiver webview:self processAsyncMessage:message.message args:message.args callback:^(id callbackRet) {
        NSMutableDictionary *ret = [NSMutableDictionary new];
        if ([callbackRet isKindOfClass:[NSError class]]) {
            NSError *err = callbackRet;
            ret[@"error"] = [self payloadWithError:err];
        } else {
            ret[@"data"] = callbackRet ?: @{};
        }
        
        [self onCallBack:callBackId result:ret];
    }];
}

- (NSDictionary *)payloadWithError:(NSError *)error
{
    return @{
             @"message" : error.localizedDescription ?: @"",
             @"code" : @(error.code),
             };
}

#pragma mark - H5 CallBack
- (void)onCallBack:(id)callbackId result:(NSDictionary *)result
{
    if (callbackId) {
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:result options:0 error:nil];
        NSString *resultStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
        NSString *callbackScript = [NSString stringWithFormat:@"JSBridge.onCallback(%@, %@)", callbackId, resultStr];
        [self.webview evaluateJavaScript:callbackScript completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            
        }];
    }
}

- (void)onEvent:(NSString *)eventType data:(NSDictionary *)data
{
    NSDictionary *eventParam = self.eventParam[@"eventType"]?:@{};
    NSData *dData = [NSJSONSerialization dataWithJSONObject:data ?: @{} options:0 error:nil];
    NSString *sData = [[NSString alloc] initWithData:dData encoding:NSUTF8StringEncoding];
    NSString *onEventScript = [NSString stringWithFormat:@"JSBridge.onEvent(\"%@\", %@, %@)", eventType, sData, eventParam];
    [self.webview evaluateJavaScript:onEventScript completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        
    }];
}

#pragma mark - NotificationCenter Delegate
- (void)GPWebViewNotifyByEventName:(NSString *)eventName data:(NSDictionary *)data
{
    [self onEvent:eventName data:data];
}

#pragma mark - WKWebViewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.sourceFrame.mainFrame) {
        self._loading = YES;
    }
    
    self.nonMainFrameRequestCount ++;
    
    BOOL isAllowed = YES;
    if ([self.delegate respondsToSelector:@selector(gpWebView:shouldStartLoadWithRequest:navigationType:)]) {
        isAllowed = [self.delegate gpWebView:self shouldStartLoadWithRequest:navigationAction.request
                              navigationType:(UIWebViewNavigationType)navigationAction.navigationType];
    }
    
    if (isAllowed) {
        [self progressStart];
        [self hideErrorView];
        self.errorStatusView = nil;
        
        decisionHandler(WKNavigationActionPolicyAllow);
        [self urlStackAddUrl:navigationAction.request.URL.absoluteString ?: @""];
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    if ([self.delegate respondsToSelector:@selector(gpWebViewDidStartLoad:)]) {
        [self.delegate gpWebViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.nonMainFrameRequestCount = 0;
    
    if ([self.delegate respondsToSelector:@selector(gpWebViewDidFinishLoad:)]) {
        [self.delegate gpWebViewDidFinishLoad:self];
    }
    
    [self hideErrorView];
    [self progressFadeOut];
    
    self._loading = NO;
}

- (void)                webView:(WKWebView *)webView
   didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation
                      withError:(NSError *)error
{
    self.nonMainFrameRequestCount --;
    if (self.nonMainFrameRequestCount > 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(gpWebView:didFailLoadWithError:)]) {
        [self.delegate gpWebView:self didFailLoadWithError:error];
    }
    
    [self showErrorViewWithError:error];
    [self progressFadeOut];
    
    self._loading = NO;
}

#pragma mark - KVO for loadingPrgress & title
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[WKWebView class]]) {
        [self webviewObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
    } else if ([object isKindOfClass:[UIGestureRecognizer class]]) {
        [self scrollViewObserveValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)scrollViewObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIGestureRecognizerState state = [change[NSKeyValueChangeNewKey] integerValue];
    if (state == UIGestureRecognizerStateEnded ||
        state == UIGestureRecognizerStateCancelled) {
        [self scrollViewDidEndDragging:self.webview.scrollView];
    }
    if (state == UIGestureRecognizerStateBegan) {
        [self scrollViewWillBeginDragging:self.webview.scrollView];
    }
}

- (void)webviewObserveValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]) {
        NSString *newTitle = change[@"new"];
        self.title = newTitle;
        if (self.titleDidChange) {
            self.titleDidChange(newTitle);
        }
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double newProgress = [change[@"new"] floatValue];
        self.loadingProgress = newProgress;
        if (self.loadingProgressDidChange) {
            self.loadingProgressDidChange(newProgress);
        }
        
        [self progressLoadWithProgress:newProgress];
    }
}

#pragma mark - ProgressBar
- (void)setupProgressBar
{
    if (self.progressBar) {
        return;
    }
    
    if ([self.UIDelegate respondsToSelector:@selector(gpProgressBarViewWithFrame:)]) {
        UIView *progressBar = [self.UIDelegate gpProgressBarViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 3)];
        progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.progressBar = progressBar;
    }
}

- (void)progressStart
{
    [self setupProgressBar];
    
    [self addSubview:self.progressBar];
    
    if ([self.UIDelegate respondsToSelector:@selector(gpProgressBarWillStartLoad:)]) {
        [self.UIDelegate gpProgressBarWillStartLoad:self.progressBar];
    }
}

- (void)progressLoadWithProgress:(double)progress
{
    if (!self._loading) {
        return;
    }
    
    if ([self.UIDelegate respondsToSelector:@selector(gpProgressBar:loadedWithPrgress:)]) {
        [self.UIDelegate gpProgressBar:self.progressBar loadedWithPrgress:progress];
    }
}

- (void)progressFadeOut
{
    if ([self.UIDelegate respondsToSelector:@selector(gpProgressBar:fadeOutWithCompletion:)]) {
        [self.UIDelegate gpProgressBar:self.progressBar fadeOutWithCompletion:^{
            [self.progressBar removeFromSuperview];
        }];
    } else {
        [self.progressBar removeFromSuperview];
    }
}

#pragma mark - ErrorView
- (void)hideErrorView
{
    [self.errorStatusView removeFromSuperview];
}

- (void)showErrorViewWithError:(NSError *)error
{
    if ([self.UIDelegate respondsToSelector:@selector(gpErrorStatusViewWithFrame:error:)]) {
        UIView *errorStatusView = [self.UIDelegate gpErrorStatusViewWithFrame:self.bounds error:error];
        errorStatusView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:errorStatusView];
        
        self.errorStatusView = errorStatusView;
    }
}

#pragma mark - Url Stack
- (NSMutableArray *)urlStack
{
    if (_urlStack) {
        return _urlStack;
    }
    
    _urlStack = [NSMutableArray new];
    return _urlStack;
}

- (void)urlStackAddUrl:(NSString *)urlString
{
    [self.urlStack addObject:urlString];
    NSMutableString *urlStackString = [NSMutableString new];
    [self.urlStack enumerateObjectsUsingBlock:^(NSString *stackItem, NSUInteger idx, BOOL *stop) {
        [urlStackString appendFormat:@"%@ -> ", stackItem];
    }];
    
    if (urlStackString.length >= 4) {
        [urlStackString deleteCharactersInRange:NSMakeRange(urlStackString.length - 4, 4)];
    }
    
    self.urlStackDescription = [NSString stringWithFormat:@"urlStack:[%@]", urlStackString];
}

- (NSString *)description
{
    NSMutableString *ret = [[NSMutableString alloc] initWithString:[super description]];
    [ret appendFormat:@" %@", self.urlStackDescription];
    return ret;
}

- (NSString *)debugDescription
{
    return [self description];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
{
    self.webview.scrollView.decelerationRate = kWebViewScrollDecelerationRate;
}

#pragma WebView Bug Hook
////修复苹果的bug，有可能往WebView发送paste/cut等消息
//void webView_implement_UIResponderStandardEditActions(id self, SEL selector, id param)
//{
//    
//}
//
//- (void)_prepareForNoCrashes
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSArray* selectors = @[@"cut:", @"copy:",
//                               @"paste:", @"select:",
//                               @"selectAll:", @"delete:",
//                               @"makeTextWritingDirectionLeftToRight:",
//                               @"makeTextWritingDirectionRightToLeft:",
//                               @"toggleBoldface:", @"toggleItalics:",
//                               @"toggleUnderline:", @"increaseSize:",
//                               @"decreaseSize:"];
//        
//        for (NSString* selName in selectors)
//        {
//            SEL selector = NSSelectorFromString(selName);
//            
//            //This is safe, the method will fail if there is already an implementation.
//            class_addMethod([self.webview class], selector, (IMP)webView_implement_UIResponderStandardEditActions, "");
//        }
//    });
//}

#pragma mark - eventParam
- (NSMutableDictionary<NSString *,NSDictionary *> *)eventParam
{
    if (_eventParam) {
        return _eventParam;
    }
    
    _eventParam = [NSMutableDictionary new];
    return _eventParam;
}

- (NSDictionary *)getEventParamWithEventName:(NSString *)eventName
{
    if (eventName) {
        return self.eventParam[eventName]?:@{};
    }
    
    return @{};
}

- (void)setEventParam:(NSDictionary *)param
            eventName:(NSString *)eventName
{
    if (param
        && eventName
        && [eventName isKindOfClass:NSString.class]
        && eventName.length > 0) {
        self.eventParam[eventName] = param;
    }
}
@end
