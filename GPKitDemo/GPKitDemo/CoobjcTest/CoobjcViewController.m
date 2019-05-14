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
                                                                     //[self searchBtnClick];
                                                                 }];
    
    
    self.gp_navigationItem.rightBarButtonItem = searchItem;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
}

@end
