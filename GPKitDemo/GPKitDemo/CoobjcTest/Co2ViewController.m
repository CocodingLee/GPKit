//
//  Co2ViewController.m
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "Co2ViewController.h"

@interface Co2ViewController ()

@end

@implementation Co2ViewController

/**
 业务域
 
 @return 当前名称
 */
+ (NSString *)supportedDomain
{
    return kRouteCoobjcDomain;
}

/**
 如果不实现这个方法，则默认添加一个Path为*的插件，
 当某个跳转的path未能命中该domain下的任一个插件时，会寻找*插件
 
 @return 当前支持的路径，业务分支
 */
+ (NSArray *)supportedPath
{
    return @[kRouteCoobjcThreadPath];
}

/**
 初始化
 
 @param params 参数
 @return 当前实例
 */
- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void) setupNavigationBar
{
    self.gp_navigationItem.title = @"coobjc2";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
}


@end
