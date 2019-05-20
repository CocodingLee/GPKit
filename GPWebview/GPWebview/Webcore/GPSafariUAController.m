//
//  GPSafariUAController.m
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPSafariUAController.h"

@interface GPSafariUAController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
@end

@implementation GPSafariUAController

+ (GPSafariUAController *)sharedInstance;
{
    static GPSafariUAController * _instance = nil;
    if (nil == _instance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[GPSafariUAController alloc] init];
        });
    }
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self syncFetchUserAgent];
    return self;
}

//只有第一次启动，本地没有UA记录，才会同步去获取UA，会卡主线程
- (void)syncFetchUserAgent
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _webView.delegate = self;
    
    self.safariUAString = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}
@end
