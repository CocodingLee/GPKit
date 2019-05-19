//
//  CoobjcViewController.m
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "CoobjcViewController.h"

@interface CoobjcViewController ()
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
    
    {
        GPButton* frameLossBtn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        frameLossBtn.frame = CGRectMake(0, 0, 100, 44);
        [frameLossBtn setTitle:@"卡顿模拟" forState:UIControlStateNormal];
        [frameLossBtn addTarget:self action:@selector(frameLossAction) forControlEvents:UIControlEventTouchUpInside];
        frameLossBtn.left = 15;
        frameLossBtn.top = self.gp_navigationBar.height + 10;
        
        [self.view addSubview:frameLossBtn];
    }
    
    {
        GPButton* crashBtn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        crashBtn.frame = CGRectMake(0, 0, 100, 44);
        [crashBtn setTitle:@"crash模拟" forState:UIControlStateNormal];
        [crashBtn addTarget:self action:@selector(crashAction) forControlEvents:UIControlEventTouchUpInside];
        crashBtn.left = 15;
        crashBtn.top = self.gp_navigationBar.height + crashBtn.height + 20;
        
        [self.view addSubview:crashBtn];
    }
    
}

- (void) frameLossAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        sleep(1);
    });
}

- (void) crashAction
{
    // C 异常
    //[self testCPtr];
    [self testSampleArray];
    [self testSimpleDictionary];
    [self testUnrecognizedSelector];
    [self testNull];
}

- (void) testCPtr
{
    char* p = (char*)0x123455;
    *p = '0';
}

- (void)testSampleArray
{
    NSArray* test = @[];
    NSLog(@"object:%@",test[1]);
}

- (void)testSimpleDictionary
{
    id value = nil;
    NSDictionary* dic = @{@"key":value};
    NSLog(@"dic:%@",dic);
}

- (void)testUnrecognizedSelector
{
    [self performSelector:@selector(testUndefineSelector)];
    [self performSelector:@selector(handleCrashException:exceptionCategory:extraInfo:)];
}

- (void)testNull
{
    NSNull* null = [NSNull null];
    NSString* str = (NSString*)null;
    NSLog(@"Str length:%ld",str.length);
}

@end
