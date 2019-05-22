//
//  GPMoreViewController.m
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/10.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPMoreViewController.h"

@interface GPMoreViewController ()
< GPWebViewDelegate
, DZNEmptyDataSetSource
, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) GPWebView *webview;
@end

@implementation GPMoreViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        // 首页不创建返回
        self.gp_notAutoCreateBackButtonItem = YES;
    }
    
    return self;
}

- (GPWebView *)webview
{
    if (!_webview) {
        CGFloat top = self.gp_navigationBar.height;
        CGRect frame = CGRectMake(0, top, self.view.width, self.view.height - top);
        GPWebView* webview = [[GPWebView alloc] initWithFrame:frame];
        webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        webview.delegate = self;
        webview.scrollView.bounces = NO;
        webview.scrollView.backgroundColor = [UIColor whiteColor];
        webview.scrollView.emptyDataSetSource = self;
        webview.scrollView.emptyDataSetDelegate = self;
        
        _webview = webview;
    }
    
    return _webview;
}

- (void) setupNavigationBar
{
    self.gp_navigationItem.title = @"H5 demo页面";
    self.gp_navigationItem.tintColor = HEXCOLORA(0x222222, 1.0);
    
    self.gp_navigationItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.gp_navigationItem.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    if ([self.gp_navigationBar isKindOfClass:[GPNavigationBar class]]) {
        GPNavigationBar* bar = (GPNavigationBar*)self.gp_navigationBar;
        UIColor* color = bar.lineView.backgroundColor;
        bar.lineView.backgroundColor = [color colorWithAlphaComponent:1.0];
    }
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
    
    [self.view addSubview:self.webview];
    
    // 重新加载数据
    [self load];
}

- (void) load
{
    NSString* url = @"http://m.taobao.com";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 4.0;
    [self.webview loadRequest:request];
}

#pragma mark - GPWebViewDelegate

- (BOOL)        gpWebView:(GPWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
           navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) gpWebViewDidStartLoad:(GPWebView *)webView
{
    
}

- (void) gpWebViewDidFinishLoad:(GPWebView *)webView
{
    
}

- (void)    gpWebView:(GPWebView *)webView
 didFailLoadWithError:(NSError *)error
{
    
}

- (UIViewController *)containerController
{
    return self;
}

@end
