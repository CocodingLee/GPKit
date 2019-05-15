//
//  GPBaseViewController.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPBaseViewController.h"

@interface GPBaseViewController ()
// VC正在消失
@property (nonatomic, assign) BOOL viewDisappearing;
@end

@implementation GPBaseViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIViewController*)topViewController
{
    UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topViewControllerWithRootViewController:root];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (instancetype)initWithParams:(NSDictionary *)params;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // app启动或者app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    // app从后台进入前台都会调用这个方法
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    // 添加检测app进入后台的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnterBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void) applicationBecomeActive
{
    
}

- (void) applicationEnterBackground
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.viewDisappearing = YES;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    //页面展现打点。
    [super viewDidAppear:animated];
    self.viewDisappearing = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.viewDisappearing = NO;
}

@end
