//
//  CoobjcViewController.m
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "CoobjcViewController.h"

@interface CoobjcViewController ()
// 触发线程卡顿
@property (nonatomic , strong) UIButton* mainThreadButton;
@end

@implementation CoobjcViewController

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
    self.gp_navigationItem.title = @"coobjc";
    self.gp_navigationItem.tintColor = HEXCOLOR(0x222222);
    
    self.gp_navigationItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.gp_navigationItem.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.gp_navigationBar.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    @weakify(self);
    // 更多
    UIImage* searchImage = [UIImage imageNamed:@"navbar_icon_search"];
    GPBarButtonItem* searchItem = [[GPBarButtonItem alloc] initWithImage:searchImage
                                                                   style:GPBarButtonItemStyleDefault
                                                                 handler:^(id sender) {
                                                                     @strongify(self);
                                                                     [self jumptoCo2];
                                                                 }];
    
    
    self.gp_navigationItem.rightBarButtonItem = searchItem;
}

- (void) jumptoCo2
{
    [[GPRouteManager sharedInstance] openDomain:kRouteCoobjcDomain
                                           path:kRouteCoobjcThreadPath
                                         params:@{}
                                     completion:^(NSDictionary * _Nonnull param, NSError * _Nonnull error) {
                                         
                                         id vc = param[GPRouteTargetKey];
                                         if ([vc isKindOfClass:UIViewController.class] && !error) {
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }
                                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
    
    
    self.mainThreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mainThreadButton.backgroundColor = [UIColor redColor];
    self.mainThreadButton.frame = CGRectMake(100, 100, 100, 44);
    [self.view addSubview:self.mainThreadButton];
    
    [self.mainThreadButton addTarget:self action:@selector(mainThreadButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) mainThreadButtonAction
{
    while (1) {
        sleep(1000);
    }
}
@end
