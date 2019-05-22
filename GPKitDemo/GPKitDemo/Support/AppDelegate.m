//
//  AppDelegate.m
//  GPUIKitDemo
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CYLMainRootViewController.h"

@interface AppDelegate () <GPExceptionHandle>
// 监控数据写入队列
@property (nonatomic, strong) dispatch_queue_t monitorDataQueue;
// 监控数据Actor
@property (nonatomic, strong) COActor * monitorModelActor;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 调试信息
    [[GPLagMonitor shareInstance] beginMonitor];
    // 显示调试窗口
    [GPInspector showOnStatusBar];
    // 抓crash
    [GPInspector setShouldHandleCrash:YES];
    // 配置UI样式
    [GPButton configButtonType];
    // 监控crash
    if ([GPInspector isHookException]) {    
        GPException.exceptionWhenTerminate = NO;
        [GPException configExceptionCategory:GPExceptionGuardAll];
        [GPException startGuardException];
        [GPException registerExceptionHandle:self];
    } else {
        GPException.exceptionWhenTerminate = YES;
        [GPException configExceptionCategory:GPExceptionGuardNone];
        [GPException startGuardException];
        [GPException registerExceptionHandle:self];
    }
    
    // 启动H5
    [self setupH5Container];
    
    // UI 启动
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyWindow];
    
    CYLMainRootViewController *rootViewController = [[CYLMainRootViewController alloc] init];
    [self.window setRootViewController:rootViewController];
    [self setUpNavigationBarAppearance];
    
    [self.window makeKeyAndVisible];
    
    _monitorDataQueue = dispatch_queue_create("com.gp.performance.exception.queue", NULL);
    
    //
    // 数据写入 协程
    //
    _monitorModelActor = co_actor_onqueue(_monitorDataQueue, ^(COActorChan *channel) {
        id cls = nil;
        
        for (COActorMessage *message in channel) {
            cls = [message type];
            
            // DSReq 请求解析
            if ([cls isKindOfClass:[GPOCExceptionModel class]]) {
                id tmp = await([self writeToDB:cls]);
                message.complete(tmp);
            } else{
                message.complete(nil);
            }
        }
    });
    
    return YES;
}

- (void) setupH5Container
{
    // 支持的域名
    [self setupDomain];
    
    // UA设置
    [self setupUserAgent];
}

#pragma mark - WebView
- (void) setupDomain
{
    [GPWebView addCookieDomain:@"m.baidu.com"];
    [GPWebView addCookieDomain:@"m.taobao.com"];
}

- (void) setupUserAgent
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    // 获取App的版本号
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    // 获取App的build版本
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    // 新的UA
    NSString* addUA = [NSString stringWithFormat:@"GPKitDemo/ios/%@.%@" , appVersion , appBuildVersion];
    
    // 获取默认User-Agent
    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    //NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    
    // 给User-Agent添加额外的信息
    //NSString *newAgent = [NSString stringWithFormat:@"%@ %@", oldAgent, addUA];
    //NSLog(@"UA = %@" , newAgent);
    
    [GPWebView appendCustomUserAgent:addUA];
}

#pragma mark - WebView header
- (void)setupLoginHeader
{
    NSString* st = @"";
    NSString* uid = @"";
    [GPWebView setCookieValue:st forKey:@"serviceTicket"];
    [GPWebView setAdditionHeader:uid forKey:@"x-mg-uid"];
    [GPWebView setAdditionHeader:@"as" forKey:@"x-mg-auth"];
    
    //[GPWebView setAdditionHeader:vid forKey:@"x-mg-vid"];
    //NSDictionary* clientInfo = [AGSClientMagaParams clientInfo];
    //NSData *clientData = [NSJSONSerialization dataWithJSONObject:clientInfo options:0 error:nil];
    //NSString *clientStr = [[NSString alloc] initWithData:clientData encoding:NSUTF8StringEncoding];
    //[GPWebView setAdditionHeader:clientStr forKey:@"x-mg-client"];
}

- (void)setupLogoutHeader
{
    [GPWebView setAdditionHeader:@"" forKey:@"x-mg-ast"];
    [GPWebView setAdditionHeader:@"" forKey:@"x-mg-uid"];
    [GPWebView setAdditionHeader:@"" forKey:@"x-mg-auth"];
}

#pragma mark - Cookie

- (void)setupLogoutCookie
{
    [GPWebView setCookieValue:@"" forKey:@"x-mg-ast"];
    [GPWebView setCookieValue:@"" forKey:@"x-mg-uid"];
    [GPWebView setCookieValue:@"" forKey:@"x-mg-auth"];
    
    [GPWebView setCookieValue:@"" forKey:@"ucid"];
    [GPWebView setCookieValue:@"" forKey:@"ast"];
    [GPWebView setCookieValue:@"" forKey:@"serviceTicket"];
}
#pragma mark - GPExceptionHandle

/**
 Crash message and extra info from current thread
 
 @param exceptionMessage crash message
 @param info extraInfo,key and value
 */
- (void)handleCrashException:(NSString*)exceptionMessage
                   extraInfo:(nullable NSDictionary*)info
{
    //NSLog(@"[CRASH] - %@ , %@" , exceptionMessage , info.description);
}

/**
 Crash message,exceptionCategory, extra info from current thread
 
 @param exceptionMessage crash message
 @param exceptionCategory GPExceptionGuardCategory
 @param info extra info
 */
- (void)handleCrashException:(NSString*)exceptionMessage
           exceptionCategory:(GPExceptionGuardCategory)exceptionCategory
                   extraInfo:(nullable NSDictionary*)info
{
    NSLog(@"[CRASH] - %@ , %ld , %@" , exceptionMessage , (long)exceptionCategory , info.description);
    // 触发获取主线程堆栈
    co_launch(^{
        GPOCExceptionModel* model = [[GPOCExceptionModel alloc] init];
        model.callStackStr = exceptionMessage;
        model.exceptionType = exceptionCategory;
        model.exceptionInfo = [info yy_modelToJSONString];
        
        id tmp = await([self.monitorModelActor sendMessage:model]);
        if (!co_getError()) {
            NSLog(@"crash hook = %@" , tmp);
        }
    });
}

- (COPromise*) writeToDB:(GPOCExceptionModel*) model
{
    return [[GPLagDB shareInstance] addWithOCExceptionModel:model];
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance
{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"navigationbar_background_tall"];
        
        textAttributes = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName : [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
