//
//  GPUIKitViewController.m
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/10.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPUIKitViewController.h"

@interface GPUIKitViewController ()

@end

@implementation GPUIKitViewController

- (instancetype) init
{
    self = [super init];
    if (self) {
        // 首页不创建返回
        self.gp_notAutoCreateBackButtonItem = YES;
    }
    
    return self;
}

- (void) setupNavigationBar
{
    self.gp_navigationItem.title = @"UIKit";
    self.gp_navigationItem.tintColor = HEXCOLOR(0x222222);
    
    self.gp_navigationItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.gp_navigationItem.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.gp_navigationBar.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
    
    {
        GPButton* btn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        btn.frame = CGRectMake(0, 0, 100, 44);
        [btn setTitle:@"自动释放池" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(autoReleasePoolTest) forControlEvents:UIControlEventTouchUpInside];
        btn.left = 15;
        btn.top = self.gp_navigationBar.height + 10;
        
        [self.view addSubview:btn];
    }
}

- (void) autoReleasePoolTest
{
    /*
     AutoreleasePoolPage
     参考：https://draveness.me/autoreleasepool#AutoreleasePoolPage
     */
    @autoreleasepool {
        // objc
        // auto releas pool page 对象
        // 双向链表，释放的数据 autorelease 隐式调用，把对象放入hot page中。
        // 每一个页 大小 4k
        NSString *s = @"Draveness";
        [s stringByAppendingString:@"-Suffix"];
    }
    
    // ios 知识树
    // https://blog.csdn.net/hherima/article/details/50714866
}
@end
