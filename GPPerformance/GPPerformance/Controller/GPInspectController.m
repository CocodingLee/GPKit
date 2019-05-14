//
//  GPInspectController.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectController.h"
#import "GPInspectorResource.h"
#import "GPInspector.h"
#import <FrameAccessor/FrameAccessor.h>


@interface GPInspectController ()
@property(nonatomic,strong) UIButton* closeButton;
@end

@implementation GPInspectController

- (UIButton*) closeButton
{
    if (!_closeButton) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImage* img = [GPInspectorResource logo];
        [button setImage:img forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        _closeButton = button;
    }
    
    return _closeButton;
}

- (void) closeAction
{
    [GPInspector hide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.closeButton.left = 15;
    
    UIEdgeInsets safeArea = gpSafeArea();
    self.closeButton.top = safeArea.top;
    [self.view addSubview:self.closeButton];
    
}

@end
