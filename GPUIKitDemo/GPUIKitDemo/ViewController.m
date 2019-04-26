//
//  ViewController.m
//  GPUIKitDemo
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "ViewController.h"
#import <GPUIKit/GPUIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets safeArea = gpSafeArea();
    NSLog(@"safeArea.top = %f" , safeArea.top);
}


@end
